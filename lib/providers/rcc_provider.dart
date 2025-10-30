import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../interfaces/rcc_interface.dart';
import '../l10n/app_localizations.dart';
import '../components/rcc_messenger.dart';
import '../constants.dart';
import './preferences_provider.dart';

class RccProvider extends ChangeNotifier {
  final RccInterface _rccService;
  String _status = 'STOPPED';
  bool _isLoading = false;

  final List<String> _logs = [];
  Timer? _pollingTimer;
  String _lastLogContent = '';
  File? _logFile;

  String get status => _status;
  bool get isLoading => _isLoading;
  bool get isButtonEnabled => !_isLoading;
  List<String> get logs => List.unmodifiable(_logs);

  RccProvider(this._rccService) {
    _initialize();
  }

  void _initialize() {
    _rccService.statusStream.listen((status) {
      _status = status;
      _isLoading = false;
      notifyListeners();
    });

    _fetchInitialStatus();
    _initLogFile();
  }

  Future<void> _fetchInitialStatus() async {
    final status = await _rccService.getRccStatus();
    _status = status;
    notifyListeners();
  }

  Future<void> toggle(BuildContext? context) async {
    _isLoading = true;
    notifyListeners();

    if (_status == 'STOPPED' || _status == 'INVALID') {
      bool hasPermission = await _rccService.checkRccPermission();

      if (!hasPermission) {
        hasPermission = await _rccService.requestRccPermission();

        if (!hasPermission) {
          if (context != null && context.mounted) {
            RccMessenger.showError(
              context: context,
              message: AppLocalizations.of(context)!.servicePermissionRequired,
            );
          }
          _isLoading = false;
          notifyListeners();
          return;
        }

        await Future.delayed(const Duration(milliseconds: 800));
      }

      String? configToUse;
      if (context != null && context.mounted) {
        final preferencesProvider = context.read<PreferencesProvider>();
        configToUse = preferencesProvider.userEncodedConfig;
      }

      if (configToUse == null || configToUse.isEmpty) {
        configToUse = Constants.encodedConfig;
      }

      if (configToUse.isEmpty) {
        _isLoading = false;
        notifyListeners();
        if (context != null && context.mounted) {
          RccMessenger.showError(
            context: context,
            message: AppLocalizations.of(context)!.configurationRequired,
            action: SnackBarAction(
              label: 'Help',
              onPressed: () {
                launchUrl(Uri.parse(Constants.projectUrl));
              },
            ),
          );
        }
        return;
      }

      final success = await _rccService.startRcc(configToUse);
      if (!success && context != null && context.mounted) {
        RccMessenger.showError(
          context: context,
          message: AppLocalizations.of(context)!.failedToStartService,
        );
        _isLoading = false;
        notifyListeners();
      }
    } else if (_status == 'STARTED') {
      await _rccService.stopRcc();
    }
  }

  Color get statusColor {
    switch (_status) {
      case 'STARTED':
        return Colors.green;
      case 'STARTING':
      case 'STOPPING':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  String getStatusText(BuildContext context) {
    switch (_status) {
      case 'STARTED':
        return AppLocalizations.of(context)!.connected;
      case 'STARTING':
        return AppLocalizations.of(context)!.connecting;
      case 'STOPPING':
        return AppLocalizations.of(context)!.disconnecting;
      case 'INVALID':
      case 'STOPPED':
      default:
        return AppLocalizations.of(context)!.disconnected;
    }
  }

  String getButtonText(BuildContext context) {
    return _isLoading
        ? (_status == 'STOPPED' || _status == 'INVALID'
              ? AppLocalizations.of(context)!.connecting
              : AppLocalizations.of(context)!.disconnecting)
        : (_status == 'STARTED'
              ? AppLocalizations.of(context)!.disconnect
              : AppLocalizations.of(context)!.connect);
  }

  void updateStatus(String newStatus) {
    if (_isLoading && (_status == 'STARTING' || _status == 'STOPPING')) {
      return;
    }
    _status = newStatus;
    notifyListeners();
  }

  Future<void> _initLogFile() async {
    try {
      final logPath = await _rccService.getLogFilePath();
      if (logPath != null && logPath.isNotEmpty) {
        _logFile = File(logPath);
        debugPrint('[RccProvider] Using native log path: $logPath');
        _startPolling();
      } else {
        debugPrint('[RccProvider] Error: No log path returned from native');
      }
    } catch (e) {
      debugPrint('[RccProvider] Error initializing log file: $e');
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

    while (_logs.length > Constants.maxLogLines) {
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

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _rccService.dispose();
    super.dispose();
  }
}
