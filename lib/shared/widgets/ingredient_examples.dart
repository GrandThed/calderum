import 'package:flutter/material.dart';
import '../constants/ingredient_assets.dart';
import 'ingredient_icon.dart';

/// Example usage of ingredient icons and widgets
class IngredientExamplesView extends StatefulWidget {
  const IngredientExamplesView({super.key});

  @override
  State<IngredientExamplesView> createState() => _IngredientExamplesViewState();
}

class _IngredientExamplesViewState extends State<IngredientExamplesView> {
  Set<IngredientType> selectedIngredients = {};

  final Map<IngredientType, int> ingredientCounts = {
    IngredientType.white: 5,
    IngredientType.orange: 3,
    IngredientType.yellow: 2,
    IngredientType.green: 4,
    IngredientType.blue: 1,
    IngredientType.red: 2,
    IngredientType.purple: 1,
    IngredientType.black: 0,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ingredient Icons Examples')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basic ingredient icons
            Text(
              'Basic Ingredient Icons',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: IngredientType.values.map((ingredient) {
                return Column(
                  children: [
                    IngredientIcon(ingredient: ingredient, size: 48),
                    const SizedBox(height: 4),
                    Text(
                      ingredient.displayName,
                      style: Theme.of(context).textTheme.labelSmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // Ingredient icons with backgrounds
            Text(
              'Icons with Backgrounds',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: IngredientType.values.take(4).map((ingredient) {
                return IngredientIcon(
                  ingredient: ingredient,
                  size: 64,
                  showBackground: true,
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // Interactive ingredient chips
            Text(
              'Interactive Ingredient Chips',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: IngredientType.values.map((ingredient) {
                return IngredientChip(
                  ingredient: ingredient,
                  size: 64,
                  isSelected: selectedIngredients.contains(ingredient),
                  count: ingredientCounts[ingredient],
                  onTap: () {
                    setState(() {
                      if (selectedIngredients.contains(ingredient)) {
                        selectedIngredients.remove(ingredient);
                      } else {
                        selectedIngredients.add(ingredient);
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // Ingredient grid
            Text(
              'Ingredient Selection Grid',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            IngredientGrid(
              ingredients: IngredientType.values,
              selectedIngredients: selectedIngredients,
              ingredientCounts: ingredientCounts,
              onIngredientToggle: (ingredient) {
                setState(() {
                  if (selectedIngredients.contains(ingredient)) {
                    selectedIngredients.remove(ingredient);
                  } else {
                    selectedIngredients.add(ingredient);
                  }
                });
              },
            ),

            const SizedBox(height: 32),

            // Selected ingredients summary
            if (selectedIngredients.isNotEmpty) ...[
              Text(
                'Selected Ingredients',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: selectedIngredients.map((ingredient) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            IngredientIcon(ingredient: ingredient, size: 24),
                            const SizedBox(width: 12),
                            Expanded(child: Text(ingredient.displayName)),
                            if (ingredientCounts[ingredient] != null)
                              Text('×${ingredientCounts[ingredient]}'),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
