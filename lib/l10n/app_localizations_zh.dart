// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
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
  String get servicePermissionRequired => '需要服务权限';

  @override
  String get failedToStartService => '服务启动失败';

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
  String get language => '语言';

  @override
  String get systemDefault => '系统默认';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get privacy => '隐私与支持';

  @override
  String get about => '关于';

  @override
  String get close => '关闭';

  @override
  String get agree => '同意';

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
    return '$projectName 是开源网络研究平台，专注于隐私和安全';
  }

  @override
  String get configuration => '配置';

  @override
  String get configurationRequired => '连接需要配置';

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
  String get noCustomConfig => '无已保存配置';
}
