import 'package:flutter/material.dart';
import '../../../shared/theme/app_theme.dart';

/// Dialog showing detailed score breakdown for a player
class ScoreBreakdownDialog extends StatelessWidget {
  final String playerName;
  final Map<String, dynamic> scoreBreakdown;

  const ScoreBreakdownDialog({
    super.key,
    required this.playerName,
    required this.scoreBreakdown,
  });

  @override
  Widget build(BuildContext context) {
    final basePoints = scoreBreakdown['basePoints'] as int? ?? 0;
    final bonusDiePoints = scoreBreakdown['bonusDiePoints'] as int? ?? 0;
    final comboPoints = scoreBreakdown['comboPoints'] as int? ?? 0;
    final roundBonus = scoreBreakdown['roundBonus'] as int? ?? 0;
    final multiplier = scoreBreakdown['multiplier'] as double? ?? 1.0;
    final totalThisRound = scoreBreakdown['totalThisRound'] as int? ?? 0;
    final totalVictoryPoints =
        scoreBreakdown['totalVictoryPoints'] as int? ?? 0;
    final coins = scoreBreakdown['coins'] as int? ?? 0;
    final rubies = scoreBreakdown['rubies'] as int? ?? 0;
    final exploded = scoreBreakdown['exploded'] as bool? ?? false;
    final combos = scoreBreakdown['combos'] as Map<String, dynamic>? ?? {};

    return Dialog(
      backgroundColor: AppTheme.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppTheme.primaryColor.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  exploded ? Icons.warning : Icons.leaderboard,
                  color: exploded ? Colors.red : AppTheme.primaryColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$playerName\'s Score',
                        style: AppTheme.titleStyle.copyWith(
                          fontFamily: 'Caveat',
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      if (exploded)
                        Text(
                          'Pot Exploded! 💥',
                          style: AppTheme.bodyStyle.copyWith(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  color: Colors.white70,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Score breakdown
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Base points
                    _buildScoreRow(
                      'Base Position Points',
                      basePoints,
                      Icons.location_on,
                      Colors.blue,
                    ),

                    // Bonus die points
                    if (bonusDiePoints > 0)
                      _buildScoreRow(
                        'Bonus Die Points',
                        bonusDiePoints,
                        Icons.casino,
                        Colors.green,
                      ),

                    // Combo points
                    if (comboPoints > 0)
                      _buildScoreRow(
                        'Ingredient Combos',
                        comboPoints,
                        Icons.auto_awesome,
                        Colors.purple,
                      ),

                    // Round bonus
                    if (roundBonus > 0)
                      _buildScoreRow(
                        'Round Bonus',
                        roundBonus,
                        Icons.trending_up,
                        Colors.orange,
                      ),

                    // Multiplier
                    if (multiplier != 1.0) _buildMultiplierRow(multiplier),

                    // Divider
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: Colors.white24),
                    ),

                    // Total this round
                    _buildScoreRow(
                      'Total This Round',
                      totalThisRound,
                      Icons.add_circle,
                      AppTheme.primaryColor,
                      isTotal: true,
                    ),

                    // Final total
                    _buildScoreRow(
                      'Total Victory Points',
                      totalVictoryPoints,
                      Icons.emoji_events,
                      AppTheme.secondaryColor,
                      isTotal: true,
                      isFinal: true,
                    ),

                    const SizedBox(height: 16),

                    // Resources
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildResourceCard(
                          'Coins',
                          coins.toString(),
                          Icons.monetization_on,
                          Colors.amber,
                        ),
                        _buildResourceCard(
                          'Rubies',
                          rubies.toString(),
                          Icons.diamond,
                          Colors.red,
                        ),
                      ],
                    ),

                    // Combos detail
                    if (combos.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _buildCombosSection(combos),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreRow(
    String label,
    int points,
    IconData icon,
    Color color, {
    bool isTotal = false,
    bool isFinal = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: isTotal ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: AppTheme.bodyStyle.copyWith(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                fontSize: isFinal ? 16 : 14,
              ),
            ),
          ),
          Text(
            '+$points',
            style: AppTheme.titleStyle.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: isFinal ? 18 : 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultiplierRow(double multiplier) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.purple.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.purple.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.purple.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.close, size: 20, color: Colors.purple),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Score Multiplier',
              style: AppTheme.bodyStyle.copyWith(fontSize: 14),
            ),
          ),
          Text(
            '×${multiplier.toStringAsFixed(1)}',
            style: AppTheme.titleStyle.copyWith(
              color: Colors.purple,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTheme.titleStyle.copyWith(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: AppTheme.bodyStyle.copyWith(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCombosSection(Map<String, dynamic> combos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ingredient Combos',
          style: AppTheme.titleStyle.copyWith(
            fontFamily: 'Caudex',
            fontSize: 16,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        ...combos.entries.map((combo) {
          final name = _formatComboName(combo.key);
          final points = combo.value as int;

          return Container(
            margin: const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                const Icon(Icons.auto_fix_high, size: 16, color: Colors.purple),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    name,
                    style: AppTheme.bodyStyle.copyWith(fontSize: 12),
                  ),
                ),
                Text(
                  '+$points',
                  style: AppTheme.bodyStyle.copyWith(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  String _formatComboName(String comboKey) {
    // Format combo keys for display
    switch (comboKey) {
      case 'green_pair':
        return 'Green Chip Pairs';
      case 'blue_protection':
        return 'Blue Protection Bonus';
      case 'red_yellow_combo':
        return 'Red & Yellow Synergy';
      case 'purple_black_synergy':
        return 'Purple & Black Synergy';
      default:
        return comboKey
            .replaceAll('_', ' ')
            .split(' ')
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join(' ');
    }
  }
}
