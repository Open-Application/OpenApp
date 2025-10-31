// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
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
  String get servicePermissionRequired => 'Hizmet izni gerekli';

  @override
  String get failedToStartService => 'Hizmet başlatılamadı';

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
  String get language => 'Dil';

  @override
  String get systemDefault => 'Sistem Varsayılanı';

  @override
  String get selectLanguage => 'Dil Seçin';

  @override
  String get privacy => 'Gizlilik ve Destek';

  @override
  String get about => 'Hakkında';

  @override
  String get close => 'Kapat';

  @override
  String get agree => 'Kabul';

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
    return '$projectName, gizlilik ve güvenlik için açık kaynaklı ağ araştırma platformudur';
  }

  @override
  String get configuration => 'Yapılandırma';

  @override
  String get configurationRequired => 'Bağlanmak için yapılandırma gerekli';

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
  String get noCustomConfig => 'Kaydedilmiş yapılandırma yok';
}
