// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class AppLocalizationsMs extends AppLocalizations {
  AppLocalizationsMs([String locale = 'ms']) : super(locale);

  @override
  String get dashboard => 'Papan Pemuka';

  @override
  String get profile => 'Profil';

  @override
  String get connect => 'Sambung';

  @override
  String get disconnect => 'Putuskan Sambungan';

  @override
  String get connecting => 'Menyambung...';

  @override
  String get disconnecting => 'Memutuskan Sambungan...';

  @override
  String get connected => 'Disambung';

  @override
  String get disconnected => 'Terputus';

  @override
  String get servicePermissionRequired => 'Kebenaran perkhidmatan diperlukan';

  @override
  String get failedToStartService => 'Gagal memulakan perkhidmatan';

  @override
  String get noNetworkConnection =>
      'Tiada sambungan rangkaian. Sila periksa Wi-Fi atau data mudah alih anda.';

  @override
  String get settings => 'Tetapan';

  @override
  String get darkMode => 'Mod Gelap';

  @override
  String aboutProject(String projectName) {
    return 'Perihal $projectName';
  }

  @override
  String get version => 'Versi';

  @override
  String get termsOfUse => 'Terma Penggunaan';

  @override
  String get privacyPolicy => 'Dasar Privasi';

  @override
  String get status => 'Status';

  @override
  String get control => 'Kawalan';

  @override
  String get networkControlCenter => 'Pusat kawalan rangkaian';

  @override
  String get connectionStatus => 'Status';

  @override
  String get language => 'Bahasa';

  @override
  String get systemDefault => 'Lalai Sistem';

  @override
  String get selectLanguage => 'Pilih Bahasa';

  @override
  String get privacy => 'Privasi dan Sokongan';

  @override
  String get about => 'Perihal';

  @override
  String get close => 'Tutup';

  @override
  String get agree => 'Bersetuju';

  @override
  String get stopped => 'DIHENTIKAN';

  @override
  String get started => 'DISAMBUNG';

  @override
  String get starting => 'MENYAMBUNG';

  @override
  String get stopping => 'MEMUTUSKAN';

  @override
  String get active => 'Aktif';

  @override
  String get inactive => 'Tidak Aktif';

  @override
  String get mobile => 'Mudah Alih';

  @override
  String get desktop => 'Desktop';

  @override
  String get serviceLogs => 'Log Perkhidmatan';

  @override
  String get logs => 'Log';

  @override
  String get copyLogs => 'Salin log';

  @override
  String get logsCopiedToClipboard => 'Log disalin ke papan keratan';

  @override
  String get noLogsYet => 'Tiada log lagi';

  @override
  String logEntries(int count) {
    return '$count entri log';
  }

  @override
  String get accountManagementHub => 'Pusat pengurusan akaun';

  @override
  String aboutProjectText(String projectName) {
    return '$projectName ialah platform penyelidikan rangkaian sumber terbuka untuk privasi dan keselamatan';
  }

  @override
  String get configuration => 'Konfigurasi';

  @override
  String get configurationRequired => 'Konfigurasi diperlukan untuk menyambung';

  @override
  String get enterBase64Config => 'Masukkan Konfigurasi Berkod Base64';

  @override
  String get pasteConfigHere => 'Tampal konfigurasi berkod base64 anda di sini';

  @override
  String get saveConfiguration => 'Simpan';

  @override
  String get clearConfiguration => 'Kosongkan Konfigurasi';

  @override
  String get configSaved => 'Konfigurasi berjaya disimpan';

  @override
  String get configCleared => 'Konfigurasi dikosongkan';

  @override
  String get configEmpty => 'Konfigurasi tidak boleh kosong';

  @override
  String get noCustomConfig => 'Tiada konfigurasi tersimpan';
}
