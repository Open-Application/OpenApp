import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fa'),
    Locale('hi'),
    Locale('id'),
    Locale('ms'),
    Locale('ru'),
    Locale('tr'),
    Locale('zh'),
  ];

  /// Dashboard navigation label
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// Profile navigation label
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Rcc connect button
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// Rcc disconnect button
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// Rcc connecting status
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get connecting;

  /// Rcc disconnecting status
  ///
  /// In en, this message translates to:
  /// **'Disconnecting...'**
  String get disconnecting;

  /// Rcc connected status
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// Rcc disconnected status
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get disconnected;

  /// Connection encrypted label
  ///
  /// In en, this message translates to:
  /// **'Encrypted'**
  String get encrypted;

  /// Connection unprotected warning
  ///
  /// In en, this message translates to:
  /// **'Unprotected'**
  String get unprotected;

  /// Rcc permission message
  ///
  /// In en, this message translates to:
  /// **'Rcc permission required'**
  String get vpnPermissionRequired;

  /// Rcc start failure
  ///
  /// In en, this message translates to:
  /// **'Failed to start Rcc service'**
  String get failedToStartVpn;

  /// No network connection error message
  ///
  /// In en, this message translates to:
  /// **'No network connection. Please check your Wi-Fi or mobile data.'**
  String get noNetworkConnection;

  /// Settings section
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Dark mode toggle
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// About section title
  ///
  /// In en, this message translates to:
  /// **'About {projectName}'**
  String aboutProject(String projectName);

  /// Version label
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Open source license label
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get openSourceLicense;

  /// Core library label
  ///
  /// In en, this message translates to:
  /// **'Core Library'**
  String get coreLibrary;

  /// Terms of use label
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get termsOfUse;

  /// Privacy policy label
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Status section title
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// Control section title
  ///
  /// In en, this message translates to:
  /// **'Control'**
  String get control;

  /// Dashboard subtitle
  ///
  /// In en, this message translates to:
  /// **'Network control center'**
  String get networkControlCenter;

  /// Connection status label
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get connectionStatus;

  /// Secure connection message
  ///
  /// In en, this message translates to:
  /// **'Your network connection is protected'**
  String get yourInternetIsSecure;

  /// Exposed connection message
  ///
  /// In en, this message translates to:
  /// **'Your network connection is vulnerable'**
  String get yourInternetIsExposed;

  /// Connecting status message
  ///
  /// In en, this message translates to:
  /// **'Establishing secure connection'**
  String get establishingSecureConnection;

  /// Disconnecting status message
  ///
  /// In en, this message translates to:
  /// **'Closing secure connection'**
  String get closingSecureConnection;

  /// Language setting label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Chinese language option
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get chinese;

  /// System default language option
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// Language selection dialog title
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// Privacy section title
  ///
  /// In en, this message translates to:
  /// **'Privacy and Support'**
  String get privacy;

  /// About section title
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Data collection section title
  ///
  /// In en, this message translates to:
  /// **'Data Collection'**
  String get dataCollection;

  /// Data collection description
  ///
  /// In en, this message translates to:
  /// **'We do not collect or store any personal information. All network configurations are stored locally on your device.'**
  String get dataCollectionText;

  /// Network traffic section title
  ///
  /// In en, this message translates to:
  /// **'Network Traffic'**
  String get networkTraffic;

  /// Network traffic description
  ///
  /// In en, this message translates to:
  /// **'This educational tool processes network traffic locally for learning purposes. No data is transmitted to external servers for tracking or analytics.'**
  String get networkTrafficText;

  /// Third-party services section title
  ///
  /// In en, this message translates to:
  /// **'Third-Party Services'**
  String get thirdPartyServices;

  /// Third-party services description
  ///
  /// In en, this message translates to:
  /// **'We do not share any information with third parties. All operations are performed locally on your device.'**
  String get thirdPartyServicesText;

  /// Data security section title
  ///
  /// In en, this message translates to:
  /// **'Data Security'**
  String get dataSecurity;

  /// Data security description
  ///
  /// In en, this message translates to:
  /// **'All configurations and settings are encrypted and stored securely on your device using industry-standard encryption methods.'**
  String get dataSecurityText;

  /// Educational use only section title
  ///
  /// In en, this message translates to:
  /// **'Educational Use Only'**
  String get educationalUseOnly;

  /// Educational use only description
  ///
  /// In en, this message translates to:
  /// **'This software is provided for educational and research purposes only. Users must comply with all applicable laws and regulations.'**
  String get educationalUseOnlyText;

  /// No warranty section title
  ///
  /// In en, this message translates to:
  /// **'No Warranty'**
  String get noWarranty;

  /// No warranty description
  ///
  /// In en, this message translates to:
  /// **'The software is provided \"as is\" without warranty of any kind. We are not responsible for any damages arising from its use.'**
  String get noWarrantyText;

  /// User responsibility section title
  ///
  /// In en, this message translates to:
  /// **'User Responsibility'**
  String get userResponsibility;

  /// User responsibility description
  ///
  /// In en, this message translates to:
  /// **'Users are responsible for ensuring their use of this tool complies with local regulations and institutional policies.'**
  String get userResponsibilityText;

  /// Academic integrity section title
  ///
  /// In en, this message translates to:
  /// **'Academic Integrity'**
  String get academicIntegrity;

  /// Academic integrity description
  ///
  /// In en, this message translates to:
  /// **'This tool should be used in accordance with academic integrity guidelines and ethical research practices.'**
  String get academicIntegrityText;

  /// Close button text
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Purpose label
  ///
  /// In en, this message translates to:
  /// **'Purpose'**
  String get purpose;

  /// Educational label
  ///
  /// In en, this message translates to:
  /// **'Educational'**
  String get educational;

  /// Technology label
  ///
  /// In en, this message translates to:
  /// **'Technology'**
  String get technology;

  /// Network research label
  ///
  /// In en, this message translates to:
  /// **'Network Research'**
  String get networkResearch;

  /// Rcc stopped status
  ///
  /// In en, this message translates to:
  /// **'STOPPED'**
  String get stopped;

  /// Rcc connected status
  ///
  /// In en, this message translates to:
  /// **'CONNECTED'**
  String get started;

  /// Rcc connecting status
  ///
  /// In en, this message translates to:
  /// **'CONNECTING'**
  String get starting;

  /// Rcc disconnecting status
  ///
  /// In en, this message translates to:
  /// **'DISCONNECTING'**
  String get stopping;

  /// Active status
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// Inactive status
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// Mobile device type
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get mobile;

  /// Desktop device type
  ///
  /// In en, this message translates to:
  /// **'Desktop'**
  String get desktop;

  /// Service logs section title
  ///
  /// In en, this message translates to:
  /// **'Service Logs'**
  String get serviceLogs;

  /// Logs section title
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get logs;

  /// Copy logs button tooltip
  ///
  /// In en, this message translates to:
  /// **'Copy logs'**
  String get copyLogs;

  /// Message shown when logs are copied
  ///
  /// In en, this message translates to:
  /// **'Logs copied to clipboard'**
  String get logsCopiedToClipboard;

  /// Message shown when there are no logs
  ///
  /// In en, this message translates to:
  /// **'No logs yet'**
  String get noLogsYet;

  /// Log count display
  ///
  /// In en, this message translates to:
  /// **'{count} log entries'**
  String logEntries(int count);

  /// Account management center description
  ///
  /// In en, this message translates to:
  /// **'Account management hub'**
  String get accountManagementHub;

  /// About project description
  ///
  /// In en, this message translates to:
  /// **'{projectName} is an educational network security tool designed to help users understand privacy protection and secure network communications. This application is intended for educational and research purposes, enabling users to learn about network protocols, encryption, and privacy technologies. All operations are performed locally on your device in compliance with applicable laws and regulations.'**
  String aboutProjectText(String projectName);

  /// Configuration section title
  ///
  /// In en, this message translates to:
  /// **'Configuration'**
  String get configuration;

  /// Error message when no configuration is available
  ///
  /// In en, this message translates to:
  /// **'Configuration is required to connect'**
  String get configurationRequired;

  /// User configuration label
  ///
  /// In en, this message translates to:
  /// **'User Configuration'**
  String get userConfiguration;

  /// Hint text for config input field
  ///
  /// In en, this message translates to:
  /// **'Enter Base64 Encoded Config'**
  String get enterBase64Config;

  /// Placeholder text for config input
  ///
  /// In en, this message translates to:
  /// **'Paste your base64 encoded configuration here'**
  String get pasteConfigHere;

  /// Save configuration button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveConfiguration;

  /// Clear configuration button
  ///
  /// In en, this message translates to:
  /// **'Clear Configuration'**
  String get clearConfiguration;

  /// Success message when config is saved
  ///
  /// In en, this message translates to:
  /// **'Configuration saved successfully'**
  String get configSaved;

  /// Message when config is cleared
  ///
  /// In en, this message translates to:
  /// **'Configuration cleared'**
  String get configCleared;

  /// Error message when trying to save empty config
  ///
  /// In en, this message translates to:
  /// **'Configuration cannot be empty'**
  String get configEmpty;

  /// Config status label
  ///
  /// In en, this message translates to:
  /// **'Config Status'**
  String get configStatus;

  /// Custom config status label
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get customConfig;

  /// No custom config status label
  ///
  /// In en, this message translates to:
  /// **'No saved config'**
  String get noCustomConfig;

  /// Arabic language option
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// Russian language option
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get russian;

  /// Turkish language option
  ///
  /// In en, this message translates to:
  /// **'Türkçe'**
  String get turkish;

  /// Malay language option
  ///
  /// In en, this message translates to:
  /// **'Melayu'**
  String get malay;

  /// Persian language option
  ///
  /// In en, this message translates to:
  /// **'فارسی'**
  String get persian;

  /// Hindi language option
  ///
  /// In en, this message translates to:
  /// **'हिन्दी'**
  String get hindi;

  /// Indonesian language option
  ///
  /// In en, this message translates to:
  /// **'Bahasa Indonesia'**
  String get indonesian;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'en',
    'fa',
    'hi',
    'id',
    'ms',
    'ru',
    'tr',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fa':
      return AppLocalizationsFa();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'ms':
      return AppLocalizationsMs();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
