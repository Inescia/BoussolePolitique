import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';

class GradientScaffold extends StatelessWidget {
  const GradientScaffold({
    super.key,
    required this.child,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.padding,
  });

  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final EdgeInsetsGeometry? padding;

  static const List<Color> _gradientColors = [
    Color(0xFFE8EEFF),
    AppColors.cream,
    Color(0xFFFFF0EC),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _gradientColors,
            stops: [0, 0.45, 1],
          ),
        ),
        child: padding != null
            ? Padding(padding: padding!, child: child)
            : child,
      ),
    );
  }
}

PreferredSizeWidget boussoleAppBar(
  BuildContext context, {
  required String title,
  List<Widget>? actions,
  bool implyLeading = true,
}) {
  return AppBar(
    title: Text(title),
    centerTitle: false,
    actions: actions,
    automaticallyImplyLeading: implyLeading,
    surfaceTintColor: Colors.transparent,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  );
}

class SoftCard extends StatelessWidget {
  const SoftCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    this.onTap,
    this.color,
    this.border,
    this.semanticLabel,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;
  final Border? border;
  final String? semanticLabel;

  static const _radius = BorderRadius.all(Radius.circular(28));

  @override
  Widget build(BuildContext context) {
    final surface = color ?? Theme.of(context).colorScheme.surface;

    Widget content = Padding(padding: padding, child: child);

    if (onTap != null) {
      content = InkWell(borderRadius: _radius, onTap: onTap, child: content);
    }

    content = Material(
      color: surface,
      shape: RoundedRectangleBorder(
        borderRadius: _radius,
        side: border?.top ?? BorderSide.none,
      ),
      child: content,
    );

    content = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: _radius,
        boxShadow: [
          BoxShadow(
            color: AppColors.nightBlue.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: content,
    );

    if (onTap == null) return content;

    return Semantics(button: true, label: semanticLabel, child: content);
  }
}
