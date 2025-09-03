import '../models/game_state_model.dart';
import '../models/ingredient_model.dart';
import '../models/ingredient_ability_model.dart';

/// Service for managing and executing ingredient abilities
class AbilityService {
  /// Get all active abilities for a player
  static List<ActiveAbility> getActiveAbilities({
    required String playerId,
    required List<IngredientChip> placedChips,
    required int ingredientSet,
  }) {
    final activeAbilities = <ActiveAbility>[];

    for (final chip in placedChips) {
      if (!chip.isOnBoard) continue;

      // Get abilities for this ingredient chip
      final abilities = IngredientAbilities.getAbilitiesFor(
        color: chip.color,
        chipValue: chip.value,
        ingredientSet: ingredientSet,
      );

      // Create active ability instances
      for (final ability in abilities) {
        activeAbilities.add(
          ActiveAbility(
            abilityId: '${chip.id}_${ability.id}',
            playerId: playerId,
            chipId: chip.id,
            ability: ability,
          ),
        );
      }
    }

    return activeAbilities;
  }

  /// Execute an ability and return the result
  static AbilityResult executeAbility({
    required ActiveAbility activeAbility,
    required GamePlayer player,
    required GameState gameState,
  }) {
    final ability = activeAbility.ability;

    // Check if ability can be activated
    if (!_canExecuteAbility(activeAbility, player)) {
      return const AbilityResult(
        success: false,
        message: 'Ability cannot be activated',
      );
    }

    // Execute based on effect type
    switch (ability.effectType) {
      case AbilityEffectType.drawChips:
        return _executeDrawChips(ability, player);
      case AbilityEffectType.moveDroplet:
        return _executeMoveDroplet(ability, player);
      case AbilityEffectType.gainRubies:
        return _executeGainRubies(ability, player);
      case AbilityEffectType.gainVictoryPoints:
        return _executeGainVictoryPoints(ability, player);
      case AbilityEffectType.protection:
        return _executeProtection(ability, player);
      case AbilityEffectType.multiplier:
        return _executeMultiplier(ability, player);
      case AbilityEffectType.skipPhase:
        return _executeSkipPhase(ability, player);
      case AbilityEffectType.chooseEffect:
        return _executeChooseEffect(ability, player);
    }
  }

  /// Check if ability can be executed
  static bool _canExecuteAbility(
    ActiveAbility activeAbility,
    GamePlayer player,
  ) {
    // Check cooldown
    if (activeAbility.cooldownRemaining > 0) return false;

    // Check uses per turn
    if (activeAbility.usesThisTurn >= activeAbility.ability.usesPerTurn) {
      return false;
    }

    // Check if available
    if (!activeAbility.isAvailable) return false;

    // Check ability requirements
    return activeAbility.ability.canActivate(
      placedChips: player.potState.placedChips,
      currentTurn: 1, // TODO: Pass actual turn
      rubies: player.potState.rubies,
      victoryPoints: player.potState.victoryPoints,
    );
  }

  /// Execute draw chips ability
  static AbilityResult _executeDrawChips(
    IngredientAbility ability,
    GamePlayer player,
  ) {
    final drawCount = ability.parameters['draw_count'] as int? ?? 1;

    return AbilityResult(
      success: true,
      message: 'Draw $drawCount additional chip${drawCount > 1 ? 's' : ''}',
      effects: {
        'draw_chips': drawCount,
        'place_one': true,
        'return_others': true,
      },
      triggeredEvents: ['chip_draw_bonus'],
    );
  }

  /// Execute move droplet ability
  static AbilityResult _executeMoveDroplet(
    IngredientAbility ability,
    GamePlayer player,
  ) {
    final spaces = ability.parameters['spaces'] as int? ?? 1;
    final moveToRuby =
        ability.parameters['move_to_next_ruby'] as bool? ?? false;

    int newPosition;
    if (moveToRuby) {
      // Find next ruby space
      newPosition = _findNextRubySpace(player.potState.dropletPosition);
    } else {
      newPosition = (player.potState.dropletPosition + spaces).clamp(0, 33);
    }

    return AbilityResult(
      success: true,
      message: 'Move droplet to position $newPosition',
      effects: {
        'new_droplet_position': newPosition,
        'spaces_moved': newPosition - player.potState.dropletPosition,
      },
      triggeredEvents: ['droplet_moved'],
    );
  }

  /// Execute gain rubies ability
  static AbilityResult _executeGainRubies(
    IngredientAbility ability,
    GamePlayer player,
  ) {
    int rubiesGained = 0;

    if (ability.parameters.containsKey('rubies')) {
      rubiesGained = ability.parameters['rubies'] as int;
    } else if (ability.parameters.containsKey('ruby_formula')) {
      final formula = ability.parameters['ruby_formula'] as String;
      rubiesGained = _calculateFormulaValue(formula, player);
    } else if (ability.parameters.containsKey('extra_rubies_on_ruby_space')) {
      // Only grant if on ruby space
      if (player.potState.scoringPosition % 5 == 0 &&
          player.potState.scoringPosition > 0) {
        rubiesGained = ability.parameters['extra_rubies_on_ruby_space'] as int;
      }
    }

    return AbilityResult(
      success: true,
      message: 'Gain $rubiesGained ${rubiesGained == 1 ? 'ruby' : 'rubies'}',
      effects: {
        'rubies_gained': rubiesGained,
        'new_ruby_count': player.potState.rubies + rubiesGained,
      },
      triggeredEvents: ['rubies_gained'],
    );
  }

  /// Execute gain victory points ability
  static AbilityResult _executeGainVictoryPoints(
    IngredientAbility ability,
    GamePlayer player,
  ) {
    int pointsGained = 0;

    if (ability.parameters.containsKey('points')) {
      pointsGained = ability.parameters['points'] as int;
    } else if (ability.parameters.containsKey('vp_on_ruby_space')) {
      // Only grant if on ruby space
      if (player.potState.scoringPosition % 5 == 0 &&
          player.potState.scoringPosition > 0) {
        pointsGained = ability.parameters['vp_on_ruby_space'] as int;
      }
    }

    return AbilityResult(
      success: true,
      message:
          'Gain $pointsGained victory ${pointsGained == 1 ? 'point' : 'points'}',
      effects: {
        'points_gained': pointsGained,
        'new_vp_count': player.potState.victoryPoints + pointsGained,
      },
      triggeredEvents: ['victory_points_gained'],
    );
  }

  /// Execute protection ability
  static AbilityResult _executeProtection(
    IngredientAbility ability,
    GamePlayer player,
  ) {
    final protectionValue = ability.parameters['protection_value'] as int? ?? 1;

    return AbilityResult(
      success: true,
      message: 'Explosion protection: $protectionValue',
      effects: {
        'protection_value': protectionValue,
        'prevents_explosion': true,
      },
      triggeredEvents: ['explosion_protected'],
    );
  }

  /// Execute multiplier ability
  static AbilityResult _executeMultiplier(
    IngredientAbility ability,
    GamePlayer player,
  ) {
    final multiplier = ability.parameters['multiplier'] as double? ?? 1.0;

    // Check if requirements are met for multiplier
    bool canApply = true;
    if (ability.requirements.contains('color_count:total:3')) {
      final uniqueColors = player.potState.placedChips
          .map((chip) => chip.color)
          .toSet()
          .length;
      canApply = uniqueColors >= 3;
    } else if (ability.requirements.contains('color_count:total:8')) {
      final uniqueColors = player.potState.placedChips
          .map((chip) => chip.color)
          .toSet()
          .length;
      canApply = uniqueColors >= 8;
    }

    return AbilityResult(
      success: canApply,
      message: canApply
          ? 'Score multiplier: ${multiplier}x'
          : 'Requirements not met for multiplier',
      effects: canApply
          ? {'score_multiplier': multiplier, 'applies_to_vp': true}
          : {},
      triggeredEvents: canApply ? ['score_multiplied'] : [],
    );
  }

  /// Execute skip phase ability
  static AbilityResult _executeSkipPhase(
    IngredientAbility ability,
    GamePlayer player,
  ) {
    return const AbilityResult(
      success: true,
      message: 'Skip to next phase',
      effects: {'skip_phase': true},
      triggeredEvents: ['phase_skipped'],
    );
  }

  /// Execute choose effect ability
  static AbilityResult _executeChooseEffect(
    IngredientAbility ability,
    GamePlayer player,
  ) {
    final choices =
        ability.parameters['choices'] as List<Map<String, dynamic>>?;

    if (choices == null || choices.isEmpty) {
      return const AbilityResult(
        success: false,
        message: 'No choices available',
      );
    }

    // For now, automatically choose the first option
    // In a real implementation, this would present choices to the player
    final selectedChoice = choices.first;
    final type = selectedChoice['type'] as String;
    final value = selectedChoice['value'] as int;

    String message;
    Map<String, dynamic> effects;

    switch (type) {
      case 'rubies':
        message = 'Chose to gain $value ${value == 1 ? 'ruby' : 'rubies'}';
        effects = {'rubies_gained': value, 'choice_made': 'rubies'};
        break;
      case 'droplet':
        message = 'Chose to move droplet $value space${value == 1 ? '' : 's'}';
        effects = {'droplet_spaces': value, 'choice_made': 'droplet'};
        break;
      default:
        return const AbilityResult(
          success: false,
          message: 'Unknown choice type',
        );
    }

    return AbilityResult(
      success: true,
      message: message,
      effects: effects,
      triggeredEvents: ['choice_made'],
    );
  }

  /// Find the next ruby space after current position
  static int _findNextRubySpace(int currentPosition) {
    for (int pos = currentPosition + 1; pos <= 33; pos++) {
      if (pos % 5 == 0) {
        return pos;
      }
    }
    return 33; // If no ruby space found, go to end
  }

  /// Calculate value from formula string
  static int _calculateFormulaValue(String formula, GamePlayer player) {
    // Simple formula parser for "position/5" type formulas
    if (formula == 'position/5') {
      return (player.potState.scoringPosition / 5).floor();
    }

    return 0; // Default if formula not recognized
  }

  /// Get abilities that trigger at specific phase
  static List<ActiveAbility> getAbilitiesForTrigger({
    required List<ActiveAbility> activeAbilities,
    required AbilityTrigger trigger,
  }) {
    return activeAbilities
        .where((ability) => ability.ability.trigger == trigger)
        .toList();
  }

  /// Update ability cooldowns and usage counts
  static List<ActiveAbility> updateAbilitiesForNewTurn(
    List<ActiveAbility> activeAbilities,
  ) {
    return activeAbilities.map((ability) {
      return ability.copyWith(
        cooldownRemaining: (ability.cooldownRemaining - 1).clamp(0, 999),
        usesThisTurn: 0, // Reset uses per turn
      );
    }).toList();
  }

  /// Execute all passive abilities
  static List<AbilityResult> executePassiveAbilities({
    required GamePlayer player,
    required List<ActiveAbility> activeAbilities,
    required GameState gameState,
  }) {
    final results = <AbilityResult>[];

    final passiveAbilities = getAbilitiesForTrigger(
      activeAbilities: activeAbilities,
      trigger: AbilityTrigger.passive,
    );

    for (final ability in passiveAbilities) {
      final result = executeAbility(
        activeAbility: ability,
        player: player,
        gameState: gameState,
      );
      results.add(result);
    }

    return results;
  }

  /// Check if any abilities provide explosion protection
  static int calculateTotalProtection({
    required List<ActiveAbility> activeAbilities,
    required GamePlayer player,
    required GameState gameState,
  }) {
    int totalProtection = 0;

    final protectionAbilities = activeAbilities
        .where(
          (ability) =>
              ability.ability.effectType == AbilityEffectType.protection,
        )
        .toList();

    for (final ability in protectionAbilities) {
      final result = executeAbility(
        activeAbility: ability,
        player: player,
        gameState: gameState,
      );

      if (result.success) {
        totalProtection += result.effects['protection_value'] as int? ?? 0;
      }
    }

    return totalProtection;
  }
}
