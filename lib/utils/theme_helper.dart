import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemeHelper {
  ThemeHelper._();
  static SystemUiOverlayStyle getSystemUiOverlayStyle({
    required Brightness brightness,
    Color statusBarColor = Colors.transparent,
    Color systemNavigationBarColor = Colors.transparent,
  }) {
    if (brightness == Brightness.light) {
      return SystemUiOverlayStyle.light.copyWith(
        statusBarColor: statusBarColor,
        systemNavigationBarColor: systemNavigationBarColor,
      );
    } else {
      return SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: statusBarColor,
        systemNavigationBarColor: systemNavigationBarColor,
      );
    }
  }

  static SystemUiOverlayStyle getAdaptiveSystemUiOverlayStyle(BuildContext context) {
    final theme = Theme.of(context);
    return getSystemUiOverlayStyle(
      brightness: theme.brightness,
    );
  }

  static Widget withSystemUiOverlay({
    required Widget child,
    required SystemUiOverlayStyle style,
  }) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: style,
      child: child,
    );
  }

  static Future<ColorScheme?> getDynamicColorScheme({
    required Brightness brightness,
    Color? fallbackSeedColor,
  }) async {
    return null;
  }
}