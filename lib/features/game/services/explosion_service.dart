import 'package:flutter/material.dart' show Color, Colors;
import '../models/game_state_model.dart';
import '../models/ingredient_model.dart';

/// Service for handling explosion mechanics in Quacks of Quedlinburg
class ExplosionService {
  /// Explosion threshold for white chips (7 is safe, 8+ explodes)
  static const int explosionThreshold = 7;

  /// Check if adding a chip would cause an explosion
  static bool wouldCauseExplosion(
    List<IngredientChip> currentChips,
    IngredientChip newChip,
  ) {
    final currentWhiteTotal = _calculateWhiteChipTotal(currentChips);
    final newWhiteValue = newChip.color == IngredientColor.white
        ? newChip.value
        : 0;
    return (currentWhiteTotal + newWhiteValue) > explosionThreshold;
  }

  /// Check if pot has exploded based on current chips
  static bool hasExploded(List<IngredientChip> placedChips) {
    return _calculateWhiteChipTotal(placedChips) > explosionThreshold;
  }

  /// Calculate total white chip value
  static int _calculateWhiteChipTotal(List<IngredientChip> chips) {
    return chips
        .where((chip) => chip.color == IngredientColor.white)
        .fold(0, (sum, chip) => sum + chip.value);
  }

  /// Get explosion penalty for a player
  static Map<String, dynamic> calculateExplosionPenalty({
    required List<IngredientChip> placedChips,
    required int currentPosition,
    required int currentRound,
  }) {
    final whiteTotal = _calculateWhiteChipTotal(placedChips);
    final excessWhite = whiteTotal - explosionThreshold;

    // Basic penalty: lose progress based on excess white chips
    final positionPenalty = (excessWhite * 2).clamp(0, currentPosition);
    final newPosition = (currentPosition - positionPenalty).clamp(0, 33);

    // Victory point penalty (later rounds have higher penalties)
    int victoryPointPenalty = 0;
    if (currentRound >= 7) {
      victoryPointPenalty =
          excessWhite * 2; // 2 VP per excess white in late game
    } else if (currentRound >= 4) {
      victoryPointPenalty = excessWhite; // 1 VP per excess white in mid game
    }

    // Ruby penalty (lose rubies for major explosions)
    int rubyPenalty = 0;
    if (excessWhite >= 3) {
      rubyPenalty = 1; // Lose 1 ruby for major explosions
    }

    return {
      'whiteTotal': whiteTotal,
      'excessWhite': excessWhite,
      'positionPenalty': positionPenalty,
      'newPosition': newPosition,
      'victoryPointPenalty': victoryPointPenalty,
      'rubyPenalty': rubyPenalty,
      'severity': _getExplosionSeverity(excessWhite),
    };
  }

  /// Get explosion severity level
  static ExplosionSeverity _getExplosionSeverity(int excessWhite) {
    if (excessWhite >= 5) return ExplosionSeverity.catastrophic;
    if (excessWhite >= 3) return ExplosionSeverity.major;
    if (excessWhite >= 2) return ExplosionSeverity.moderate;
    return ExplosionSeverity.minor;
  }

  /// Apply explosion effects to a pot state
  static PotState applyExplosionEffects({
    required PotState currentPotState,
    required int currentRound,
  }) {
    if (!hasExploded(currentPotState.placedChips)) {
      return currentPotState; // No explosion, return unchanged
    }

    final penalty = calculateExplosionPenalty(
      placedChips: currentPotState.placedChips,
      currentPosition: currentPotState.scoringPosition,
      currentRound: currentRound,
    );

    // Apply penalties
    return currentPotState.copyWith(
      hasExploded: true,
      dropletPosition: penalty['newPosition'] as int,
      victoryPoints:
          (currentPotState.victoryPoints -
                  (penalty['victoryPointPenalty'] as int))
              .clamp(0, 999),
      rubies: (currentPotState.rubies - (penalty['rubyPenalty'] as int)).clamp(
        0,
        99,
      ),
      flaskAvailable: false, // Can't use flask after explosion
    );
  }

  /// Check if flask can be used to prevent explosion
  static bool canUseFlaskToPrevent({
    required List<IngredientChip> placedChips,
    required bool flaskAvailable,
  }) {
    if (!flaskAvailable) return false;
    if (!hasExploded(placedChips)) return false;

    // Find the last white chip that could be returned
    final lastWhiteChip = placedChips
        .where((chip) => chip.color == IngredientColor.white)
        .lastWhere(
          (chip) => chip.isOnBoard,
          orElse: () => throw StateError('No white chips found'),
        );

    // Check if removing this chip would prevent explosion
    final chipsWithoutLast = placedChips
        .where((chip) => chip.id != lastWhiteChip.id)
        .toList();

    return !hasExploded(chipsWithoutLast);
  }

  /// Get recovery options after explosion
  static Map<String, dynamic> getRecoveryOptions({
    required PotState explodedPotState,
    required int availableRubies,
    required int currentRound,
  }) {
    final options = <String, dynamic>{};

    // Ruby recovery options (2 rubies each)
    if (availableRubies >= 2) {
      options['moveDroplet'] = {
        'cost': 2,
        'effect': 'Move droplet 1 space forward',
        'available': true,
      };

      if (!explodedPotState.flaskAvailable) {
        options['refillFlask'] = {
          'cost': 2,
          'effect': 'Refill flask for next turn',
          'available': true,
        };
      }
    }

    // Late game recovery bonuses
    if (currentRound >= 6) {
      options['lateGameBonus'] = {
        'cost': 0,
        'effect': 'Reduced explosion penalty in late game',
        'available': true,
      };
    }

    return options;
  }

  /// Calculate protection value from ingredient abilities
  static int calculateExplosionProtection({
    required List<IngredientChip> placedChips,
    required int ingredientSet,
  }) {
    int protection = 0;

    // Count protection-providing ingredients
    final blueChips = placedChips
        .where((chip) => chip.color == IngredientColor.blue)
        .length;

    final purpleChips = placedChips
        .where((chip) => chip.color == IngredientColor.purple)
        .length;

    // Set-specific protection bonuses
    switch (ingredientSet) {
      case 1:
        // Set 1: Basic protection
        protection += blueChips; // 1 protection per blue
        break;
      case 2:
        // Set 2: Enhanced protection focus
        protection += blueChips * 2; // 2 protection per blue
        protection += purpleChips; // 1 protection per purple
        break;
      case 3:
        // Set 3: Balanced protection
        protection += blueChips; // 1 protection per blue
        break;
      case 4:
        // Set 4: Advanced protection combinations
        if (blueChips >= 2) {
          protection += 3; // Flat bonus for multiple blues
        }
        protection += purpleChips; // 1 protection per purple
        break;
    }

    return protection;
  }

  /// Check if explosion can be mitigated by ingredient abilities
  static bool canMitigateExplosion({
    required List<IngredientChip> placedChips,
    required int ingredientSet,
  }) {
    final whiteTotal = _calculateWhiteChipTotal(placedChips);
    final protection = calculateExplosionProtection(
      placedChips: placedChips,
      ingredientSet: ingredientSet,
    );

    // Check if protection reduces white total below threshold
    return (whiteTotal - protection) <= explosionThreshold;
  }

  /// Get explosion warning level for UI feedback
  static ExplosionWarning getExplosionWarning(
    List<IngredientChip> currentChips,
  ) {
    final whiteTotal = _calculateWhiteChipTotal(currentChips);

    if (whiteTotal >= explosionThreshold) {
      return ExplosionWarning.exploded;
    } else if (whiteTotal >= 6) {
      return ExplosionWarning.critical; // One chip away from explosion
    } else if (whiteTotal >= 4) {
      return ExplosionWarning.warning; // Getting dangerous
    } else {
      return ExplosionWarning.safe;
    }
  }
}

/// Explosion severity levels
enum ExplosionSeverity {
  minor(1, 'Minor Explosion', '💥'),
  moderate(2, 'Moderate Explosion', '💥💥'),
  major(3, 'Major Explosion', '💥💥💥'),
  catastrophic(4, 'Catastrophic Explosion', '💥💥💥💥');

  const ExplosionSeverity(this.level, this.displayName, this.icon);

  final int level;
  final String displayName;
  final String icon;
}

/// Explosion warning levels for UI
enum ExplosionWarning {
  safe(0, 'Safe', Colors.green),
  warning(1, 'Warning', Colors.orange),
  critical(2, 'Critical', Colors.red),
  exploded(3, 'Exploded', Colors.purple);

  const ExplosionWarning(this.level, this.displayName, this.color);

  final int level;
  final String displayName;
  final Color color;
}
