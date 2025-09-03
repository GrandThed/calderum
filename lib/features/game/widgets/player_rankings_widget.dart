import 'package:flutter/material.dart';
import '../models/game_state_model.dart';
import '../../../shared/theme/app_theme.dart';

/// Widget that displays player rankings in a compact leaderboard format
class PlayerRankingsWidget extends StatelessWidget {
  final GameState gameState;
  final String currentPlayerId;
  final bool showCompact;

  const PlayerRankingsWidget({
    super.key,
    required this.gameState,
    required this.currentPlayerId,
    this.showCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final rankedPlayers = _getRankedPlayers();

    if (showCompact) {
      return _buildCompactRankings(rankedPlayers);
    } else {
      return _buildFullRankings(rankedPlayers);
    }
  }

  Widget _buildFullRankings(List<GamePlayer> rankedPlayers) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(11),
                topRight: Radius.circular(11),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.emoji_events,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Player Rankings',
                  style: AppTheme.titleStyle.copyWith(
                    fontFamily: 'Caudex',
                    fontSize: 16,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),

          // Rankings list
          ...rankedPlayers.asMap().entries.map((entry) {
            final index = entry.key;
            final player = entry.value;
            final rank = index + 1;
            final isCurrentPlayer = player.userId == currentPlayerId;

            return _buildPlayerRankingRow(
              player,
              rank,
              isCurrentPlayer,
              index < rankedPlayers.length - 1,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCompactRankings(List<GamePlayer> rankedPlayers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: rankedPlayers.take(3).toList().asMap().entries.map((entry) {
        final index = entry.key;
        final player = entry.value;
        final rank = index + 1;
        final isCurrentPlayer = player.userId == currentPlayerId;

        return _buildCompactPlayerCard(player, rank, isCurrentPlayer);
      }).toList(),
    );
  }

  Widget _buildPlayerRankingRow(
    GamePlayer player,
    int rank,
    bool isCurrentPlayer,
    bool showDivider,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isCurrentPlayer
            ? AppTheme.primaryColor.withValues(alpha: 0.1)
            : null,
        border: showDivider
            ? Border(
                bottom: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              )
            : null,
      ),
      child: Row(
        children: [
          // Rank medal/badge
          _buildRankBadge(rank),

          const SizedBox(width: 12),

          // Player avatar (simplified)
          CircleAvatar(
            radius: 16,
            backgroundColor: _getPlayerColor(player.userId),
            child: Text(
              player.displayName[0].toUpperCase(),
              style: AppTheme.bodyStyle.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Player info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      player.displayName,
                      style: AppTheme.bodyStyle.copyWith(
                        fontWeight: isCurrentPlayer
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isCurrentPlayer
                            ? AppTheme.primaryColor
                            : Colors.white,
                      ),
                    ),
                    if (isCurrentPlayer) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'YOU',
                          style: AppTheme.bodyStyle.copyWith(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                // Player stats
                Row(
                  children: [
                    Icon(Icons.location_on, size: 12, color: Colors.blue),
                    const SizedBox(width: 2),
                    Text(
                      'Pos ${player.potState.scoringPosition}',
                      style: AppTheme.bodyStyle.copyWith(
                        fontSize: 10,
                        color: Colors.white70,
                      ),
                    ),
                    if (player.potState.hasExploded) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.warning, size: 12, color: Colors.red),
                      Text(
                        'Exploded',
                        style: AppTheme.bodyStyle.copyWith(
                          fontSize: 10,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Score
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${player.potState.victoryPoints}',
                style: AppTheme.titleStyle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _getRankColor(rank),
                ),
              ),
              Text(
                'VP',
                style: AppTheme.bodyStyle.copyWith(
                  fontSize: 10,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactPlayerCard(
    GamePlayer player,
    int rank,
    bool isCurrentPlayer,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCurrentPlayer
            ? AppTheme.primaryColor.withValues(alpha: 0.1)
            : AppTheme.surfaceColor.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrentPlayer
              ? AppTheme.primaryColor.withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.2),
          width: isCurrentPlayer ? 2 : 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Rank badge
          _buildRankBadge(rank, size: 24),

          const SizedBox(height: 8),

          // Player avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: _getPlayerColor(player.userId),
            child: Text(
              player.displayName[0].toUpperCase(),
              style: AppTheme.bodyStyle.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Player name
          Text(
            player.displayName.length > 10
                ? '${player.displayName.substring(0, 10)}...'
                : player.displayName,
            style: AppTheme.bodyStyle.copyWith(
              fontSize: 12,
              fontWeight: isCurrentPlayer ? FontWeight.bold : FontWeight.normal,
              color: isCurrentPlayer ? AppTheme.primaryColor : Colors.white,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 4),

          // Score
          Text(
            '${player.potState.victoryPoints} VP',
            style: AppTheme.titleStyle.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: _getRankColor(rank),
            ),
          ),

          // Status indicators
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (player.potState.hasExploded)
                const Icon(Icons.warning, size: 12, color: Colors.red),
              if (player.potState.rubies > 0) ...[
                if (player.potState.hasExploded) const SizedBox(width: 4),
                Icon(Icons.diamond, size: 10, color: Colors.red.shade300),
                Text(
                  '${player.potState.rubies}',
                  style: AppTheme.bodyStyle.copyWith(
                    fontSize: 8,
                    color: Colors.white70,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRankBadge(int rank, {double size = 28}) {
    final color = _getRankColor(rank);
    final icon = _getRankIcon(rank);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: rank <= 3
            ? Icon(icon, color: color, size: size * 0.6)
            : Text(
                '$rank',
                style: AppTheme.titleStyle.copyWith(
                  color: color,
                  fontSize: size * 0.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  List<GamePlayer> _getRankedPlayers() {
    final players = List<GamePlayer>.from(gameState.players);
    players.sort((a, b) {
      // Primary sort by victory points (descending)
      final vpComparison = b.potState.victoryPoints.compareTo(
        a.potState.victoryPoints,
      );
      if (vpComparison != 0) return vpComparison;

      // Secondary sort by position (descending)
      final posComparison = b.potState.scoringPosition.compareTo(
        a.potState.scoringPosition,
      );
      if (posComparison != 0) return posComparison;

      // Tertiary sort by name (ascending) for consistency
      return a.displayName.compareTo(b.displayName);
    });
    return players;
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return Colors.white70;
    }
  }

  IconData _getRankIcon(int rank) {
    switch (rank) {
      case 1:
        return Icons.emoji_events;
      case 2:
        return Icons.military_tech;
      case 3:
        return Icons.workspace_premium;
      default:
        return Icons.person;
    }
  }

  Color _getPlayerColor(String userId) {
    // Generate consistent color based on user ID
    final hash = userId.hashCode;
    final colors = [
      Colors.red.shade400,
      Colors.blue.shade400,
      Colors.green.shade400,
      Colors.purple.shade400,
      Colors.orange.shade400,
      Colors.teal.shade400,
      Colors.pink.shade400,
      Colors.indigo.shade400,
    ];
    return colors[hash.abs() % colors.length];
  }
}
