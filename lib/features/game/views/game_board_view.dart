import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/calderum_app_bar.dart';
import '../models/game_state_model.dart';
import '../models/ingredient_model.dart';
import '../viewmodels/game_viewmodel.dart';
import '../../account/viewmodels/auth_viewmodel.dart';
import '../widgets/ingredient_bag_row_widget.dart';
import '../widgets/game_actions_row_widget.dart';
import '../widgets/game_phase_indicator.dart';
import '../widgets/ingredient_market_widget.dart';
import '../utils/feedback_helper.dart';
import '../utils/pot_scoring.dart';

class GameBoardView extends ConsumerWidget {
  final String gameId;

  const GameBoardView({super.key, required this.gameId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStreamProvider(gameId));
    final currentPlayer = ref.watch(currentPlayerProvider(gameId));
    final isHostValue = ref.watch(isHostProvider(gameId));
    final authState = ref.watch(authViewModelProvider);
    final currentUser = authState.when(
      authenticated: (user) => user,
      anonymous: (user) => user,
      initial: () => null,
      loading: () => null,
      unauthenticated: () => null,
      error: (_) => null,
    );

    return gameState.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: const Text('Game Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text('Error loading game: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Back to Lobby'),
              ),
            ],
          ),
        ),
      ),
      data: (state) {
        if (currentPlayer == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Game Error')),
            body: const Center(child: Text('Player not found in game')),
          );
        }

        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          appBar: CalderumAppBar(
            title:
                'Turn ${state.currentTurn} - ${state.currentPhase.displayName}',
            showBackButton: true,
            onBackPressed: () => context.go('/home'),
            actions: [
              if (isHostValue && state.allPlayersReady)
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  onPressed: () => _nextPhase(ref),
                  tooltip: 'Next Phase',
                ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Game Phase Indicator
                  GamePhaseIndicator(
                    currentPhase: state.currentPhase,
                    currentTurn: state.currentTurn,
                  ),

                  const SizedBox(height: 16),

                  // Main Player Pot - Larger and detailed
                  SizedBox(
                    height: 280,
                    child: _buildMainPlayerPot(currentPlayer, state, ref),
                  ),

                  const SizedBox(height: 12),

                  // Opponent Pot Summaries
                  SizedBox(
                    height: 78,
                    child: _buildOpponentSummaries(
                      state,
                      currentUser?.uid ?? '',
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Ingredient Bag Row
                  IngredientBagRowWidget(
                    ingredientBag: currentPlayer.ingredientBag,
                    onDrawChip: state.currentPhase == GamePhase.potions
                        ? () => _drawChip(ref)
                        : null,
                    canDraw: _canDrawChips(currentPlayer, state),
                  ),

                  const SizedBox(height: 12),

                  // Game Actions Row
                  GameActionsRowWidget(
                    player: currentPlayer,
                    gameState: state,
                    onStopDrawing: () => _stopDrawing(ref),
                    onUseFlask: () => _useFlask(ref, currentPlayer),
                    onCompletePhase: () => _completePhase(ref),
                  ),

                  const SizedBox(height: 12),

                  // Ingredient Market Row (during buy phase)
                  if (state.currentPhase == GamePhase.evaluationE)
                    SizedBox(
                      height: 120,
                      child: IngredientMarketWidget(
                        market: state.ingredientMarket,
                        playerCoins: currentPlayer.potState.coins,
                        onBuyIngredient: (ingredient) =>
                            _buyIngredient(ref, ingredient),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainPlayerPot(
    GamePlayer player,
    GameState state,
    WidgetRef ref,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Player header
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppTheme.getPlayerColor(player.userId),
                child: Text(
                  player.displayName.isNotEmpty
                      ? player.displayName[0].toUpperCase()
                      : 'P',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.displayName,
                      style: AppTheme.headingStyle.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Your Pot',
                      style: AppTheme.bodyStyle.copyWith(
                        color: AppTheme.primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Pot: ${PotScoring.getPotNumber(player.potState.scoringPosition)} (Space ${player.potState.scoringPosition})',
                  style: AppTheme.headingStyle.copyWith(
                    color: AppTheme.secondaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Scoring Track Carousel
          Expanded(child: _buildScoringTrackCarousel(player, state, ref)),
        ],
      ),
    );
  }

  List<Widget> _buildEnhancedScoringTrack(
    GamePlayer player,
    GameState state,
    WidgetRef ref,
  ) {
    final List<Widget> positions = [];
    final placedChips = player.potState.placedChips;

    // Create positions 0-53 (full scoring track)
    const maxPosition = 53;

    for (int i = 0; i <= maxPosition; i++) {
      final chipsAtPosition = placedChips
          .where((chip) => _getChipScoringValue(chip) == i)
          .toList();

      positions.add(
        _buildEnhancedTrackPosition(i, chipsAtPosition, player, state, ref),
      );
    }

    return positions;
  }

  Widget _buildEnhancedTrackPosition(
    int position,
    List<IngredientChip> chipsHere,
    GamePlayer player,
    GameState state,
    WidgetRef ref,
  ) {
    final isCurrentPosition = position == player.potState.scoringPosition;
    final hasChips = chipsHere.isNotEmpty;
    final canPlaceChips = _canPlaceChips(player, state);
    final drawnChips = player.ingredientBag.drawnThisTurn;

    // Calculate points and ruby status for this position
    final points = _getPointsForPosition(position);
    final hasRuby = PotScoring.hasRuby(position);

    return GestureDetector(
      onTap: canPlaceChips && drawnChips.isNotEmpty
          ? () {
              if (drawnChips.isNotEmpty) {
                _placeChip(ref, drawnChips.first, position);
              }
            }
          : null,
      child: Container(
        width: 60,
        height: 80,
        margin: const EdgeInsets.only(right: 6),
        decoration: BoxDecoration(
          color: isCurrentPosition
              ? AppTheme.primaryColor.withValues(alpha: 0.4)
              : hasChips
              ? Colors.white.withValues(alpha: 0.15)
              : Colors.transparent,
          border: Border.all(
            color: isCurrentPosition
                ? AppTheme.primaryColor
                : Colors.white.withValues(alpha: 0.3),
            width: isCurrentPosition ? 3 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ruby indicator
            if (hasRuby) ...[
              Icon(
                Icons.diamond,
                color: Colors.red.shade400,
                size: 16,
              ),
              const SizedBox(height: 2),
            ],
            
            // Points indicator
            if (points > 0) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '+$points',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),
            ],

            // Chip if present
            if (hasChips)
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: _getIngredientColor(chipsHere.first.color),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: Center(
                  child: Text(
                    '${chipsHere.first.value}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 4),

            // Pot number (main display)
            Text(
              '${PotScoring.getPotNumber(position)}',
              style: TextStyle(
                color: isCurrentPosition ? Colors.white : Colors.white60,
                fontSize: 16,
                fontWeight: isCurrentPosition
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoringTrackCarousel(
    GamePlayer player,
    GameState state,
    WidgetRef ref,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Track header with title and current score
        Row(
          children: [
            Text(
              'Scoring Track',
              style: AppTheme.bodyStyle.copyWith(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.primaryColor, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.my_location,
                    color: AppTheme.primaryColor,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Pot ${PotScoring.getPotNumber(player.potState.scoringPosition)}',
                    style: AppTheme.bodyStyle.copyWith(
                      color: AppTheme.primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // M3-style carousel for scoring track positions
        Expanded(child: _buildM3ScoringCarousel(player, state, ref)),
      ],
    );
  }

  Widget _buildM3ScoringCarousel(
    GamePlayer player,
    GameState state,
    WidgetRef ref,
  ) {
    return _CustomPotCarousel(
      player: player,
      state: state,
      ref: ref,
      onPositionTapped: (position) {
        final drawnChips = player.ingredientBag.drawnThisTurn;
        final canPlaceChips = _canPlaceChips(player, state);

        if (canPlaceChips && drawnChips.isNotEmpty) {
          _placeChip(ref, drawnChips.first, position);
        }
      },
      getChipScoringValue: _getChipScoringValue,
      getIngredientColor: _getIngredientColor,
      getPointsForPosition: _getPointsForPosition,
      canPlaceChips: _canPlaceChips(player, state),
    );
  }

  Widget _buildHeroPositionCard(
    int position,
    List<IngredientChip> chipsHere,
    GamePlayer player,
    GameState state,
    WidgetRef ref,
    bool isHeroPosition,
  ) {
    final isCurrentPosition = position == player.potState.scoringPosition;
    final hasChips = chipsHere.isNotEmpty;
    final drawnChips = player.ingredientBag.drawnThisTurn;
    final canPlaceChips = _canPlaceChips(player, state);
    final points = _getPointsForPosition(position);

    // Calculate chip total value for explosion risk
    final totalChipValue = chipsHere.fold(0, (sum, chip) => sum + chip.value);
    final isNearExplosion = totalChipValue >= 5;
    final wouldExplode = totalChipValue >= 7;

    return Card(
      elevation: isCurrentPosition ? 8 : 4,
      shadowColor: isCurrentPosition
          ? AppTheme.primaryColor.withValues(alpha: 0.4)
          : Colors.black.withValues(alpha: 0.2),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isCurrentPosition
                ? [
                    AppTheme.primaryColor.withValues(alpha: 0.1),
                    AppTheme.primaryColor.withValues(alpha: 0.05),
                  ]
                : wouldExplode
                ? [
                    Colors.red.withValues(alpha: 0.2),
                    Colors.red.withValues(alpha: 0.1),
                  ]
                : isNearExplosion
                ? [
                    Colors.orange.withValues(alpha: 0.15),
                    Colors.orange.withValues(alpha: 0.05),
                  ]
                : [
                    AppTheme.surfaceColor.withValues(alpha: 0.3),
                    AppTheme.surfaceColor.withValues(alpha: 0.1),
                  ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isCurrentPosition
                ? AppTheme.primaryColor
                : wouldExplode
                ? Colors.red.withValues(alpha: 0.6)
                : isNearExplosion
                ? Colors.orange.withValues(alpha: 0.6)
                : Colors.white.withValues(alpha: 0.2),
            width: isCurrentPosition ? 2 : 1,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Position number with status ring
              Stack(
                alignment: Alignment.center,
                children: [
                  // Status ring
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCurrentPosition
                            ? AppTheme.primaryColor
                            : wouldExplode
                            ? Colors.red
                            : isNearExplosion
                            ? Colors.orange
                            : Colors.white38,
                        width: 3,
                      ),
                    ),
                  ),
                  // Position number
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: isCurrentPosition
                          ? AppTheme.primaryColor.withValues(alpha: 0.2)
                          : Colors.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$position',
                        style: AppTheme.headingStyle.copyWith(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Current position indicator
                  if (isCurrentPosition)
                    Positioned(
                      top: -5,
                      right: -5,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.my_location,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 20),

              // Status and points row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Points indicator
                  if (points > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.secondaryColor.withValues(
                              alpha: 0.3,
                            ),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.white, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            '+$points',
                            style: AppTheme.headingStyle.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Risk indicator
                  if (wouldExplode)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.warning, color: Colors.white, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            'EXPLODES!',
                            style: AppTheme.bodyStyle.copyWith(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (isNearExplosion)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.warning_amber,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'DANGER',
                            style: AppTheme.bodyStyle.copyWith(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 20),

              // Chips display section
              if (hasChips) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Placed Ingredients',
                        style: AppTheme.bodyStyle.copyWith(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: chipsHere
                            .map(
                              (chip) => Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: _getIngredientColor(chip.color),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _getIngredientColor(
                                        chip.color,
                                      ).withValues(alpha: 0.4),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    '${chip.value}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Total Value: $totalChipValue',
                        style: AppTheme.bodyStyle.copyWith(
                          color: totalChipValue >= 7
                              ? Colors.red
                              : totalChipValue >= 5
                              ? Colors.orange
                              : Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else if (canPlaceChips && drawnChips.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.primaryColor, width: 2),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.touch_app,
                        color: AppTheme.primaryColor,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap to Place Ingredient',
                        style: AppTheme.bodyStyle.copyWith(
                          color: AppTheme.primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Value: ${drawnChips.first.value}',
                        style: AppTheme.bodyStyle.copyWith(
                          color: AppTheme.primaryColor.withValues(alpha: 0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.circle_outlined,
                        color: Colors.white38,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Empty Position',
                        style: AppTheme.bodyStyle.copyWith(
                          color: Colors.white60,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOpponentSummaries(GameState state, String currentUserId) {
    final opponents = state.players
        .where((player) => player.userId != currentUserId)
        .toList();

    if (opponents.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Opponents',
            style: AppTheme.bodyStyle.copyWith(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: opponents.length,
            itemBuilder: (context, index) {
              final opponent = opponents[index];
              return Container(
                width: 140,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: AppTheme.getPlayerColor(opponent.userId),
                      child: Text(
                        opponent.displayName.isNotEmpty
                            ? opponent.displayName[0].toUpperCase()
                            : 'P',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            opponent.displayName,
                            style: AppTheme.bodyStyle.copyWith(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: AppTheme.secondaryColor,
                                size: 10,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${opponent.potState.scoringPosition}',
                                style: AppTheme.bodyStyle.copyWith(
                                  color: AppTheme.secondaryColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                opponent.hasCompletedPhase
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: opponent.hasCompletedPhase
                                    ? Colors.green
                                    : Colors.orange,
                                size: 10,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  int _getPointsForPosition(int position) {
    return PotScoring.getVictoryPoints(position);
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

  // Helper methods for game logic
  bool _canDrawChips(GamePlayer player, GameState state) {
    return state.currentPhase == GamePhase.potions &&
        !player.potState.hasExploded &&
        !player.hasCompletedPhase;
  }

  bool _canPlaceChips(GamePlayer player, GameState state) {
    return state.currentPhase == GamePhase.potions &&
        player.ingredientBag.drawnThisTurn.isNotEmpty;
  }

  // Action handlers
  void _drawChip(WidgetRef ref) {
    ref.read(gameViewModelProvider(gameId).notifier).drawChip();
    ref.read(gameFeedbackHelperProvider).onIngredientDraw();
  }

  void _placeChip(WidgetRef ref, IngredientChip chip, int position) {
    ref.read(gameViewModelProvider(gameId).notifier).placeChip(chip, position);
    ref.read(gameFeedbackHelperProvider).onIngredientDrop();
  }

  void _useFlask(WidgetRef ref, GamePlayer player) {
    // Find last white chip that can be returned
    final whiteChips = player.potState.placedChips
        .where((chip) => chip.color == IngredientColor.white)
        .toList();

    if (whiteChips.isNotEmpty) {
      final lastWhiteChip = whiteChips.last;
      ref.read(gameViewModelProvider(gameId).notifier).useFlask(lastWhiteChip);
      ref.read(gameFeedbackHelperProvider).onFlaskUse();
    }
  }

  void _stopDrawing(WidgetRef ref) {
    ref.read(gameViewModelProvider(gameId).notifier).stopDrawing();
  }

  void _buyIngredient(WidgetRef ref, AvailableIngredient ingredient) {
    ref.read(gameViewModelProvider(gameId).notifier).buyIngredient(ingredient);
  }

  void _completePhase(WidgetRef ref) {
    ref.read(gameViewModelProvider(gameId).notifier).completePhase();
  }

  void _nextPhase(WidgetRef ref) {
    ref.read(phaseManagerViewModelProvider(gameId).notifier).nextPhase();
  }
}

// Custom animated carousel for pot positions
class _CustomPotCarousel extends StatefulWidget {
  final GamePlayer player;
  final GameState state;
  final WidgetRef ref;
  final Function(int) onPositionTapped;
  final int Function(IngredientChip) getChipScoringValue;
  final Color Function(IngredientColor) getIngredientColor;
  final int Function(int) getPointsForPosition;
  final bool canPlaceChips;

  const _CustomPotCarousel({
    required this.player,
    required this.state,
    required this.ref,
    required this.onPositionTapped,
    required this.getChipScoringValue,
    required this.getIngredientColor,
    required this.getPointsForPosition,
    required this.canPlaceChips,
  });

  @override
  State<_CustomPotCarousel> createState() => _CustomPotCarouselState();
}

class _CustomPotCarouselState extends State<_CustomPotCarousel>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;
  int _selectedPosition = 0;
  final double _itemWidth = 80.0; // Bigger slots while keeping no gaps
  final int _visibleItems = 5;

  @override
  void initState() {
    super.initState();
    _selectedPosition = widget.player.potState.scoringPosition;
    _scrollController = ScrollController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Scroll to current position after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToPosition(_selectedPosition, animate: false);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _scrollToPosition(int position, {bool animate = true}) {
    if (!_scrollController.hasClients) return;

    // Calculate offset to center the position
    final centerOffset = (_visibleItems / 2).floor() * _itemWidth;
    final targetOffset = (position * _itemWidth) - centerOffset;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final finalOffset = targetOffset.clamp(0.0, maxScroll);

    if (animate) {
      _scrollController.animateTo(
        finalOffset,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _scrollController.jumpTo(finalOffset);
    }
  }

  @override
  Widget build(BuildContext context) {
    final placedChips = widget.player.potState.placedChips;
    final currentPosition = widget.player.potState.scoringPosition;
    final maxPosition = 53; // Full Quacks scoring track has 54 positions (0-53)

    return Column(
      children: [
        // Main carousel
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                height: constraints.maxHeight,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(maxPosition + 1, (index) {
                      final chipsAtPosition = placedChips
                          .where(
                            (chip) => widget.getChipScoringValue(chip) == index,
                          )
                          .toList();

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedPosition = index;
                          });
                          _scrollToPosition(index);
                          widget.onPositionTapped(index);
                        },
                        child: _buildPositionSlot(
                          position: index,
                          chipsHere: chipsAtPosition,
                          isSelected: index == _selectedPosition,
                          isCurrent: index == currentPosition,
                        ),
                      );
                    }),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 16),

        // Navigation buttons
        _buildNavigationControls(),
      ],
    );
  }

  Widget _buildPositionSlot({
    required int position,
    required List<IngredientChip> chipsHere,
    required bool isSelected,
    required bool isCurrent,
  }) {
    final points = widget.getPointsForPosition(position);
    final hasRuby = PotScoring.hasRuby(position);
    final hasChips = chipsHere.isNotEmpty;
    final drawnChips = widget.player.ingredientBag.drawnThisTurn;
    final totalChipValue = chipsHere.fold(0, (sum, chip) => sum + chip.value);
    final wouldExplode = totalChipValue >= 7;
    final isNearExplosion = totalChipValue >= 5;

    // Animation scale based on selection - reduced to prevent cropping
    final scale = isSelected ? 1.1 : 0.85;
    final opacity = isSelected ? 1.0 : 0.6;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      width: _itemWidth,
      // No margins - slots will touch each other
      child: Center(
        // Center to prevent cropping
        child: Transform.scale(
          scale: scale,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: opacity,
            child: Container(
              height: 120, // Fixed height for all slots regardless of content
              constraints: const BoxConstraints(minHeight: 80, maxHeight: 80),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: wouldExplode
                      ? [
                          Colors.red.withValues(alpha: 0.3),
                          Colors.red.withValues(alpha: 0.1),
                        ]
                      : isNearExplosion
                      ? [
                          Colors.orange.withValues(alpha: 0.3),
                          Colors.orange.withValues(alpha: 0.1),
                        ]
                      : isCurrent
                      ? [
                          AppTheme.primaryColor.withValues(alpha: 0.3),
                          AppTheme.primaryColor.withValues(alpha: 0.1),
                        ]
                      : isSelected
                      ? [
                          AppTheme.secondaryColor.withValues(alpha: 0.2),
                          AppTheme.secondaryColor.withValues(alpha: 0.05),
                        ]
                      : [
                          Colors.white.withValues(alpha: 0.1),
                          Colors.white.withValues(alpha: 0.05),
                        ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: wouldExplode
                      ? Colors.red
                      : isNearExplosion
                      ? Colors.orange
                      : isCurrent
                      ? AppTheme.primaryColor
                      : isSelected
                      ? AppTheme.secondaryColor
                      : Colors.white.withValues(alpha: 0.3),
                  width: isCurrent || isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color:
                              (wouldExplode
                                      ? Colors.red
                                      : isCurrent
                                      ? AppTheme.primaryColor
                                      : AppTheme.secondaryColor)
                                  .withValues(alpha: 0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : [],
              ),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Position number with status
                    Stack(
                      children: [
                        Container(
                          width: isSelected ? 45 : 36,
                          height: isSelected ? 45 : 36,
                          decoration: BoxDecoration(
                            color: wouldExplode
                                ? Colors.red.withValues(alpha: 0.3)
                                : isCurrent
                                ? AppTheme.primaryColor.withValues(alpha: 0.3)
                                : Colors.white.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: wouldExplode
                                  ? Colors.red
                                  : isCurrent
                                  ? AppTheme.primaryColor
                                  : Colors.white54,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '${PotScoring.getPotNumber(position)}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isSelected ? 18 : 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        // Current position badge
                        if (isCurrent)
                          Positioned(
                            top: -2,
                            right: -2,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        // Explosion warning
                        if (wouldExplode)
                          Positioned(
                            bottom: -2,
                            right: -2,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.warning,
                                color: Colors.white,
                                size: 10,
                              ),
                            ),
                          ),
                      ],
                    ),

                    // Ruby indicator
                    if (hasRuby) ...[
                      const SizedBox(height: 4),
                      Icon(
                        Icons.diamond,
                        color: Colors.red.shade400,
                        size: isSelected ? 16 : 14,
                      ),
                    ],

                    // Always show points if available
                    if (points > 0) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryColor.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '+$points',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isSelected ? 10 : 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],

                    // Chips display
                    if (hasChips) ...[
                      const SizedBox(height: 4),
                      Column(
                        children: [
                          // Show first 2 chips
                          ...chipsHere
                              .take(isSelected ? 3 : 2)
                              .map(
                                (chip) => Container(
                                  width: isSelected ? 22 : 18,
                                  height: isSelected ? 22 : 18,
                                  margin: const EdgeInsets.only(bottom: 2),
                                  decoration: BoxDecoration(
                                    color: widget.getIngredientColor(
                                      chip.color,
                                    ),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${chip.value}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: isSelected ? 9 : 8,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          if (chipsHere.length > (isSelected ? 3 : 2))
                            Text(
                              '+${chipsHere.length - (isSelected ? 3 : 2)}',
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 8,
                              ),
                            ),
                        ],
                      ),
                      // Show total value if dangerous
                      if (isSelected && (isNearExplosion || wouldExplode))
                        Text(
                          'Total: $totalChipValue',
                          style: TextStyle(
                            color: wouldExplode ? Colors.red : Colors.orange,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ] else if (widget.canPlaceChips &&
                        drawnChips.isNotEmpty &&
                        isSelected) ...[
                      const SizedBox(height: 4),
                      Icon(
                        Icons.add_circle_outline,
                        color: AppTheme.primaryColor,
                        size: 20,
                      ),
                      Text(
                        'Tap',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],

                    // Status text
                    if (isSelected) ...[
                      const SizedBox(height: 2),
                      // Removed CURRENT label
                      if (wouldExplode)
                        const Text(
                          'BOOM!',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      else if (isNearExplosion)
                        const Text(
                          'RISKY',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Quick jump to current position
        IconButton(
          onPressed: () {
            final currentPos = widget.player.potState.scoringPosition;
            setState(() {
              _selectedPosition = currentPos;
            });
            _scrollToPosition(currentPos);
          },
          icon: const Icon(Icons.my_location),
          color: AppTheme.primaryColor,
          tooltip: 'Jump to current position',
        ),

        const SizedBox(width: 16),

        // Position indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Text(
            'Position $_selectedPosition',
            style: AppTheme.bodyStyle.copyWith(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(width: 16),

        // Navigate buttons
        IconButton(
          onPressed: _selectedPosition > 0
              ? () {
                  setState(() {
                    _selectedPosition--;
                  });
                  _scrollToPosition(_selectedPosition);
                }
              : null,
          icon: const Icon(Icons.chevron_left),
          color: Colors.white70,
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _selectedPosition++;
            });
            _scrollToPosition(_selectedPosition);
          },
          icon: const Icon(Icons.chevron_right),
          color: Colors.white70,
        ),
      ],
    );
  }
}
