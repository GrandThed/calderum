import 'package:freezed_annotation/freezed_annotation.dart';
import 'ingredient_model.dart';

part 'ingredient_ability_model.freezed.dart';
part 'ingredient_ability_model.g.dart';

/// When an ingredient ability triggers
enum AbilityTrigger {
  onDraw('On Draw'),
  onPlace('On Place'),
  endOfPhase('End of Phase'),
  endOfTurn('End of Turn'),
  immediate('Immediate'),
  passive('Passive');

  const AbilityTrigger(this.displayName);
  final String displayName;
}

/// Types of ability effects
enum AbilityEffectType {
  drawChips('Draw Additional Chips'),
  moveDroplet('Move Droplet'),
  gainRubies('Gain Rubies'),
  gainVictoryPoints('Gain Victory Points'),
  protection('Explosion Protection'),
  multiplier('Score Multiplier'),
  skipPhase('Skip Phase'),
  chooseEffect('Choose Effect');

  const AbilityEffectType(this.displayName);
  final String displayName;
}

/// Individual ingredient ability
@freezed
class IngredientAbility with _$IngredientAbility {
  const factory IngredientAbility({
    required String id,
    required IngredientColor color,
    required int chipValue, // Which value chip has this ability (1, 2, or 4)
    required int ingredientSet, // Which ingredient set (1-4)
    required AbilityTrigger trigger,
    required AbilityEffectType effectType,
    required String description,
    required Map<String, dynamic> parameters, // Effect parameters
    @Default([]) List<String> requirements, // Conditions needed to activate
    @Default(0) int cooldownTurns, // Turns before can use again
    @Default(1) int usesPerTurn, // Max uses per turn
  }) = _IngredientAbility;

  factory IngredientAbility.fromJson(Map<String, dynamic> json) =>
      _$IngredientAbilityFromJson(json);
}

/// Active ability instance on a player's pot
@freezed
class ActiveAbility with _$ActiveAbility {
  const factory ActiveAbility({
    required String abilityId,
    required String playerId,
    required String chipId, // Which chip provides this ability
    required IngredientAbility ability,
    @Default(0) int cooldownRemaining,
    @Default(0) int usesThisTurn,
    @Default(true) bool isAvailable,
    DateTime? lastUsed,
  }) = _ActiveAbility;

  factory ActiveAbility.fromJson(Map<String, dynamic> json) =>
      _$ActiveAbilityFromJson(json);
}

/// Result of executing an ability
@freezed
class AbilityResult with _$AbilityResult {
  const factory AbilityResult({
    required bool success,
    required String message,
    @Default(<String, dynamic>{}) Map<String, dynamic> effects,
    @Default([]) List<String> triggeredEvents,
  }) = _AbilityResult;

  factory AbilityResult.fromJson(Map<String, dynamic> json) =>
      _$AbilityResultFromJson(json);
}

/// Extension methods for ingredient abilities
extension IngredientAbilityOperations on IngredientAbility {
  /// Check if ability can be activated given current game state
  bool canActivate({
    required List<IngredientChip> placedChips,
    required int currentTurn,
    required int rubies,
    required int victoryPoints,
  }) {
    // Check requirements
    for (final requirement in requirements) {
      if (!_checkRequirement(
        requirement,
        placedChips: placedChips,
        currentTurn: currentTurn,
        rubies: rubies,
        victoryPoints: victoryPoints,
      )) {
        return false;
      }
    }
    return true;
  }

  /// Check individual requirement
  bool _checkRequirement(
    String requirement, {
    required List<IngredientChip> placedChips,
    required int currentTurn,
    required int rubies,
    required int victoryPoints,
  }) {
    final parts = requirement.split(':');
    if (parts.length != 2) return false;

    final type = parts[0];
    final value = int.tryParse(parts[1]) ?? 0;

    switch (type) {
      case 'min_chips':
        return placedChips.length >= value;
      case 'min_turn':
        return currentTurn >= value;
      case 'min_rubies':
        return rubies >= value;
      case 'min_position':
        // Check if player is at least at certain position
        if (placedChips.isEmpty) return false;
        final maxPosition = placedChips
            .map((c) => c.positionOnBoard ?? 0)
            .reduce((a, b) => a > b ? a : b);
        return maxPosition >= value;
      case 'color_count':
        // Format: "color_count:green:2" means need 2+ green chips
        if (parts.length < 3) return false;
        final colorName = parts[1];
        final count = int.tryParse(parts[2]) ?? 0;
        final actualCount = placedChips
            .where((c) => c.color.name == colorName)
            .length;
        return actualCount >= count;
      default:
        return true;
    }
  }
}

/// Predefined ingredient abilities for each set
class IngredientAbilities {
  /// Get all abilities for a specific ingredient set
  static List<IngredientAbility> getAbilitiesForSet(int ingredientSet) {
    switch (ingredientSet) {
      case 1:
        return _getSet1Abilities();
      case 2:
        return _getSet2Abilities();
      case 3:
        return _getSet3Abilities();
      case 4:
        return _getSet4Abilities();
      default:
        return [];
    }
  }

  /// Get abilities for specific ingredient color and value
  static List<IngredientAbility> getAbilitiesFor({
    required IngredientColor color,
    required int chipValue,
    required int ingredientSet,
  }) {
    return getAbilitiesForSet(ingredientSet)
        .where(
          (ability) => ability.color == color && ability.chipValue == chipValue,
        )
        .toList();
  }

  /// Set 1 Abilities (Beginner)
  static List<IngredientAbility> _getSet1Abilities() {
    return [
      // Green (Garden Spider) - End of phase actions
      const IngredientAbility(
        id: 'green_1_set1',
        color: IngredientColor.green,
        chipValue: 1,
        ingredientSet: 1,
        trigger: AbilityTrigger.endOfPhase,
        effectType: AbilityEffectType.gainRubies,
        description: 'Gain 1 ruby if on space 10+',
        parameters: {'rubies': 1, 'min_position': 10},
        requirements: ['min_position:10'],
      ),

      const IngredientAbility(
        id: 'green_2_set1',
        color: IngredientColor.green,
        chipValue: 2,
        ingredientSet: 1,
        trigger: AbilityTrigger.endOfPhase,
        effectType: AbilityEffectType.gainVictoryPoints,
        description: 'Gain 1 VP if on space 15+',
        parameters: {'points': 1, 'min_position': 15},
        requirements: ['min_position:15'],
      ),

      // Blue (Crow Skull) - On draw actions
      const IngredientAbility(
        id: 'blue_1_set1',
        color: IngredientColor.blue,
        chipValue: 1,
        ingredientSet: 1,
        trigger: AbilityTrigger.onDraw,
        effectType: AbilityEffectType.drawChips,
        description: 'Draw 1 additional chip, place 1, return others',
        parameters: {'draw_count': 1},
      ),

      const IngredientAbility(
        id: 'blue_2_set1',
        color: IngredientColor.blue,
        chipValue: 2,
        ingredientSet: 1,
        trigger: AbilityTrigger.onDraw,
        effectType: AbilityEffectType.drawChips,
        description: 'Draw 2 additional chips, place 1, return others',
        parameters: {'draw_count': 2},
      ),

      // Red (Toadstool) - Immediate droplet movement
      const IngredientAbility(
        id: 'red_1_set1',
        color: IngredientColor.red,
        chipValue: 1,
        ingredientSet: 1,
        trigger: AbilityTrigger.immediate,
        effectType: AbilityEffectType.moveDroplet,
        description: 'Move droplet 1 space forward immediately',
        parameters: {'spaces': 1},
      ),

      const IngredientAbility(
        id: 'red_2_set1',
        color: IngredientColor.red,
        chipValue: 2,
        ingredientSet: 1,
        trigger: AbilityTrigger.immediate,
        effectType: AbilityEffectType.moveDroplet,
        description: 'Move droplet 2 spaces forward immediately',
        parameters: {'spaces': 2},
      ),

      // Yellow (Mandrake) - Set 1 specific effects
      const IngredientAbility(
        id: 'yellow_1_set1',
        color: IngredientColor.yellow,
        chipValue: 1,
        ingredientSet: 1,
        trigger: AbilityTrigger.onPlace,
        effectType: AbilityEffectType.gainRubies,
        description: 'Gain 1 ruby when placed',
        parameters: {'rubies': 1},
      ),

      // Purple (Ghost's Breath) - End of phase bonuses
      const IngredientAbility(
        id: 'purple_1_set1',
        color: IngredientColor.purple,
        chipValue: 1,
        ingredientSet: 1,
        trigger: AbilityTrigger.endOfPhase,
        effectType: AbilityEffectType.multiplier,
        description: 'Multiply score by 1.1x if you have 3+ ingredient colors',
        parameters: {'multiplier': 1.1},
        requirements: ['color_count:total:3'],
      ),

      // Black (Locoweed) - Special effects
      const IngredientAbility(
        id: 'black_1_set1',
        color: IngredientColor.black,
        chipValue: 1,
        ingredientSet: 1,
        trigger: AbilityTrigger.endOfPhase,
        effectType: AbilityEffectType.chooseEffect,
        description: 'Choose: Gain 1 ruby OR Move droplet 1 space',
        parameters: {
          'choices': [
            {'type': 'rubies', 'value': 1},
            {'type': 'droplet', 'value': 1},
          ],
        },
      ),
    ];
  }

  /// Set 2 Abilities (Protection focused)
  static List<IngredientAbility> _getSet2Abilities() {
    return [
      // Blue protection abilities
      const IngredientAbility(
        id: 'blue_1_set2',
        color: IngredientColor.blue,
        chipValue: 1,
        ingredientSet: 2,
        trigger: AbilityTrigger.passive,
        effectType: AbilityEffectType.protection,
        description: 'Prevent explosion if white total is exactly 8',
        parameters: {'protection_value': 1},
      ),

      const IngredientAbility(
        id: 'blue_2_set2',
        color: IngredientColor.blue,
        chipValue: 2,
        ingredientSet: 2,
        trigger: AbilityTrigger.passive,
        effectType: AbilityEffectType.protection,
        description: 'Prevent explosion if white total is 8 or 9',
        parameters: {'protection_value': 2},
      ),

      // Enhanced green abilities
      const IngredientAbility(
        id: 'green_1_set2',
        color: IngredientColor.green,
        chipValue: 1,
        ingredientSet: 2,
        trigger: AbilityTrigger.endOfPhase,
        effectType: AbilityEffectType.gainRubies,
        description: 'Gain rubies equal to position divided by 5',
        parameters: {'ruby_formula': 'position/5'},
      ),
    ];
  }

  /// Set 3 Abilities (Ruby focused)
  static List<IngredientAbility> _getSet3Abilities() {
    return [
      // Blue ruby space abilities
      const IngredientAbility(
        id: 'blue_1_set3',
        color: IngredientColor.blue,
        chipValue: 1,
        ingredientSet: 3,
        trigger: AbilityTrigger.endOfPhase,
        effectType: AbilityEffectType.gainRubies,
        description: 'Gain 1 additional ruby if on ruby space',
        parameters: {'extra_rubies_on_ruby_space': 1},
      ),

      // Strategic positioning abilities
      const IngredientAbility(
        id: 'red_1_set3',
        color: IngredientColor.red,
        chipValue: 1,
        ingredientSet: 3,
        trigger: AbilityTrigger.immediate,
        effectType: AbilityEffectType.moveDroplet,
        description: 'Move droplet to next ruby space',
        parameters: {'move_to_next_ruby': true},
      ),
    ];
  }

  /// Set 4 Abilities (Victory Point focused)
  static List<IngredientAbility> _getSet4Abilities() {
    return [
      // Blue VP abilities
      const IngredientAbility(
        id: 'blue_1_set4',
        color: IngredientColor.blue,
        chipValue: 1,
        ingredientSet: 4,
        trigger: AbilityTrigger.endOfPhase,
        effectType: AbilityEffectType.gainVictoryPoints,
        description: 'Gain 1 VP if on ruby space',
        parameters: {'vp_on_ruby_space': 1},
      ),

      // Advanced combo abilities
      const IngredientAbility(
        id: 'purple_1_set4',
        color: IngredientColor.purple,
        chipValue: 1,
        ingredientSet: 4,
        trigger: AbilityTrigger.endOfPhase,
        effectType: AbilityEffectType.multiplier,
        description: 'Multiply VP by 1.2x if you have all 8 ingredient colors',
        parameters: {'multiplier': 1.2},
        requirements: ['color_count:total:8'],
      ),
    ];
  }
}
