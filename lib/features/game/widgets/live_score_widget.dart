import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_state_model.dart';
import '../../../shared/theme/app_theme.dart';
import 'score_breakdown_dialog.dart';

/// Widget that displays live scores for all players with animations
class LiveScoreWidget extends ConsumerStatefulWidget {
  final GameState gameState;
  final String currentPlayerId;

  const LiveScoreWidget({
    super.key,
    required this.gameState,
    required this.currentPlayerId,
  });

  @override
  ConsumerState<LiveScoreWidget> createState() => _LiveScoreWidgetState();
}

class _LiveScoreWidgetState extends ConsumerState<LiveScoreWidget>
    with TickerProviderStateMixin {
  late AnimationController _scoreAnimationController;
  late AnimationController _rankingAnimationController;
  late Animation<double> _scoreAnimation;
  late Animation<double> _rankingAnimation;

  Map<String, int> _previousScores = {};
  Map<String, int> _currentScores = {};

  @override
  void initState() {
    super.initState();

    _scoreAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _rankingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scoreAnimation = CurvedAnimation(
      parent: _scoreAnimationController,
      curve: Curves.easeOutBack,
    );

    _rankingAnimation = CurvedAnimation(
      parent: _rankingAnimationController,
      curve: Curves.elasticOut,
    );

    _initializeScores();
  }

  @override
  void didUpdateWidget(LiveScoreWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.gameState != widget.gameState) {
      _updateScores();
    }
  }

  void _initializeScores() {
    _currentScores = {
      for (final player in widget.gameState.players)
        player.userId: player.potState.victoryPoints,
    };
    _previousScores = Map.from(_currentScores);
  }

  void _updateScores() {
    _previousScores = Map.from(_currentScores);
    _currentScores = {
      for (final player in widget.gameState.players)
        player.userId: player.potState.victoryPoints,
    };

    // Check if any scores changed
    bool scoresChanged = false;
    for (final playerId in _currentScores.keys) {
      if (_previousScores[playerId] != _currentScores[playerId]) {
        scoresChanged = true;
        break;
      }
    }

    if (scoresChanged) {
      _scoreAnimationController.forward().then((_) {
        _rankingAnimationController.forward().then((_) {
          _scoreAnimationController.reset();
          _rankingAnimationController.reset();
        });
      });
    }
  }

  @override
  void dispose() {
    _scoreAnimationController.dispose();
    _rankingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rankedPlayers = _getRankedPlayers();

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.leaderboard,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Live Scores',
                  style: AppTheme.titleStyle.copyWith(
                    fontFamily: 'Caveat',
                    fontSize: 20,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const Spacer(),
                Text(
                  'Turn ${widget.gameState.currentTurn}/9',
                  style: AppTheme.bodyStyle.copyWith(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Player scores
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rankedPlayers.length,
            itemBuilder: (context, index) {
              final player = rankedPlayers[index];
              final isCurrentPlayer = player.userId == widget.currentPlayerId;
              final rank = index + 1;

              return AnimatedBuilder(
                animation: _rankingAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, (1 - _rankingAnimation.value) * 20),
                    child: _buildPlayerScoreRow(
                      player,
                      rank,
                      isCurrentPlayer,
                      index,
                    ),
                  );
                },
              );
            },
          ),

          // Phase indicator
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.secondaryColor.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getPhaseIcon(widget.gameState.currentPhase),
                  color: AppTheme.secondaryColor,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.gameState.currentPhase.displayName,
                  style: AppTheme.bodyStyle.copyWith(
                    color: AppTheme.secondaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerScoreRow(
    GamePlayer player,
    int rank,
    bool isCurrentPlayer,
    int index,
  ) {
    final previousScore = _previousScores[player.userId] ?? 0;
    final currentScore = _currentScores[player.userId] ?? 0;
    final scoreIncrease = currentScore - previousScore;

    return InkWell(
      onTap: () => _showScoreBreakdown(player),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isCurrentPlayer
              ? AppTheme.primaryColor.withValues(alpha: 0.1)
              : null,
          border: Border(
            bottom: BorderSide(
              color: Colors.white.withValues(alpha: 0.1),
              width: index < widget.gameState.players.length - 1 ? 1 : 0,
            ),
          ),
        ),
        child: Row(
          children: [
            // Rank badge
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _getRankColor(rank).withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(color: _getRankColor(rank), width: 2),
              ),
              child: Center(
                child: Text(
                  '$rank',
                  style: AppTheme.titleStyle.copyWith(
                    color: _getRankColor(rank),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
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
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'YOU',
                            style: AppTheme.bodyStyle.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  // Player status indicators
                  Row(
                    children: [
                      if (player.potState.hasExploded)
                        Container(
                          margin: const EdgeInsets.only(right: 4),
                          child: const Icon(
                            Icons.warning,
                            size: 12,
                            color: Colors.red,
                          ),
                        ),
                      if (player.potState.rubies > 0) ...[
                        Icon(
                          Icons.diamond,
                          size: 12,
                          color: Colors.red.shade300,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${player.potState.rubies}',
                          style: AppTheme.bodyStyle.copyWith(
                            fontSize: 10,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (player.potState.coins > 0) ...[
                        const Icon(
                          Icons.monetization_on,
                          size: 12,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${player.potState.coins}',
                          style: AppTheme.bodyStyle.copyWith(
                            fontSize: 10,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Score display with animation
            AnimatedBuilder(
              animation: _scoreAnimation,
              builder: (context, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Main score
                    Transform.scale(
                      scale: 1 + (_scoreAnimation.value * 0.2),
                      child: Text(
                        '$currentScore',
                        style: AppTheme.titleStyle.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _getRankColor(rank),
                        ),
                      ),
                    ),

                    // Score increase indicator
                    if (scoreIncrease > 0)
                      Transform.translate(
                        offset: Offset(0, -_scoreAnimation.value * 10),
                        child: Opacity(
                          opacity: _scoreAnimation.value,
                          child: Text(
                            '+$scoreIncrease',
                            style: AppTheme.bodyStyle.copyWith(
                              fontSize: 12,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),

            const SizedBox(width: 8),

            // Tap indicator
            const Icon(Icons.info_outline, size: 16, color: Colors.white54),
          ],
        ),
      ),
    );
  }

  List<GamePlayer> _getRankedPlayers() {
    final players = List<GamePlayer>.from(widget.gameState.players);
    players.sort((a, b) {
      // Primary sort by victory points (descending)
      final vpComparison = b.potState.victoryPoints.compareTo(
        a.potState.victoryPoints,
      );
      if (vpComparison != 0) return vpComparison;

      // Secondary sort by position (descending)
      return b.potState.scoringPosition.compareTo(a.potState.scoringPosition);
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

  IconData _getPhaseIcon(GamePhase phase) {
    switch (phase) {
      case GamePhase.fortuneTeller:
        return Icons.auto_stories;
      case GamePhase.rats:
        return Icons.pets;
      case GamePhase.potions:
        return Icons.science;
      case GamePhase.evaluationA:
        return Icons.casino;
      case GamePhase.evaluationB:
        return Icons.auto_fix_high;
      case GamePhase.evaluationC:
        return Icons.diamond;
      case GamePhase.evaluationD:
        return Icons.emoji_events;
      case GamePhase.evaluationE:
        return Icons.shopping_cart;
      case GamePhase.evaluationF:
        return Icons.refresh;
      case GamePhase.gameOver:
        return Icons.flag;
    }
  }

  void _showScoreBreakdown(GamePlayer player) {
    // TODO: Calculate actual score breakdown using ScoringService
    final mockBreakdown = {
      'basePoints': player.potState.scoringPosition >= 10 ? 3 : 0,
      'bonusDiePoints': 2,
      'comboPoints': 1,
      'roundBonus': 0,
      'multiplier': 1.0,
      'totalThisRound': 6,
      'totalVictoryPoints': player.potState.victoryPoints,
      'coins': player.potState.coins,
      'rubies': player.potState.rubies,
      'exploded': player.potState.hasExploded,
      'combos': {'green_pair': 1},
    };

    showDialog(
      context: context,
      builder: (context) => ScoreBreakdownDialog(
        playerName: player.displayName,
        scoreBreakdown: mockBreakdown,
      ),
    );
  }
}
