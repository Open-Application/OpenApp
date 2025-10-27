import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../constants.dart';
import '../services/rcc_service.dart';

class LogProvider extends ChangeNotifier {
  static const int maxLogLines = 500;
  final List<String> _logs = [];
  Timer? _pollingTimer;
  String _lastLogContent = '';
  File? _logFile;

  List<String> get logs => List.unmodifiable(_logs);

  LogProvider() {
    _initLogFile();
  }

  Future<void> _initLogFile() async {
    try {
      final logPath = await RccService().getLogFilePath();
      if (logPath != null && logPath.isNotEmpty) {
        _logFile = File(logPath);
        debugPrint('[LogProvider] Using native log path: $logPath');
        _startPolling();
      } else {
        debugPrint('[LogProvider] Error: No log path returned from native');
      }
    } catch (e) {
      debugPrint('[LogProvider] Error initializing log file: $e');
    }
  }

  Future<void> createDebugLogFile() async {
    try {
      final directory = await getApplicationSupportDirectory();
      final logFile = File('${directory.path}/${Constants.debugLogFileName}');

      if (!await logFile.exists()) {
        await logFile.create();
        await logFile.writeAsString('Debug logging enabled at ${DateTime.now().toIso8601String()}\n');
      }
      _logFile = logFile;
      _startPolling();
    } catch (_) {
    }
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(Duration(seconds: 1), (_) async {
      await _readLogsFromFile();
    });
    _readLogsFromFile();
  }

  Future<void> _readLogsFromFile() async {
    try {
      if (_logFile == null || !await _logFile!.exists()) {
        return;
      }

      final logContent = await _logFile!.readAsString();
      if (logContent.isNotEmpty && logContent != _lastLogContent) {
        _updateLogs(logContent);
        _lastLogContent = logContent;
      }
    } catch (e) {
      debugPrint('Error reading logs: $e');
    }
  }

  void _updateLogs(String logContent) {
    _logs.clear();
    final lines = logContent.split('\n');

    for (final line in lines) {
      if (line.trim().isNotEmpty) {
        _logs.add(line);
      }
    }

    while (_logs.length > maxLogLines) {
      _logs.removeAt(0);
    }

    notifyListeners();
  }


  void clearLogs() async {
    _logs.clear();
    _lastLogContent = '';
    try {
      if (_logFile != null && await _logFile!.exists()) {
        await _logFile!.writeAsString('');
      }
    } catch (e) {
      debugPrint('Error clearing logs: $e');
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  String exportLogs() {
    final buffer = StringBuffer();
    buffer.writeln('=== Service Logs ===');
    buffer.writeln('Exported at: ${DateTime.now().toIso8601String()}');
    buffer.writeln('Total entries: ${_logs.length}');
    buffer.writeln('');

    for (final log in _logs) {
      buffer.writeln(log);
    }

    return buffer.toString();
  }
}