import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../utils/device_helper.dart';

class PreferencesProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  static const String _hasThemePreferenceKey = 'has_theme_preference';
  static const String _languageKey = 'app_language';
  static const String _userConfigKey = 'user_encoded_config';
  static const String _userConfigTimestampKey = 'user_config_timestamp';
  static const String _privacyAcceptedKey = 'privacy_accepted';

  ThemeMode _themeMode = ThemeMode.system;
  bool _hasUserThemePreference = false;

  Locale? _locale;

  String _version = '';
  String _appName = '';
  String _packageName = '';
  String _buildNumber = '';
  int _aboutClickCount = 0;
  bool _showServiceLogs = false;
  bool _isInitialized = false;
  Map<String, dynamic>? _deviceInfo;
  String? _userEncodedConfig;
  DateTime? _userConfigTimestamp;
  bool _privacyAccepted = false;

  ThemeMode get themeMode => _themeMode;
  bool get hasUserThemePreference => _hasUserThemePreference;

  Locale? get locale => _locale;
  String get version => _version;
  String get versionWithPrefix => _version.isEmpty ? '' : 'v$_version';
  bool get isLoadingVersion => !_isInitialized && _version.isEmpty;
  String get appName => _appName;
  String get packageName => _packageName;
  String get buildNumber => _buildNumber;
  int get aboutClickCount => _aboutClickCount;
  bool get showServiceLogs => _showServiceLogs;
  bool get isInitialized => _isInitialized;
  Map<String, dynamic>? get deviceInfo => _deviceInfo;
  String? get userEncodedConfig => _userEncodedConfig;
  bool get hasUserConfig => _userEncodedConfig != null && _userEncodedConfig!.isNotEmpty;
  DateTime? get userConfigTimestamp => _userConfigTimestamp;
  bool get privacyAccepted => _privacyAccepted;

  bool get isHuaweiDevice => DeviceHelper().isHuaweiDevice;
  bool get needsRenderingOptimization =>
      DeviceHelper().needsRenderingOptimization;
  bool get shouldUseAggressiveRepaintBoundaries =>
      DeviceHelper().shouldUseAggressiveRepaintBoundaries;
  bool get shouldPreloadFonts => DeviceHelper().shouldPreloadFonts;
  bool get shouldCacheText => DeviceHelper().shouldCacheText;
  ScrollPhysics getOptimizedScrollPhysics() =>
      DeviceHelper().getOptimizedScrollPhysics();

  PreferencesProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    await DeviceHelper().initialize();

    await Future.wait([
      _loadInfo(),
      _loadTheme(),
      _loadSavedLanguage(),
      _loadDeviceInfo(),
      _loadUserConfig(),
      _loadPrivacyAcceptance(),
    ]);
  }

  Future<void> _loadInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      _version = packageInfo.version;
      _appName = packageInfo.appName;
      _packageName = packageInfo.packageName;
      _buildNumber = packageInfo.buildNumber;
      _isInitialized = true;
      notifyListeners();
    } catch (_) {
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> _loadDeviceInfo() async {
    try {
      _deviceInfo = await DeviceHelper.getCurrentDeviceInfo();
    } catch (_) {
      _deviceInfo = {
        'type': 'unknown',
        'name': 'Unknown Device',
        'os_version': 'Unknown OS',
        'device_id': 'unknown',
      };
    }
  }

  void incrementAboutClickCount() {
    _aboutClickCount++;
    if (_aboutClickCount >= 5 && !_showServiceLogs) {
      _showServiceLogs = true;
      notifyListeners();
    }
  }

  void resetAboutClickCount() {
    _aboutClickCount = 0;
    notifyListeners();
  }

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _hasUserThemePreference = prefs.getBool(_hasThemePreferenceKey) ?? false;

      if (_hasUserThemePreference) {
        final themeModeString = prefs.getString(_themeKey);
        if (themeModeString != null) {
          if (themeModeString.contains('light')) {
            _themeMode = ThemeMode.light;
          } else if (themeModeString.contains('dark')) {
            _themeMode = ThemeMode.dark;
          } else {
            _themeMode = ThemeMode.system;
          }
        }
      } else {
        _themeMode = ThemeMode.system;
      }
      notifyListeners();
    } catch (_) {
      _themeMode = ThemeMode.system;
      notifyListeners();
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    _hasUserThemePreference = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode.toString());
    await prefs.setBool(_hasThemePreferenceKey, true);
  }

  void toggleTheme() {
    if (_themeMode == ThemeMode.dark) {
      setThemeMode(ThemeMode.light);
    } else {
      setThemeMode(ThemeMode.dark);
    }
  }

  bool isDarkMode(BuildContext context) {
    switch (_themeMode) {
      case ThemeMode.dark:
        return true;
      case ThemeMode.light:
        return false;
      case ThemeMode.system:
        return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode =
          prefs.getString(_languageKey) ?? prefs.getString('language_code');
      if (languageCode != null) {
        _locale = Locale(languageCode);
      }

      notifyListeners();
    } catch (_) {}
  }

  Future<void> _loadUserConfig() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _userEncodedConfig = prefs.getString(_userConfigKey);
      final timestamp = prefs.getInt(_userConfigTimestampKey);
      if (timestamp != null) {
        _userConfigTimestamp = DateTime.fromMillisecondsSinceEpoch(timestamp);
      }
      notifyListeners();
    } catch (_) {}
  }

  Future<void> _loadPrivacyAcceptance() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _privacyAccepted = prefs.getBool(_privacyAcceptedKey) ?? false;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> setPrivacyAccepted(bool accepted) async {
    _privacyAccepted = accepted;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_privacyAcceptedKey, accepted);
  }

  Future<void> setUserConfig(String config) async {
    _userEncodedConfig = config;
    _userConfigTimestamp = DateTime.now();
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userConfigKey, config);
    await prefs.setInt(_userConfigTimestampKey, _userConfigTimestamp!.millisecondsSinceEpoch);
  }

  Future<void> clearUserConfig() async {
    _userEncodedConfig = null;
    _userConfigTimestamp = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userConfigKey);
    await prefs.remove(_userConfigTimestampKey);
  }

  Future<void> setLanguage(String? languageCode) async {
    final prefs = await SharedPreferences.getInstance();

    if (languageCode == null) {
      await prefs.remove('language_code');
      await prefs.remove(_languageKey);
      _locale = null;
    } else {
      await prefs.setString('language_code', languageCode);
      await prefs.setString(_languageKey, languageCode);
      _locale = Locale(languageCode);
    }

    notifyListeners();
  }

  String getCurrentLanguageCode() {
    if (_locale != null) {
      return _locale!.languageCode;
    }

    final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
    return systemLocale.languageCode;
  }

  String getTranslationLanguageCode() {
    return getCurrentLanguageCode();
  }

  Future<void> resetPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_themeKey);
    await prefs.remove(_hasThemePreferenceKey);
    _themeMode = ThemeMode.system;
    _hasUserThemePreference = false;

    await prefs.remove('language_code');
    _locale = null;

    _aboutClickCount = 0;
    _showServiceLogs = false;

    notifyListeners();
  }
}
