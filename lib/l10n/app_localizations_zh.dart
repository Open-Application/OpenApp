import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get dashboard => '控制台';

  @override
  String get profile => '个人资料';

  @override
  String get connect => '连接';

  @override
  String get disconnect => '断开连接';

  @override
  String get connecting => '连接中...';

  @override
  String get disconnecting => '断开中...';

  @override
  String get connected => '已连接';

  @override
  String get disconnected => '已断开';

  @override
  String get encrypted => '已加密';

  @override
  String get unprotected => '未保护';

  @override
  String get vpnPermissionRequired => '需要Rcc权限';

  @override
  String get failedToStartVpn => 'Rcc服务启动失败';

  @override
  String get noNetworkConnection => '无网络连接。请检查您的Wi-Fi或移动数据。';

  @override
  String get settings => '设置';

  @override
  String get darkMode => '深色模式';

  @override
  String aboutProject(String projectName) {
    return '关于$projectName';
  }

  @override
  String get version => '版本';

  @override
  String get openSourceLicense => '开源许可证';

  @override
  String get coreLibrary => '核心库';

  @override
  String get termsOfUse => '使用条款';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get status => '状态';

  @override
  String get control => '控制';

  @override
  String get networkControlCenter => '网络控制中心';

  @override
  String get connectionStatus => '状态';

  @override
  String get yourInternetIsSecure => '您的网络连接受到保护';

  @override
  String get yourInternetIsExposed => '您的网络连接存在风险';

  @override
  String get establishingSecureConnection => '正在建立安全连接';

  @override
  String get closingSecureConnection => '正在关闭安全连接';

  @override
  String get language => '语言';

  @override
  String get english => '英语';

  @override
  String get chinese => '中文';

  @override
  String get systemDefault => '系统默认';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get privacy => '隐私与支持';

  @override
  String get about => '关于';

  @override
  String get dataCollection => '数据收集';

  @override
  String get dataCollectionText => '我们不收集或存储任何个人信息。所有网络配置都本地存储在您的设备上。';

  @override
  String get networkTraffic => '网络流量';

  @override
  String get networkTrafficText => '此教育工具在本地处理网络流量用于学习目的。不会将数据传输到外部服务器进行跟踪或分析。';

  @override
  String get thirdPartyServices => '第三方服务';

  @override
  String get thirdPartyServicesText => '我们不与第三方共享任何信息。所有操作都在您的设备上本地执行。';

  @override
  String get dataSecurity => '数据安全';

  @override
  String get dataSecurityText => '所有配置和设置都使用行业标准加密方法加密并安全地存储在您的设备上。';

  @override
  String get educationalUseOnly => '仅限教育用途';

  @override
  String get educationalUseOnlyText => '本软件仅供教育和研究目的提供。用户必须遵守所有适用的法律法规。';

  @override
  String get noWarranty => '免责声明';

  @override
  String get noWarrantyText => '该软件按「现状」提供，不提供任何形式的保证。我们对因使用该软件而产生的任何损害不承担责任。';

  @override
  String get userResponsibility => '用户责任';

  @override
  String get userResponsibilityText => '用户有责任确保使用此工具符合当地法规和机构政策。';

  @override
  String get academicIntegrity => '学术诚信';

  @override
  String get academicIntegrityText => '此工具应按照学术诚信准则和道德研究实践使用。';

  @override
  String get close => '关闭';

  @override
  String get purpose => '目的';

  @override
  String get educational => '教育';

  @override
  String get technology => '技术';

  @override
  String get networkResearch => '网络研究';

  @override
  String get stopped => '已停止';

  @override
  String get started => '已连接';

  @override
  String get starting => '连接中';

  @override
  String get stopping => '断开中';

  @override
  String get active => '活跃';

  @override
  String get inactive => '不活跃';

  @override
  String get mobile => '移动设备';

  @override
  String get desktop => '桌面设备';

  @override
  String get serviceLogs => '服务日志';

  @override
  String get logs => '日志';

  @override
  String get copyLogs => '复制日志';

  @override
  String get logsCopiedToClipboard => '日志已复制到剪贴板';

  @override
  String get noLogsYet => '暂无日志';

  @override
  String logEntries(int count) {
    return '$count条日志记录';
  }

  @override
  String get accountManagementHub => '账户管理中心';

  @override
  String aboutProjectText(String projectName) {
    return '$projectName是一款教育性网络安全工具，旨在帮助用户了解隐私保护和安全网络通信。本应用程序仅供教育和研究目的使用，使用户能够学习网络协议、加密和隐私技术。所有操作均在您的设备上本地执行，符合适用的法律法规。';
  }

  @override
  String get configuration => '配置';

  @override
  String get configurationRequired => '连接需要配置';

  @override
  String get userConfiguration => '用户配置';

  @override
  String get enterBase64Config => '输入Base64编码配置';

  @override
  String get pasteConfigHere => '在此粘贴您的base64编码配置';

  @override
  String get saveConfiguration => '保存';

  @override
  String get clearConfiguration => '清除配置';

  @override
  String get configSaved => '配置保存成功';

  @override
  String get configCleared => '配置已清除';

  @override
  String get configEmpty => '配置不能为空';

  @override
  String get configStatus => '配置状态';

  @override
  String get customConfig => '已保存';

  @override
  String get noCustomConfig => '无已保存配置';

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
