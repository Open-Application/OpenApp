#include "flutter_bridge.h"
#include <flutter/standard_message_codec.h>
#include <iostream>

namespace {
constexpr char kChannelName[] = "io.rootcorporation.openapp/core";
constexpr char kEventChannelName[] = "io.rootcorporation.openapp/status";
}

FlutterBridge::FlutterBridge()
    : current_status_("STOPPED"),
      vpn_service_(std::make_unique<VPNService>()) {
  vpn_service_->SetStatusCallback([this](const std::string& status) {
    UpdateStatus(status);
  });
}

FlutterBridge::~FlutterBridge() {
  Cleanup();
}

void FlutterBridge::Setup(flutter::BinaryMessenger* messenger) {
  method_channel_ = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
      messenger, kChannelName,
      &flutter::StandardMethodCodec::GetInstance());

  method_channel_->SetMethodCallHandler(
      [this](const flutter::MethodCall<flutter::EncodableValue>& call,
             std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
        HandleMethodCall(call, std::move(result));
      });

  event_channel_ = std::make_unique<flutter::EventChannel<flutter::EncodableValue>>(
      messenger, kEventChannelName,
      &flutter::StandardMethodCodec::GetInstance());

  auto handler = std::make_unique<flutter::StreamHandlerFunctions<flutter::EncodableValue>>(
      [this](const flutter::EncodableValue* arguments,
             std::unique_ptr<flutter::EventSink<flutter::EncodableValue>>&& events)
          -> std::unique_ptr<flutter::StreamHandlerError<flutter::EncodableValue>> {
        OnListen(arguments, std::move(events));
        return nullptr;
      },
      [this](const flutter::EncodableValue* arguments)
          -> std::unique_ptr<flutter::StreamHandlerError<flutter::EncodableValue>> {
        OnCancel(arguments);
        return nullptr;
      });

  event_channel_->SetStreamHandler(std::move(handler));
}

void FlutterBridge::Cleanup() {
  if (vpn_service_) {
    vpn_service_->Stop();
  }
  event_sink_.reset();
  event_channel_.reset();
  method_channel_.reset();
}

void FlutterBridge::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  const auto& method_name = method_call.method_name();

  if (method_name == "checkRccPermission") {
    CheckRccPermission(std::move(result));
  } else if (method_name == "requestRccPermission") {
    RequestRccPermission(std::move(result));
  } else if (method_name == "startRcc") {
    const auto* args_ptr = method_call.arguments();
    if (!args_ptr) {
      result->Error("NO_ARGS", "No arguments provided");
      return;
    }
    const auto* arguments = std::get_if<flutter::EncodableMap>(args_ptr);
    if (!arguments) {
      result->Error("INVALID_ARGS", "Arguments must be a map");
      return;
    }

    auto config_it = arguments->find(flutter::EncodableValue("config"));
    if (config_it == arguments->end()) {
      result->Error("INVALID_CONFIG", "Configuration is required");
      return;
    }

    const auto* config = std::get_if<std::string>(&config_it->second);
    if (!config) {
      result->Error("INVALID_CONFIG", "Configuration must be a string");
      return;
    }

    StartRcc(*config, std::move(result));
  } else if (method_name == "stopRcc") {
    StopRcc(std::move(result));
  } else if (method_name == "getRccStatus") {
    GetRccStatus(std::move(result));
  } else if (method_name == "getLogFilePath") {
    GetLogFilePath(std::move(result));
  } else {
    result->NotImplemented();
  }
}

void FlutterBridge::CheckRccPermission(
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::thread([result = std::move(result)]() mutable {
    bool has_permission = ElevationUtils::IsRunningAsAdmin();
    std::cout << "Check permission - Running as admin: " << (has_permission ? "Yes" : "No") << std::endl;
    result->Success(flutter::EncodableValue(has_permission));
  }).detach();
}

void FlutterBridge::RequestRccPermission(
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::cout << "Request permission called" << std::endl;
  std::thread([result = std::move(result)]() mutable {
    if (ElevationUtils::IsRunningAsAdmin()) {
      std::cout << "Already running as administrator" << std::endl;
      result->Success(flutter::EncodableValue(true));
      return;
    }

    if (!ElevationUtils::IsUACEnabled()) {
      std::cout << "UAC is disabled, assuming permission granted" << std::endl;
      result->Success(flutter::EncodableValue(true));
      return;
    }

    std::cout << "Requesting elevation via UAC..." << std::endl;

    bool elevated = ElevationUtils::RequestElevation();

    if (elevated) {
      std::cout << "Elevated process started, current process will exit" << std::endl;
      result->Success(flutter::EncodableValue(true));
      std::thread([]() {
        std::this_thread::sleep_for(std::chrono::milliseconds(500));
        exit(0);
      }).detach();
    } else {
      std::cout << "Elevation request failed or was cancelled" << std::endl;
      result->Success(flutter::EncodableValue(false));
    }
  }).detach();
}

void FlutterBridge::StartRcc(
    const std::string& config,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!vpn_service_) {
    result->Error("NO_SERVICE", "Service not initialized");
    return;
  }

  std::string current = vpn_service_->GetStatus();
  if (current != "STOPPED") {
    result->Error("ALREADY_RUNNING", "Service is already running");
    return;
  }

  std::cout << "Starting Windows service with config (length: " << config.length() << ")" << std::endl;
  std::thread([this, config, result = std::move(result)]() mutable {
    bool success = vpn_service_->Start(config);
    if (success) {
      result->Success(flutter::EncodableValue(true));
    } else {
      result->Error("START_FAILED", "Failed to start service");
    }
  }).detach();
}

void FlutterBridge::StopRcc(
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!vpn_service_) {
    result->Error("NO_SERVICE", "Service not initialized");
    return;
  }

  std::string current = vpn_service_->GetStatus();
  if (current == "STOPPED") {
    result->Success(flutter::EncodableValue(true));
    return;
  }

  std::cout << "Stopping Windows service" << std::endl;
  bool success = vpn_service_->Stop();
  if (success) {
    result->Success(flutter::EncodableValue(true));
  } else {
    result->Error("STOP_FAILED", "Failed to stop service");
  }
}

void FlutterBridge::GetRccStatus(
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!vpn_service_) {
    result->Success(flutter::EncodableValue("STOPPED"));
    return;
  }

  std::string status = vpn_service_->GetStatus();
  result->Success(flutter::EncodableValue(status));
}

void FlutterBridge::GetLogFilePath(
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  char* appdata = nullptr;
  size_t len = 0;
  if (_dupenv_s(&appdata, &len, "LOCALAPPDATA") == 0 && appdata != nullptr) {
    std::string log_path = std::string(appdata) + "\\io.rootcorporation.openapp\\debug.log";
    free(appdata);
    result->Success(flutter::EncodableValue(log_path));
  } else {
    result->Success(flutter::EncodableValue("debug.log"));
  }
}

void FlutterBridge::OnListen(
    const flutter::EncodableValue* arguments,
    std::unique_ptr<flutter::EventSink<flutter::EncodableValue>>&& events) {
  event_sink_ = std::move(events);
  flutter::EncodableMap status_event;
  status_event[flutter::EncodableValue("type")] = flutter::EncodableValue("status");
  status_event[flutter::EncodableValue("data")] = flutter::EncodableValue(GetCurrentStatus());

  if (event_sink_) {
    event_sink_->Success(flutter::EncodableValue(status_event));
  }
}

void FlutterBridge::OnCancel(const flutter::EncodableValue* arguments) {
  event_sink_.reset();
}

void FlutterBridge::UpdateStatus(const std::string& status) {
  current_status_ = status;

  if (event_sink_) {
    flutter::EncodableMap status_event;
    status_event[flutter::EncodableValue("type")] = flutter::EncodableValue("status");
    status_event[flutter::EncodableValue("data")] = flutter::EncodableValue(status);

    event_sink_->Success(flutter::EncodableValue(status_event));
  }
}

std::string FlutterBridge::GetCurrentStatus() const {
  std::lock_guard<std::mutex> lock(status_mutex_);
  return current_status_;
}
