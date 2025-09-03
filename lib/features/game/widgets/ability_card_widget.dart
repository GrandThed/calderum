import 'package:flutter/material.dart';
import '../models/ingredient_ability_model.dart';
import '../../../shared/theme/app_theme.dart';

/// Widget that displays an individual ingredient ability as a card
class AbilityCardWidget extends StatefulWidget {
  final ActiveAbility activeAbility;
  final bool isAvailable;
  final VoidCallback? onActivate;
  final bool showDetails;

  const AbilityCardWidget({
    super.key,
    required this.activeAbility,
    this.isAvailable = true,
    this.onActivate,
    this.showDetails = false,
  });

  @override
  State<AbilityCardWidget> createState() => _AbilityCardWidgetState();
}

class _AbilityCardWidgetState extends State<AbilityCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.isAvailable && widget.onActivate != null) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(AbilityCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isAvailable != oldWidget.isAvailable) {
      if (widget.isAvailable && widget.onActivate != null) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ability = widget.activeAbility.ability;
    final ingredientColor = ability.color.displayColor;
    final isActivatable = widget.isAvailable && widget.onActivate != null;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: isActivatable ? _pulseAnimation.value : 1.0,
            child: GestureDetector(
              onTap: isActivatable ? widget.onActivate : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: widget.showDetails ? 200 : 120,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _isHovered && isActivatable
                      ? ingredientColor.withValues(alpha: 0.2)
                      : ingredientColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isActivatable
                        ? ingredientColor.withValues(alpha: 0.6)
                        : ingredientColor.withValues(alpha: 0.3),
                    width: isActivatable ? 2 : 1,
                  ),
                  boxShadow: isActivatable
                      ? [
                          BoxShadow(
                            color: ingredientColor.withValues(alpha: 0.3),
                            blurRadius: _isHovered ? 12 : 6,
                            spreadRadius: _isHovered ? 2 : 0,
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Ingredient color indicator
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: ingredientColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: ingredientColor.darkerColor,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${ability.chipValue}',
                          style: AppTheme.titleStyle.copyWith(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.7),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Trigger indicator
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getTriggerColor(
                          ability.trigger,
                        ).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        ability.trigger.displayName,
                        style: AppTheme.bodyStyle.copyWith(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: _getTriggerColor(ability.trigger),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Effect type icon
                    Icon(
                      _getEffectIcon(ability.effectType),
                      color: ingredientColor,
                      size: 20,
                    ),

                    if (widget.showDetails) ...[
                      const SizedBox(height: 8),

                      // Description
                      Text(
                        ability.description,
                        style: AppTheme.bodyStyle.copyWith(
                          fontSize: 10,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    // Cooldown indicator
                    if (widget.activeAbility.cooldownRemaining > 0) ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Cooldown: ${widget.activeAbility.cooldownRemaining}',
                          style: AppTheme.bodyStyle.copyWith(
                            fontSize: 8,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],

                    // Uses remaining indicator
                    if (ability.usesPerTurn > 1) ...[
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(ability.usesPerTurn, (index) {
                          final used =
                              index < widget.activeAbility.usesThisTurn;
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: used
                                  ? Colors.red.withValues(alpha: 0.7)
                                  : ingredientColor.withValues(alpha: 0.7),
                              shape: BoxShape.circle,
                            ),
                          );
                        }),
                      ),
                    ],

                    // Activation indicator
                    if (isActivatable) ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.touch_app,
                          size: 12,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getTriggerColor(AbilityTrigger trigger) {
    switch (trigger) {
      case AbilityTrigger.onDraw:
        return Colors.blue;
      case AbilityTrigger.onPlace:
        return Colors.green;
      case AbilityTrigger.endOfPhase:
        return Colors.orange;
      case AbilityTrigger.endOfTurn:
        return Colors.purple;
      case AbilityTrigger.immediate:
        return Colors.red;
      case AbilityTrigger.passive:
        return Colors.grey;
    }
  }

  IconData _getEffectIcon(AbilityEffectType effectType) {
    switch (effectType) {
      case AbilityEffectType.drawChips:
        return Icons.add_circle;
      case AbilityEffectType.moveDroplet:
        return Icons.arrow_forward;
      case AbilityEffectType.gainRubies:
        return Icons.diamond;
      case AbilityEffectType.gainVictoryPoints:
        return Icons.emoji_events;
      case AbilityEffectType.protection:
        return Icons.shield;
      case AbilityEffectType.multiplier:
        return Icons.close;
      case AbilityEffectType.skipPhase:
        return Icons.skip_next;
      case AbilityEffectType.chooseEffect:
        return Icons.help_outline;
    }
  }
}

/// Extension to get darker color shade for ingredients
extension IngredientColorExtension on Color {
  Color get darkerColor {
    final hsl = HSLColor.fromColor(this);
    return hsl.withLightness((hsl.lightness * 0.7).clamp(0.0, 1.0)).toColor();
  }
}
