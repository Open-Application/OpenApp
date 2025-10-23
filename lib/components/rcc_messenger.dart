import 'package:flutter/material.dart';
import '../constants.dart';
import '../utils/haptic_helper.dart';
import '../ui.dart';
import '../router.dart';

enum RccMessengerType {
  success,
  error,
  warning,
  info,
}

class RccMessenger {
  RccMessenger._();

  static void showSuccess({
    BuildContext? context,
    required String message,
    Duration? duration,
    SnackBarAction? action,
  }) {
    final effectiveDuration = duration ??
        (action != null ? Constants.messengerLongDuration : Constants.messengerDefaultDuration);

    _show(
      context: context,
      message: message,
      type: RccMessengerType.success,
      duration: effectiveDuration,
      action: action,
    );

    final ctx = context ?? rootNavigatorKey.currentContext;
    Future.delayed(effectiveDuration, () {
      if (ctx != null && ctx.mounted) {
        ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
      }
    });
  }

  static void showError({
    BuildContext? context,
    required String message,
    Duration? duration,
    SnackBarAction? action,
  }) {
    _show(
      context: context,
      message: message,
      type: RccMessengerType.error,
      duration: duration ?? Constants.messengerDefaultDuration,
      action: action,
    );
  }

  static void showWarning({
    BuildContext? context,
    required String message,
    Duration? duration,
    SnackBarAction? action,
  }) {
    _show(
      context: context,
      message: message,
      type: RccMessengerType.warning,
      duration: duration ?? Constants.messengerDefaultDuration,
      action: action,
    );
  }

  static void showInfo({
    BuildContext? context,
    required String message,
    Duration? duration,
    SnackBarAction? action,
  }) {
    _show(
      context: context,
      message: message,
      type: RccMessengerType.info,
      duration: duration ?? Constants.messengerShortDuration,
      action: action,
    );
  }

  static void show({
    BuildContext? context,
    required String message,
    Color? backgroundColor,
    Color? textColor,
    Duration? duration,
    SnackBarAction? action,
    IconData? icon,
  }) {
    _show(
      context: context,
      message: message,
      backgroundColor: backgroundColor,
      textColor: textColor,
      duration: duration ?? Constants.messengerDefaultDuration,
      action: action,
      icon: icon,
    );
  }

  static void _show({
    BuildContext? context,
    required String message,
    RccMessengerType? type,
    Color? backgroundColor,
    Color? textColor,
    Duration? duration,
    SnackBarAction? action,
    IconData? icon,
  }) {
    final ctx = context ?? rootNavigatorKey.currentContext;
    if (ctx == null) {
      debugPrint('[RccMessenger] No context available to show message: $message');
      return;
    }

    final theme = Theme.of(ctx);

    Color bgColor = backgroundColor ?? theme.colorScheme.surfaceContainerHighest;
    Color txtColor = textColor ?? theme.colorScheme.onSurface;
    IconData? messageIcon = icon;

    final effectiveDuration = duration ?? Constants.messengerDefaultDuration;

    switch (type) {
      case RccMessengerType.success:
        bgColor = backgroundColor ?? Colors.green;
        txtColor = textColor ?? Colors.white;
        messageIcon = icon ?? Constants.iconCheckCircle;
        HapticUtils.success();
        break;
      case RccMessengerType.error:
        bgColor = backgroundColor ?? theme.colorScheme.error;
        txtColor = textColor ?? theme.colorScheme.onError;
        messageIcon = icon ?? Constants.iconErrorOutline;
        HapticUtils.error();
        break;
      case RccMessengerType.warning:
        bgColor = backgroundColor ?? Colors.orange;
        txtColor = textColor ?? Colors.white;
        messageIcon = icon ?? Constants.iconWarning;
        HapticUtils.warning();
        break;
      case RccMessengerType.info:
        bgColor = backgroundColor ?? theme.colorScheme.primary;
        txtColor = textColor ?? theme.colorScheme.onPrimary;
        messageIcon = icon ?? Constants.iconInfoOutline;
        HapticUtils.lightImpact();
        break;
      case null:
        break;
    }

    ScaffoldMessenger.of(ctx).clearSnackBars();
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (messageIcon != null) ...[
              Icon(
                messageIcon,
                color: txtColor,
                size: UI.adaptiveIconSize(20),
              ),
              SizedBox(width: UI.scaledDimension(12)),
            ],
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: UI.bodyTextSize,
                  color: txtColor,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (action != null) ...[
              SizedBox(width: UI.scaledDimension(8)),
              TextButton(
                onPressed: action.onPressed,
                style: TextButton.styleFrom(
                  padding: UI.paddingSymmetric(horizontal: 12, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  action.label,
                  style: TextStyle(
                    fontSize: UI.buttonTextSize,
                    color: txtColor.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UI.scaledDimension(Constants.messengerBorderRadius)),
        ),
        elevation: Constants.messengerElevation,
        duration: effectiveDuration,
        margin: UI.paddingSymmetric(horizontal: 16, vertical: 8),
      ),
    );

    if (action == null) {
      Future.delayed(effectiveDuration, () {
        if (ctx.mounted) {
          ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
        }
      });
    }
  }

  static void clear(BuildContext? context) {
    final ctx = context ?? rootNavigatorKey.currentContext;
    if (ctx != null) {
      ScaffoldMessenger.of(ctx).clearSnackBars();
    }
  }

  static void hide(BuildContext? context) {
    final ctx = context ?? rootNavigatorKey.currentContext;
    if (ctx != null) {
      ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
    }
  }
}