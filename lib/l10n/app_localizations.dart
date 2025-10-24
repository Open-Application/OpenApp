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

abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

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

  String get dashboard;

  String get profile;

  String get connect;

  String get disconnect;

  String get connecting;

  String get disconnecting;

  String get connected;

  String get disconnected;

  String get encrypted;

  String get unprotected;

  String get vpnPermissionRequired;

  String get failedToStartVpn;

  String get noNetworkConnection;

  String get settings;

  String get darkMode;

  String aboutProject(String projectName);

  String get version;

  String get openSourceLicense;

  String get coreLibrary;

  String get termsOfUse;

  String get privacyPolicy;

  String get status;

  String get control;

  String get networkControlCenter;

  String get connectionStatus;

  String get yourInternetIsSecure;

  String get yourInternetIsExposed;

  String get establishingSecureConnection;

  String get closingSecureConnection;

  String get language;

  String get english;

  String get chinese;

  String get systemDefault;

  String get selectLanguage;

  String get privacy;

  String get about;

  String get dataCollection;

  String get dataCollectionText;

  String get networkTraffic;

  String get networkTrafficText;

  String get thirdPartyServices;

  String get thirdPartyServicesText;

  String get dataSecurity;

  String get dataSecurityText;

  String get educationalUseOnly;

  String get educationalUseOnlyText;

  String get noWarranty;

  String get noWarrantyText;

  String get userResponsibility;

  String get userResponsibilityText;

  String get academicIntegrity;

  String get academicIntegrityText;

  String get close;

  String get purpose;

  String get educational;

  String get technology;

  String get networkResearch;

  String get stopped;

  String get started;

  String get starting;

  String get stopping;

  String get active;

  String get inactive;

  String get mobile;

  String get desktop;

  String get serviceLogs;

  String get logs;

  String get copyLogs;

  String get logsCopiedToClipboard;

  String get noLogsYet;

  String logEntries(int count);

  String get accountManagementHub;

  String aboutProjectText(String projectName);

  String get configuration;

  String get configurationRequired;

  String get userConfiguration;

  String get enterBase64Config;

  String get pasteConfigHere;

  String get saveConfiguration;

  String get clearConfiguration;

  String get configSaved;

  String get configCleared;

  String get configEmpty;

  String get configStatus;

  String get customConfig;

  String get noCustomConfig;

  String get arabic;

  String get russian;

  String get turkish;

  String get malay;

  String get persian;

  String get hindi;

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
