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
  String get encrypted => 'Terenkripsi';

  @override
  String get unprotected => 'Tidak Dilindungi';

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
  String get openSourceLicense => 'Lisensi';

  @override
  String get coreLibrary => 'Pustaka Inti';

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
  String get yourInternetIsSecure => 'Koneksi jaringan Anda terlindungi';

  @override
  String get yourInternetIsExposed => 'Koneksi jaringan Anda rentan';

  @override
  String get establishingSecureConnection => 'Membuat koneksi aman';

  @override
  String get closingSecureConnection => 'Menutup koneksi aman';

  @override
  String get language => 'Bahasa';

  @override
  String get english => 'English';

  @override
  String get chinese => '中文';

  @override
  String get systemDefault => 'Bawaan Sistem';

  @override
  String get selectLanguage => 'Pilih Bahasa';

  @override
  String get privacy => 'Privasi dan Dukungan';

  @override
  String get about => 'Tentang';

  @override
  String get dataCollection => 'Pengumpulan Data';

  @override
  String get dataCollectionText =>
      'Kami tidak mengumpulkan atau menyimpan informasi pribadi apa pun. Semua konfigurasi jaringan disimpan secara lokal di perangkat Anda.';

  @override
  String get networkTraffic => 'Lalu Lintas Jaringan';

  @override
  String get networkTrafficText =>
      'Alat pendidikan ini memproses lalu lintas jaringan secara lokal untuk tujuan pembelajaran. Tidak ada data yang dikirim ke server eksternal untuk pelacakan atau analitik.';

  @override
  String get thirdPartyServices => 'Layanan Pihak Ketiga';

  @override
  String get thirdPartyServicesText =>
      'Kami tidak membagikan informasi apa pun kepada pihak ketiga. Semua operasi dilakukan secara lokal di perangkat Anda.';

  @override
  String get dataSecurity => 'Keamanan Data';

  @override
  String get dataSecurityText =>
      'Semua konfigurasi dan pengaturan dienkripsi dan disimpan dengan aman di perangkat Anda menggunakan metode enkripsi standar industri.';

  @override
  String get educationalUseOnly => 'Hanya untuk Penggunaan Pendidikan';

  @override
  String get educationalUseOnlyText =>
      'Perangkat lunak ini disediakan hanya untuk tujuan pendidikan dan penelitian. Pengguna harus mematuhi semua hukum dan peraturan yang berlaku.';

  @override
  String get noWarranty => 'Tanpa Jaminan';

  @override
  String get noWarrantyText =>
      'Perangkat lunak disediakan \"apa adanya\" tanpa jaminan apa pun. Kami tidak bertanggung jawab atas kerusakan apa pun yang timbul dari penggunaannya.';

  @override
  String get userResponsibility => 'Tanggung Jawab Pengguna';

  @override
  String get userResponsibilityText =>
      'Pengguna bertanggung jawab untuk memastikan penggunaan alat ini sesuai dengan peraturan lokal dan kebijakan institusional.';

  @override
  String get academicIntegrity => 'Integritas Akademik';

  @override
  String get academicIntegrityText =>
      'Alat ini harus digunakan sesuai dengan pedoman integritas akademik dan praktik penelitian etis.';

  @override
  String get close => 'Tutup';

  @override
  String get agree => 'Agree';

  @override
  String get purpose => 'Tujuan';

  @override
  String get educational => 'Pendidikan';

  @override
  String get technology => 'Teknologi';

  @override
  String get networkResearch => 'Riset Jaringan';

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
    return '$projectName adalah alat keamanan jaringan pendidikan yang dirancang untuk membantu pengguna memahami perlindungan privasi dan komunikasi jaringan yang aman. Aplikasi ini ditujukan untuk tujuan pendidikan dan penelitian, memungkinkan pengguna untuk mempelajari protokol jaringan, enkripsi, dan teknologi privasi. Semua operasi dilakukan secara lokal di perangkat Anda sesuai dengan hukum dan peraturan yang berlaku.';
  }

  @override
  String get configuration => 'Konfigurasi';

  @override
  String get configurationRequired => 'Konfigurasi diperlukan untuk terhubung';

  @override
  String get userConfiguration => 'Konfigurasi Pengguna';

  @override
  String get enterBase64Config => 'Masukkan Konfigurasi Berkode Base64';

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
  String get configStatus => 'Status Konfigurasi';

  @override
  String get customConfig => 'Tersimpan';

  @override
  String get noCustomConfig => 'Tidak ada konfigurasi tersimpan';

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

  @override
  String serviceDataPrivacy(String appName) {
    return '$appName Privasi Data Koneksi Jaringan';
  }

  @override
  String get serviceDataCollectionTitle =>
      'Informasi pengguna apa yang dikumpulkan aplikasi menggunakan layanan?';

  @override
  String get serviceDataCollectionAnswer =>
      'Aplikasi ini TIDAK mengumpulkan informasi pengguna melalui layanan. Semua pemrosesan lalu lintas jaringan dilakukan secara lokal di perangkat Anda. Riwayat penelusuran, data pribadi, atau informasi yang dapat diidentifikasi tidak dikumpulkan, dicatat, atau dikirimkan.';

  @override
  String get serviceDataPurposeTitle =>
      'Untuk tujuan apa informasi ini dikumpulkan?';

  @override
  String get serviceDataPurposeAnswer =>
      'Karena tidak ada data pengguna yang dikumpulkan, tidak ada tujuan untuk pengumpulan data. Fungsionalitas layanan digunakan semata-mata untuk merutekan lalu lintas jaringan sesuai dengan konfigurasi Anda untuk tujuan pendidikan dan perlindungan privasi. Semua operasi dilakukan secara lokal di perangkat Anda.';

  @override
  String get serviceDataSharingTitle =>
      'Apakah data akan dibagikan dengan pihak ketiga?';

  @override
  String get serviceDataSharingAnswer =>
      'Tidak ada data yang dibagikan dengan pihak ketiga karena tidak ada data yang dikumpulkan. Aplikasi ini beroperasi sepenuhnya secara lokal di perangkat Anda dan tidak mengirimkan informasi pengguna ke server eksternal. Privasi Anda sepenuhnya dilindungi.';
}
