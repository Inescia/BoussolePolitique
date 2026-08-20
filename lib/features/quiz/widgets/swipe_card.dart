import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/haptics.dart';
import '../models/political_dimension.dart';
import '../models/political_dimension_hints.dart';
import '../models/question.dart';
import 'answer_style.dart';

typedef SwipeAnswerCallback = void Function(AnswerValue value);

/// Swipe par coins :
/// ↖ Super non · ↗ Super oui · ↙ Non · ↘ Oui
class SwipeCard extends StatefulWidget {
  const SwipeCard({
    super.key,
    required this.question,
    required this.onAnswered,
    required this.haptics,
    this.enabled = true,
    this.reduceMotion = false,
    this.progressLabel,
  });

  final Question question;
  final SwipeAnswerCallback onAnswered;
  final AppHaptics haptics;
  final bool enabled;
  final bool reduceMotion;

  /// Ex. `12 / 100` — remplace l’ancien libellé « Affirmation ».
  final String? progressLabel;

  @override
  State<SwipeCard> createState() => SwipeCardState();
}

class SwipeCardState extends State<SwipeCard>
    with SingleTickerProviderStateMixin {
  Offset _offset = Offset.zero;
  double _angle = 0;
  AnswerValue? _armed;
  bool _locked = false;
  late final AnimationController _resetController;
  Animation<Offset>? _resetAnimation;

  static const _commitDistance = 100.0;

  bool get _canInteract => widget.enabled && !_locked;

  @override
  void initState() {
    super.initState();
    _resetController =
        AnimationController(
          vsync: this,
          duration: Duration(milliseconds: widget.reduceMotion ? 80 : 280),
        )..addListener(() {
          if (_resetAnimation != null) {
            setState(() {
              _offset = _resetAnimation!.value;
              _angle = widget.reduceMotion ? 0 : _offset.dx / 320 * 0.22;
            });
          }
        });
  }

  @override
  void didUpdateWidget(covariant SwipeCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question.id != widget.question.id) {
      _snapToCenter();
    }
  }

  /// Remet la carte au centre sans laisser l’ancienne anim réécrire l’offset.
  void _snapToCenter() {
    _resetAnimation = null;
    _resetController.stop();
    _resetController.reset();
    _offset = Offset.zero;
    _angle = 0;
    _armed = null;
    _locked = false;
  }

  @override
  void dispose() {
    _resetController.dispose();
    super.dispose();
  }

  /// Coins uniquement — le geste doit clairement viser un quadrant.
  AnswerValue? _valueForOffset(Offset o) {
    final distance = o.distance;
    if (distance < _commitDistance * 0.45) return null;

    // Zone centrale basse = passer (évite la confusion avec les coins).
    if (o.dy > 70 && o.dx.abs() < 48) return AnswerValue.skip;

    final left = o.dx < 0;
    final top = o.dy < 0;

    // Exige un minimum d'engagement vertical pour les supers (coins hauts).
    if (top && o.dy.abs() > 28) {
      return left ? AnswerValue.superNo : AnswerValue.superYes;
    }
    // Coins bas = oui / non classiques.
    if (!top && o.dy.abs() > 18) {
      return left ? AnswerValue.no : AnswerValue.yes;
    }
    // Horizontal dominant sans beaucoup de vertical → oui/non (pas super).
    if (o.dx.abs() > o.dy.abs() * 1.4) {
      return left ? AnswerValue.no : AnswerValue.yes;
    }
    return null;
  }

  AnswerValue? get _preview => _valueForOffset(_offset);

  Future<void> _flyOut(AnswerValue value, {bool fromButton = false}) async {
    if (_locked) return;
    setState(() => _locked = true);

    final size = MediaQuery.sizeOf(context);
    final end = switch (value) {
      AnswerValue.superYes => Offset(size.width * 1.2, -size.height * 0.9),
      AnswerValue.yes => Offset(size.width * 1.2, size.height * 0.55),
      AnswerValue.superNo => Offset(-size.width * 1.2, -size.height * 0.9),
      AnswerValue.no => Offset(-size.width * 1.2, size.height * 0.55),
      AnswerValue.skip => Offset(0, size.height * 1.1),
    };

    if (widget.reduceMotion) {
      widget.onAnswered(value);
      return;
    }

    final previousDuration = _resetController.duration;
    _resetController.duration = Duration(milliseconds: fromButton ? 920 : 320);

    var begin = _offset;
    if (fromButton && begin.distance < 8) {
      begin = switch (value) {
        AnswerValue.superYes => const Offset(42, -50),
        AnswerValue.yes => const Offset(42, 50),
        AnswerValue.superNo => const Offset(-42, -50),
        AnswerValue.no => const Offset(-42, 50),
        AnswerValue.skip => const Offset(0, 56),
      };
      setState(() {
        _offset = begin;
        _angle = begin.dx / 320 * 0.22;
      });
    }

    final anim = Tween<Offset>(begin: begin, end: end).animate(
      CurvedAnimation(
        parent: _resetController,
        curve: fromButton ? Curves.easeInOutCubic : Curves.easeInCubic,
      ),
    );
    _resetAnimation = anim;
    await _resetController.forward(from: 0);
    _resetController.duration = previousDuration;
    if (!mounted) return;
    _resetAnimation = null;
    _resetController.stop();
    widget.onAnswered(value);
  }

  void _reset() {
    final anim = Tween<Offset>(begin: _offset, end: Offset.zero).animate(
      CurvedAnimation(
        parent: _resetController,
        curve: widget.reduceMotion ? Curves.linear : Curves.easeOutBack,
      ),
    );
    _resetAnimation = anim;
    _resetController.forward(from: 0).whenComplete(() {
      if (!mounted) return;
      setState(() {
        _offset = Offset.zero;
        _angle = 0;
        _armed = null;
      });
    });
  }

  Future<void> playDirectionDemo() async {
    if (!mounted || widget.reduceMotion || _locked) return;
    setState(() => _locked = true);

    const targets = [
      Offset(-52, -62),
      Offset(52, -62),
      Offset(0, 54),
      Offset(-52, 62),
      Offset(52, 62),
    ];
    final previousDuration = _resetController.duration;

    for (final target in targets) {
      if (!mounted) return;
      await _animateOffsetTo(target, const Duration(milliseconds: 380));
      await Future<void>.delayed(const Duration(milliseconds: 220));
      if (!mounted) return;
      await _animateOffsetTo(Offset.zero, const Duration(milliseconds: 280));
      await Future<void>.delayed(const Duration(milliseconds: 90));
    }

    _resetController.duration = previousDuration;
    if (!mounted) return;
    setState(() {
      _offset = Offset.zero;
      _angle = 0;
      _armed = null;
      _locked = false;
    });
  }

  Future<void> _animateOffsetTo(Offset end, Duration duration) async {
    _resetController.duration = duration;
    final anim = Tween<Offset>(begin: _offset, end: end).animate(
      CurvedAnimation(parent: _resetController, curve: Curves.easeInOutCubic),
    );
    _resetAnimation = anim;
    await _resetController.forward(from: 0);
    if (!mounted) return;
    setState(() {
      _offset = end;
      _angle = widget.reduceMotion ? 0 : end.dx / 320 * 0.22;
    });
  }

  Future<void> answerProgrammatically(AnswerValue value) async {
    if (!_canInteract) return;
    await widget.haptics.play(
      value.isStrong ? HapticKind.heavy : HapticKind.medium,
    );
    await _flyOut(value, fromButton: true);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!_canInteract) return;
    setState(() {
      _offset += details.delta;
      _angle = widget.reduceMotion ? 0 : _offset.dx / 320 * 0.22;
    });

    final next = _preview;
    if (next != null && next != _armed) {
      _armed = next;
      widget.haptics.play(
        next.isStrong ? HapticKind.medium : HapticKind.selection,
      );
    } else if (next == null) {
      _armed = null;
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (!_canInteract) return;
    final preview = _preview;
    final distance = _offset.distance;
    if (preview != null && distance >= _commitDistance) {
      widget.haptics.play(
        preview.isStrong ? HapticKind.heavy : HapticKind.light,
      );
      _flyOut(preview);
    } else {
      _reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final preview = _preview;
    final progress = (_offset.distance / (_commitDistance * 1.35)).clamp(
      0.0,
      1.0,
    );

    return Semantics(
      label: 'Affirmation politique. ${widget.question.text}',
      hint:
          'Glisse vers un coin : haut gauche super non, haut droite super oui, '
          'bas gauche non, bas droite oui. Ou utilise les boutons.',
      child: GestureDetector(
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: Transform.translate(
          offset: _offset,
          child: Transform.rotate(
            angle: _angle,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(
                    minHeight: 220,
                    maxHeight: 300,
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                  decoration: BoxDecoration(
                    gradient: AppColors.cardGradient,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: preview == null
                          ? AppColors.softGray.withValues(alpha: 0.7)
                          : preview.color.withValues(alpha: 0.55),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.nightBlue.withValues(alpha: 0.12),
                        blurRadius: 36,
                        offset: Offset(0, 18 + progress * 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (widget.progressLabel != null)
                            Text(
                              widget.progressLabel!,
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(
                                    color: AppColors.electricBlue,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          const Spacer(),
                          if (_categoryLabel(widget.question.category) != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.electricBlue.withValues(
                                  alpha: 0.08,
                                ),
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: Text(
                                _categoryLabel(widget.question.category)!,
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(color: AppColors.deepBlue),
                              ),
                            ),
                        ],
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.question.text,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(height: 1.28, color: AppColors.ink),
                          ),
                        ),
                      ),
                      _CardContext(
                        text:
                            widget.question.explanation ??
                            _categoryHint(widget.question.category),
                        source: widget.question.source,
                      ),
                    ],
                  ),
                ),
                if (preview != null)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Center(
                        child: ExcludeSemantics(
                          child: Transform.scale(
                            scale: 0.82 + progress * 0.28,
                            child: _Stamp(
                              label: preview.badge,
                              color: preview.color,
                            ),
                          ).animateOpacity(progress),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _categoryLabel(String id) =>
      PoliticalDimension.tryFromId(id)?.chipLabel;

  String _categoryHint(String id) =>
      PoliticalDimension.tryFromId(id)?.contextHint ??
      'Réagis selon tes idées : il n’y a pas de bonne ou de mauvaise réponse.';
}

class _CardContext extends StatelessWidget {
  const _CardContext({required this.text, this.source});

  final String text;
  final String? source;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: AppColors.electricBlue.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CONTEXTE',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.electricBlue,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            text,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.deepBlue,
              height: 1.35,
            ),
          ),
          if (source != null && source!.trim().isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              'Repère : $source',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.warmGray,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Stamp extends StatelessWidget {
  const _Stamp({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -math.pi / 28,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 4),
          borderRadius: BorderRadius.circular(18),
          color: AppColors.warmWhite.withValues(alpha: 0.94),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.28),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.6,
            height: 1,
          ),
        ),
      ),
    );
  }
}

extension on Widget {
  Widget animateOpacity(double t) =>
      Opacity(opacity: 0.35 + t * 0.65, child: this);
}
