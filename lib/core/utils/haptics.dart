import 'package:flutter/services.dart';

enum HapticKind { selection, light, medium, heavy, success }

/// Wrapper léger autour des haptics système, désactivable via préférences.
class AppHaptics {
  AppHaptics({this.enabled = true});

  bool enabled;

  Future<void> play(HapticKind kind) async {
    if (!enabled) return;
    switch (kind) {
      case HapticKind.selection:
        await HapticFeedback.selectionClick();
      case HapticKind.light:
        await HapticFeedback.lightImpact();
      case HapticKind.medium:
        await HapticFeedback.mediumImpact();
      case HapticKind.heavy:
        await HapticFeedback.heavyImpact();
      case HapticKind.success:
        await HapticFeedback.mediumImpact();
    }
  }
}
