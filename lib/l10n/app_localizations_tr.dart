import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get dashboard => 'Kontrol Paneli';

  @override
  String get profile => 'Profil';

  @override
  String get connect => 'Bağlan';

  @override
  String get disconnect => 'Bağlantıyı Kes';

  @override
  String get connecting => 'Bağlanıyor...';

  @override
  String get disconnecting => 'Bağlantı Kesiliyor...';

  @override
  String get connected => 'Bağlandı';

  @override
  String get disconnected => 'Bağlantı Kesildi';

  @override
  String get encrypted => 'Şifreli';

  @override
  String get unprotected => 'Korumasız';

  @override
  String get vpnPermissionRequired => 'Rcc izni gerekli';

  @override
  String get failedToStartVpn => 'Rcc hizmeti başlatılamadı';

  @override
  String get noNetworkConnection =>
      'Ağ bağlantısı yok. Lütfen Wi-Fi veya mobil verilerinizi kontrol edin.';

  @override
  String get settings => 'Ayarlar';

  @override
  String get darkMode => 'Karanlık Mod';

  @override
  String aboutProject(String projectName) {
    return '$projectName Hakkında';
  }

  @override
  String get version => 'Sürüm';

  @override
  String get openSourceLicense => 'Lisans';

  @override
  String get coreLibrary => 'Temel Kütüphane';

  @override
  String get termsOfUse => 'Kullanım Koşulları';

  @override
  String get privacyPolicy => 'Gizlilik Politikası';

  @override
  String get status => 'Durum';

  @override
  String get control => 'Kontrol';

  @override
  String get networkControlCenter => 'Ağ kontrol merkezi';

  @override
  String get connectionStatus => 'Durum';

  @override
  String get yourInternetIsSecure => 'Ağ bağlantınız korunuyor';

  @override
  String get yourInternetIsExposed => 'Ağ bağlantınız savunmasız';

  @override
  String get establishingSecureConnection => 'Güvenli bağlantı kuruluyor';

  @override
  String get closingSecureConnection => 'Güvenli bağlantı kapatılıyor';

  @override
  String get language => 'Dil';

  @override
  String get english => 'English';

  @override
  String get chinese => '中文';

  @override
  String get systemDefault => 'Sistem Varsayılanı';

  @override
  String get selectLanguage => 'Dil Seçin';

  @override
  String get privacy => 'Gizlilik ve Destek';

  @override
  String get about => 'Hakkında';

  @override
  String get dataCollection => 'Veri Toplama';

  @override
  String get dataCollectionText =>
      'Hiçbir kişisel bilgi toplamıyor veya saklamıyoruz. Tüm ağ yapılandırmaları cihazınızda yerel olarak saklanır.';

  @override
  String get networkTraffic => 'Ağ Trafiği';

  @override
  String get networkTrafficText =>
      'Bu eğitim aracı, öğrenme amaçları için ağ trafiğini yerel olarak işler. İzleme veya analiz için harici sunuculara hiçbir veri iletilmez.';

  @override
  String get thirdPartyServices => 'Üçüncü Taraf Hizmetler';

  @override
  String get thirdPartyServicesText =>
      'Üçüncü taraflarla hiçbir bilgi paylaşmıyoruz. Tüm işlemler cihazınızda yerel olarak gerçekleştirilir.';

  @override
  String get dataSecurity => 'Veri Güvenliği';

  @override
  String get dataSecurityText =>
      'Tüm yapılandırmalar ve ayarlar, endüstri standartı şifreleme yöntemleri kullanılarak şifrelenir ve cihazınızda güvenli bir şekilde saklanır.';

  @override
  String get educationalUseOnly => 'Yalnızca Eğitim Amaçlı';

  @override
  String get educationalUseOnlyText =>
      'Bu yazılım yalnızca eğitim ve araştırma amaçları için sağlanmaktadır. Kullanıcılar, geçerli tüm yasa ve düzenlemelere uymak zorundadır.';

  @override
  String get noWarranty => 'Garanti Yok';

  @override
  String get noWarrantyText =>
      'Yazılım \"olduğu gibi\" herhangi bir garanti olmaksızın sağlanmaktadır. Kullanımından kaynaklanan herhangi bir zarardan sorumlu değiliz.';

  @override
  String get userResponsibility => 'Kullanıcı Sorumluluğu';

  @override
  String get userResponsibilityText =>
      'Kullanıcılar, bu aracın kullanımının yerel düzenlemelere ve kurumsal politikalara uygun olduğundan emin olmaktan sorumludur.';

  @override
  String get academicIntegrity => 'Akademik Dürüstlük';

  @override
  String get academicIntegrityText =>
      'Bu araç, akademik dürüstlük yönergeleri ve etik araştırma uygulamalarına uygun olarak kullanılmalıdır.';

  @override
  String get close => 'Kapat';

  @override
  String get purpose => 'Amaç';

  @override
  String get educational => 'Eğitim';

  @override
  String get technology => 'Teknoloji';

  @override
  String get networkResearch => 'Ağ Araştırması';

  @override
  String get stopped => 'DURDURULDU';

  @override
  String get started => 'BAĞLANDI';

  @override
  String get starting => 'BAĞLANIYOR';

  @override
  String get stopping => 'KESİLİYOR';

  @override
  String get active => 'Aktif';

  @override
  String get inactive => 'Pasif';

  @override
  String get mobile => 'Mobil';

  @override
  String get desktop => 'Masaüstü';

  @override
  String get serviceLogs => 'Hizmet Günlükleri';

  @override
  String get logs => 'Günlükler';

  @override
  String get copyLogs => 'Günlükleri kopyala';

  @override
  String get logsCopiedToClipboard => 'Günlükler panoya kopyalandı';

  @override
  String get noLogsYet => 'Henüz günlük yok';

  @override
  String logEntries(int count) {
    return '$count günlük kaydı';
  }

  @override
  String get accountManagementHub => 'Hesap yönetim merkezi';

  @override
  String aboutProjectText(String projectName) {
    return '$projectName, kullanıcıların gizlilik korumasını ve güvenli ağ iletişimini anlamalarına yardımcı olmak için tasarlanmış bir eğitim ağ güvenliği aracıdır. Bu uygulama, kullanıcıların ağ protokolleri, şifreleme ve gizlilik teknolojileri hakkında bilgi edinmelerini sağlayan eğitim ve araştırma amaçlarına yöneliktir. Tüm işlemler, geçerli yasa ve düzenlemelere uygun olarak cihazınızda yerel olarak gerçekleştirilir.';
  }

  @override
  String get configuration => 'Yapılandırma';

  @override
  String get configurationRequired => 'Bağlanmak için yapılandırma gerekli';

  @override
  String get userConfiguration => 'Kullanıcı Yapılandırması';

  @override
  String get enterBase64Config => 'Base64 Kodlu Yapılandırmayı Girin';

  @override
  String get pasteConfigHere =>
      'Base64 kodlu yapılandırmanızı buraya yapıştırın';

  @override
  String get saveConfiguration => 'Kaydet';

  @override
  String get clearConfiguration => 'Yapılandırmayı Temizle';

  @override
  String get configSaved => 'Yapılandırma başarıyla kaydedildi';

  @override
  String get configCleared => 'Yapılandırma temizlendi';

  @override
  String get configEmpty => 'Yapılandırma boş olamaz';

  @override
  String get configStatus => 'Yapılandırma Durumu';

  @override
  String get customConfig => 'Kaydedildi';

  @override
  String get noCustomConfig => 'Kaydedilmiş yapılandırma yok';

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
