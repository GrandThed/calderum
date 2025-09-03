import '../models/ingredient_model.dart';

/// Service for calculating scores in Quacks of Quedlinburg
class ScoringService {
  /// Calculate base victory points from scoring position on track
  static int calculateVictoryPointsFromPosition(int position) {
    if (position < 10) return 0;
    if (position < 15) return 1;
    if (position < 20) return 3;
    if (position < 25) return 6;
    if (position < 30) return 10;
    if (position <= 33) return 15;
    return 15; // Max points for position 33+
  }

  /// Calculate coins based on scoring position
  static int calculateCoinsFromPosition(int position) {
    return position; // Direct 1:1 mapping
  }

  /// Check if position is on a ruby space (every 5th position)
  static bool isRubySpace(int position) {
    return position > 0 && position % 5 == 0;
  }

  /// Calculate total white chip value on pot (for explosion check)
  static int calculateWhiteChipTotal(List<IngredientChip> placedChips) {
    return placedChips
        .where((chip) => chip.color == IngredientColor.white)
        .fold(0, (sum, chip) => sum + chip.value);
  }

  /// Check if pot has exploded (white chips > 7)
  static bool hasExploded(List<IngredientChip> placedChips) {
    return calculateWhiteChipTotal(placedChips) > 7;
  }

  /// Calculate bonus die reward value
  static int calculateBonusDieReward(int dieResult) {
    switch (dieResult) {
      case 1:
        return 1; // 1 Victory Point
      case 2:
        return 2; // 2 Victory Points
      case 3:
        return 0; // 1 Ruby (handled separately)
      case 4:
        return 0; // 1 Orange chip (handled separately)
      case 5:
        return 0; // Move droplet 1 space (handled separately)
      case 6:
        return 0; // Special effect based on Fortune Teller card
      default:
        return 0;
    }
  }

  /// Calculate ingredient combo bonuses (basic implementation)
  /// TODO: Implement specific ingredient set bonuses based on chosen set
  static Map<String, int> calculateIngredientCombos(
    List<IngredientChip> placedChips,
    int ingredientSet,
  ) {
    final combos = <String, int>{};

    // Count ingredients by color and value
    final ingredientCounts = <String, int>{};
    for (final chip in placedChips) {
      if (chip.color != IngredientColor.white) {
        // Exclude white chips from combos
        final key = '${chip.color.name}_${chip.value}';
        ingredientCounts[key] = (ingredientCounts[key] ?? 0) + 1;
      }
    }

    // Basic combo detection (placeholder - needs ingredient set specific logic)
    switch (ingredientSet) {
      case 1:
        combos.addAll(_calculateSet1Combos(placedChips));
        break;
      case 2:
        combos.addAll(_calculateSet2Combos(placedChips));
        break;
      case 3:
        combos.addAll(_calculateSet3Combos(placedChips));
        break;
      case 4:
        combos.addAll(_calculateSet4Combos(placedChips));
        break;
    }

    return combos;
  }

  /// Calculate multiplier effects from special ingredients
  static double calculateMultiplier(
    List<IngredientChip> placedChips,
    int ingredientSet,
  ) {
    double multiplier = 1.0;

    // Count special ingredients that provide multipliers
    final purpleChips = placedChips
        .where((chip) => chip.color == IngredientColor.purple)
        .length;

    final blackChips = placedChips
        .where((chip) => chip.color == IngredientColor.black)
        .length;

    // Basic multiplier logic (ingredient set specific)
    switch (ingredientSet) {
      case 1:
        // Set 1: Simple scoring
        multiplier += purpleChips * 0.1; // 10% per purple
        break;
      case 2:
        // Set 2: Protection focus
        multiplier += blackChips * 0.05; // 5% per black
        break;
      case 3:
        // Set 3: Ruby bonuses
        multiplier += purpleChips * 0.15; // 15% per purple
        break;
      case 4:
        // Set 4: Victory point focus
        multiplier += (purpleChips + blackChips) * 0.08; // 8% per special
        break;
    }

    return multiplier;
  }

  /// Calculate round bonus points
  static int calculateRoundBonus(int currentRound, int finalPosition) {
    // Later rounds provide bonus points
    int roundMultiplier = 1;
    if (currentRound >= 7) {
      roundMultiplier = 3;
    } else if (currentRound >= 5) {
      roundMultiplier = 2;
    }

    // Position-based bonus
    int positionBonus = 0;
    if (finalPosition >= 30) {
      positionBonus = 5;
    } else if (finalPosition >= 25) {
      positionBonus = 3;
    } else if (finalPosition >= 20) {
      positionBonus = 1;
    }

    return positionBonus * roundMultiplier;
  }

  /// Calculate final score for a player's pot
  static Map<String, dynamic> calculateFinalScore({
    required List<IngredientChip> placedChips,
    required int finalPosition,
    required int currentRound,
    required int ingredientSet,
    required bool receivedBonusDie,
    required int bonusDieResult,
    required int previousVictoryPoints,
    required int rubies,
  }) {
    // Base scoring
    final basePoints = calculateVictoryPointsFromPosition(finalPosition);
    final coins = calculateCoinsFromPosition(finalPosition);
    final isOnRubySpace = isRubySpace(finalPosition);
    final exploded = hasExploded(placedChips);

    // Bonus die points
    int bonusDiePoints = 0;
    if (receivedBonusDie && !exploded) {
      bonusDiePoints = calculateBonusDieReward(bonusDieResult);
    }

    // Ingredient combos
    final combos = calculateIngredientCombos(placedChips, ingredientSet);
    final comboPoints = combos.values.fold(0, (sum, points) => sum + points);

    // Multipliers
    final multiplier = calculateMultiplier(placedChips, ingredientSet);

    // Round bonus
    final roundBonus = calculateRoundBonus(currentRound, finalPosition);

    // Calculate total
    final baseTotal = basePoints + bonusDiePoints + comboPoints + roundBonus;
    final multipliedTotal = (baseTotal * multiplier).round();
    final finalTotal = previousVictoryPoints + multipliedTotal;

    return {
      'basePoints': basePoints,
      'bonusDiePoints': bonusDiePoints,
      'comboPoints': comboPoints,
      'roundBonus': roundBonus,
      'multiplier': multiplier,
      'totalThisRound': multipliedTotal,
      'totalVictoryPoints': finalTotal,
      'coins': coins,
      'rubies': rubies + (isOnRubySpace ? 1 : 0),
      'exploded': exploded,
      'combos': combos,
    };
  }

  /// Set 1 specific combo calculations (Beginner set)
  static Map<String, int> _calculateSet1Combos(List<IngredientChip> chips) {
    final combos = <String, int>{};

    // Simple scoring - no complex combos
    final greenChips = chips
        .where((c) => c.color == IngredientColor.green)
        .length;
    if (greenChips >= 2) {
      combos['green_pair'] = greenChips ~/ 2; // 1 point per pair
    }

    return combos;
  }

  /// Set 2 specific combo calculations
  static Map<String, int> _calculateSet2Combos(List<IngredientChip> chips) {
    final combos = <String, int>{};

    // Blue protection bonuses
    final blueChips = chips
        .where((c) => c.color == IngredientColor.blue)
        .length;
    if (blueChips >= 1) {
      combos['blue_protection'] = blueChips; // 1 point per blue
    }

    return combos;
  }

  /// Set 3 specific combo calculations
  static Map<String, int> _calculateSet3Combos(List<IngredientChip> chips) {
    final combos = <String, int>{};

    // Ruby space bonuses
    final redChips = chips.where((c) => c.color == IngredientColor.red).length;
    final yellowChips = chips
        .where((c) => c.color == IngredientColor.yellow)
        .length;

    if (redChips >= 1 && yellowChips >= 1) {
      combos['red_yellow_combo'] = (redChips + yellowChips) ~/ 2;
    }

    return combos;
  }

  /// Set 4 specific combo calculations (Advanced)
  static Map<String, int> _calculateSet4Combos(List<IngredientChip> chips) {
    final combos = <String, int>{};

    // Victory point focus
    final purpleChips = chips
        .where((c) => c.color == IngredientColor.purple)
        .length;
    final blackChips = chips
        .where((c) => c.color == IngredientColor.black)
        .length;

    // Advanced scoring combinations
    if (purpleChips >= 2 && blackChips >= 1) {
      combos['purple_black_synergy'] = 3; // Flat 3 points for synergy
    }

    return combos;
  }
}
