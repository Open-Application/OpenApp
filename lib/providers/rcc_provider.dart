import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../interfaces/rcc_interface.dart';
import '../l10n/app_localizations.dart';
import '../components/rcc_messenger.dart';
import '../constants.dart';
import './preferences_provider.dart';

class RccProvider extends ChangeNotifier {
  final RccInterface _rccService;
  String _status = 'STOPPED';
  bool _isLoading = false;

  String get status => _status;
  bool get isLoading => _isLoading;
  bool get isButtonEnabled => !_isLoading;

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
  }

  Future<void> _fetchInitialStatus() async {
    final status = await _rccService.getRccStatus();
    _status = status;
    notifyListeners();
  }

  Future<void> toggle(BuildContext? context) async {
    _isLoading = true;
    notifyListeners();

    if (_status == 'STOPPED') {
      bool hasPermission = await _rccService.checkRccPermission();

      if (!hasPermission) {
        hasPermission = await _rccService.requestRccPermission();

        if (!hasPermission) {
          if (context != null && context.mounted) {
            RccMessenger.showError(
              context: context,
              message: AppLocalizations.of(context)!.vpnPermissionRequired,
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
          );
        }
        return;
      }

      final success = await _rccService.startRcc(configToUse);
      if (!success && context != null && context.mounted) {
        RccMessenger.showError(
          context: context,
          message: AppLocalizations.of(context)!.failedToStartVpn,
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
      default:
        return AppLocalizations.of(context)!.disconnected;
    }
  }

  String getStatusSubtext(BuildContext context) {
    switch (_status) {
      case 'STARTED':
        return 'Your data is protected';
      case 'STARTING':
        return AppLocalizations.of(context)!.establishingSecureConnection;
      case 'STOPPING':
        return 'Closing connection';
      default:
        return 'Tap to connect';
    }
  }

  String getButtonText(BuildContext context) {
    return _isLoading
        ? (_status == 'STOPPED'
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

  @override
  void dispose() {
    _rccService.dispose();
    super.dispose();
  }
}
