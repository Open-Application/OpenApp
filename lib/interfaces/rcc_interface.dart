import 'dart:async';

abstract class RccInterface {
  Stream<String> get statusStream;

  String get currentStatus;

  Future<bool> checkRccPermission();
  Future<bool> requestRccPermission();
  Future<bool> startRcc(String base64Config);
  Future<bool> stopRcc();
  Future<String> getRccStatus();
  void dispose();
}
