import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../interfaces/rcc_interface.dart';

class RccService implements RccInterface {
  static const _channel = MethodChannel('io.rootcorporation.openapp/core');
  static const _eventChannel = EventChannel('io.rootcorporation.openapp/status');
  static final RccService _instance = RccService._internal();

  factory RccService() => _instance;

  RccService._internal() {
    _initEventChannel();
  }

  final _statusController = StreamController<String>.broadcast();
  @override
  Stream<String> get statusStream => _statusController.stream;

  String _currentStatus = 'STOPPED';
  @override
  String get currentStatus => _currentStatus;
  
  @override
  Future<bool> checkRccPermission() async {
    try {
      final result = await _channel.invokeMethod<bool>('checkRccPermission');
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> requestRccPermission() async {
    try {
      final result = await _channel.invokeMethod<bool>('requestRccPermission');
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> startRcc(String base64Config) async {
    try {
      final decodedConfig = utf8.decode(base64.decode(base64Config));
      final result = await _channel.invokeMethod<bool>(
        'startRcc',
        {'config': decodedConfig},
      );
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> stopRcc() async {
    try {
      final result = await _channel.invokeMethod<bool>('stopRcc');
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<String> getRccStatus() async {
    try {
      final result = await _channel.invokeMethod<String>('getRccStatus');
      return result ?? 'STOPPED';
    } catch (_) {
      return 'STOPPED';
    }
  }

  void _initEventChannel() {
    _eventChannel.receiveBroadcastStream().listen((event) {
      final data = event as Map;
      final type = data['type'] as String;

      switch (type) {
        case 'status':
          final status = data['data'] as String;
          _currentStatus = status;
          _statusController.add(status);
          break;
      }
    }, onError: (error) {
      assert(() {
        debugPrint('EventChannel error: $error');
        return true;
      }());
    });
  }
  
  @override
  void dispose() {
    _statusController.close();
  }
}