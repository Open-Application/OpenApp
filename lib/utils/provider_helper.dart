import 'package:flutter/material.dart';

class ProviderHelper {
  static dynamic getRccProvider(BuildContext context) {
    dynamic rccProvider;

    context.visitAncestorElements((element) {
      try {
        final provider = (element as dynamic).value;
        if (provider != null && provider is ChangeNotifier) {
          try {
            final dynamic p = provider;
            final status = p.status;
            final statusColor = p.statusColor;
            final toggle = p.toggle;
            if (status != null && statusColor != null && toggle != null) {
              rccProvider = provider;
              return false;
            }
          } catch (_) {}
        }
      } catch (_) {}
      return true;
    });

    return rccProvider;
  }

  static dynamic getPreferencesProvider(BuildContext context) {
    dynamic preferencesProvider;

    context.visitAncestorElements((element) {
      try {
        final provider = (element as dynamic).value;
        if (provider != null && provider is ChangeNotifier) {
          try {
            final dynamic p = provider;
            final themeMode = p.themeMode;
            final toggleTheme = p.toggleTheme;
            final setLanguage = p.setLanguage;
            final isDarkMode = p.isDarkMode;
            if (themeMode != null && toggleTheme != null && setLanguage != null && isDarkMode != null) {
              preferencesProvider = provider;
              return false;
            }
          } catch (_) {}
        }
      } catch (_) {}
      return true;
    });

    return preferencesProvider;
  }

  static dynamic getLogProvider(BuildContext context) {
    dynamic logProvider;

    context.visitAncestorElements((element) {
      try {
        final provider = (element as dynamic).value;
        if (provider != null && provider is ChangeNotifier) {
          try {
            final dynamic p = provider;
            final logs = p.logs;
            final clearLogs = p.clearLogs;
            final exportLogs = p.exportLogs;
            final createDebugLogFile = p.createDebugLogFile;
            if (logs != null && clearLogs != null && exportLogs != null && createDebugLogFile != null) {
              logProvider = provider;
              return false;
            }
          } catch (_) {}
        }
      } catch (_) {}
      return true;
    });

    return logProvider;
  }
}