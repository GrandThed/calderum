import 'package:flutter/material.dart';
import '../../../shared/theme/app_theme.dart';
import '../models/game_state_model.dart';

class PlayerInfoPanel extends StatelessWidget {
  final GamePlayer player;
  final bool isCurrentPlayer;
  final bool compact;

  const PlayerInfoPanel({
    super.key,
    required this.player,
    required this.isCurrentPlayer,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(compact ? 4 : 8),
      padding: EdgeInsets.all(compact ? 8 : 12),
      decoration: BoxDecoration(
        color: isCurrentPlayer
            ? AppTheme.primaryColor.withOpacity(0.3)
            : AppTheme.surfaceColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrentPlayer
              ? AppTheme.primaryColor
              : Colors.white.withOpacity(0.2),
          width: isCurrentPlayer ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Player header
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: compact ? 16 : 20,
                backgroundColor: AppTheme.primaryColor,
                backgroundImage: player.photoUrl != null
                    ? NetworkImage(player.photoUrl!)
                    : null,
                child: player.photoUrl == null
                    ? Icon(
                        Icons.person,
                        color: Colors.white,
                        size: compact ? 16 : 20,
                      )
                    : null,
              ),

              const SizedBox(width: 8),

              // Player name and status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            player.displayName,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: compact ? 12 : 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        if (isCurrentPlayer) ...[
                          const SizedBox(width: 4),
                          Icon(
                            Icons.person,
                            color: AppTheme.primaryColor,
                            size: compact ? 14 : 16,
                          ),
                        ],
                      ],
                    ),

                    Row(
                      children: [
                        // Online status
                        Icon(
                          player.isOnline
                              ? Icons.circle
                              : Icons.circle_outlined,
                          color: player.isOnline ? Colors.green : Colors.grey,
                          size: compact ? 8 : 10,
                        ),

                        const SizedBox(width: 4),

                        Text(
                          player.isOnline ? 'Online' : 'Offline',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: compact ? 10 : 12,
                          ),
                        ),

                        const Spacer(),

                        // Phase completion status
                        if (player.hasCompletedPhase)
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: compact ? 14 : 16,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (!compact) ...[
            const SizedBox(height: 8),

            // Player stats
            _buildPlayerStats(),
          ],
        ],
      ),
    );
  }

  Widget _buildPlayerStats() {
    return Row(
      children: [
        // Victory Points
        _buildStatChip(
          icon: Icons.star,
          label: 'VP',
          value: '${player.potState.victoryPoints}',
          color: Colors.yellow,
        ),

        const SizedBox(width: 8),

        // Rubies
        _buildStatChip(
          icon: Icons.diamond,
          label: 'R',
          value: '${player.potState.rubies}',
          color: Colors.red,
        ),

        const SizedBox(width: 8),

        // Coins
        _buildStatChip(
          icon: Icons.monetization_on,
          label: 'C',
          value: '${player.potState.coins}',
          color: Colors.amber,
        ),

        const SizedBox(width: 8),

        // Scoring position
        _buildStatChip(
          icon: Icons.place,
          label: 'Pos',
          value: '${player.potState.scoringPosition}',
          color: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 2),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
