import 'package:flutter/material.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/calderum_button.dart';
import '../models/ingredient_model.dart';

class IngredientMarketWidget extends StatelessWidget {
  final IngredientMarket market;
  final int playerCoins;
  final Function(AvailableIngredient ingredient) onBuyIngredient;

  const IngredientMarketWidget({
    super.key,
    required this.market,
    required this.playerCoins,
    required this.onBuyIngredient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.secondaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.store, color: AppTheme.secondaryColor, size: 20),
              const SizedBox(width: 8),
              Text(
                'Ingredient Market',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              _buildCoinsDisplay(),
            ],
          ),

          const SizedBox(height: 12),

          // Available ingredients
          Expanded(child: _buildAvailableIngredients()),
        ],
      ),
    );
  }

  Widget _buildCoinsDisplay() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.monetization_on, size: 16, color: Colors.amber),
          const SizedBox(width: 4),
          Text(
            '$playerCoins',
            style: const TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableIngredients() {
    if (market.availableIngredients.isEmpty) {
      return const Center(
        child: Text(
          'No ingredients available',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    // Group ingredients by color
    final Map<IngredientColor, List<AvailableIngredient>> groupedIngredients =
        {};
    for (final ingredient in market.availableIngredients) {
      groupedIngredients[ingredient.color] =
          groupedIngredients[ingredient.color] ?? [];
      groupedIngredients[ingredient.color]!.add(ingredient);
    }

    return ListView.builder(
      itemCount: groupedIngredients.length,
      itemBuilder: (context, index) {
        final entry = groupedIngredients.entries.elementAt(index);
        final color = entry.key;
        final ingredients = entry.value;

        return _buildIngredientColorSection(color, ingredients);
      },
    );
  }

  Widget _buildIngredientColorSection(
    IngredientColor color,
    List<AvailableIngredient> ingredients,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.displayColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.displayColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Color header
          Text(
            color.displayName,
            style: TextStyle(
              color: color.displayColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 8),

          // Ingredients of this color
          ...ingredients.map((ingredient) => _buildIngredientItem(ingredient)),
        ],
      ),
    );
  }

  Widget _buildIngredientItem(AvailableIngredient ingredient) {
    final canAfford = playerCoins >= ingredient.cost;
    final isAvailable = ingredient.quantity > 0;
    final canBuy = canAfford && isAvailable;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: canBuy ? ingredient.color.displayColor : Colors.grey,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Chip visual
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: ingredient.color.displayColor,
              border: Border.all(color: ingredient.color.darkerColor, width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                '${ingredient.value}',
                style: TextStyle(
                  color: ingredient.color == IngredientColor.white
                      ? Colors.black
                      : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Value ${ingredient.value}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  '${ingredient.quantity} available',
                  style: TextStyle(
                    color: ingredient.quantity > 0
                        ? Colors.white70
                        : Colors.red,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          // Cost
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.amber, width: 1),
            ),
            child: Text(
              '${ingredient.cost}',
              style: const TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Buy button
          SizedBox(
            width: 60,
            height: 32,
            child: CalderumButton(
              text: 'Buy',
              onPressed: canBuy ? () => onBuyIngredient(ingredient) : null,
              style: CalderumButtonStyle.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
