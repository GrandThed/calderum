import 'package:flutter/material.dart';
import '../models/ingredient_ability_model.dart';
import '../models/game_state_model.dart';
import '../services/ability_service.dart';
import '../../../shared/theme/app_theme.dart';
import 'ability_card_widget.dart';

/// Panel that displays all available abilities for a player
class AbilityPanelWidget extends StatefulWidget {
  final GamePlayer player;
  final GameState gameState;
  final int ingredientSet;
  final Function(ActiveAbility)? onAbilityActivate;
  final bool isExpanded;

  const AbilityPanelWidget({
    super.key,
    required this.player,
    required this.gameState,
    required this.ingredientSet,
    this.onAbilityActivate,
    this.isExpanded = false,
  });

  @override
  State<AbilityPanelWidget> createState() => _AbilityPanelWidgetState();
}

class _AbilityPanelWidgetState extends State<AbilityPanelWidget>
    with TickerProviderStateMixin {
  late AnimationController _expandController;
  late AnimationController _activationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _activationAnimation;

  bool _isExpanded = false;
  List<ActiveAbility> _activeAbilities = [];

  @override
  void initState() {
    super.initState();

    _expandController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _activationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOut,
    );

    _activationAnimation = CurvedAnimation(
      parent: _activationController,
      curve: Curves.elasticOut,
    );

    _isExpanded = widget.isExpanded;
    if (_isExpanded) {
      _expandController.value = 1.0;
    }

    _updateActiveAbilities();
  }

  @override
  void didUpdateWidget(AbilityPanelWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.player != widget.player ||
        oldWidget.gameState != widget.gameState) {
      _updateActiveAbilities();
    }
  }

  void _updateActiveAbilities() {
    setState(() {
      _activeAbilities = AbilityService.getActiveAbilities(
        playerId: widget.player.userId,
        placedChips: widget.player.potState.placedChips,
        ingredientSet: widget.ingredientSet,
      );
    });
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _expandController.forward();
    } else {
      _expandController.reverse();
    }
  }

  void _handleAbilityActivation(ActiveAbility ability) {
    _activationController.forward().then((_) {
      _activationController.reverse();
    });

    widget.onAbilityActivate?.call(ability);
  }

  @override
  void dispose() {
    _expandController.dispose();
    _activationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final availableAbilities = _getAvailableAbilities();
    final passiveAbilities = _getPassiveAbilities();

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          InkWell(
            onTap: _toggleExpanded,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(14),
              topRight: Radius.circular(14),
            ),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.auto_fix_high,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Abilities',
                    style: AppTheme.titleStyle.copyWith(
                      fontFamily: 'Caudex',
                      fontSize: 16,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const Spacer(),
                  if (availableAbilities.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${availableAbilities.length}',
                        style: AppTheme.bodyStyle.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: const Icon(
                      Icons.expand_more,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Abilities content
          AnimatedBuilder(
            animation: _expandAnimation,
            builder: (context, child) {
              return SizeTransition(
                sizeFactor: _expandAnimation,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Available abilities section
                      if (availableAbilities.isNotEmpty) ...[
                        Row(
                          children: [
                            const Icon(
                              Icons.flash_on,
                              color: Colors.green,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Available (${availableAbilities.length})',
                              style: AppTheme.bodyStyle.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        AnimatedBuilder(
                          animation: _activationAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: 1 + (_activationAnimation.value * 0.05),
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: availableAbilities.map((ability) {
                                  return AbilityCardWidget(
                                    activeAbility: ability,
                                    isAvailable: true,
                                    onActivate: () =>
                                        _handleAbilityActivation(ability),
                                    showDetails: true,
                                  );
                                }).toList(),
                              ),
                            );
                          },
                        ),
                      ],

                      // Passive abilities section
                      if (passiveAbilities.isNotEmpty) ...[
                        if (availableAbilities.isNotEmpty)
                          const SizedBox(height: 16),

                        Row(
                          children: [
                            const Icon(
                              Icons.shield,
                              color: Colors.blue,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Passive (${passiveAbilities.length})',
                              style: AppTheme.bodyStyle.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: passiveAbilities.map((ability) {
                            return AbilityCardWidget(
                              activeAbility: ability,
                              isAvailable: false,
                              showDetails: false,
                            );
                          }).toList(),
                        ),
                      ],

                      // All abilities section (when nothing is available)
                      if (availableAbilities.isEmpty &&
                          passiveAbilities.isEmpty) ...[
                        if (_activeAbilities.isNotEmpty) ...[
                          Text(
                            'All Abilities (${_activeAbilities.length})',
                            style: AppTheme.bodyStyle.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 8),

                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _activeAbilities.map((ability) {
                              return AbilityCardWidget(
                                activeAbility: ability,
                                isAvailable: false,
                                showDetails: false,
                              );
                            }).toList(),
                          ),
                        ] else ...[
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.auto_fix_off,
                                    color: Colors.white54,
                                    size: 32,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'No abilities available',
                                    style: AppTheme.bodyStyle.copyWith(
                                      color: Colors.white54,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    'Place ingredient chips to unlock abilities',
                                    style: AppTheme.bodyStyle.copyWith(
                                      color: Colors.white38,
                                      fontSize: 10,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  List<ActiveAbility> _getAvailableAbilities() {
    return AbilityService.getAbilitiesForTrigger(
      activeAbilities: _activeAbilities,
      trigger: _getCurrentTrigger(),
    ).where((ability) {
      // Check if ability can be activated
      return ability.cooldownRemaining == 0 &&
          ability.usesThisTurn < ability.ability.usesPerTurn &&
          ability.isAvailable;
    }).toList();
  }

  List<ActiveAbility> _getPassiveAbilities() {
    return AbilityService.getAbilitiesForTrigger(
      activeAbilities: _activeAbilities,
      trigger: AbilityTrigger.passive,
    );
  }

  AbilityTrigger _getCurrentTrigger() {
    // Map game phase to ability trigger
    switch (widget.gameState.currentPhase) {
      case GamePhase.potions:
        return AbilityTrigger.onPlace;
      case GamePhase.evaluationB:
      case GamePhase.evaluationC:
      case GamePhase.evaluationD:
        return AbilityTrigger.endOfPhase;
      case GamePhase.evaluationF:
        return AbilityTrigger.endOfTurn;
      default:
        return AbilityTrigger.immediate;
    }
  }
}

/// Floating ability activation button
class FloatingAbilityButton extends StatefulWidget {
  final List<ActiveAbility> availableAbilities;
  final Function(ActiveAbility) onAbilityActivate;

  const FloatingAbilityButton({
    super.key,
    required this.availableAbilities,
    required this.onAbilityActivate,
  });

  @override
  State<FloatingAbilityButton> createState() => _FloatingAbilityButtonState();
}

class _FloatingAbilityButtonState extends State<FloatingAbilityButton>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _menuController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _menuAnimation;

  bool _isMenuOpen = false;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _menuController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _menuAnimation = CurvedAnimation(
      parent: _menuController,
      curve: Curves.elasticOut,
    );

    if (widget.availableAbilities.isNotEmpty) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(FloatingAbilityButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.availableAbilities.isEmpty) {
      _pulseController.stop();
      _pulseController.reset();
      if (_isMenuOpen) {
        _toggleMenu();
      }
    } else if (oldWidget.availableAbilities.isEmpty) {
      _pulseController.repeat(reverse: true);
    }
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });

    if (_isMenuOpen) {
      _menuController.forward();
    } else {
      _menuController.reverse();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _menuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.availableAbilities.isEmpty) {
      return const SizedBox.shrink();
    }

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Ability menu
        AnimatedBuilder(
          animation: _menuAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _menuAnimation.value,
              child: Opacity(
                opacity: _menuAnimation.value,
                child: _isMenuOpen
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...widget.availableAbilities.asMap().entries.map((
                            entry,
                          ) {
                            final index = entry.key;
                            final ability = entry.value;

                            return Transform.translate(
                              offset: Offset(
                                0,
                                -(80.0 * (index + 1) * _menuAnimation.value),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: AbilityCardWidget(
                                  activeAbility: ability,
                                  isAvailable: true,
                                  onActivate: () {
                                    widget.onAbilityActivate(ability);
                                    _toggleMenu();
                                  },
                                ),
                              ),
                            );
                          }),
                          const SizedBox(height: 80), // Space for main button
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
            );
          },
        ),

        // Main floating button
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: FloatingActionButton(
                onPressed: widget.availableAbilities.length == 1
                    ? () => widget.onAbilityActivate(
                        widget.availableAbilities.first,
                      )
                    : _toggleMenu,
                backgroundColor: AppTheme.primaryColor,
                child: AnimatedRotation(
                  turns: _isMenuOpen ? 0.125 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    _isMenuOpen
                        ? Icons.close
                        : (widget.availableAbilities.length == 1
                              ? Icons.auto_fix_high
                              : Icons.auto_awesome_motion),
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
