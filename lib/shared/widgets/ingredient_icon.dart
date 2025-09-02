import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/ingredient_assets.dart';

/// A widget that displays an ingredient icon using SVG assets
class IngredientIcon extends StatelessWidget {
  /// The ingredient type to display
  final IngredientType ingredient;

  /// The size of the icon (width and height)
  final double size;

  /// Optional color filter to apply to the SVG
  final Color? color;

  /// Whether to show a circular background
  final bool showBackground;

  /// Background color when showBackground is true
  final Color? backgroundColor;

  /// Semantic label for accessibility
  final String? semanticLabel;

  const IngredientIcon({
    super.key,
    required this.ingredient,
    this.size = 48.0,
    this.color,
    this.showBackground = false,
    this.backgroundColor,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBackgroundColor =
        backgroundColor ??
        Color(ingredient.primaryColorValue).withValues(alpha: 0.1);

    Widget svgIcon = SvgPicture.asset(
      ingredient.assetPath,
      width: size,
      height: size,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
      semanticsLabel: semanticLabel ?? ingredient.displayName,
      placeholderBuilder: (context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(size * 0.1),
        ),
        child: Icon(
          Icons.science,
          size: size * 0.6,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );

    if (showBackground) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: Color(ingredient.primaryColorValue).withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Center(
          child: SvgPicture.asset(
            ingredient.assetPath,
            width: size * 0.7,
            height: size * 0.7,
            colorFilter: color != null
                ? ColorFilter.mode(color!, BlendMode.srcIn)
                : null,
            semanticsLabel: semanticLabel ?? ingredient.displayName,
          ),
        ),
      );
    }

    return svgIcon;
  }
}

/// A specialized ingredient icon with chip-like styling for game use
class IngredientChip extends StatelessWidget {
  /// The ingredient type to display
  final IngredientType ingredient;

  /// The size of the chip
  final double size;

  /// Whether the chip is selected/active
  final bool isSelected;

  /// Callback when the chip is tapped
  final VoidCallback? onTap;

  /// Optional count to display on the chip
  final int? count;

  /// Whether the chip is disabled
  final bool disabled;

  const IngredientChip({
    super.key,
    required this.ingredient,
    this.size = 56.0,
    this.isSelected = false,
    this.onTap,
    this.count,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = Color(ingredient.primaryColorValue);

    return Semantics(
      button: true,
      enabled: !disabled,
      selected: isSelected,
      label:
          '${ingredient.displayName}${count != null ? ', count: $count' : ''}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: disabled ? null : onTap,
          borderRadius: BorderRadius.circular(size * 0.5),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? primaryColor.withValues(alpha: 0.2)
                  : theme.colorScheme.surface,
              border: Border.all(
                color: isSelected
                    ? primaryColor
                    : primaryColor.withValues(alpha: 0.3),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Stack(
              children: [
                Center(
                  child: Opacity(
                    opacity: disabled ? 0.5 : 1.0,
                    child: SvgPicture.asset(
                      ingredient.assetPath,
                      width: size * 0.6,
                      height: size * 0.6,
                      semanticsLabel: ingredient.displayName,
                    ),
                  ),
                ),
                if (count != null && count! > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.colorScheme.surface,
                          width: 1,
                        ),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      child: Text(
                        count.toString(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
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
}

/// A grid of ingredient chips for selection
class IngredientGrid extends StatelessWidget {
  /// List of ingredients to display
  final List<IngredientType> ingredients;

  /// Currently selected ingredients
  final Set<IngredientType> selectedIngredients;

  /// Callback when an ingredient is selected/deselected
  final void Function(IngredientType ingredient)? onIngredientToggle;

  /// Size of each ingredient chip
  final double chipSize;

  /// Number of columns in the grid
  final int crossAxisCount;

  /// Spacing between grid items
  final double spacing;

  /// Whether selection is disabled
  final bool disabled;

  /// Ingredient counts (for display)
  final Map<IngredientType, int>? ingredientCounts;

  const IngredientGrid({
    super.key,
    required this.ingredients,
    this.selectedIngredients = const {},
    this.onIngredientToggle,
    this.chipSize = 64.0,
    this.crossAxisCount = 4,
    this.spacing = 8.0,
    this.disabled = false,
    this.ingredientCounts,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 1,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        final ingredient = ingredients[index];
        final isSelected = selectedIngredients.contains(ingredient);
        final count = ingredientCounts?[ingredient];

        return IngredientChip(
          ingredient: ingredient,
          size: chipSize,
          isSelected: isSelected,
          count: count,
          disabled: disabled,
          onTap: () => onIngredientToggle?.call(ingredient),
        );
      },
    );
  }
}
