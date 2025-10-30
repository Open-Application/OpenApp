// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get dashboard => 'डैशबोर्ड';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get connect => 'कनेक्ट';

  @override
  String get disconnect => 'डिस्कनेक्ट';

  @override
  String get connecting => 'कनेक्ट हो रहा है...';

  @override
  String get disconnecting => 'डिस्कनेक्ट हो रहा है...';

  @override
  String get connected => 'कनेक्ट हो गया';

  @override
  String get disconnected => 'डिस्कनेक्ट हो गया';

  @override
  String get servicePermissionRequired => 'सेवा अनुमति आवश्यक है';

  @override
  String get failedToStartService => 'सेवा प्रारंभ करने में विफल';

  @override
  String get noNetworkConnection =>
      'कोई नेटवर्क कनेक्शन नहीं है। कृपया अपना Wi-Fi या मोबाइल डेटा जांचें।';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get darkMode => 'डार्क मोड';

  @override
  String aboutProject(String projectName) {
    return '$projectName के बारे में';
  }

  @override
  String get version => 'संस्करण';

  @override
  String get openSourceLicense => 'लाइसेंस';

  @override
  String get termsOfUse => 'उपयोग की शर्तें';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get status => 'स्थिति';

  @override
  String get control => 'नियंत्रण';

  @override
  String get networkControlCenter => 'नेटवर्क नियंत्रण केंद्र';

  @override
  String get connectionStatus => 'स्थिति';

  @override
  String get language => 'भाषा';

  @override
  String get systemDefault => 'सिस्टम डिफ़ॉल्ट';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String get privacy => 'गोपनीयता और सहायता';

  @override
  String get about => 'के बारे में';

  @override
  String get close => 'बंद करें';

  @override
  String get agree => 'सहमत';

  @override
  String get stopped => 'रुका हुआ';

  @override
  String get started => 'कनेक्टेड';

  @override
  String get starting => 'कनेक्ट हो रहा है';

  @override
  String get stopping => 'डिस्कनेक्ट हो रहा है';

  @override
  String get active => 'सक्रिय';

  @override
  String get inactive => 'निष्क्रिय';

  @override
  String get mobile => 'मोबाइल';

  @override
  String get desktop => 'डेस्कटॉप';

  @override
  String get serviceLogs => 'सेवा लॉग';

  @override
  String get logs => 'लॉग';

  @override
  String get copyLogs => 'लॉग कॉपी करें';

  @override
  String get logsCopiedToClipboard => 'लॉग क्लिपबोर्ड पर कॉपी किए गए';

  @override
  String get noLogsYet => 'अभी तक कोई लॉग नहीं';

  @override
  String logEntries(int count) {
    return '$count लॉग प्रविष्टियां';
  }

  @override
  String get accountManagementHub => 'खाता प्रबंधन केंद्र';

  @override
  String aboutProjectText(String projectName) {
    return '$projectName गोपनीयता और सुरक्षा के लिए ओपन-सोर्स नेटवर्क अनुसंधान प्लेटफ़ॉर्म है';
  }

  @override
  String get configuration => 'कॉन्फ़िगरेशन';

  @override
  String get configurationRequired =>
      'कनेक्ट करने के लिए कॉन्फ़िगरेशन आवश्यक है';

  @override
  String get enterBase64Config => 'Base64 एन्कोडेड कॉन्फ़िगरेशन दर्ज करें';

  @override
  String get pasteConfigHere =>
      'अपना base64 एन्कोडेड कॉन्फ़िगरेशन यहां पेस्ट करें';

  @override
  String get saveConfiguration => 'सहेजें';

  @override
  String get clearConfiguration => 'कॉन्फ़िगरेशन साफ़ करें';

  @override
  String get configSaved => 'कॉन्फ़िगरेशन सफलतापूर्वक सहेजा गया';

  @override
  String get configCleared => 'कॉन्फ़िगरेशन साफ़ किया गया';

  @override
  String get configEmpty => 'कॉन्फ़िगरेशन खाली नहीं हो सकता';

  @override
  String get noCustomConfig => 'कोई सहेजा गया कॉन्फ़िगरेशन नहीं';
}
