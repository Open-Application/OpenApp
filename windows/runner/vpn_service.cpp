#include "vpn_service.h"
#include <iostream>
#include <thread>
#include <ctime>
#include <iomanip>
#include <sstream>
#include <windows.h>
#include <shlobj.h>

std::string VPNService::log_file_path_;
std::mutex VPNService::log_mutex_;
bool VPNService::log_initialized_ = false;
bool VPNService::setup_initialized_ = false;
std::mutex VPNService::setup_mutex_;

extern "C" void VPNServiceLogCallback(const char* message) {
  VPNService::WriteLog(message);
}

VPNService::VPNService()
    : service_handle_(nullptr),
      current_status_("STOPPED") {}

VPNService::~VPNService() {
  if (service_handle_ != nullptr) {
    Stop();
  }
}

void VPNService::EnsureSetup() {
  std::lock_guard<std::mutex> lock(setup_mutex_);
  if (setup_initialized_) {
    return;
  }

  wchar_t* roaming_path_wstr = nullptr;
  std::string base_path;
  if (SUCCEEDED(::SHGetKnownFolderPath(FOLDERID_RoamingAppData, 0, nullptr, &roaming_path_wstr))) {
    int size_needed = ::WideCharToMultiByte(CP_UTF8, 0, roaming_path_wstr, -1, nullptr, 0, nullptr, nullptr);
    base_path = std::string(size_needed - 1, 0);
    ::WideCharToMultiByte(CP_UTF8, 0, roaming_path_wstr, -1, &base_path[0], size_needed, nullptr, nullptr);
    ::CoTaskMemFree(roaming_path_wstr);
    base_path += "\\io.root-corporation\\openapp";
  }

  wchar_t temp_path_wstr[MAX_PATH];
  std::string temp_path;
  if (::GetTempPathW(MAX_PATH, temp_path_wstr) > 0) {
    int size_needed = ::WideCharToMultiByte(CP_UTF8, 0, temp_path_wstr, -1, nullptr, 0, nullptr, nullptr);
    temp_path = std::string(size_needed - 1, 0);
    ::WideCharToMultiByte(CP_UTF8, 0, temp_path_wstr, -1, &temp_path[0], size_needed, nullptr, nullptr);
    if (!temp_path.empty() && temp_path.back() == '\\') {
      temp_path.pop_back();
    }
  }

  ::CreateDirectoryA(base_path.c_str(), nullptr);

  char* base_path_cstr = _strdup(base_path.c_str());
  char* working_path_cstr = _strdup(base_path.c_str());
  char* temp_path_cstr = _strdup(temp_path.c_str());

  std::cout << "[VPNService] Calling Setup with paths:" << std::endl;
  std::cout << "  Base: " << base_path << std::endl;
  std::cout << "  Working: " << base_path << std::endl;
  std::cout << "  Temp: " << temp_path << std::endl;

  char* setup_error = Setup(base_path_cstr, working_path_cstr, temp_path_cstr, 0, 0);

  free(base_path_cstr);
  free(working_path_cstr);
  free(temp_path_cstr);

  if (setup_error != nullptr) {
    std::string error_msg(setup_error);
    FreeString(setup_error);
    WriteLog(("Setup failed: " + error_msg).c_str());
  }

  setup_initialized_ = true;
}

bool VPNService::Start(const std::string& config) {
  std::lock_guard<std::mutex> lock(status_mutex_);

  if (service_handle_ != nullptr) {
    LogMessage("Service already running");
    return false;
  }

  EnsureSetup();
  InitLogger();

  UpdateStatus("STARTING");

  PlatformInterface platform_interface = {0};
  platform_interface.writeLog = VPNServiceLogCallback;

  std::cout << "[VPNService] Calling NewService with config length: " << config.length() << std::endl;
  char* config_cstr = _strdup(config.c_str());
  int64_t service_id = NewService(config_cstr, &platform_interface);
  std::cout << "[VPNService] NewService returned: " << service_id << std::endl;
  free(config_cstr);

  if (service_id < 0) {
    char* error = LibocGetLastError();
    std::string error_msg = error ? error : "Unknown error";
    FreeString(error);

    LogMessage("Failed to create service: " + error_msg);
    UpdateStatus("STOPPED");
    return false;
  }

  service_handle_ = reinterpret_cast<void*>(service_id);
  char* start_error = ServiceStart(service_id);
  if (start_error != nullptr) {
    std::string error_msg(start_error);
    FreeString(start_error);

    LogMessage("Failed to start service: " + error_msg);
    ServiceClose(service_id);
    service_handle_ = nullptr;
    UpdateStatus("STOPPED");
    return false;
  }

  LogMessage("Service started successfully");
  UpdateStatus("STARTED");
  return true;
}

bool VPNService::Stop() {
  std::lock_guard<std::mutex> lock(status_mutex_);

  if (service_handle_ == nullptr) {
    return true;
  }

  UpdateStatus("STOPPING");

  int64_t service_id = reinterpret_cast<int64_t>(service_handle_);
  char* error = ServiceClose(service_id);
  service_handle_ = nullptr;

  if (error != nullptr) {
    std::string error_msg(error);
    FreeString(error);
    LogMessage("Error stopping service: " + error_msg);
    UpdateStatus("STOPPED");
    return false;
  }

  LogMessage("Service stopped");
  UpdateStatus("STOPPED");
  return true;
}

std::string VPNService::GetStatus() const {
  std::lock_guard<std::mutex> lock(status_mutex_);
  return current_status_;
}

void VPNService::SetStatusCallback(StatusCallback callback) {
  status_callback_ = callback;
}

std::string VPNService::GetVersion() {
  char* version_cstr = Version();
  if (version_cstr == nullptr) {
    return "unknown";
  }

  std::string version(version_cstr);
  FreeString(version_cstr);
  return version;
}

bool VPNService::ValidateConfig(const std::string& config, std::string& error) {
  char* config_cstr = _strdup(config.c_str());
  char* error_cstr = CheckConfig(config_cstr);
  free(config_cstr);

  if (error_cstr != nullptr) {
    error = std::string(error_cstr);
    FreeString(error_cstr);
    return false;
  }

  return true;
}

void VPNService::UpdateStatus(const std::string& status) {
  current_status_ = status;

  if (status_callback_) {
    std::thread([this, status]() {
      status_callback_(status);
    }).detach();
  }
}

void VPNService::LogMessage(const std::string& message) {
  std::cout << "[VPNService] " << message << std::endl;
  if (!log_file_path_.empty()) {
    WriteLog(message.c_str());
  }
}

std::string VPNService::GetLogFilePath() {
  wchar_t* path_wstr = nullptr;
  if (SUCCEEDED(::SHGetKnownFolderPath(FOLDERID_RoamingAppData, 0, nullptr, &path_wstr))) {
    int size_needed = ::WideCharToMultiByte(CP_UTF8, 0, path_wstr, -1, nullptr, 0, nullptr, nullptr);
    std::string path(size_needed - 1, 0);
    ::WideCharToMultiByte(CP_UTF8, 0, path_wstr, -1, &path[0], size_needed, nullptr, nullptr);
    ::CoTaskMemFree(path_wstr);
    return path + "\\io.root-corporation\\openapp\\debug.log";
  }
  return "";
}

void VPNService::InitLogger() {
  std::lock_guard<std::mutex> lock(log_mutex_);

  std::string path = GetLogFilePath();
  if (path.empty()) {
    return;
  }

  size_t pos = path.find_last_of("\\/");
  if (pos != std::string::npos) {
    std::string dir = path.substr(0, pos);
    ::CreateDirectoryA(dir.c_str(), nullptr);
  }

  log_file_path_ = path;
  log_initialized_ = true;

  std::ofstream log_file(path, std::ios::out | std::ios::trunc);
  if (log_file.is_open()) {
    auto now = std::time(nullptr);
    std::tm tm;
    localtime_s(&tm, &now);
    std::ostringstream oss;
    oss << std::put_time(&tm, "%Y-%m-%d %H:%M:%S");

#ifdef FLUTTER_VERSION
    log_file << "[" << oss.str() << "] App version: " << FLUTTER_VERSION << "\n";
#else
    log_file << "[" << oss.str() << "] App version: unknown\n";
#endif
    log_file << "[" << oss.str() << "] Log file initialized\n";
    log_file.close();
  }
}

void VPNService::WriteLog(const char* message) {
  if (!log_initialized_) {
    InitLogger();
  }

  if (log_file_path_.empty() || !message) {
    return;
  }

  std::lock_guard<std::mutex> lock(log_mutex_);

  std::ofstream log_file(log_file_path_, std::ios::out | std::ios::app);
  if (log_file.is_open()) {
    std::string msg(message);
    std::istringstream stream(msg);
    std::string line;

    auto now = std::time(nullptr);
    std::tm tm;
    localtime_s(&tm, &now);
    std::ostringstream timestamp;
    timestamp << std::put_time(&tm, "%Y-%m-%d %H:%M:%S");

    while (std::getline(stream, line)) {
      size_t start = line.find_first_not_of(" \t\r\n");
      size_t end = line.find_last_not_of(" \t\r\n");

      if (start != std::string::npos) {
        std::string trimmed = line.substr(start, end - start + 1);
        if (!trimmed.empty()) {
          log_file << "[" << timestamp.str() << "] " << trimmed << "\n";
        }
      }
    }

    log_file.flush();
    log_file.close();
  }
}
