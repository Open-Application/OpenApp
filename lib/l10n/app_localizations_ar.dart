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
  String get encrypted => 'مشفر';

  @override
  String get unprotected => 'غير محمي';

  @override
  String get vpnPermissionRequired => 'مطلوب إذن Rcc';

  @override
  String get failedToStartVpn => 'فشل في بدء خدمة Rcc';

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
  String get coreLibrary => 'المكتبة الأساسية';

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
  String get yourInternetIsSecure => 'اتصال شبكتك محمي';

  @override
  String get yourInternetIsExposed => 'اتصال شبكتك معرض للخطر';

  @override
  String get establishingSecureConnection => 'جارٍ إنشاء اتصال آمن';

  @override
  String get closingSecureConnection => 'جارٍ إغلاق الاتصال الآمن';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'English';

  @override
  String get chinese => '中文';

  @override
  String get systemDefault => 'النظام الافتراضي';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get privacy => 'الخصوصية والدعم';

  @override
  String get about => 'حول';

  @override
  String get dataCollection => 'جمع البيانات';

  @override
  String get dataCollectionText =>
      'نحن لا نجمع أو نخزن أي معلومات شخصية. يتم تخزين جميع تكوينات الشبكة محليًا على جهازك.';

  @override
  String get networkTraffic => 'حركة الشبكة';

  @override
  String get networkTrafficText =>
      'تقوم هذه الأداة التعليمية بمعالجة حركة الشبكة محليًا لأغراض التعلم. لا يتم إرسال أي بيانات إلى خوادم خارجية للتتبع أو التحليلات.';

  @override
  String get thirdPartyServices => 'خدمات الطرف الثالث';

  @override
  String get thirdPartyServicesText =>
      'نحن لا نشارك أي معلومات مع أطراف ثالثة. يتم تنفيذ جميع العمليات محليًا على جهازك.';

  @override
  String get dataSecurity => 'أمان البيانات';

  @override
  String get dataSecurityText =>
      'يتم تشفير جميع التكوينات والإعدادات وتخزينها بشكل آمن على جهازك باستخدام طرق التشفير القياسية في الصناعة.';

  @override
  String get educationalUseOnly => 'للاستخدام التعليمي فقط';

  @override
  String get educationalUseOnlyText =>
      'يتم توفير هذا البرنامج للأغراض التعليمية والبحثية فقط. يجب على المستخدمين الامتثال لجميع القوانين واللوائح المعمول بها.';

  @override
  String get noWarranty => 'بدون ضمان';

  @override
  String get noWarrantyText =>
      'يتم توفير البرنامج \"كما هو\" دون ضمان من أي نوع. نحن لسنا مسؤولين عن أي أضرار ناتجة عن استخدامه.';

  @override
  String get userResponsibility => 'مسؤولية المستخدم';

  @override
  String get userResponsibilityText =>
      'المستخدمون مسؤولون عن ضمان امتثال استخدامهم لهذه الأداة للوائح المحلية وسياسات المؤسسة.';

  @override
  String get academicIntegrity => 'النزاهة الأكاديمية';

  @override
  String get academicIntegrityText =>
      'يجب استخدام هذه الأداة وفقًا لإرشادات النزاهة الأكاديمية وممارسات البحث الأخلاقية.';

  @override
  String get close => 'إغلاق';

  @override
  String get purpose => 'الغرض';

  @override
  String get educational => 'تعليمي';

  @override
  String get technology => 'التكنولوجيا';

  @override
  String get networkResearch => 'بحث الشبكة';

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
    return '$projectName هي أداة تعليمية لأمن الشبكات مصممة لمساعدة المستخدمين على فهم حماية الخصوصية والاتصالات الآمنة للشبكة. هذا التطبيق مخصص للأغراض التعليمية والبحثية، مما يتيح للمستخدمين التعرف على بروتوكولات الشبكة والتشفير وتقنيات الخصوصية. يتم تنفيذ جميع العمليات محليًا على جهازك بما يتوافق مع القوانين واللوائح المعمول بها.';
  }

  @override
  String get configuration => 'التكوين';

  @override
  String get configurationRequired => 'التكوين مطلوب للاتصال';

  @override
  String get userConfiguration => 'تكوين المستخدم';

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
  String get configStatus => 'حالة التكوين';

  @override
  String get customConfig => 'محفوظ';

  @override
  String get noCustomConfig => 'لا يوجد تكوين محفوظ';

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
}
