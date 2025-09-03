import 'package:flutter/material.dart';
import '../models/game_state_model.dart';
import '../models/ingredient_model.dart';
import '../../../shared/theme/app_theme.dart';
import 'opponent_board_widget.dart';
import 'animated_score_counter.dart';

/// Detailed dialog showing opponent's full game state
class OpponentDetailDialog extends StatelessWidget {
  final GamePlayer opponent;
  final GameState gameState;

  const OpponentDetailDialog({
    super.key,
    required this.opponent,
    required this.gameState,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            // Header
            _buildHeader(context),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Detailed opponent board
                    OpponentBoardWidget(
                      opponent: opponent,
                      showDetailedView: true,
                    ),

                    const SizedBox(height: 24),

                    // Score history and statistics
                    _buildScoreSection(),

                    const SizedBox(height: 24),

                    // Ingredient bag status
                    _buildIngredientBagSection(),

                    const SizedBox(height: 24),

                    // Action history
                    _buildActionHistorySection(),
                  ],
                ),
              ),
            ),

            // Close button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Close',
                    style: AppTheme.titleStyle.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      child: Row(
        children: [
          // Player avatar
          CircleAvatar(
            radius: 24,
            backgroundColor: _getPlayerColor(),
            child: opponent.photoUrl != null
                ? ClipOval(
                    child: Image.network(
                      opponent.photoUrl!,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                  )
                : Text(
                    opponent.displayName.characters.first.toUpperCase(),
                    style: AppTheme.titleStyle.copyWith(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),

          const SizedBox(width: 16),

          // Player info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  opponent.displayName,
                  style: AppTheme.titleStyle.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    // Online status
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: opponent.isOnline ? Colors.green : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      opponent.isOnline ? 'Online' : 'Offline',
                      style: AppTheme.bodyStyle.copyWith(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Last action time
                    if (opponent.lastAction != null) ...[
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatLastActionTime(opponent.lastAction!),
                        style: AppTheme.bodyStyle.copyWith(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Close button
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.close,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Scores & Resources',
          style: AppTheme.titleStyle.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 12),
        
        PlayerScoreRow(
          victoryPoints: opponent.potState.victoryPoints,
          coins: opponent.potState.coins,
          rubies: opponent.potState.rubies,
          showAnimations: false,
        ),
        
        const SizedBox(height: 16),
        
        // Additional metrics
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Scoring Position:',
                    style: AppTheme.bodyStyle.copyWith(color: Colors.white70),
                  ),
                  Text(
                    '${opponent.potState.scoringPosition}/33',
                    style: AppTheme.bodyStyle.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'White Chip Total:',
                    style: AppTheme.bodyStyle.copyWith(color: Colors.white70),
                  ),
                  Text(
                    '${opponent.potState.whiteChipTotal}/7',
                    style: AppTheme.bodyStyle.copyWith(
                      color: opponent.potState.whiteChipTotal > 6 
                          ? Colors.red 
                          : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (opponent.potState.ratPosition != null) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rat Position:',
                      style: AppTheme.bodyStyle.copyWith(color: Colors.white70),
                    ),
                    Text(
                      '${opponent.potState.ratPosition}',
                      style: AppTheme.bodyStyle.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientBagSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ingredient Bag',
          style: AppTheme.titleStyle.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 12),
        
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              // Bag summary
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Chips:',
                    style: AppTheme.bodyStyle.copyWith(color: Colors.white70),
                  ),
                  Text(
                    '${opponent.ingredientBag.chips.length}',
                    style: AppTheme.bodyStyle.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Chips by color (without showing actual chips for fairness)
              Text(
                'Chip Distribution:',
                style: AppTheme.bodyStyle.copyWith(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              
              _buildChipDistribution(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChipDistribution() {
    final chipsByColor = <IngredientColor, int>{};
    
    for (final chip in opponent.ingredientBag.chips) {
      chipsByColor[chip.color] = (chipsByColor[chip.color] ?? 0) + 1;
    }

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: chipsByColor.entries.map((entry) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: entry.key.displayColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: entry.key.displayColor.withValues(alpha: 0.5),
            ),
          ),
          child: Text(
            '${entry.key.displayName}: ${entry.value}',
            style: AppTheme.bodyStyle.copyWith(
              fontSize: 10,
              color: Colors.white,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status',
          style: AppTheme.titleStyle.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 12),
        
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              // Phase completion status
              _buildStatusRow(
                'Phase Completion',
                opponent.hasCompletedPhase ? 'Ready' : 'In Progress',
                opponent.hasCompletedPhase ? Colors.green : Colors.orange,
                opponent.hasCompletedPhase 
                    ? Icons.check_circle 
                    : Icons.hourglass_empty,
              ),
              
              const SizedBox(height: 8),
              
              // Explosion status
              _buildStatusRow(
                'Pot Status',
                opponent.potState.hasExploded ? 'Exploded' : 'Safe',
                opponent.potState.hasExploded ? Colors.red : Colors.green,
                opponent.potState.hasExploded 
                    ? Icons.local_fire_department 
                    : Icons.check_circle,
              ),
              
              const SizedBox(height: 8),
              
              // Flask status
              _buildStatusRow(
                'Flask',
                opponent.potState.flaskAvailable ? 'Available' : 'Used',
                opponent.potState.flaskAvailable ? Colors.green : Colors.grey,
                opponent.potState.flaskAvailable 
                    ? Icons.science 
                    : Icons.not_interested,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusRow(
    String label,
    String status,
    Color color,
    IconData icon,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: AppTheme.bodyStyle.copyWith(color: Colors.white70),
        ),
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              status,
              style: AppTheme.bodyStyle.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getPlayerColor() {
    // Generate consistent color based on player ID
    final hash = opponent.userId.hashCode;
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.teal,
    ];
    
    return colors[hash.abs() % colors.length];
  }

  String _formatLastActionTime(DateTime lastAction) {
    final now = DateTime.now();
    final difference = now.difference(lastAction);
    
    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else {
      return '${difference.inHours}h ago';
    }
  }
}