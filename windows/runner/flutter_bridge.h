#ifndef RUNNER_FLUTTER_BRIDGE_H_
#define RUNNER_FLUTTER_BRIDGE_H_

#include <flutter/method_channel.h>
#include <flutter/event_channel.h>
#include <flutter/binary_messenger.h>
#include <flutter/standard_method_codec.h>
#include <flutter/event_stream_handler_functions.h>
#include <memory>
#include <string>
#include <mutex>
#include "vpn_service.h"
#include "elevation_utils.h"

class FlutterBridge {
 public:
  FlutterBridge();
  ~FlutterBridge();

  void Setup(flutter::BinaryMessenger* messenger);
  void Cleanup();

 private:
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue>& method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void CheckRccPermission(std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void RequestRccPermission(std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void StartRcc(const std::string& config, std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void StopRcc(std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void GetRccStatus(std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void GetLogFilePath(std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void OnListen(
      const flutter::EncodableValue* arguments,
      std::unique_ptr<flutter::EventSink<flutter::EncodableValue>>&& events);
  void OnCancel(const flutter::EncodableValue* arguments);
  void UpdateStatus(const std::string& status);
  std::string GetCurrentStatus() const;

  std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>> method_channel_;
  std::unique_ptr<flutter::EventChannel<flutter::EncodableValue>> event_channel_;
  std::unique_ptr<flutter::EventSink<flutter::EncodableValue>> event_sink_;

  mutable std::mutex status_mutex_;
  std::string current_status_;
  std::unique_ptr<VPNService> vpn_service_;
};

#endif
