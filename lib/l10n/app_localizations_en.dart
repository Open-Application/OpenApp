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
  String get encrypted => 'Encrypted';

  @override
  String get unprotected => 'Unprotected';

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
  String get coreLibrary => 'Core Library';

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
  String get yourInternetIsSecure => 'Your network connection is protected';

  @override
  String get yourInternetIsExposed => 'Your network connection is vulnerable';

  @override
  String get establishingSecureConnection => 'Establishing secure connection';

  @override
  String get closingSecureConnection => 'Closing secure connection';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get chinese => 'Chinese';

  @override
  String get systemDefault => 'System Default';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get privacy => 'Privacy and Support';

  @override
  String get about => 'About';

  @override
  String get dataCollection => 'Data Collection';

  @override
  String get dataCollectionText =>
      'We do not collect or store any personal information. All network configurations are stored locally on your device.';

  @override
  String get networkTraffic => 'Network Traffic';

  @override
  String get networkTrafficText =>
      'This educational tool processes network traffic locally for learning purposes. No data is transmitted to external servers for tracking or analytics.';

  @override
  String get thirdPartyServices => 'Third-Party Services';

  @override
  String get thirdPartyServicesText =>
      'We do not share any information with third parties. All operations are performed locally on your device.';

  @override
  String get dataSecurity => 'Data Security';

  @override
  String get dataSecurityText =>
      'All configurations and settings are encrypted and stored securely on your device using industry-standard encryption methods.';

  @override
  String get educationalUseOnly => 'Educational Use Only';

  @override
  String get educationalUseOnlyText =>
      'This software is provided for educational and research purposes only. Users must comply with all applicable laws and regulations.';

  @override
  String get noWarranty => 'No Warranty';

  @override
  String get noWarrantyText =>
      'The software is provided \"as is\" without warranty of any kind. We are not responsible for any damages arising from its use.';

  @override
  String get userResponsibility => 'User Responsibility';

  @override
  String get userResponsibilityText =>
      'Users are responsible for ensuring their use of this tool complies with local regulations and institutional policies.';

  @override
  String get academicIntegrity => 'Academic Integrity';

  @override
  String get academicIntegrityText =>
      'This tool should be used in accordance with academic integrity guidelines and ethical research practices.';

  @override
  String get close => 'Close';

  @override
  String get agree => 'Agree';

  @override
  String get purpose => 'Purpose';

  @override
  String get educational => 'Educational';

  @override
  String get technology => 'Technology';

  @override
  String get networkResearch => 'Network Research';

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
    return '$projectName is an educational network security tool designed to help users understand privacy protection and secure network communications. This application is intended for educational and research purposes, enabling users to learn about network protocols, encryption, and privacy technologies. All operations are performed locally on your device in compliance with applicable laws and regulations.';
  }

  @override
  String get configuration => 'Configuration';

  @override
  String get configurationRequired => 'Configuration is required to connect';

  @override
  String get userConfiguration => 'User Configuration';

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
  String get configStatus => 'Config Status';

  @override
  String get customConfig => 'Saved';

  @override
  String get noCustomConfig => 'No saved config';

  @override
  String get arabic => 'العربية';

  @override
  String get russian => 'Русский';

  @override
  String get turkish => 'Türkçe';

  @override
  String get malay => 'Melayu';

  @override
  String get persian => 'فارسی';

  @override
  String get hindi => 'हिन्दी';

  @override
  String get indonesian => 'Bahasa Indonesia';

  @override
  String serviceDataPrivacy(String appName) {
    return '$appName Network Connect Data Privacy';
  }

  @override
  String get serviceDataCollectionTitle =>
      'What user information is the app collecting using the service?';

  @override
  String get serviceDataCollectionAnswer =>
      'This application does NOT collect any user information through the service. All network traffic processing is performed locally on your device. No browsing history, personal data, or identifiable information is collected, logged, or transmitted.';

  @override
  String get serviceDataPurposeTitle =>
      'For what purposes is this information collected?';

  @override
  String get serviceDataPurposeAnswer =>
      'Since no user data is collected, there are no purposes for data collection. The service functionality is used solely to route network traffic according to your configuration for educational and privacy protection purposes. All operations are local to your device.';

  @override
  String get serviceDataSharingTitle =>
      'Will the data be shared with any third parties?';

  @override
  String get serviceDataSharingAnswer =>
      'No data is shared with any third parties because no data is collected. This application operates entirely locally on your device and does not transmit any user information to external servers. Your privacy is completely protected.';
}
