import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/calderum_app_bar.dart';
import '../../../shared/widgets/calderum_button.dart';
import '../models/game_state_model.dart';
import '../models/ingredient_model.dart';
import '../viewmodels/game_viewmodel.dart';
import '../widgets/pot_widget.dart';
import '../widgets/ingredient_bag_widget.dart';
import '../widgets/game_phase_indicator.dart';
import '../widgets/player_info_panel.dart';
import '../widgets/ingredient_market_widget.dart';

class GameBoardView extends ConsumerWidget {
  final String gameId;

  const GameBoardView({super.key, required this.gameId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStreamProvider(gameId));
    final currentPlayer = ref.watch(currentPlayerProvider(gameId));
    final isHostValue = ref.watch(isHostProvider(gameId));

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
            child: Column(
              children: [
                // Game Phase Indicator
                GamePhaseIndicator(
                  currentPhase: state.currentPhase,
                  currentTurn: state.currentTurn,
                ),

                Expanded(
                  child: Row(
                    children: [
                      // Left Panel - Player Info & Opponents
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            // Current Player Info
                            PlayerInfoPanel(
                              player: currentPlayer,
                              isCurrentPlayer: true,
                            ),

                            const SizedBox(height: 16),

                            // Opponents Info
                            Expanded(child: _buildOpponentsList(ref, state)),
                          ],
                        ),
                      ),

                      // Center - Game Board (Pot)
                      Expanded(
                        flex: 3,
                        child: _buildGameBoard(
                          context,
                          ref,
                          currentPlayer,
                          state,
                        ),
                      ),

                      // Right Panel - Ingredient Bag & Market
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            // Ingredient Bag
                            Expanded(
                              flex: 2,
                              child: IngredientBagWidget(
                                ingredientBag: currentPlayer.ingredientBag,
                                onDrawChip:
                                    state.currentPhase == GamePhase.potions
                                    ? () => _drawChip(ref)
                                    : null,
                                canDraw: _canDrawChips(currentPlayer, state),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Ingredient Market (during buy phase)
                            if (state.currentPhase == GamePhase.evaluationE)
                              Expanded(
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
                    ],
                  ),
                ),

                // Bottom Action Bar
                _buildActionBar(context, ref, currentPlayer, state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGameBoard(
    BuildContext context,
    WidgetRef ref,
    GamePlayer player,
    GameState state,
  ) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Pot/Cauldron
          Expanded(
            flex: 3,
            child: PotWidget(
              potState: player.potState,
              onChipPlaced: state.currentPhase == GamePhase.potions
                  ? (chip, position) => _placeChip(ref, chip, position)
                  : null,
              drawnChips: player.ingredientBag.drawnThisTurn,
              canPlaceChips: _canPlaceChips(player, state),
            ),
          ),

          const SizedBox(height: 16),

          // Game Controls
          if (state.currentPhase == GamePhase.potions)
            _buildPotionPhaseControls(ref, player),
        ],
      ),
    );
  }

  Widget _buildOpponentsList(WidgetRef ref, GameState state) {
    final opponents = ref.watch(opponentsProvider(gameId));

    return ListView.builder(
      itemCount: opponents.length,
      itemBuilder: (context, index) {
        final opponent = opponents[index];
        return PlayerInfoPanel(
          player: opponent,
          isCurrentPlayer: false,
          compact: true,
        );
      },
    );
  }

  Widget _buildPotionPhaseControls(WidgetRef ref, GamePlayer player) {
    final hasDrawnChips = player.ingredientBag.drawnThisTurn.isNotEmpty;
    final hasWhiteChips = player.ingredientBag.drawnThisTurn.any(
      (chip) => chip.color == IngredientColor.white,
    );
    final canUseFlask = player.potState.flaskAvailable && hasWhiteChips;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (canUseFlask)
          CalderumButton(
            text: 'Use Flask',
            onPressed: () => _useFlask(ref, player),
            icon: Icons.local_drink,
            style: CalderumButtonStyle.secondary,
          ),

        if (hasDrawnChips || player.potState.hasExploded)
          CalderumButton(
            text: 'Stop Drawing',
            onPressed: () => _stopDrawing(ref),
            icon: Icons.stop,
            style: CalderumButtonStyle.primary,
          ),
      ],
    );
  }

  Widget _buildActionBar(
    BuildContext context,
    WidgetRef ref,
    GamePlayer player,
    GameState state,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        children: [
          // Phase completion status
          Expanded(
            child: Text(
              player.hasCompletedPhase
                  ? 'Waiting for other players...'
                  : 'Complete your turn',
              style: AppTheme.bodyStyle.copyWith(color: Colors.white70),
            ),
          ),

          // Game status
          if (state.currentPhase != GamePhase.potions &&
              !player.hasCompletedPhase)
            CalderumButton(
              text: 'Ready',
              onPressed: () => _completePhase(ref),
              icon: Icons.check,
              style: CalderumButtonStyle.primary,
            ),
        ],
      ),
    );
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
  }

  void _placeChip(WidgetRef ref, IngredientChip chip, int position) {
    ref.read(gameViewModelProvider(gameId).notifier).placeChip(chip, position);
  }

  void _useFlask(WidgetRef ref, GamePlayer player) {
    // Find last white chip that can be returned
    final whiteChips = player.potState.placedChips
        .where((chip) => chip.color == IngredientColor.white)
        .toList();

    if (whiteChips.isNotEmpty) {
      final lastWhiteChip = whiteChips.last;
      ref.read(gameViewModelProvider(gameId).notifier).useFlask(lastWhiteChip);
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
