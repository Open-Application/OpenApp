// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get dashboard => 'Dashboard';

  @override
  String get profile => 'Profile';

  @override
  String get connect => 'Connect';

  @override
  String get disconnect => 'Disconnect';

  @override
  String get connecting => 'Connecting...';

  @override
  String get disconnecting => 'Disconnecting...';

  @override
  String get connected => 'Connected';

  @override
  String get disconnected => 'Disconnected';

  @override
  String get servicePermissionRequired => 'Service permission required';

  @override
  String get failedToStartService => 'Failed to start service';

  @override
  String get noNetworkConnection =>
      'No network connection. Please check your Wi-Fi or mobile data.';

  @override
  String get settings => 'Settings';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String aboutProject(String projectName) {
    return 'About $projectName';
  }

  @override
  String get version => 'Version';

  @override
  String get openSourceLicense => 'License';

  @override
  String get termsOfUse => 'Terms of Use';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get status => 'Status';

  @override
  String get control => 'Control';

  @override
  String get networkControlCenter => 'Network control center';

  @override
  String get connectionStatus => 'Status';

  @override
  String get language => 'Language';

  @override
  String get systemDefault => 'System Default';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get privacy => 'Privacy and Support';

  @override
  String get about => 'About';

  @override
  String get close => 'Close';

  @override
  String get agree => 'Agree';

  @override
  String get stopped => 'STOPPED';

  @override
  String get started => 'CONNECTED';

  @override
  String get starting => 'CONNECTING';

  @override
  String get stopping => 'DISCONNECTING';

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String get mobile => 'Mobile';

  @override
  String get desktop => 'Desktop';

  @override
  String get serviceLogs => 'Service Logs';

  @override
  String get logs => 'Logs';

  @override
  String get copyLogs => 'Copy logs';

  @override
  String get logsCopiedToClipboard => 'Logs copied to clipboard';

  @override
  String get noLogsYet => 'No logs yet';

  @override
  String logEntries(int count) {
    return '$count log entries';
  }

  @override
  String get accountManagementHub => 'Account management hub';

  @override
  String aboutProjectText(String projectName) {
    return '$projectName is open-source network research platform for privacy and security';
  }

  @override
  String get configuration => 'Configuration';

  @override
  String get configurationRequired => 'Configuration is required to connect';

  @override
  String get enterBase64Config => 'Enter Base64 Encoded Config';

  @override
  String get pasteConfigHere => 'Paste your base64 encoded configuration here';

  @override
  String get saveConfiguration => 'Save';

  @override
  String get clearConfiguration => 'Clear Configuration';

  @override
  String get configSaved => 'Configuration saved successfully';

  @override
  String get configCleared => 'Configuration cleared';

  @override
  String get configEmpty => 'Configuration cannot be empty';

  @override
  String get noCustomConfig => 'No saved config';
}
