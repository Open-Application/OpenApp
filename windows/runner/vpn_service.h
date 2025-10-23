#ifndef RUNNER_VPN_SERVICE_H_
#define RUNNER_VPN_SERVICE_H_

#include <windows.h>
#include <string>
#include <functional>
#include <mutex>
#include <fstream>

#include "librcc.h"

class VPNService {
 public:
  using StatusCallback = std::function<void(const std::string&)>;

  VPNService();
  ~VPNService();

  bool Start(const std::string& config);
  bool Stop();
  std::string GetStatus() const;

  void SetStatusCallback(StatusCallback callback);
  static std::string GetVersion();
  static bool ValidateConfig(const std::string& config, std::string& error);
  static void InitLogger();
  static void WriteLog(const char* message);

 private:
  void UpdateStatus(const std::string& status);
  void LogMessage(const std::string& message);
  static std::string GetLogFilePath();

  void* service_handle_;
  mutable std::mutex status_mutex_;
  std::string current_status_;
  StatusCallback status_callback_;

  static std::string log_file_path_;
  static std::mutex log_mutex_;
  static bool log_initialized_;
};

#endif
