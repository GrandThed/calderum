import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_state_model.dart';
import '../models/ingredient_model.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/calderum_button.dart';

class IngredientBagRowWidget extends ConsumerWidget {
  final IngredientBag ingredientBag;
  final VoidCallback? onDrawChip;
  final bool canDraw;

  const IngredientBagRowWidget({
    super.key,
    required this.ingredientBag,
    this.onDrawChip,
    this.canDraw = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
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
                Icons.backpack,
                color: AppTheme.secondaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Ingredient Bag',
                style: AppTheme.bodyStyle.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              if (canDraw)
                SizedBox(
                  width: 100,
                  height: 32,
                  child: CalderumButton(
                    text: 'Draw',
                    onPressed: onDrawChip,
                    style: CalderumButtonStyle.primary,
                    height: 32,
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Drawn chips this turn
          if (ingredientBag.drawnThisTurn.isNotEmpty) ...[
            Text(
              'Drawn This Turn:',
              style: AppTheme.bodyStyle.copyWith(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 32,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: ingredientBag.drawnThisTurn.length,
                itemBuilder: (context, index) {
                  final chip = ingredientBag.drawnThisTurn[index];
                  return Container(
                    width: 28,
                    height: 28,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                      color: _getIngredientColor(chip.color),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: Center(
                      child: Text(
                        '${chip.value}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
          
          // Remaining chips in bag
          Text(
            'Remaining in Bag:',
            style: AppTheme.bodyStyle.copyWith(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 40,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _buildRemainingChips(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRemainingChips() {
    final chipCounts = <IngredientColor, int>{};
    
    // Count remaining chips by color
    for (final chip in ingredientBag.chips) {
      chipCounts[chip.color] = (chipCounts[chip.color] ?? 0) + 1;
    }
    
    final List<Widget> widgets = [];
    
    for (final entry in chipCounts.entries) {
      if (entry.value > 0) {
        widgets.add(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            margin: const EdgeInsets.only(right: 6),
            decoration: BoxDecoration(
              color: _getIngredientColor(entry.key).withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _getIngredientColor(entry.key),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: _getIngredientColor(entry.key),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '×${entry.value}',
                  style: TextStyle(
                    color: _getIngredientColor(entry.key),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
    
    return widgets;
  }

  Color _getIngredientColor(IngredientColor color) {
    switch (color) {
      case IngredientColor.white:
        return Colors.white;
      case IngredientColor.orange:
        return Colors.orange;
      case IngredientColor.yellow:
        return Colors.yellow;
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
}