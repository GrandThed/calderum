import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_state_model.dart';
import '../models/ingredient_model.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/calderum_button.dart';

class GameActionsRowWidget extends ConsumerWidget {
  final GamePlayer player;
  final GameState gameState;
  final VoidCallback? onStopDrawing;
  final VoidCallback? onUseFlask;
  final VoidCallback? onCompletePhase;

  const GameActionsRowWidget({
    super.key,
    required this.player,
    required this.gameState,
    this.onStopDrawing,
    this.onUseFlask,
    this.onCompletePhase,
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
                Icons.touch_app,
                color: AppTheme.secondaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Actions',
                style: AppTheme.bodyStyle.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Phase-specific actions
          if (gameState.currentPhase == GamePhase.potions)
            _buildPotionPhaseActions()
          else
            _buildEvaluationPhaseActions(),
        ],
      ),
    );
  }

  Widget _buildPotionPhaseActions() {
    final hasDrawnChips = player.ingredientBag.drawnThisTurn.isNotEmpty;
    final hasWhiteChips = player.ingredientBag.drawnThisTurn.any(
      (chip) => chip.color == IngredientColor.white,
    );
    final canUseFlask = player.potState.flaskAvailable && hasWhiteChips;
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Stop Drawing button
          if (hasDrawnChips || player.potState.hasExploded)
            CalderumButton(
              text: 'Stop Drawing',
              onPressed: onStopDrawing,
              icon: Icons.stop,
              style: CalderumButtonStyle.primary,
              width: 140,
              height: 40,
            ),
          
          if (hasDrawnChips || player.potState.hasExploded)
            const SizedBox(width: 12),
          
          // Use Flask button
          if (canUseFlask)
            CalderumButton(
              text: 'Use Flask',
              onPressed: onUseFlask,
              icon: Icons.local_drink,
              style: CalderumButtonStyle.secondary,
              width: 120,
              height: 40,
            ),
          
          // Status indicator
          if (!hasDrawnChips && !player.potState.hasExploded) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.touch_app, color: Colors.blue, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'Draw chips from your bag',
                    style: AppTheme.bodyStyle.copyWith(
                      color: Colors.blue,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEvaluationPhaseActions() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Phase completion button
          if (!player.hasCompletedPhase)
            CalderumButton(
              text: 'Ready',
              onPressed: onCompletePhase,
              icon: Icons.check,
              style: CalderumButtonStyle.primary,
              width: 100,
              height: 40,
            ),
          
          // Status indicator
          if (player.hasCompletedPhase) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'Waiting for other players...',
                    style: AppTheme.bodyStyle.copyWith(
                      color: Colors.green,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.schedule, color: Colors.orange, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'Complete your ${gameState.currentPhase.displayName} actions',
                    style: AppTheme.bodyStyle.copyWith(
                      color: Colors.orange,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}