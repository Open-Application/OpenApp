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

bool VPNService::Start(const std::string& config) {
  std::lock_guard<std::mutex> lock(status_mutex_);

  if (service_handle_ != nullptr) {
    LogMessage("Service already running");
    return false;
  }

  UpdateStatus("STARTING");

  PlatformInterface platform_interface = {0};
  platform_interface.writeLog = VPNServiceLogCallback;

  char* config_cstr = _strdup(config.c_str());
  int64_t service_id = NewService(config_cstr, &platform_interface);
  free(config_cstr);

  if (service_id < 0) {
    char* error = LibocGetLastError();
    std::string error_msg = error ? error : "Unknown error";
    FreeString(error);

    LogMessage("Failed to create VPN service: " + error_msg);
    UpdateStatus("STOPPED");
    return false;
  }

  service_handle_ = reinterpret_cast<void*>(service_id);
  char* start_error = ServiceStart(service_id);
  if (start_error != nullptr) {
    std::string error_msg(start_error);
    FreeString(start_error);

    LogMessage("Failed to start VPN service: " + error_msg);
    ServiceClose(service_id);
    service_handle_ = nullptr;
    UpdateStatus("STOPPED");
    return false;
  }

  LogMessage("VPN service started successfully");
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
    LogMessage("Error stopping VPN service: " + error_msg);
    UpdateStatus("STOPPED");
    return false;
  }

  LogMessage("VPN service stopped");
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
    return path + "\\io.rootcorporation.openapp\\debug.log";
  }
  return "";
}

void VPNService::InitLogger() {
  std::lock_guard<std::mutex> lock(log_mutex_);
  if (log_initialized_) {
    return;
  }

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

  std::ifstream test_file(path);
  if (!test_file.good()) {
    std::ofstream log_file(path, std::ios::out | std::ios::trunc);
    if (log_file.is_open()) {
      auto now = std::time(nullptr);
      std::tm tm;
      localtime_s(&tm, &now);
      std::ostringstream oss;
      oss << std::put_time(&tm, "%Y-%m-%d %H:%M:%S");
      log_file << "[" << oss.str() << "] Log file initialized\n";
      log_file.close();
    }
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
    auto now = std::time(nullptr);
    std::tm tm;
    localtime_s(&tm, &now);
    std::ostringstream oss;
    oss << std::put_time(&tm, "%Y-%m-%d %H:%M:%S");
    log_file << "[" << oss.str() << "] " << message << "\n";
    log_file.flush();
    log_file.close();
  }
}
