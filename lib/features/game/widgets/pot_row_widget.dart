import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_state_model.dart';
import '../models/ingredient_model.dart';
import '../../../shared/theme/app_theme.dart';

class PotRowWidget extends ConsumerWidget {
  final GamePlayer player;
  final bool isCurrentPlayer;
  final Function(IngredientChip chip, int position)? onChipPlaced;
  final List<IngredientChip> drawnChips;
  final bool canPlaceChips;

  const PotRowWidget({
    super.key,
    required this.player,
    required this.isCurrentPlayer,
    this.onChipPlaced,
    this.drawnChips = const [],
    this.canPlaceChips = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: isCurrentPlayer 
            ? AppTheme.primaryColor.withValues(alpha: 0.2)
            : AppTheme.surfaceColor.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrentPlayer 
              ? AppTheme.primaryColor
              : Colors.white.withValues(alpha: 0.1),
          width: isCurrentPlayer ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Player info header
          _buildPlayerHeader(),
          
          const SizedBox(height: 12),
          
          // Pot scoring track as horizontal row
          _buildPotTrack(),
          
          const SizedBox(height: 12),
          
          // Player status and coins
          _buildPlayerStatus(),
        ],
      ),
    );
  }

  Widget _buildPlayerHeader() {
    return Row(
      children: [
        // Player avatar
        CircleAvatar(
          radius: 16,
          backgroundColor: AppTheme.getPlayerColor(player.userId),
          child: Text(
            player.displayName.isNotEmpty ? player.displayName[0].toUpperCase() : 'P',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        
        const SizedBox(width: 8),
        
        // Player name
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                player.displayName,
                style: AppTheme.bodyStyle.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              if (isCurrentPlayer)
                Text(
                  'YOU',
                  style: AppTheme.bodyStyle.copyWith(
                    color: AppTheme.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
        
        // Score
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.secondaryColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${player.potState.scoringPosition}',
            style: AppTheme.headingStyle.copyWith(
              color: AppTheme.secondaryColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPotTrack() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Track label
        Text(
          'Scoring Track',
          style: AppTheme.bodyStyle.copyWith(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        
        const SizedBox(height: 6),
        
        // Horizontal scoring track with chips
        Container(
          height: 60,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _buildScoringTrackPositions(),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildScoringTrackPositions() {
    final List<Widget> positions = [];
    final placedChips = player.potState.placedChips;
    
    // Create positions 0-50+ (showing up to current score + 10)
    final maxPosition = (player.potState.scoringPosition + 10).clamp(15, 50);
    
    for (int i = 0; i <= maxPosition; i++) {
      final chipsAtPosition = placedChips
          .where((chip) => _getChipScoringValue(chip) == i)
          .toList();
      
      positions.add(_buildTrackPosition(i, chipsAtPosition));
    }
    
    return positions;
  }

  Widget _buildTrackPosition(int position, List<IngredientChip> chipsHere) {
    final isCurrentPosition = position == player.potState.scoringPosition;
    final hasChips = chipsHere.isNotEmpty;
    
    return GestureDetector(
      onTap: canPlaceChips && drawnChips.isNotEmpty
          ? () => _handleChipPlacement(position)
          : null,
      child: Container(
        width: 48,
        height: 48,
        margin: const EdgeInsets.only(right: 4),
        decoration: BoxDecoration(
          color: isCurrentPosition
              ? AppTheme.primaryColor.withValues(alpha: 0.3)
              : hasChips
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.transparent,
          border: Border.all(
            color: isCurrentPosition
                ? AppTheme.primaryColor
                : Colors.white.withValues(alpha: 0.3),
            width: isCurrentPosition ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Show chip if present
            if (hasChips)
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: _getIngredientColor(chipsHere.first.color),
                  shape: BoxShape.circle,
                ),
              ),
            
            // Position number
            Text(
              '$position',
              style: TextStyle(
                color: isCurrentPosition ? Colors.white : Colors.white60,
                fontSize: 10,
                fontWeight: isCurrentPosition ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerStatus() {
    return Row(
      children: [
        // Coins
        Row(
          children: [
            Icon(
              Icons.monetization_on,
              color: AppTheme.secondaryColor,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              '${player.potState.coins}',
              style: AppTheme.bodyStyle.copyWith(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        
        const Spacer(),
        
        // Ready status
        Row(
          children: [
            Icon(
              player.hasCompletedPhase ? Icons.check_circle : Icons.radio_button_unchecked,
              color: player.hasCompletedPhase ? Colors.green : Colors.orange,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              player.hasCompletedPhase ? 'Ready' : 'Playing',
              style: AppTheme.bodyStyle.copyWith(
                color: player.hasCompletedPhase ? Colors.green : Colors.orange,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        
        // Flask availability
        if (player.potState.flaskAvailable) ...[
          const SizedBox(width: 8),
          Icon(
            Icons.local_drink,
            color: AppTheme.primaryColor,
            size: 16,
          ),
        ],
        
        // Explosion indicator
        if (player.potState.hasExploded) ...[
          const SizedBox(width: 8),
          Icon(
            Icons.warning,
            color: Colors.red,
            size: 16,
          ),
        ],
      ],
    );
  }

  void _handleChipPlacement(int position) {
    if (drawnChips.isNotEmpty && onChipPlaced != null) {
      // Place the first drawn chip at this position
      onChipPlaced!(drawnChips.first, position);
    }
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

  int _getChipScoringValue(IngredientChip chip) {
    // Simplified scoring - in real game this would be more complex
    return chip.value;
  }
}