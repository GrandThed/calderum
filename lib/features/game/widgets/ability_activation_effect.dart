import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/ingredient_ability_model.dart';
import '../../../shared/theme/app_theme.dart';

/// Widget that shows animated effects when abilities are activated
class AbilityActivationEffect extends StatefulWidget {
  final AbilityResult abilityResult;
  final Offset startPosition;
  final VoidCallback? onComplete;

  const AbilityActivationEffect({
    super.key,
    required this.abilityResult,
    required this.startPosition,
    this.onComplete,
  });

  @override
  State<AbilityActivationEffect> createState() =>
      _AbilityActivationEffectState();
}

class _AbilityActivationEffectState extends State<AbilityActivationEffect>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _particleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _particleAnimation;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _particleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0, -2)).animate(
          CurvedAnimation(
            parent: _mainController,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
          ),
        );

    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.easeOut),
    );

    _startAnimation();
  }

  void _startAnimation() {
    _mainController.forward();
    _particleController.forward();

    _mainController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.startPosition.dx,
      top: widget.startPosition.dy,
      child: AnimatedBuilder(
        animation: Listenable.merge([_mainController, _particleController]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.translate(
              offset: _slideAnimation.value * 50,
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Particle effects
                    ..._buildParticleEffects(),

                    // Main effect container
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _getEffectColor().withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _getEffectColor(), width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: _getEffectColor().withValues(alpha: 0.5),
                            blurRadius: 20,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Effect icon
                          Icon(_getEffectIcon(), color: Colors.white, size: 32),

                          const SizedBox(height: 8),

                          // Effect message
                          Text(
                            widget.abilityResult.message,
                            style: AppTheme.titleStyle.copyWith(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),

                          // Effect values
                          if (widget.abilityResult.effects.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            ..._buildEffectValues(),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildParticleEffects() {
    final particles = <Widget>[];
    final particleCount = widget.abilityResult.success ? 8 : 4;

    for (int i = 0; i < particleCount; i++) {
      final angle = (i / particleCount) * 2 * 3.14159;
      final distance = 60.0 * _particleAnimation.value;

      particles.add(
        Positioned(
          left: distance * cos(angle),
          top: distance * sin(angle),
          child: Transform.scale(
            scale: 1.0 - _particleAnimation.value,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: _getEffectColor(),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _getEffectColor().withValues(alpha: 0.5),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return particles;
  }

  List<Widget> _buildEffectValues() {
    final values = <Widget>[];
    final effects = widget.abilityResult.effects;

    if (effects.containsKey('rubies_gained')) {
      values.add(
        _buildValueChip(
          '${effects['rubies_gained']} Ruby${effects['rubies_gained'] == 1 ? '' : 'ies'}',
          Icons.diamond,
          Colors.red,
        ),
      );
    }

    if (effects.containsKey('points_gained')) {
      values.add(
        _buildValueChip(
          '${effects['points_gained']} VP',
          Icons.emoji_events,
          Colors.amber,
        ),
      );
    }

    if (effects.containsKey('draw_chips')) {
      values.add(
        _buildValueChip(
          'Draw ${effects['draw_chips']}',
          Icons.add_circle,
          Colors.blue,
        ),
      );
    }

    if (effects.containsKey('droplet_spaces')) {
      values.add(
        _buildValueChip(
          'Move ${effects['droplet_spaces']}',
          Icons.arrow_forward,
          Colors.green,
        ),
      );
    }

    return values;
  }

  Widget _buildValueChip(String text, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTheme.bodyStyle.copyWith(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getEffectColor() {
    if (!widget.abilityResult.success) {
      return Colors.red;
    }

    // Choose color based on effect type
    final effects = widget.abilityResult.effects;

    if (effects.containsKey('rubies_gained')) {
      return Colors.red.shade400;
    } else if (effects.containsKey('points_gained')) {
      return AppTheme.secondaryColor;
    } else if (effects.containsKey('draw_chips')) {
      return Colors.blue;
    } else if (effects.containsKey('droplet_spaces')) {
      return Colors.green;
    } else if (effects.containsKey('protection_value')) {
      return Colors.purple;
    } else if (effects.containsKey('score_multiplier')) {
      return Colors.orange;
    }

    return AppTheme.primaryColor;
  }

  IconData _getEffectIcon() {
    if (!widget.abilityResult.success) {
      return Icons.error;
    }

    final effects = widget.abilityResult.effects;

    if (effects.containsKey('rubies_gained')) {
      return Icons.diamond;
    } else if (effects.containsKey('points_gained')) {
      return Icons.emoji_events;
    } else if (effects.containsKey('draw_chips')) {
      return Icons.add_circle;
    } else if (effects.containsKey('droplet_spaces')) {
      return Icons.arrow_forward;
    } else if (effects.containsKey('protection_value')) {
      return Icons.shield;
    } else if (effects.containsKey('score_multiplier')) {
      return Icons.close;
    }

    return Icons.auto_fix_high;
  }
}

/// Overlay that manages multiple ability activation effects
class AbilityEffectOverlay extends StatefulWidget {
  final Widget child;

  const AbilityEffectOverlay({super.key, required this.child});

  static AbilityEffectOverlayState? of(BuildContext context) {
    return context.findAncestorStateOfType<AbilityEffectOverlayState>();
  }

  @override
  State<AbilityEffectOverlay> createState() => AbilityEffectOverlayState();
}

class AbilityEffectOverlayState extends State<AbilityEffectOverlay> {
  final List<AbilityActivationEffect> _activeEffects = [];

  void showAbilityEffect({
    required AbilityResult abilityResult,
    required Offset position,
  }) {
    final effect = AbilityActivationEffect(
      abilityResult: abilityResult,
      startPosition: position,
      onComplete: () {
        setState(() {
          _activeEffects.removeWhere((e) => e.abilityResult == abilityResult);
        });
      },
    );

    setState(() {
      _activeEffects.add(effect);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [widget.child, ..._activeEffects]);
  }
}

// Extension for math functions
double cos(double radians) => math.cos(radians);
double sin(double radians) => math.sin(radians);
