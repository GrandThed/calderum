import 'package:flutter/material.dart';
import '../models/ingredient_model.dart';
import '../../../shared/theme/app_theme.dart';

/// Widget to display an ingredient chip
class IngredientChipWidget extends StatelessWidget {
  final IngredientChip chip;
  final double size;
  final bool showValue;
  final VoidCallback? onTap;

  const IngredientChipWidget({
    super.key,
    required this.chip,
    this.size = 24,
    this.showValue = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: chip.color.displayColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: chip.color.displayColor.withValues(alpha: 0.8),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: chip.color.displayColor.withValues(alpha: 0.3),
              blurRadius: 2,
              spreadRadius: 1,
            ),
          ],
        ),
        child: showValue
            ? Center(
                child: Text(
                  '${chip.value}',
                  style: AppTheme.bodyStyle.copyWith(
                    color: Colors.white,
                    fontSize: size * 0.4,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 1,
                      ),
                    ],
                  ),
                ),
              )
            : null,
      ),
    );
  }
}