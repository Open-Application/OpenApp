import 'dart:io';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../l10n/app_localizations.dart';
import '../constants.dart';

class DeviceHelper {
  static final DeviceHelper _instance = DeviceHelper._internal();
  factory DeviceHelper() => _instance;
  DeviceHelper._internal();

  bool? _isHuaweiDevice;
  String? _manufacturer;
  String? _model;
  int? _androidSdkInt;

  Future<void> initialize() async {
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;

      _manufacturer = androidInfo.manufacturer.toLowerCase();
      _model = androidInfo.model.toLowerCase();
      _androidSdkInt = androidInfo.version.sdkInt;

      _isHuaweiDevice =
          _manufacturer?.contains('huawei') == true ||
          _manufacturer?.contains('honor') == true ||
          _model?.contains('huawei') == true ||
          _model?.contains('honor') == true;
    }
  }

  bool get isHuaweiDevice => _isHuaweiDevice ?? false;

  bool get isAndroid => Platform.isAndroid;

  bool get isIOS => Platform.isIOS;

  String get manufacturer => _manufacturer ?? 'unknown';

  String get model => _model ?? 'unknown';

  int get androidSdkInt => _androidSdkInt ?? 0;

  bool get needsRenderingOptimization {
    if (!Platform.isAndroid) return false;

    if (isHuaweiDevice) return true;

    if (androidSdkInt < 28) return true;

    final problematicManufacturers = ['xiaomi', 'oppo', 'vivo', 'realme'];
    return problematicManufacturers.any(
      (m) => _manufacturer?.contains(m) ?? false,
    );
  }

  bool get shouldUseAggressiveRepaintBoundaries {
    return needsRenderingOptimization;
  }

  bool get shouldPreloadFonts {
    return isHuaweiDevice || needsRenderingOptimization;
  }

  ScrollPhysics getOptimizedScrollPhysics() {
    if (needsRenderingOptimization) {
      return const ClampingScrollPhysics();
    }
    return const BouncingScrollPhysics();
  }

  bool get shouldCacheText {
    return isHuaweiDevice || needsRenderingOptimization;
  }

  static Future<Map<String, dynamic>> getCurrentDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    final Map<String, dynamic> info = {};

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        info['type'] = 'android';
        info['name'] = '${androidInfo.manufacturer} ${androidInfo.model}';
        info['os_version'] = 'Android ${androidInfo.version.release}';
        info['sdk_version'] = androidInfo.version.sdkInt;
        info['manufacturer'] = androidInfo.manufacturer;
        info['model'] = androidInfo.model;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        info['type'] = 'ios';
        info['name'] = iosInfo.name;
        info['os_version'] = 'iOS ${iosInfo.systemVersion}';
        info['model'] = iosInfo.model;
      } else {
        info['type'] = 'unknown';
        info['name'] = 'Unknown Device';
        info['os_version'] = 'Unknown OS';
      }
    } catch (_) {
      info['type'] = 'unknown';
      info['name'] = 'Unknown Device';
      info['os_version'] = 'Unknown OS';
    }

    return info;
  }

  static String getDeviceStatus(BuildContext context, String status) {
    final l10n = AppLocalizations.of(context)!;

    switch (status.toLowerCase()) {
      case 'active':
      case 'online':
        return l10n.active;
      case 'inactive':
      case 'offline':
        return l10n.inactive;
      default:
        return status;
    }
  }

  static String getDeviceType(BuildContext context, String type) {
    final l10n = AppLocalizations.of(context)!;

    switch (type.toLowerCase()) {
      case 'mobile':
        return l10n.mobile;
      case 'desktop':
        return l10n.desktop;
      case 'ios':
        return 'iOS';
      case 'android':
        return 'Android';
      case 'windows':
        return 'Windows';
      case 'macos':
      case 'mac':
        return 'macOS';
      case 'linux':
        return 'Linux';
      default:
        return type;
    }
  }

  static IconData getDeviceIcon(String type) {
    switch (type.toLowerCase()) {
      case 'mobile':
      case 'ios':
      case 'android':
        return Constants.iconDevicePhone;
      case 'desktop':
      case 'windows':
      case 'macos':
      case 'mac':
      case 'linux':
        return Constants.iconDeviceComputer;
      default:
        return Constants.iconDeviceDefault;
    }
  }

  static Color getDeviceStatusColor(BuildContext context, String status) {
    final theme = Theme.of(context);
    switch (status.toLowerCase()) {
      case 'active':
      case 'online':
        return Colors.green;
      case 'inactive':
      case 'offline':
        return theme.colorScheme.onSurface.withValues(alpha: 0.5);
      default:
        return theme.colorScheme.onSurface;
    }
  }
}
