import 'package:flutter/material.dart';
import '../models/room_model.dart';

class RoomSettingsCard extends StatelessWidget {
  final RoomSettingsModel settings;

  const RoomSettingsCard({required this.settings, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.settings, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Game Settings',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontFamily: 'Caudex',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Game settings - using flexible layout instead of fixed grid
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width:
                      (MediaQuery.of(context).size.width - 80) /
                      2, // Account for padding and spacing
                  child: _buildSettingTile(
                    icon: Icons.people,
                    label: 'Players',
                    value: '${settings.minPlayers}-${settings.maxPlayers}',
                    theme: theme,
                  ),
                ),
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 80) / 2,
                  child: _buildSettingTile(
                    icon: _getIngredientSetIcon(settings.ingredientSet),
                    label: 'Ingredient Set',
                    value: _getIngredientSetName(settings.ingredientSet),
                    theme: theme,
                  ),
                ),
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 80) / 2,
                  child: _buildSettingTile(
                    icon: Icons.science,
                    label: 'Test Tube',
                    value: settings.testTubeVariant ? 'On' : 'Off',
                    theme: theme,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIngredientSetIcon(IngredientSet set) {
    switch (set) {
      case IngredientSet.set1:
        return Icons.looks_one;
      case IngredientSet.set2:
        return Icons.looks_two;
      case IngredientSet.set3:
        return Icons.looks_3;
      case IngredientSet.set4:
        return Icons.looks_4;
    }
  }

  String _getIngredientSetName(IngredientSet set) {
    switch (set) {
      case IngredientSet.set1:
        return 'Set 1';
      case IngredientSet.set2:
        return 'Set 2';
      case IngredientSet.set3:
        return 'Set 3';
      case IngredientSet.set4:
        return 'Set 4';
    }
  }
}
