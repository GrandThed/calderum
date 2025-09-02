import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/room_model.dart';
import '../services/room_service.dart';
import '../../account/services/auth_service.dart';
import '../../../shared/theme/app_theme.dart';

class RoomSettingsDialog extends ConsumerStatefulWidget {
  final String roomId;
  final RoomSettingsModel currentSettings;

  const RoomSettingsDialog({
    required this.roomId,
    required this.currentSettings,
    super.key,
  });

  @override
  ConsumerState<RoomSettingsDialog> createState() => _RoomSettingsDialogState();
}

class _RoomSettingsDialogState extends ConsumerState<RoomSettingsDialog> {
  late int _maxPlayers;
  late IngredientSet _ingredientSet;
  late bool _testTubeVariant;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _maxPlayers = widget.currentSettings.maxPlayers;
    _ingredientSet = widget.currentSettings.ingredientSet;
    _testTubeVariant = widget.currentSettings.testTubeVariant;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      backgroundColor: AppTheme.surfaceColor,
      title: Row(
        children: [
          Icon(Icons.settings, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Text(
            'Room Settings',
            style: AppTheme.headlineStyle.copyWith(fontSize: 24),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Max Players Setting
            Text(
              'Max Players',
              style: AppTheme.bodyStyle.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 2, label: Text('2')),
                ButtonSegment(value: 3, label: Text('3')),
                ButtonSegment(value: 4, label: Text('4')),
              ],
              selected: {_maxPlayers},
              onSelectionChanged: (Set<int> selection) {
                setState(() {
                  _maxPlayers = selection.first;
                });
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return theme.colorScheme.primary;
                  }
                  return theme.colorScheme.surface;
                }),
                foregroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Colors.white;
                  }
                  return theme.colorScheme.onSurface;
                }),
              ),
            ),
            const SizedBox(height: 24),

            // Ingredient Set Setting
            Text(
              'Ingredient Set',
              style: AppTheme.bodyStyle.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            SegmentedButton<IngredientSet>(
              segments: const [
                ButtonSegment(
                  value: IngredientSet.set1,
                  label: Text('Set 1'),
                  icon: Icon(Icons.looks_one),
                ),
                ButtonSegment(
                  value: IngredientSet.set2,
                  label: Text('Set 2'),
                  icon: Icon(Icons.looks_two),
                ),
                ButtonSegment(
                  value: IngredientSet.set3,
                  label: Text('Set 3'),
                  icon: Icon(Icons.looks_3),
                ),
                ButtonSegment(
                  value: IngredientSet.set4,
                  label: Text('Set 4'),
                  icon: Icon(Icons.looks_4),
                ),
              ],
              selected: {_ingredientSet},
              onSelectionChanged: (Set<IngredientSet> selection) {
                setState(() {
                  _ingredientSet = selection.first;
                });
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return theme.colorScheme.primary;
                  }
                  return theme.colorScheme.surface;
                }),
                foregroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Colors.white;
                  }
                  return theme.colorScheme.onSurface;
                }),
              ),
            ),
            const SizedBox(height: 24),

            // Test Tube Variant
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.science, color: theme.colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Test Tube Variant',
                          style: AppTheme.bodyStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Advanced gameplay with test tubes',
                          style: TextStyle(fontSize: 12, color: Colors.white60),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _testTubeVariant,
                    onChanged: (value) {
                      setState(() {
                        _testTubeVariant = value;
                      });
                    },
                    activeThumbColor: theme.colorScheme.primary,
                    activeTrackColor: theme.colorScheme.primary.withValues(
                      alpha: 0.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Info text
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.tertiary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: theme.colorScheme.tertiary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Settings can only be changed while waiting for players',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isUpdating ? null : () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
        FilledButton(
          onPressed: _isUpdating ? null : _updateSettings,
          child: _isUpdating
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text('Save Changes'),
        ),
      ],
    );
  }

  Future<void> _updateSettings() async {
    setState(() => _isUpdating = true);

    try {
      final authService = ref.read(authServiceProvider);
      final roomService = ref.read(roomServiceProvider);
      final currentUser = authService.currentUser;

      if (currentUser == null) {
        throw 'User not authenticated';
      }

      final newSettings = RoomSettingsModel(
        maxPlayers: _maxPlayers,
        minPlayers: 2, // Keep default
        ingredientSet: _ingredientSet,
        testTubeVariant: _testTubeVariant,
        allowMidGameJoins: false, // Keep default
        allowSpectators: false, // Keep default
      );

      await roomService.updateRoomSettings(
        widget.roomId,
        currentUser.uid,
        newSettings,
      );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Room settings updated!'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update settings: $error'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUpdating = false);
      }
    }
  }
}
