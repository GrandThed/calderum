import 'package:flutter/material.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/calderum_button.dart';
import '../models/ingredient_model.dart';

class IngredientBagWidget extends StatelessWidget {
  final IngredientBag ingredientBag;
  final VoidCallback? onDrawChip;
  final bool canDraw;

  const IngredientBagWidget({
    super.key,
    required this.ingredientBag,
    this.onDrawChip,
    this.canDraw = false,
  });

  @override
  Widget build(BuildContext context) {
    final availableChips = ingredientBag.availableChips;
    final drawnChips = ingredientBag.drawnThisTurn;

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.shopping_bag,
                color: AppTheme.secondaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Ingredient Bag',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Text(
                '${availableChips.length} chips',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Bag visualization
          Expanded(child: _buildBagContents(availableChips)),

          const SizedBox(height: 12),

          // Drawn chips this turn
          if (drawnChips.isNotEmpty) ...[
            const Divider(color: Colors.white24),
            const SizedBox(height: 8),
            Text(
              'Drawn This Turn:',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildDrawnChips(drawnChips),
            const SizedBox(height: 12),
          ],

          // Draw button
          if (canDraw && onDrawChip != null)
            SizedBox(
              width: double.infinity,
              child: CalderumButton(
                text: availableChips.isEmpty ? 'Bag Empty' : 'Draw Chip',
                onPressed: availableChips.isEmpty ? null : onDrawChip,
                icon: Icons.shuffle,
                style: CalderumButtonStyle.primary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBagContents(List<IngredientChip> chips) {
    if (chips.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, size: 48, color: Colors.white30),
            SizedBox(height: 8),
            Text(
              'Bag is empty',
              style: TextStyle(color: Colors.white30, fontSize: 14),
            ),
          ],
        ),
      );
    }

    // Group chips by color and value
    final Map<String, List<IngredientChip>> groupedChips = {};
    for (final chip in chips) {
      final key = '${chip.color.name}_${chip.value}';
      groupedChips[key] = groupedChips[key] ?? [];
      groupedChips[key]!.add(chip);
    }

    return SingleChildScrollView(
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: groupedChips.entries.map((entry) {
          final chips = entry.value;
          final firstChip = chips.first;
          final count = chips.length;

          return _buildChipGroup(firstChip, count);
        }).toList(),
      ),
    );
  }

  Widget _buildChipGroup(IngredientChip chip, int count) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: chip.color.displayColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: chip.color.displayColor.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Chip visual
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: chip.color.displayColor,
              border: Border.all(color: chip.color.darkerColor, width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                '${chip.value}',
                style: TextStyle(
                  color: chip.color == IngredientColor.white
                      ? Colors.black
                      : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),

          const SizedBox(height: 4),

          // Count and color name
          Text(
            'x$count',
            style: TextStyle(
              color: chip.color.displayColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),

          Text(
            chip.color.name.toUpperCase(),
            style: TextStyle(color: Colors.white70, fontSize: 8),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawnChips(List<IngredientChip> chips) {
    return Wrap(
      spacing: 8,
      children: chips.map((chip) => _buildDrawnChip(chip)).toList(),
    );
  }

  Widget _buildDrawnChip(IngredientChip chip) {
    final isWhite = chip.color == IngredientColor.white;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isWhite
            ? Colors.red.withValues(alpha: 0.2)
            : Colors.green.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isWhite ? Colors.red : Colors.green,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Chip visual
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: chip.color.displayColor,
              border: Border.all(color: chip.color.darkerColor, width: 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '${chip.value}',
                style: TextStyle(
                  color: chip.color == IngredientColor.white
                      ? Colors.black
                      : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ),

          const SizedBox(width: 4),

          Text(
            chip.color.name.toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
