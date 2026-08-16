/// Helpers accessibilité / animations.
library;

import 'package:flutter/material.dart';

/// Vrai si l'utilisateur a activé « Réduire les animations ».
bool reduceMotionOf(BuildContext context) =>
    MediaQuery.disableAnimationsOf(context);

/// Applique [builder] seulement si les animations sont autorisées.
Widget motionAware({
  required BuildContext context,
  required Widget child,
  required Widget Function(Widget child) animated,
}) {
  if (reduceMotionOf(context)) return child;
  return animated(child);
}
