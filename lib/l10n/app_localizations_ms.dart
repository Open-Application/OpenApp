import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

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
  String get encrypted => 'Disulitkan';

  @override
  String get unprotected => 'Tidak Dilindungi';

  @override
  String get vpnPermissionRequired => 'Kebenaran Rcc diperlukan';

  @override
  String get failedToStartVpn => 'Gagal memulakan perkhidmatan Rcc';

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
  String get openSourceLicense => 'Lesen';

  @override
  String get coreLibrary => 'Perpustakaan Teras';

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
  String get yourInternetIsSecure => 'Sambungan rangkaian anda dilindungi';

  @override
  String get yourInternetIsExposed => 'Sambungan rangkaian anda terdedah';

  @override
  String get establishingSecureConnection => 'Mewujudkan sambungan selamat';

  @override
  String get closingSecureConnection => 'Menutup sambungan selamat';

  @override
  String get language => 'Bahasa';

  @override
  String get english => 'English';

  @override
  String get chinese => '中文';

  @override
  String get systemDefault => 'Lalai Sistem';

  @override
  String get selectLanguage => 'Pilih Bahasa';

  @override
  String get privacy => 'Privasi dan Sokongan';

  @override
  String get about => 'Perihal';

  @override
  String get dataCollection => 'Pengumpulan Data';

  @override
  String get dataCollectionText =>
      'Kami tidak mengumpul atau menyimpan sebarang maklumat peribadi. Semua konfigurasi rangkaian disimpan secara tempatan pada peranti anda.';

  @override
  String get networkTraffic => 'Trafik Rangkaian';

  @override
  String get networkTrafficText =>
      'Alat pendidikan ini memproses trafik rangkaian secara tempatan untuk tujuan pembelajaran. Tiada data dihantar ke pelayan luar untuk penjejakan atau analitik.';

  @override
  String get thirdPartyServices => 'Perkhidmatan Pihak Ketiga';

  @override
  String get thirdPartyServicesText =>
      'Kami tidak berkongsi sebarang maklumat dengan pihak ketiga. Semua operasi dilakukan secara tempatan pada peranti anda.';

  @override
  String get dataSecurity => 'Keselamatan Data';

  @override
  String get dataSecurityText =>
      'Semua konfigurasi dan tetapan disulitkan dan disimpan dengan selamat pada peranti anda menggunakan kaedah penyulitan standard industri.';

  @override
  String get educationalUseOnly => 'Penggunaan Pendidikan Sahaja';

  @override
  String get educationalUseOnlyText =>
      'Perisian ini disediakan untuk tujuan pendidikan dan penyelidikan sahaja. Pengguna mesti mematuhi semua undang-undang dan peraturan yang berkenaan.';

  @override
  String get noWarranty => 'Tiada Jaminan';

  @override
  String get noWarrantyText =>
      'Perisian disediakan \"seadanya\" tanpa jaminan apa-apa jenis. Kami tidak bertanggungjawab atas sebarang kerosakan yang timbul daripada penggunaannya.';

  @override
  String get userResponsibility => 'Tanggungjawab Pengguna';

  @override
  String get userResponsibilityText =>
      'Pengguna bertanggungjawab memastikan penggunaan alat ini mematuhi peraturan tempatan dan dasar institusi.';

  @override
  String get academicIntegrity => 'Integriti Akademik';

  @override
  String get academicIntegrityText =>
      'Alat ini harus digunakan mengikut garis panduan integriti akademik dan amalan penyelidikan etika.';

  @override
  String get close => 'Tutup';

  @override
  String get purpose => 'Tujuan';

  @override
  String get educational => 'Pendidikan';

  @override
  String get technology => 'Teknologi';

  @override
  String get networkResearch => 'Penyelidikan Rangkaian';

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
    return '$projectName ialah alat keselamatan rangkaian pendidikan yang direka untuk membantu pengguna memahami perlindungan privasi dan komunikasi rangkaian selamat. Aplikasi ini bertujuan untuk tujuan pendidikan dan penyelidikan, membolehkan pengguna mempelajari protokol rangkaian, penyulitan, dan teknologi privasi. Semua operasi dilakukan secara tempatan pada peranti anda mematuhi undang-undang dan peraturan yang berkenaan.';
  }

  @override
  String get configuration => 'Konfigurasi';

  @override
  String get configurationRequired => 'Konfigurasi diperlukan untuk menyambung';

  @override
  String get userConfiguration => 'Konfigurasi Pengguna';

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
  String get configStatus => 'Status Konfigurasi';

  @override
  String get customConfig => 'Disimpan';

  @override
  String get noCustomConfig => 'Tiada konfigurasi tersimpan';

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
