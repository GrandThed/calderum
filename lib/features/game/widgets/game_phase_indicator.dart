import 'package:flutter/material.dart';
import '../../../shared/theme/app_theme.dart';
import '../models/game_state_model.dart';

class GamePhaseIndicator extends StatelessWidget {
  final GamePhase currentPhase;
  final int currentTurn;

  const GamePhaseIndicator({
    super.key,
    required this.currentPhase,
    required this.currentTurn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryColor, width: 1),
      ),
      child: Row(
        children: [
          // Turn indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Turn $currentTurn/9',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Phase indicator
          Icon(
            _getPhaseIcon(currentPhase),
            color: AppTheme.secondaryColor,
            size: 24,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              currentPhase.displayName,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          // Phase progress
          _buildPhaseProgress(),
        ],
      ),
    );
  }

  IconData _getPhaseIcon(GamePhase phase) {
    switch (phase) {
      case GamePhase.fortuneTeller:
        return Icons.auto_awesome;
      case GamePhase.rats:
        return Icons.pets;
      case GamePhase.potions:
        return Icons.science;
      case GamePhase.evaluationA:
        return Icons.casino;
      case GamePhase.evaluationB:
        return Icons.settings;
      case GamePhase.evaluationC:
        return Icons.diamond;
      case GamePhase.evaluationD:
        return Icons.star;
      case GamePhase.evaluationE:
        return Icons.shopping_cart;
      case GamePhase.evaluationF:
        return Icons.check_circle;
      case GamePhase.gameOver:
        return Icons.emoji_events;
    }
  }

  Widget _buildPhaseProgress() {
    // Show current phase position in the turn sequence
    final phases = [
      GamePhase.fortuneTeller,
      GamePhase.rats,
      GamePhase.potions,
      GamePhase.evaluationA,
      GamePhase.evaluationB,
      GamePhase.evaluationC,
      GamePhase.evaluationD,
      GamePhase.evaluationE,
      GamePhase.evaluationF,
    ];

    final currentIndex = phases.indexOf(currentPhase);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: phases.asMap().entries.map((entry) {
        final index = entry.key;
        final isActive = index == currentIndex;
        final isCompleted = index < currentIndex;

        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: isActive
                ? AppTheme.secondaryColor
                : isCompleted
                ? AppTheme.primaryColor
                : Colors.white30,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }).toList(),
    );
  }
}
