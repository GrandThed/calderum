import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_state_model.dart';
import '../../../shared/theme/app_theme.dart';
import 'ingredient_chip_widget.dart';

/// Widget that displays an opponent's pot and current state
class OpponentBoardWidget extends ConsumerStatefulWidget {
  final GamePlayer opponent;
  final bool isCurrentTurn;
  final bool showDetailedView;
  final VoidCallback? onTap;

  const OpponentBoardWidget({
    super.key,
    required this.opponent,
    this.isCurrentTurn = false,
    this.showDetailedView = false,
    this.onTap,
  });

  @override
  ConsumerState<OpponentBoardWidget> createState() => _OpponentBoardWidgetState();
}

class _OpponentBoardWidgetState extends ConsumerState<OpponentBoardWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _actionController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _actionAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _actionController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _actionAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _actionController, curve: Curves.elasticOut),
    );

    if (widget.isCurrentTurn) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(OpponentBoardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isCurrentTurn != oldWidget.isCurrentTurn) {
      if (widget.isCurrentTurn) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
    }

    // Trigger action animation if opponent performed an action
    if (widget.opponent.lastAction != oldWidget.opponent.lastAction) {
      _actionController.forward().then((_) => _actionController.reset());
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _actionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulseAnimation, _actionAnimation]),
        builder: (context, child) {
          return Transform.scale(
            scale: widget.isCurrentTurn ? _pulseAnimation.value : 1.0,
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: widget.isCurrentTurn
                      ? AppTheme.primaryColor.withValues(alpha: 0.8)
                      : Colors.white.withValues(alpha: 0.2),
                  width: widget.isCurrentTurn ? 3 : 1,
                ),
                boxShadow: [
                  if (widget.isCurrentTurn)
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Player header
                  _buildPlayerHeader(),

                  // Pot visualization
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: widget.showDetailedView
                        ? _buildDetailedPotView()
                        : _buildCompactPotView(),
                  ),

                  // Status indicators
                  _buildStatusIndicators(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlayerHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.isCurrentTurn
            ? AppTheme.primaryColor.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
        ),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 16,
            backgroundColor: _getPlayerColor(),
            child: widget.opponent.photoUrl != null
                ? ClipOval(
                    child: Image.network(
                      widget.opponent.photoUrl!,
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                    ),
                  )
                : Text(
                    widget.opponent.displayName.characters.first.toUpperCase(),
                    style: AppTheme.titleStyle.copyWith(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),

          const SizedBox(width: 8),

          // Player name and status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.opponent.displayName,
                  style: AppTheme.bodyStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: widget.isCurrentTurn
                        ? AppTheme.primaryColor
                        : Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    // Online indicator
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: widget.opponent.isOnline
                            ? Colors.green
                            : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.opponent.isOnline ? 'Online' : 'Offline',
                      style: AppTheme.bodyStyle.copyWith(
                        fontSize: 10,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Turn indicator
          if (widget.isCurrentTurn)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'TURN',
                style: AppTheme.bodyStyle.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailedPotView() {
    return Column(
      children: [
        // Pot board with chips
        _buildPotBoard(),
        
        const SizedBox(height: 12),
        
        // Score breakdown
        _buildScoreBreakdown(),
      ],
    );
  }

  Widget _buildCompactPotView() {
    return Column(
      children: [
        // Mini pot visualization
        _buildMiniPotBoard(),
        
        const SizedBox(height: 8),
        
        // Key stats
        _buildKeyStats(),
      ],
    );
  }

  Widget _buildPotBoard() {
    final potState = widget.opponent.potState;
    
    return Container(
      height: 120,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: potState.hasExploded
              ? Colors.red.withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Stack(
        children: [
          // Droplet position indicator
          _buildDropletIndicator(),
          
          // Placed chips
          ..._buildPlacedChips(),
          
          // Explosion effect
          if (potState.hasExploded) _buildExplosionEffect(),
        ],
      ),
    );
  }

  Widget _buildMiniPotBoard() {
    final potState = widget.opponent.potState;
    
    return Container(
      height: 40,
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: potState.hasExploded
              ? Colors.red.withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          // Droplet
          Container(
            width: 16,
            height: 16,
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.water_drop, size: 10, color: Colors.white),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Mini chips
          Expanded(
            child: Row(
              children: potState.placedChips.take(8).map((chip) {
                return Container(
                  margin: const EdgeInsets.only(right: 2),
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: chip.color.displayColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 0.5),
                  ),
                );
              }).toList(),
            ),
          ),
          
          // Explosion indicator
          if (potState.hasExploded)
            const Icon(Icons.local_fire_department, 
                 size: 16, color: Colors.red),
        ],
      ),
    );
  }

  Widget _buildDropletIndicator() {
    final position = widget.opponent.potState.dropletPosition;
    final maxPosition = 33;
    final leftOffset = (position / maxPosition) * 100;
    
    return Positioned(
      left: leftOffset.clamp(0.0, 85.0),
      top: 8,
      child: Container(
        width: 20,
        height: 20,
        decoration: const BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Icon(Icons.water_drop, size: 12, color: Colors.white),
        ),
      ),
    );
  }

  List<Widget> _buildPlacedChips() {
    final chips = widget.opponent.potState.placedChips;
    final widgets = <Widget>[];
    
    for (int i = 0; i < chips.length; i++) {
      final chip = chips[i];
      final position = chip.positionOnBoard ?? 0;
      final maxPosition = 33;
      final leftOffset = (position / maxPosition) * 85;
      final topOffset = 40.0 + (i % 3) * 20;
      
      widgets.add(
        Positioned(
          left: leftOffset,
          top: topOffset,
          child: IngredientChipWidget(
            chip: chip,
            size: 18,
            showValue: true,
          ),
        ),
      );
    }
    
    return widgets;
  }

  Widget _buildExplosionEffect() {
    return AnimatedBuilder(
      animation: _actionAnimation,
      builder: (context, child) {
        return Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.3 * _actionAnimation.value),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Transform.scale(
                scale: _actionAnimation.value,
                child: const Icon(
                  Icons.local_fire_department,
                  size: 32,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildKeyStats() {
    final potState = widget.opponent.potState;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatChip(
          icon: Icons.emoji_events,
          value: '${potState.victoryPoints}',
          color: AppTheme.secondaryColor,
          label: 'VP',
        ),
        _buildStatChip(
          icon: Icons.monetization_on,
          value: '${potState.coins}',
          color: Colors.amber,
          label: 'Coins',
        ),
        _buildStatChip(
          icon: Icons.diamond,
          value: '${potState.rubies}',
          color: Colors.red.shade400,
          label: 'Rubies',
        ),
        _buildStatChip(
          icon: Icons.place,
          value: '${potState.scoringPosition}',
          color: Colors.blue,
          label: 'Pos',
        ),
      ],
    );
  }

  Widget _buildScoreBreakdown() {
    final potState = widget.opponent.potState;
    
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildDetailedStatChip(
            icon: Icons.emoji_events,
            value: '${potState.victoryPoints}',
            color: AppTheme.secondaryColor,
            label: 'Victory Points',
          ),
          _buildDetailedStatChip(
            icon: Icons.monetization_on,
            value: '${potState.coins}',
            color: Colors.amber,
            label: 'Coins',
          ),
          _buildDetailedStatChip(
            icon: Icons.diamond,
            value: '${potState.rubies}',
            color: Colors.red.shade400,
            label: 'Rubies',
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String value,
    required Color color,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 10, color: color),
              const SizedBox(width: 2),
              Text(
                value,
                style: AppTheme.bodyStyle.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTheme.bodyStyle.copyWith(
            fontSize: 8,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedStatChip({
    required IconData icon,
    required String value,
    required Color color,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTheme.titleStyle.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: AppTheme.bodyStyle.copyWith(
            fontSize: 10,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIndicators() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(14),
          bottomRight: Radius.circular(14),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Action indicator
          _buildActionIndicator(),
          
          // Phase completion
          _buildPhaseIndicator(),
          
          // Special status
          _buildSpecialStatus(),
        ],
      ),
    );
  }

  Widget _buildActionIndicator() {
    final lastAction = widget.opponent.lastAction;
    final isRecentAction = lastAction != null &&
        DateTime.now().difference(lastAction).inSeconds < 30;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isRecentAction ? Colors.green : Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          isRecentAction ? 'Active' : 'Idle',
          style: AppTheme.bodyStyle.copyWith(
            fontSize: 10,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildPhaseIndicator() {
    final hasCompleted = widget.opponent.hasCompletedPhase;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          hasCompleted ? Icons.check_circle : Icons.hourglass_empty,
          size: 12,
          color: hasCompleted ? Colors.green : Colors.orange,
        ),
        const SizedBox(width: 4),
        Text(
          hasCompleted ? 'Ready' : 'Waiting',
          style: AppTheme.bodyStyle.copyWith(
            fontSize: 10,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialStatus() {
    final potState = widget.opponent.potState;
    
    Widget statusWidget = const SizedBox();
    
    if (potState.hasExploded) {
      statusWidget = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.warning, size: 12, color: Colors.red),
          const SizedBox(width: 4),
          Text(
            'Exploded',
            style: AppTheme.bodyStyle.copyWith(
              fontSize: 10,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    } else if (!potState.flaskAvailable) {
      statusWidget = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.science, size: 12, color: Colors.grey),
          const SizedBox(width: 4),
          Text(
            'No Flask',
            style: AppTheme.bodyStyle.copyWith(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
        ],
      );
    }
    
    return statusWidget;
  }

  Color _getPlayerColor() {
    // Generate consistent color based on player ID
    final hash = widget.opponent.userId.hashCode;
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
}

/// Grid of opponent boards
class OpponentGridWidget extends StatelessWidget {
  final List<GamePlayer> opponents;
  final String? currentPlayerTurnId;
  final Function(GamePlayer)? onOpponentTap;

  const OpponentGridWidget({
    super.key,
    required this.opponents,
    this.currentPlayerTurnId,
    this.onOpponentTap,
  });

  @override
  Widget build(BuildContext context) {
    if (opponents.isEmpty) {
      return const SizedBox();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: opponents.length > 2 ? 2 : 1,
        childAspectRatio: 1.2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: opponents.length,
      itemBuilder: (context, index) {
        final opponent = opponents[index];
        final isCurrentTurn = opponent.userId == currentPlayerTurnId;

        return OpponentBoardWidget(
          opponent: opponent,
          isCurrentTurn: isCurrentTurn,
          onTap: () => onOpponentTap?.call(opponent),
        );
      },
    );
  }
}