// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get dashboard => 'داشبورد';

  @override
  String get profile => 'پروفایل';

  @override
  String get connect => 'اتصال';

  @override
  String get disconnect => 'قطع اتصال';

  @override
  String get connecting => 'در حال اتصال...';

  @override
  String get disconnecting => 'در حال قطع اتصال...';

  @override
  String get connected => 'متصل شد';

  @override
  String get disconnected => 'قطع شد';

  @override
  String get servicePermissionRequired => 'مجوز سرویس لازم است';

  @override
  String get failedToStartService => 'راه‌اندازی سرویس ناموفق بود';

  @override
  String get noNetworkConnection =>
      'اتصال شبکه وجود ندارد. لطفاً Wi-Fi یا داده موبایل خود را بررسی کنید.';

  @override
  String get settings => 'تنظیمات';

  @override
  String get darkMode => 'حالت تاریک';

  @override
  String aboutProject(String projectName) {
    return 'درباره $projectName';
  }

  @override
  String get version => 'نسخه';

  @override
  String get openSourceLicense => 'مجوز';

  @override
  String get termsOfUse => 'شرایط استفاده';

  @override
  String get privacyPolicy => 'سیاست حریم خصوصی';

  @override
  String get status => 'وضعیت';

  @override
  String get control => 'کنترل';

  @override
  String get networkControlCenter => 'مرکز کنترل شبکه';

  @override
  String get connectionStatus => 'وضعیت';

  @override
  String get language => 'زبان';

  @override
  String get systemDefault => 'پیش‌فرض سیستم';

  @override
  String get selectLanguage => 'انتخاب زبان';

  @override
  String get privacy => 'حریم خصوصی و پشتیبانی';

  @override
  String get about => 'درباره';

  @override
  String get close => 'بستن';

  @override
  String get agree => 'موافقم';

  @override
  String get stopped => 'متوقف شد';

  @override
  String get started => 'متصل شد';

  @override
  String get starting => 'در حال اتصال';

  @override
  String get stopping => 'در حال قطع';

  @override
  String get active => 'فعال';

  @override
  String get inactive => 'غیرفعال';

  @override
  String get mobile => 'موبایل';

  @override
  String get desktop => 'دسکتاپ';

  @override
  String get serviceLogs => 'گزارش‌های سرویس';

  @override
  String get logs => 'گزارش‌ها';

  @override
  String get copyLogs => 'کپی گزارش‌ها';

  @override
  String get logsCopiedToClipboard => 'گزارش‌ها در کلیپ‌بورد کپی شد';

  @override
  String get noLogsYet => 'هنوز گزارشی وجود ندارد';

  @override
  String logEntries(int count) {
    return '$count ورودی گزارش';
  }

  @override
  String get accountManagementHub => 'مرکز مدیریت حساب';

  @override
  String aboutProjectText(String projectName) {
    return '$projectName پلتفرم تحقیقاتی شبکه متن‌باز برای حریم خصوصی و امنیت است';
  }

  @override
  String get configuration => 'پیکربندی';

  @override
  String get configurationRequired => 'برای اتصال پیکربندی لازم است';

  @override
  String get enterBase64Config => 'پیکربندی رمزگذاری شده Base64 را وارد کنید';

  @override
  String get pasteConfigHere =>
      'پیکربندی رمزگذاری شده base64 خود را اینجا قرار دهید';

  @override
  String get saveConfiguration => 'ذخیره';

  @override
  String get clearConfiguration => 'پاک کردن پیکربندی';

  @override
  String get configSaved => 'پیکربندی با موفقیت ذخیره شد';

  @override
  String get configCleared => 'پیکربندی پاک شد';

  @override
  String get configEmpty => 'پیکربندی نمی‌تواند خالی باشد';

  @override
  String get noCustomConfig => 'پیکربندی ذخیره شده وجود ندارد';
}
