import 'package:haptic_feedback/haptic_feedback.dart';

class HapticUtils {
  static void lightImpact() {
    Haptics.vibrate(HapticsType.light);
  }

  static void mediumImpact() {
    Haptics.vibrate(HapticsType.medium);
  }

  static void heavyImpact() {
    Haptics.vibrate(HapticsType.heavy);
  }

  static void selectionClick() {
    Haptics.vibrate(HapticsType.selection);
  }

  static void success() {
    Haptics.vibrate(HapticsType.success);
  }

  static void warning() {
    Haptics.vibrate(HapticsType.warning);
  }

  static void error() {
    Haptics.vibrate(HapticsType.error);
  }

  static void buttonTap() {
    lightImpact();
  }

  static void primaryAction() {
    mediumImpact();
  }

  static void destructiveAction() {
    heavyImpact();
  }

  static void toggle() {
    selectionClick();
  }

  static void navigationTap() {
    lightImpact();
  }

  static void menuSelection() {
    selectionClick();
  }

  static void modalDismiss() {
    lightImpact();
  }
}