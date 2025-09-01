import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

part 'ingredient_model.freezed.dart';
part 'ingredient_model.g.dart';

/// The 8 ingredient colors in Quacks of Quedlinburg
enum IngredientColor {
  white('Cherry Bombs'),
  orange('Pumpkin'),
  yellow('Mandrake'),
  green('Garden Spider'),
  blue('Crow Skull'),
  red('Toadstool'),
  purple('Ghost\'s Breath'),
  black('Locoweed');

  const IngredientColor(this.displayName);
  final String displayName;

  /// Get the color for UI display
  Color get displayColor {
    switch (this) {
      case IngredientColor.white:
        return Colors.grey.shade100;
      case IngredientColor.orange:
        return Colors.orange;
      case IngredientColor.yellow:
        return Colors.yellow.shade700;
      case IngredientColor.green:
        return Colors.green;
      case IngredientColor.blue:
        return Colors.blue;
      case IngredientColor.red:
        return Colors.red;
      case IngredientColor.purple:
        return Colors.purple;
      case IngredientColor.black:
        return Colors.grey.shade800;
    }
  }

  /// Get darker shade for shadows/outlines
  Color get darkerColor {
    switch (this) {
      case IngredientColor.white:
        return Colors.grey.shade400;
      case IngredientColor.orange:
        return Colors.orange.shade800;
      case IngredientColor.yellow:
        return Colors.yellow.shade900;
      case IngredientColor.green:
        return Colors.green.shade800;
      case IngredientColor.blue:
        return Colors.blue.shade800;
      case IngredientColor.red:
        return Colors.red.shade800;
      case IngredientColor.purple:
        return Colors.purple.shade800;
      case IngredientColor.black:
        return Colors.black;
    }
  }
}

/// Individual ingredient chip with value and color
@freezed
class IngredientChip with _$IngredientChip {
  const factory IngredientChip({
    required String id, // Unique identifier for this chip instance
    required IngredientColor color,
    required int value, // 1, 2, 3, or 4
    @Default(false) bool isInBag, // Whether chip is currently in player's bag
    @Default(false) bool isOnBoard, // Whether chip is placed on pot
    int? positionOnBoard, // Position in pot (0-33)
  }) = _IngredientChip;

  factory IngredientChip.fromJson(Map<String, dynamic> json) =>
      _$IngredientChipFromJson(json);
}

/// Player's ingredient bag containing all their chips
@freezed
class IngredientBag with _$IngredientBag {
  const factory IngredientBag({
    required String playerId,
    @Default([]) List<IngredientChip> chips,
    @Default([])
    List<IngredientChip> drawnThisTurn, // Chips drawn but not yet placed
  }) = _IngredientBag;

  factory IngredientBag.fromJson(Map<String, dynamic> json) =>
      _$IngredientBagFromJson(json);
}

/// Extension methods for ingredient bag operations
extension IngredientBagOperations on IngredientBag {
  /// Get all chips currently in the bag (not drawn or on board)
  List<IngredientChip> get availableChips =>
      chips.where((chip) => chip.isInBag && !chip.isOnBoard).toList();

  /// Get total number of available chips
  int get availableCount => availableChips.length;

  /// Check if bag is empty
  bool get isEmpty => availableChips.isEmpty;

  /// Get white chip value total from drawn chips
  int get whiteChipTotal => drawnThisTurn
      .where((chip) => chip.color == IngredientColor.white)
      .fold(0, (sum, chip) => sum + chip.value);

  /// Check if pot would explode with current white chips
  bool get wouldExplode => whiteChipTotal > 7;

  /// Create starting bag for new player
  static IngredientBag createStartingBag(String playerId) {
    return IngredientBag(
      playerId: playerId,
      chips: [
        // 4x white 1-chips
        IngredientChip(
          id: '${playerId}_white_1_1',
          color: IngredientColor.white,
          value: 1,
          isInBag: true,
        ),
        IngredientChip(
          id: '${playerId}_white_1_2',
          color: IngredientColor.white,
          value: 1,
          isInBag: true,
        ),
        IngredientChip(
          id: '${playerId}_white_1_3',
          color: IngredientColor.white,
          value: 1,
          isInBag: true,
        ),
        IngredientChip(
          id: '${playerId}_white_1_4',
          color: IngredientColor.white,
          value: 1,
          isInBag: true,
        ),
        // 2x white 2-chips
        IngredientChip(
          id: '${playerId}_white_2_1',
          color: IngredientColor.white,
          value: 2,
          isInBag: true,
        ),
        IngredientChip(
          id: '${playerId}_white_2_2',
          color: IngredientColor.white,
          value: 2,
          isInBag: true,
        ),
        // 1x white 3-chip
        IngredientChip(
          id: '${playerId}_white_3_1',
          color: IngredientColor.white,
          value: 3,
          isInBag: true,
        ),
        // 1x orange 1-chip
        IngredientChip(
          id: '${playerId}_orange_1_1',
          color: IngredientColor.orange,
          value: 1,
          isInBag: true,
        ),
        // 1x green 1-chip
        IngredientChip(
          id: '${playerId}_green_1_1',
          color: IngredientColor.green,
          value: 1,
          isInBag: true,
        ),
      ],
    );
  }
}

/// Available ingredients in the market/ingredient books
@freezed
class IngredientMarket with _$IngredientMarket {
  const factory IngredientMarket({
    @Default([]) List<AvailableIngredient> availableIngredients,
    required int currentTurn, // Determines which ingredient books are available
  }) = _IngredientMarket;

  factory IngredientMarket.fromJson(Map<String, dynamic> json) =>
      _$IngredientMarketFromJson(json);
}

/// Represents an ingredient available for purchase
@freezed
class AvailableIngredient with _$AvailableIngredient {
  const factory AvailableIngredient({
    required IngredientColor color,
    required int value,
    required int cost, // Cost in coins
    required int quantity, // Available quantity
  }) = _AvailableIngredient;

  factory AvailableIngredient.fromJson(Map<String, dynamic> json) =>
      _$AvailableIngredientFromJson(json);
}

/// Extension for market operations
extension IngredientMarketOperations on IngredientMarket {
  /// Get available ingredient books based on current turn
  List<IngredientColor> get availableColors {
    final colors = <IngredientColor>[
      IngredientColor.orange, // Always available
      IngredientColor.black, // Always available
      IngredientColor.green, // Available from turn 1
      IngredientColor.blue, // Available from turn 1
      IngredientColor.red, // Available from turn 1
    ];

    if (currentTurn >= 2) {
      colors.add(IngredientColor.yellow); // Available from turn 2
    }

    if (currentTurn >= 3) {
      colors.add(IngredientColor.purple); // Available from turn 3
    }

    return colors;
  }

  /// Create market for specific turn
  static IngredientMarket createForTurn(int turn) {
    final market = IngredientMarket(currentTurn: turn);
    final availableIngredients = <AvailableIngredient>[];

    // Add ingredients based on available colors
    for (final color in market.availableColors) {
      switch (color) {
        case IngredientColor.orange:
          availableIngredients.add(
            const AvailableIngredient(
              color: IngredientColor.orange,
              value: 1,
              cost: 2,
              quantity: 20,
            ),
          );
          break;
        case IngredientColor.black:
          availableIngredients.add(
            const AvailableIngredient(
              color: IngredientColor.black,
              value: 1,
              cost: 3,
              quantity: 18,
            ),
          );
          break;
        case IngredientColor.green:
          availableIngredients.addAll([
            const AvailableIngredient(
              color: IngredientColor.green,
              value: 1,
              cost: 4,
              quantity: 15,
            ),
            const AvailableIngredient(
              color: IngredientColor.green,
              value: 2,
              cost: 8,
              quantity: 10,
            ),
            const AvailableIngredient(
              color: IngredientColor.green,
              value: 4,
              cost: 16,
              quantity: 10,
            ),
          ]);
          break;
        case IngredientColor.blue:
          availableIngredients.addAll([
            const AvailableIngredient(
              color: IngredientColor.blue,
              value: 1,
              cost: 6,
              quantity: 14,
            ),
            const AvailableIngredient(
              color: IngredientColor.blue,
              value: 2,
              cost: 12,
              quantity: 10,
            ),
            const AvailableIngredient(
              color: IngredientColor.blue,
              value: 4,
              cost: 24,
              quantity: 10,
            ),
          ]);
          break;
        case IngredientColor.red:
          availableIngredients.addAll([
            const AvailableIngredient(
              color: IngredientColor.red,
              value: 1,
              cost: 8,
              quantity: 12,
            ),
            const AvailableIngredient(
              color: IngredientColor.red,
              value: 2,
              cost: 16,
              quantity: 8,
            ),
            const AvailableIngredient(
              color: IngredientColor.red,
              value: 4,
              cost: 32,
              quantity: 6,
            ),
          ]);
          break;
        case IngredientColor.yellow:
          if (turn >= 2) {
            availableIngredients.addAll([
              const AvailableIngredient(
                color: IngredientColor.yellow,
                value: 1,
                cost: 5,
                quantity: 15,
              ),
              const AvailableIngredient(
                color: IngredientColor.yellow,
                value: 2,
                cost: 10,
                quantity: 10,
              ),
              const AvailableIngredient(
                color: IngredientColor.yellow,
                value: 4,
                cost: 20,
                quantity: 13,
              ),
            ]);
          }
          break;
        case IngredientColor.purple:
          if (turn >= 3) {
            availableIngredients.add(
              const AvailableIngredient(
                color: IngredientColor.purple,
                value: 1,
                cost: 7,
                quantity: 15,
              ),
            );
          }
          break;
        case IngredientColor.white:
          // White chips are not purchasable
          break;
      }
    }

    return market.copyWith(availableIngredients: availableIngredients);
  }
}
