// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get connect => 'اتصال';

  @override
  String get disconnect => 'قطع الاتصال';

  @override
  String get connecting => 'جارٍ الاتصال...';

  @override
  String get disconnecting => 'جارٍ قطع الاتصال...';

  @override
  String get connected => 'متصل';

  @override
  String get disconnected => 'غير متصل';

  @override
  String get servicePermissionRequired => 'مطلوب إذن الخدمة';

  @override
  String get failedToStartService => 'فشل في بدء الخدمة';

  @override
  String get noNetworkConnection =>
      'لا يوجد اتصال بالشبكة. يرجى التحقق من Wi-Fi أو بيانات الجوال.';

  @override
  String get settings => 'الإعدادات';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String aboutProject(String projectName) {
    return 'حول $projectName';
  }

  @override
  String get version => 'الإصدار';

  @override
  String get openSourceLicense => 'الترخيص';

  @override
  String get termsOfUse => 'شروط الاستخدام';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get status => 'الحالة';

  @override
  String get control => 'التحكم';

  @override
  String get networkControlCenter => 'مركز التحكم في الشبكة';

  @override
  String get connectionStatus => 'الحالة';

  @override
  String get language => 'اللغة';

  @override
  String get systemDefault => 'النظام الافتراضي';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get privacy => 'الخصوصية والدعم';

  @override
  String get about => 'حول';

  @override
  String get close => 'إغلاق';

  @override
  String get agree => 'موافق';

  @override
  String get stopped => 'متوقف';

  @override
  String get started => 'متصل';

  @override
  String get starting => 'جارٍ الاتصال';

  @override
  String get stopping => 'جارٍ القطع';

  @override
  String get active => 'نشط';

  @override
  String get inactive => 'غير نشط';

  @override
  String get mobile => 'جوال';

  @override
  String get desktop => 'سطح المكتب';

  @override
  String get serviceLogs => 'سجلات الخدمة';

  @override
  String get logs => 'السجلات';

  @override
  String get copyLogs => 'نسخ السجلات';

  @override
  String get logsCopiedToClipboard => 'تم نسخ السجلات إلى الحافظة';

  @override
  String get noLogsYet => 'لا توجد سجلات حتى الآن';

  @override
  String logEntries(int count) {
    return '$count إدخال سجل';
  }

  @override
  String get accountManagementHub => 'مركز إدارة الحساب';

  @override
  String aboutProjectText(String projectName) {
    return '$projectName هي منصة بحث شبكات مفتوحة المصدر للخصوصية والأمان';
  }

  @override
  String get configuration => 'التكوين';

  @override
  String get configurationRequired => 'التكوين مطلوب للاتصال';

  @override
  String get enterBase64Config => 'أدخل التكوين المشفر بـ Base64';

  @override
  String get pasteConfigHere => 'الصق تكوينك المشفر بـ base64 هنا';

  @override
  String get saveConfiguration => 'حفظ';

  @override
  String get clearConfiguration => 'مسح التكوين';

  @override
  String get configSaved => 'تم حفظ التكوين بنجاح';

  @override
  String get configCleared => 'تم مسح التكوين';

  @override
  String get configEmpty => 'لا يمكن أن يكون التكوين فارغًا';

  @override
  String get noCustomConfig => 'لا يوجد تكوين محفوظ';
}
