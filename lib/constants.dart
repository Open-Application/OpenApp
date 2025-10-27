import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Constants {
  static const String appName = 'OpenApp';
  static const String projectName = 'RootCorporation';
  static const String projectUrl = 'https://github.com/Open-Application/OpenApp';
  static const String projectVersion = '1.0.0';

  static const String licenseText = 'MIT';
  static const String licenseFullText = '''
MIT License

Copyright (c) 2025 Root-Corporation PTY LTD Australia

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
''';

  static const String encodedConfig = '';
  // Asset paths
  static const String iconAppIcon = 'assets/logo.png';
  static const String licensePath = 'assets/legals/LICENSE';
  static const String privacyPolicyPath = 'assets/legals/privacy_policy.txt';
  static const String userAgreementPath = 'assets/legals/user_agreement.txt';

  static const IconData iconDashboard = Icons.dashboard_outlined;
  static const IconData iconDashboardFill = Icons.dashboard;
  static const IconData iconShield = Icons.shield;
  static const IconData iconShieldOff = Icons.shield_outlined;
  static const IconData iconServer = Icons.dns_outlined;
  static const IconData iconGlobe = Icons.public;
  static const IconData iconStart = Icons.play_arrow;
  static const IconData iconStop = Icons.stop;

  static const IconData iconPerson = Icons.person_outline;
  static const IconData iconSun = Icons.wb_sunny_outlined;
  static const IconData iconMoon = Icons.nightlight_round;
  static const IconData iconLanguage = Icons.language;
  static const IconData iconArticle = Icons.article_outlined;
  static const IconData iconPrivacyTip = Icons.privacy_tip_outlined;
  static const IconData iconInfo = FontAwesomeIcons.circleInfo;
  static const IconData iconOpenInNew = Icons.open_in_new;

  static const IconData iconCheck = Icons.check;
  static const IconData iconChevronRight = FontAwesomeIcons.chevronRight;
  static const IconData iconChevronDown = FontAwesomeIcons.chevronDown;
  static const IconData iconCopy = FontAwesomeIcons.copy;
  static const IconData iconRefresh = FontAwesomeIcons.arrowsRotate;
  static const IconData iconSuccess = FontAwesomeIcons.circleCheck;
  static const IconData iconError = FontAwesomeIcons.circleExclamation;
  static const IconData iconWarning = FontAwesomeIcons.triangleExclamation;
  static const IconData iconCheckCircle = FontAwesomeIcons.circleCheck;
  static const IconData iconErrorOutline = FontAwesomeIcons.circleExclamation;
  static const IconData iconInfoOutline = FontAwesomeIcons.circleInfo;
  static const IconData iconLock = FontAwesomeIcons.lock;
  static const IconData iconVersion = Icons.verified;
  static const IconData iconSupportAgent = FontAwesomeIcons.headset;
  static const IconData iconAutoAwesome = Icons.auto_awesome;
  static const IconData iconExpandLess = Icons.expand_less;
  static const IconData iconRadioButtonUnchecked = Icons.radio_button_unchecked;
  static const IconData iconTerminal = Icons.terminal;
  static const IconData iconDocumentText = Icons.description;

  static const IconData iconRccStatus = FontAwesomeIcons.solidCircle;
  static const IconData iconRccSync = Icons.sync;
  static const IconData iconRccConnected = Icons.check_circle;
  static const IconData iconRccDisconnected = Icons.cancel;
  static const IconData iconRccStop = Icons.stop_circle;
  static const IconData iconRccPower = Icons.power_settings_new;

  static const IconData iconDevicePhone = Icons.phone_android;
  static const IconData iconDeviceComputer = Icons.computer;
  static const IconData iconDeviceDefault = Icons.devices;

  static const Duration messengerShortDuration = Duration(seconds: 2);
  static const Duration messengerDefaultDuration = Duration(seconds: 3);
  static const Duration messengerLongDuration = Duration(seconds: 5);
  static const double messengerBorderRadius = 12.0;
  static const double messengerElevation = 4.0;

  static const double modalContentPadding = 24.0;
  static const double modalSectionSpacing = 20.0;
  static const double modalPopupHeightFactor = 0.9;
  static const double modalBorderRadius = 20.0;
  static const double modalHandleWidth = 40.0;
  static const double modalHandleHeight = 4.0;
  static const double modalHandleTopMargin = 12.0;
  static const double modalHandleBottomMargin = 16.0;
  static const double modalHeaderPadding = 24.0;
  static const double modalIconSize = 24.0;
  static const double modalIconSpacing = 12.0;
  static const double modalHeaderBottomSpacing = 16.0;
  static const double modalButtonHeight = 50.0;
  static const double modalFooterPadding = 24.0;
  static const double modalFooterSpacing = 12.0;

  static const double listItemMinHeight = 56.0;
  static const double listItemPadding = 16.0;
  static const double listItemBorderRadius = 12.0;
  static const double listItemTitleBottom = 4.0;

  static const double defaultBorderRadius = 12.0;
  static const double defaultOutlineOpacity = 0.1;
  static const double defaultBackgroundOpacity = 0.03;
  static const double defaultShadowOpacity = 0.1;
  static const double defaultOnSurfaceOpacity = 0.6;
  static const double defaultOnSurfaceSecondaryOpacity = 0.4;
  static const double modalButtonBorderRadius = 12.0;

  static const IconData iconArrowLeft = Icons.arrow_back;

  static const String debugLogFileName = 'debug.log';
}
