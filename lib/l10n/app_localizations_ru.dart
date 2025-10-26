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
  String get encrypted => 'Зашифровано';

  @override
  String get unprotected => 'Незащищено';

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
  String get coreLibrary => 'Основная библиотека';

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
  String get yourInternetIsSecure => 'Ваше сетевое соединение защищено';

  @override
  String get yourInternetIsExposed => 'Ваше сетевое соединение уязвимо';

  @override
  String get establishingSecureConnection => 'Установка безопасного соединения';

  @override
  String get closingSecureConnection => 'Закрытие безопасного соединения';

  @override
  String get language => 'Язык';

  @override
  String get english => 'English';

  @override
  String get chinese => '中文';

  @override
  String get systemDefault => 'Системный';

  @override
  String get selectLanguage => 'Выбрать язык';

  @override
  String get privacy => 'Конфиденциальность и поддержка';

  @override
  String get about => 'О программе';

  @override
  String get dataCollection => 'Сбор данных';

  @override
  String get dataCollectionText =>
      'Мы не собираем и не храним личную информацию. Все сетевые конфигурации хранятся локально на вашем устройстве.';

  @override
  String get networkTraffic => 'Сетевой трафик';

  @override
  String get networkTrafficText =>
      'Этот образовательный инструмент обрабатывает сетевой трафик локально в учебных целях. Данные не передаются на внешние серверы для отслеживания или аналитики.';

  @override
  String get thirdPartyServices => 'Сторонние сервисы';

  @override
  String get thirdPartyServicesText =>
      'Мы не передаем информацию третьим лицам. Все операции выполняются локально на вашем устройстве.';

  @override
  String get dataSecurity => 'Безопасность данных';

  @override
  String get dataSecurityText =>
      'Все конфигурации и настройки зашифрованы и надежно хранятся на вашем устройстве с использованием стандартных методов шифрования.';

  @override
  String get educationalUseOnly => 'Только для образовательных целей';

  @override
  String get educationalUseOnlyText =>
      'Это программное обеспечение предоставляется только для образовательных и исследовательских целей. Пользователи должны соблюдать все применимые законы и правила.';

  @override
  String get noWarranty => 'Без гарантий';

  @override
  String get noWarrantyText =>
      'Программное обеспечение предоставляется «как есть» без каких-либо гарантий. Мы не несем ответственности за любой ущерб, возникший в результате его использования.';

  @override
  String get userResponsibility => 'Ответственность пользователя';

  @override
  String get userResponsibilityText =>
      'Пользователи несут ответственность за соблюдение местных норм и организационных политик при использовании этого инструмента.';

  @override
  String get academicIntegrity => 'Академическая честность';

  @override
  String get academicIntegrityText =>
      'Этот инструмент следует использовать в соответствии с рекомендациями по академической честности и этическими исследовательскими практиками.';

  @override
  String get close => 'Закрыть';

  @override
  String get agree => 'Agree';

  @override
  String get purpose => 'Назначение';

  @override
  String get educational => 'Образовательный';

  @override
  String get technology => 'Технология';

  @override
  String get networkResearch => 'Исследование сетей';

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
    return '$projectName — это образовательный инструмент сетевой безопасности, разработанный для помощи пользователям в понимании защиты конфиденциальности и безопасных сетевых коммуникаций. Это приложение предназначено для образовательных и исследовательских целей, позволяя пользователям изучать сетевые протоколы, шифрование и технологии конфиденциальности. Все операции выполняются локально на вашем устройстве в соответствии с применимыми законами и правилами.';
  }

  @override
  String get configuration => 'Конфигурация';

  @override
  String get configurationRequired => 'Для подключения требуется конфигурация';

  @override
  String get userConfiguration => 'Конфигурация пользователя';

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
  String get configStatus => 'Статус конфигурации';

  @override
  String get customConfig => 'Сохранено';

  @override
  String get noCustomConfig => 'Нет сохранённой конфигурации';

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
    return '$appName Конфиденциальность данных сетевого подключения';
  }

  @override
  String get serviceDataCollectionTitle =>
      'Какую информацию о пользователе собирает приложение через службу?';

  @override
  String get serviceDataCollectionAnswer =>
      'Это приложение НЕ собирает никакой информации о пользователях через службу. Вся обработка сетевого трафика выполняется локально на вашем устройстве. История просмотров, личные данные или идентифицирующая информация не собираются, не регистрируются и не передаются.';

  @override
  String get serviceDataPurposeTitle =>
      'Для каких целей собирается эта информация?';

  @override
  String get serviceDataPurposeAnswer =>
      'Поскольку данные пользователей не собираются, нет целей для сбора данных. Функциональность службы используется исключительно для маршрутизации сетевого трафика в соответствии с вашей конфигурацией для образовательных целей и защиты конфиденциальности. Все операции выполняются локально на вашем устройстве.';

  @override
  String get serviceDataSharingTitle =>
      'Будут ли данные переданы третьим лицам?';

  @override
  String get serviceDataSharingAnswer =>
      'Данные не передаются третьим лицам, поскольку они не собираются. Это приложение работает полностью локально на вашем устройстве и не передает никакую информацию о пользователе на внешние серверы. Ваша конфиденциальность полностью защищена.';
}
