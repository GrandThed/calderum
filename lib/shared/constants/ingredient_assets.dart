/// Constants for ingredient SVG assets
class IngredientAssets {
  static const String _basePath = 'assets/images/ingredients';
  
  // Individual ingredient SVG paths
  static const String whiteCherryBomb = '$_basePath/white_cherry_bomb.svg';
  static const String orangePumpkin = '$_basePath/orange_pumpkin.svg';
  static const String yellowToadstool = '$_basePath/yellow_toadstool.svg';
  static const String greenSpider = '$_basePath/green_spider.svg';
  static const String blueGhostlyBreath = '$_basePath/blue_ghostly_breath.svg';
  static const String redMandrake = '$_basePath/red_mandrake.svg';
  static const String purpleDeathsHead = '$_basePath/purple_deaths_head.svg';
  static const String blackCrowSkull = '$_basePath/black_crow_skull.svg';
  
  /// Map of ingredient types to their SVG asset paths
  static const Map<IngredientType, String> ingredientPaths = {
    IngredientType.white: whiteCherryBomb,
    IngredientType.orange: orangePumpkin,
    IngredientType.yellow: yellowToadstool,
    IngredientType.green: greenSpider,
    IngredientType.blue: blueGhostlyBreath,
    IngredientType.red: redMandrake,
    IngredientType.purple: purpleDeathsHead,
    IngredientType.black: blackCrowSkull,
  };
  
  /// Get SVG asset path for a specific ingredient type
  static String getAssetPath(IngredientType ingredient) {
    return ingredientPaths[ingredient] ?? whiteCherryBomb;
  }
  
  /// Get all ingredient asset paths as a list
  static List<String> get allPaths => ingredientPaths.values.toList();
  
  /// Get ingredient names for display
  static const Map<IngredientType, String> ingredientNames = {
    IngredientType.white: 'Cherry Bomb',
    IngredientType.orange: 'Pumpkin',
    IngredientType.yellow: 'Yellow Toadstool',
    IngredientType.green: 'Spider',
    IngredientType.blue: 'Ghostly Breath',
    IngredientType.red: 'Mandrake',
    IngredientType.purple: 'African Death\'s Head',
    IngredientType.black: 'Crow Skull',
  };
  
  /// Get display name for ingredient type
  static String getDisplayName(IngredientType ingredient) {
    return ingredientNames[ingredient] ?? 'Unknown Ingredient';
  }
}

/// Enum representing the 8 ingredient types in Quacks of Quedlinburg
enum IngredientType {
  white,    // Cherry Bomb - Basic explosion ingredient
  orange,   // Pumpkin - Scoring ingredient
  yellow,   // Yellow Toadstool - Forward movement
  green,    // Spider - Multiple effects
  blue,     // Ghostly Breath - Special actions
  red,      // Mandrake - Powerful effects
  purple,   // African Death's Head - Advanced ingredient
  black,    // Crow Skull - Rare ingredient
}

/// Extension methods for IngredientType
extension IngredientTypeExtension on IngredientType {
  /// Get the SVG asset path for this ingredient type
  String get assetPath => IngredientAssets.getAssetPath(this);
  
  /// Get the display name for this ingredient type
  String get displayName => IngredientAssets.getDisplayName(this);
  
  /// Get the primary color associated with this ingredient
  int get primaryColorValue {
    switch (this) {
      case IngredientType.white:
        return 0xFFFFFFFF;
      case IngredientType.orange:
        return 0xFFFF8C00;
      case IngredientType.yellow:
        return 0xFFFFD700;
      case IngredientType.green:
        return 0xFF228B22;
      case IngredientType.blue:
        return 0xFF4169E1;
      case IngredientType.red:
        return 0xFFDC143C;
      case IngredientType.purple:
        return 0xFF9370DB;
      case IngredientType.black:
        return 0xFF2F2F2F;
    }
  }
}