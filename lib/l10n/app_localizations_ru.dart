// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get dashboard => 'Панель управления';

  @override
  String get profile => 'Профиль';

  @override
  String get connect => 'Подключить';

  @override
  String get disconnect => 'Отключить';

  @override
  String get connecting => 'Подключение...';

  @override
  String get disconnecting => 'Отключение...';

  @override
  String get connected => 'Подключено';

  @override
  String get disconnected => 'Отключено';

  @override
  String get servicePermissionRequired => 'Требуется разрешение службы';

  @override
  String get failedToStartService => 'Не удалось запустить службу';

  @override
  String get noNetworkConnection =>
      'Нет подключения к сети. Проверьте Wi-Fi или мобильные данные.';

  @override
  String get settings => 'Настройки';

  @override
  String get darkMode => 'Тёмная тема';

  @override
  String aboutProject(String projectName) {
    return 'О $projectName';
  }

  @override
  String get version => 'Версия';

  @override
  String get openSourceLicense => 'Лицензия';

  @override
  String get termsOfUse => 'Условия использования';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get status => 'Статус';

  @override
  String get control => 'Управление';

  @override
  String get networkControlCenter => 'Центр управления сетью';

  @override
  String get connectionStatus => 'Статус';

  @override
  String get language => 'Язык';

  @override
  String get systemDefault => 'Системный';

  @override
  String get selectLanguage => 'Выбрать язык';

  @override
  String get privacy => 'Конфиденциальность и поддержка';

  @override
  String get about => 'О программе';

  @override
  String get close => 'Закрыть';

  @override
  String get agree => 'Согласен';

  @override
  String get stopped => 'ОСТАНОВЛЕНО';

  @override
  String get started => 'ПОДКЛЮЧЕНО';

  @override
  String get starting => 'ПОДКЛЮЧЕНИЕ';

  @override
  String get stopping => 'ОТКЛЮЧЕНИЕ';

  @override
  String get active => 'Активно';

  @override
  String get inactive => 'Неактивно';

  @override
  String get mobile => 'Мобильное';

  @override
  String get desktop => 'Настольное';

  @override
  String get serviceLogs => 'Журналы службы';

  @override
  String get logs => 'Журналы';

  @override
  String get copyLogs => 'Скопировать журналы';

  @override
  String get logsCopiedToClipboard => 'Журналы скопированы в буфер обмена';

  @override
  String get noLogsYet => 'Журналов пока нет';

  @override
  String logEntries(int count) {
    return '$count записей журнала';
  }

  @override
  String get accountManagementHub => 'Центр управления учётной записью';

  @override
  String aboutProjectText(String projectName) {
    return '$projectName — это открытая платформа для исследования сетей, конфиденциальности и безопасности';
  }

  @override
  String get configuration => 'Конфигурация';

  @override
  String get configurationRequired => 'Для подключения требуется конфигурация';

  @override
  String get enterBase64Config => 'Введите конфигурацию в кодировке Base64';

  @override
  String get pasteConfigHere =>
      'Вставьте вашу конфигурацию в кодировке base64 здесь';

  @override
  String get saveConfiguration => 'Сохранить';

  @override
  String get clearConfiguration => 'Очистить конфигурацию';

  @override
  String get configSaved => 'Конфигурация успешно сохранена';

  @override
  String get configCleared => 'Конфигурация очищена';

  @override
  String get configEmpty => 'Конфигурация не может быть пустой';

  @override
  String get noCustomConfig => 'Нет сохранённой конфигурации';
}
