// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get dashboard => 'Dasbor';

  @override
  String get profile => 'Profil';

  @override
  String get connect => 'Hubungkan';

  @override
  String get disconnect => 'Putuskan';

  @override
  String get connecting => 'Menghubungkan...';

  @override
  String get disconnecting => 'Memutuskan...';

  @override
  String get connected => 'Terhubung';

  @override
  String get disconnected => 'Terputus';

  @override
  String get servicePermissionRequired => 'Izin layanan diperlukan';

  @override
  String get failedToStartService => 'Gagal memulai layanan';

  @override
  String get noNetworkConnection =>
      'Tidak ada koneksi jaringan. Silakan periksa Wi-Fi atau data seluler Anda.';

  @override
  String get settings => 'Pengaturan';

  @override
  String get darkMode => 'Mode Gelap';

  @override
  String aboutProject(String projectName) {
    return 'Tentang $projectName';
  }

  @override
  String get version => 'Versi';

  @override
  String get termsOfUse => 'Ketentuan Penggunaan';

  @override
  String get privacyPolicy => 'Kebijakan Privasi';

  @override
  String get status => 'Status';

  @override
  String get control => 'Kontrol';

  @override
  String get networkControlCenter => 'Pusat kontrol jaringan';

  @override
  String get connectionStatus => 'Status';

  @override
  String get language => 'Bahasa';

  @override
  String get systemDefault => 'Bawaan Sistem';

  @override
  String get selectLanguage => 'Pilih Bahasa';

  @override
  String get privacy => 'Privasi dan Dukungan';

  @override
  String get about => 'Tentang';

  @override
  String get close => 'Tutup';

  @override
  String get agree => 'Setuju';

  @override
  String get stopped => 'DIHENTIKAN';

  @override
  String get started => 'TERHUBUNG';

  @override
  String get starting => 'MENGHUBUNGKAN';

  @override
  String get stopping => 'MEMUTUSKAN';

  @override
  String get active => 'Aktif';

  @override
  String get inactive => 'Tidak Aktif';

  @override
  String get mobile => 'Seluler';

  @override
  String get desktop => 'Desktop';

  @override
  String get serviceLogs => 'Log Layanan';

  @override
  String get logs => 'Log';

  @override
  String get copyLogs => 'Salin log';

  @override
  String get logsCopiedToClipboard => 'Log disalin ke papan klip';

  @override
  String get noLogsYet => 'Belum ada log';

  @override
  String logEntries(int count) {
    return '$count entri log';
  }

  @override
  String get accountManagementHub => 'Pusat manajemen akun';

  @override
  String aboutProjectText(String projectName) {
    return '$projectName adalah platform penelitian jaringan sumber terbuka untuk privasi dan keamanan';
  }

  @override
  String get configuration => 'Konfigurasi';

  @override
  String get configurationRequired => 'Konfigurasi diperlukan untuk terhubung';

  @override
  String get enterBase64Config => 'Masukkan Konfigurasi Terenkode Base64';

  @override
  String get pasteConfigHere =>
      'Tempel konfigurasi berkode base64 Anda di sini';

  @override
  String get saveConfiguration => 'Simpan';

  @override
  String get clearConfiguration => 'Hapus Konfigurasi';

  @override
  String get configSaved => 'Konfigurasi berhasil disimpan';

  @override
  String get configCleared => 'Konfigurasi dihapus';

  @override
  String get configEmpty => 'Konfigurasi tidak boleh kosong';

  @override
  String get noCustomConfig => 'Tidak ada konfigurasi tersimpan';
}
