import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/haptics.dart';
import '../models/question.dart';

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
    _resetController = AnimationController(
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

  Future<void> _flyOut(AnswerValue value) async {
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

    final anim = Tween<Offset>(begin: _offset, end: end).animate(
      CurvedAnimation(parent: _resetController, curve: Curves.easeInCubic),
    );
    _resetAnimation = anim;
    _resetController.forward(from: 0);
    await Future<void>.delayed(const Duration(milliseconds: 220));
    if (!mounted) return;
    // Coupe l’anim pour qu’un reset ultérieur ne réécrive pas l’offset.
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

  Future<void> answerProgrammatically(AnswerValue value) async {
    if (!_canInteract) return;
    await widget.haptics.play(
      value.isStrong ? HapticKind.heavy : HapticKind.medium,
    );
    await _flyOut(value);
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
    final progress =
        (_offset.distance / (_commitDistance * 1.35)).clamp(0.0, 1.0);

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
                          : _badgeColor(preview).withValues(alpha: 0.55),
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
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
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
                                color: AppColors.electricBlue
                                    .withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: Text(
                                _categoryLabel(widget.question.category)!,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
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
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  height: 1.28,
                                  color: AppColors.ink,
                                ),
                          ),
                        ),
                      ),
                      _CardContext(
                        text: widget.question.explanation ??
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
                              color: _badgeColor(preview),
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

  Color _badgeColor(AnswerValue value) => switch (value) {
        AnswerValue.superYes => AppColors.superYes,
        AnswerValue.yes => AppColors.yes,
        AnswerValue.superNo => AppColors.superNo,
        AnswerValue.no => AppColors.no,
        AnswerValue.skip => AppColors.skip,
      };

  String? _categoryLabel(String id) {
    const labels = {
      'economy': 'Économie',
      'taxation': 'Fiscalité',
      'redistribution': 'Redistribution',
      'work': 'Travail',
      'social_protection': 'Protection sociale',
      'public_services': 'Services publics',
      'enterprise': 'Entreprise',
      'property': 'Propriété',
      'market': 'Marché',
      'civil_liberties': 'Libertés',
      'society': 'Société',
      'family': 'Famille',
      'religion_laicity': 'Laïcité',
      'immigration': 'Immigration',
      'integration': 'Intégration',
      'security': 'Sécurité',
      'justice': 'Justice',
      'authority': 'Autorité',
      'institutions': 'Institutions',
      'democracy': 'Démocratie',
      'decentralization': 'Territoires',
      'sovereignty': 'Souveraineté',
      'europe': 'Europe',
      'ecology': 'Écologie',
      'climate': 'Climat',
      'energy': 'Énergie',
      'agriculture': 'Agriculture',
      'globalization': 'Mondialisation',
      'international': 'International',
      'defense': 'Défense',
      'foreign_policy': 'Diplomatie',
      'digital': 'Numérique',
      'culture': 'Culture',
      'education': 'Éducation',
      'health': 'Santé',
    };
    return labels[id];
  }

  String _categoryHint(String id) {
    const hints = {
      'economy':
          'Cette carte porte sur le rôle de l’État et l’organisation de l’économie.',
      'taxation':
          'Cette carte interroge le niveau et la répartition des impôts.',
      'redistribution':
          'Cette carte porte sur les inégalités et la redistribution.',
      'work': 'Cette carte concerne le travail, l’emploi et les droits sociaux.',
      'social_protection':
          'Cette carte porte sur la protection sociale et la solidarité.',
      'public_services':
          'Cette carte touche au rôle et au financement des services publics.',
      'enterprise':
          'Cette carte interroge la place de l’entreprise et de l’initiative privée.',
      'property': 'Cette carte porte sur la propriété et son encadrement.',
      'market':
          'Cette carte interroge la confiance accordée au marché.',
      'civil_liberties':
          'Cette carte porte sur les libertés individuelles.',
      'society':
          'Cette carte concerne les normes sociales et le vivre-ensemble.',
      'family': 'Cette carte interroge le rôle de la famille dans la société.',
      'religion_laicity':
          'Cette carte porte sur la laïcité et la place du religieux.',
      'immigration':
          'Cette carte concerne l’accueil et les politiques migratoires.',
      'integration':
          'Cette carte porte sur l’intégration et la cohésion sociale.',
      'security': 'Cette carte interroge l’équilibre entre sécurité et libertés.',
      'justice': 'Cette carte porte sur la justice et la réponse pénale.',
      'authority':
          'Cette carte concerne l’autorité, l’ordre et la discipline.',
      'institutions':
          'Cette carte porte sur les institutions et leur fonctionnement.',
      'democracy':
          'Cette carte interroge la participation et le fonctionnement démocratique.',
      'decentralization':
          'Cette carte concerne les territoires et la décentralisation.',
      'sovereignty':
          'Cette carte porte sur la souveraineté nationale et les choix collectifs.',
      'europe':
          'Cette carte interroge la construction européenne et ses compétences.',
      'ecology':
          'Cette carte porte sur l’environnement et les priorités écologiques.',
      'climate': 'Cette carte concerne le climat et la transition.',
      'energy': 'Cette carte porte sur les choix énergétiques.',
      'agriculture':
          'Cette carte concerne l’agriculture, l’alimentation et les campagnes.',
      'globalization':
          'Cette carte interroge la mondialisation et ses contreparties.',
      'international':
          'Cette carte porte sur la place de la France dans le monde.',
      'defense': 'Cette carte concerne la défense et la sécurité collective.',
      'foreign_policy':
          'Cette carte porte sur la diplomatie et la politique étrangère.',
      'digital':
          'Cette carte interroge le numérique, ses libertés et ses régulations.',
      'culture': 'Cette carte porte sur la culture et son accès.',
      'education':
          'Cette carte concerne l’école, la formation et l’égalité des chances.',
      'health': 'Cette carte porte sur la santé et l’accès aux soins.',
    };
    return hints[id] ??
        'Réagis selon tes idées : il n’y a pas de bonne ou de mauvaise réponse.';
  }
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
