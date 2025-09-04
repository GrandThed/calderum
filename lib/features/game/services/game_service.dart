import 'dart:math';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_state_model.dart';
import '../models/ingredient_model.dart';
import '../../account/models/user_model.dart';
import '../../room/models/room_model.dart';
import '../../../shared/utils/json_converter.dart';
import 'scoring_service.dart';
import 'explosion_service.dart';

final gameServiceProvider = Provider<GameService>((ref) {
  return GameService(FirebaseFirestore.instance);
});

class GameService {
  final FirebaseFirestore _firestore;
  static const String _gamesCollection = 'games';

  GameService(this._firestore);

  /// Create new game from room
  Future<GameState> createGameFromRoom({
    required String roomId,
    required List<UserModel> players,
  }) async {
    final gameId = _firestore.collection(_gamesCollection).doc().id;

    final gameState = GameStateOperations.createNewGame(
      gameId: gameId,
      roomId: roomId,
      roomPlayers: players,
    );

    // Save to Firestore with proper JSON conversion
    try {
      await _firestore
          .collection(_gamesCollection)
          .doc(gameId)
          .set(JsonConverter.toFirestoreJson(gameState));
    } catch (e, stackTrace) {
      print('Error saving game state: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }

    // Update room status to in_progress
    await _firestore.collection('rooms').doc(roomId).update({
      'status': RoomStatus.inProgress.name,
      'gameId': gameId,
      'updatedAt': DateTime.now().toIso8601String(),
    });

    return gameState;
  }

  /// Get game by ID
  Future<GameState?> getGameById(String gameId) async {
    final doc = await _firestore.collection(_gamesCollection).doc(gameId).get();
    if (!doc.exists) return null;

    return GameState.fromJson({...doc.data()!, 'gameId': doc.id});
  }

  /// Stream game state changes
  Stream<GameState> streamGame(String gameId) {
    return _firestore
        .collection(_gamesCollection)
        .doc(gameId)
        .snapshots()
        .map((doc) => GameState.fromJson({...doc.data()!, 'gameId': doc.id}));
  }

  /// Apply game action to update state
  Future<GameState> applyAction(String gameId, GameAction action) async {
    final doc = await _firestore.collection(_gamesCollection).doc(gameId).get();
    if (!doc.exists) throw 'Game not found';

    final currentState = GameState.fromJson({...doc.data()!, 'gameId': doc.id});
    final newState = _processAction(currentState, action);

    // Save updated state
    await _firestore
        .collection(_gamesCollection)
        .doc(gameId)
        .update(JsonConverter.toFirestoreJson(newState));

    return newState;
  }

  /// Process game action and return new state
  GameState _processAction(GameState currentState, GameAction action) {
    return action.when(
      drawChip: (playerId, chip) =>
          _processDrawChip(currentState, playerId, chip),
      placeChip: (playerId, chip, position) =>
          _processPlaceChip(currentState, playerId, chip, position),
      useFlask: (playerId, returnedChip) =>
          _processUseFlask(currentState, playerId, returnedChip),
      stopDrawing: (playerId) => _processStopDrawing(currentState, playerId),
      completePhase: (playerId) =>
          _processCompletePhase(currentState, playerId),
      nextPhase: () => _processNextPhase(currentState),
      nextTurn: () => _processNextTurn(currentState),
      buyIngredient: (playerId, ingredient) =>
          _processBuyIngredient(currentState, playerId, ingredient),
      useRubies: (playerId, action, rubyCount) =>
          _processUseRubies(currentState, playerId, action, rubyCount),
    );
  }

  /// Draw chip from bag (random selection)
  GameState _processDrawChip(
    GameState state,
    String playerId,
    IngredientChip chip,
  ) {
    final playerIndex = state.players.indexWhere((p) => p.userId == playerId);
    if (playerIndex == -1) throw 'Player not found';

    final player = state.players[playerIndex];
    final availableChips = player.ingredientBag.availableChips;

    if (availableChips.isEmpty) {
      throw 'No chips available to draw';
    }

    // Randomly select a chip from available chips
    final random = Random();
    final drawnChip = availableChips[random.nextInt(availableChips.length)];

    // Update chip to be drawn (not in bag, not on board yet)
    final updatedChip = drawnChip.copyWith(isInBag: false, isOnBoard: false);

    // Update bag with drawn chip
    final updatedBag = player.ingredientBag.copyWith(
      chips: player.ingredientBag.chips
          .map((c) => c.id == drawnChip.id ? updatedChip : c)
          .toList(),
      drawnThisTurn: [...player.ingredientBag.drawnThisTurn, updatedChip],
    );

    // Update player
    final updatedPlayer = player.copyWith(
      ingredientBag: updatedBag,
      lastAction: DateTime.now(),
    );

    // Update state
    final updatedPlayers = [...state.players];
    updatedPlayers[playerIndex] = updatedPlayer;

    return state.copyWith(players: updatedPlayers, updatedAt: DateTime.now());
  }

  /// Place chip on pot at specified position
  GameState _processPlaceChip(
    GameState state,
    String playerId,
    IngredientChip chip,
    int position,
  ) {
    final playerIndex = state.players.indexWhere((p) => p.userId == playerId);
    if (playerIndex == -1) throw 'Player not found';

    final player = state.players[playerIndex];

    // Validate position
    if (!player.potState.isValidPosition(position)) {
      throw 'Invalid position: $position';
    }

    // Check if placing this chip would cause explosion
    if (ExplosionService.wouldCauseExplosion(
      player.potState.placedChips,
      chip,
    )) {
      // Allow placement but mark as explosion risk
      // Player may still choose to place it (push your luck mechanic)
    }

    // Update chip to be on board
    final placedChip = chip.copyWith(
      isOnBoard: true,
      positionOnBoard: position,
    );

    // Update pot state
    var updatedPotState = player.potState.copyWith(
      placedChips: [...player.potState.placedChips, placedChip],
    );

    // Check for explosion using explosion service
    if (ExplosionService.hasExploded(updatedPotState.placedChips)) {
      updatedPotState = ExplosionService.applyExplosionEffects(
        currentPotState: updatedPotState,
        currentRound: state.currentTurn,
      );
    }

    // Update bag (remove from drawn this turn)
    final updatedBag = player.ingredientBag.copyWith(
      chips: player.ingredientBag.chips
          .map((c) => c.id == chip.id ? placedChip : c)
          .toList(),
      drawnThisTurn: player.ingredientBag.drawnThisTurn
          .where((c) => c.id != chip.id)
          .toList(),
    );

    // Update player
    final updatedPlayer = player.copyWith(
      potState: updatedPotState,
      ingredientBag: updatedBag,
      lastAction: DateTime.now(),
    );

    // Update state
    final updatedPlayers = [...state.players];
    updatedPlayers[playerIndex] = updatedPlayer;

    return state.copyWith(players: updatedPlayers, updatedAt: DateTime.now());
  }

  /// Use flask to return white chip to bag
  GameState _processUseFlask(
    GameState state,
    String playerId,
    IngredientChip returnedChip,
  ) {
    final playerIndex = state.players.indexWhere((p) => p.userId == playerId);
    if (playerIndex == -1) throw 'Player not found';

    final player = state.players[playerIndex];

    if (!player.potState.flaskAvailable) {
      throw 'Flask not available';
    }

    if (returnedChip.color != IngredientColor.white) {
      throw 'Can only return white chips with flask';
    }

    // Return chip to bag
    final returnedToBag = returnedChip.copyWith(
      isInBag: true,
      isOnBoard: false,
      positionOnBoard: null,
    );

    // Update bag
    final updatedBag = player.ingredientBag.copyWith(
      chips: player.ingredientBag.chips
          .map((c) => c.id == returnedChip.id ? returnedToBag : c)
          .toList(),
      drawnThisTurn: player.ingredientBag.drawnThisTurn
          .where((c) => c.id != returnedChip.id)
          .toList(),
    );

    // Update pot state (remove chip and use flask)
    final updatedPotState = player.potState.copyWith(
      placedChips: player.potState.placedChips
          .where((c) => c.id != returnedChip.id)
          .toList(),
      flaskAvailable: false,
    );

    // Update player
    final updatedPlayer = player.copyWith(
      potState: updatedPotState,
      ingredientBag: updatedBag,
      lastAction: DateTime.now(),
    );

    // Update state
    final updatedPlayers = [...state.players];
    updatedPlayers[playerIndex] = updatedPlayer;

    return state.copyWith(players: updatedPlayers, updatedAt: DateTime.now());
  }

  /// Stop drawing chips for this turn
  GameState _processStopDrawing(GameState state, String playerId) {
    final playerIndex = state.players.indexWhere((p) => p.userId == playerId);
    if (playerIndex == -1) throw 'Player not found';

    final player = state.players[playerIndex];

    // Mark player as having completed phase
    final updatedPlayer = player.copyWith(
      hasCompletedPhase: true,
      lastAction: DateTime.now(),
    );

    // Update state
    final updatedPlayers = [...state.players];
    updatedPlayers[playerIndex] = updatedPlayer;

    return state.copyWith(players: updatedPlayers, updatedAt: DateTime.now());
  }

  /// Mark player as having completed current phase
  GameState _processCompletePhase(GameState state, String playerId) {
    final playerIndex = state.players.indexWhere((p) => p.userId == playerId);
    if (playerIndex == -1) throw 'Player not found';

    final player = state.players[playerIndex];

    // Mark player as having completed phase
    final updatedPlayer = player.copyWith(
      hasCompletedPhase: true,
      lastAction: DateTime.now(),
    );

    // Update state
    final updatedPlayers = [...state.players];
    updatedPlayers[playerIndex] = updatedPlayer;

    return state.copyWith(players: updatedPlayers, updatedAt: DateTime.now());
  }

  /// Move to next phase
  GameState _processNextPhase(GameState state) {
    // Only advance if all players are ready
    if (!state.allPlayersReady) {
      throw 'Not all players have completed the current phase';
    }

    GamePhase nextPhase;
    switch (state.currentPhase) {
      case GamePhase.fortuneTeller:
        nextPhase = GamePhase.rats;
        break;
      case GamePhase.rats:
        nextPhase = GamePhase.potions;
        break;
      case GamePhase.potions:
        nextPhase = GamePhase.evaluationA;
        break;
      case GamePhase.evaluationA:
        nextPhase = GamePhase.evaluationB;
        break;
      case GamePhase.evaluationB:
        nextPhase = GamePhase.evaluationC;
        break;
      case GamePhase.evaluationC:
        nextPhase = GamePhase.evaluationD;
        break;
      case GamePhase.evaluationD:
        nextPhase = GamePhase.evaluationE;
        break;
      case GamePhase.evaluationE:
        nextPhase = GamePhase.evaluationF;
        break;
      case GamePhase.evaluationF:
        // End turn, go to next turn or end game
        if (state.currentTurn >= 9) {
          nextPhase = GamePhase.gameOver;
        } else {
          nextPhase = GamePhase.fortuneTeller;
        }
        break;
      case GamePhase.gameOver:
        throw 'Game is already over';
    }

    // Reset player completion status for new phase
    final resetPlayers = state.players
        .map((player) => player.copyWith(hasCompletedPhase: false))
        .toList();

    return state.copyWith(
      currentPhase: nextPhase,
      players: resetPlayers,
      updatedAt: DateTime.now(),
    );
  }

  /// Move to next turn
  GameState _processNextTurn(GameState state) {
    if (state.currentTurn >= 9) {
      throw 'Game is already at final turn';
    }

    // Reset players for new turn
    final resetPlayers = state.players
        .map(
          (player) => player.copyWith(
            hasCompletedPhase: false,
            potState: player.potState.copyWith(
              hasExploded: false,
              flaskAvailable: true,
              ratPosition: null, // Will be recalculated in rats phase
            ),
            ingredientBag: player.ingredientBag.copyWith(drawnThisTurn: []),
          ),
        )
        .toList();

    // Update ingredient market for new turn
    final newTurn = state.currentTurn + 1;
    final updatedMarket = IngredientMarketOperations.createForTurn(newTurn);

    return state.copyWith(
      currentTurn: newTurn,
      currentPhase: GamePhase.fortuneTeller,
      players: resetPlayers,
      ingredientMarket: updatedMarket,
      updatedAt: DateTime.now(),
    );
  }

  /// Buy ingredient from market
  GameState _processBuyIngredient(
    GameState state,
    String playerId,
    AvailableIngredient ingredient,
  ) {
    final playerIndex = state.players.indexWhere((p) => p.userId == playerId);
    if (playerIndex == -1) throw 'Player not found';

    final player = state.players[playerIndex];

    // Check if player has enough coins
    if (player.potState.coins < ingredient.cost) {
      throw 'Not enough coins. Need ${ingredient.cost}, have ${player.potState.coins}';
    }

    // Create new chip for player
    final newChip = IngredientChip(
      id: '${playerId}_${ingredient.color.name}_${ingredient.value}_${DateTime.now().millisecondsSinceEpoch}',
      color: ingredient.color,
      value: ingredient.value,
      isInBag: true,
    );

    // Update bag
    final updatedBag = player.ingredientBag.copyWith(
      chips: [...player.ingredientBag.chips, newChip],
    );

    // Update pot state (spend coins)
    final updatedPotState = player.potState.copyWith(
      coins: player.potState.coins - ingredient.cost,
    );

    // Update player
    final updatedPlayer = player.copyWith(
      potState: updatedPotState,
      ingredientBag: updatedBag,
      lastAction: DateTime.now(),
    );

    // Update state
    final updatedPlayers = [...state.players];
    updatedPlayers[playerIndex] = updatedPlayer;

    return state.copyWith(players: updatedPlayers, updatedAt: DateTime.now());
  }

  /// Use rubies for actions
  GameState _processUseRubies(
    GameState state,
    String playerId,
    String action,
    int rubyCount,
  ) {
    final playerIndex = state.players.indexWhere((p) => p.userId == playerId);
    if (playerIndex == -1) throw 'Player not found';

    final player = state.players[playerIndex];

    // Check if player has enough rubies
    if (player.potState.rubies < rubyCount) {
      throw 'Not enough rubies. Need $rubyCount, have ${player.potState.rubies}';
    }

    PotState updatedPotState = player.potState;

    switch (action) {
      case 'move_droplet':
        if (rubyCount != 2) throw 'Moving droplet costs 2 rubies';
        updatedPotState = updatedPotState.copyWith(
          dropletPosition: updatedPotState.dropletPosition + 1,
          rubies: updatedPotState.rubies - 2,
        );
        break;
      case 'refill_flask':
        if (rubyCount != 2) throw 'Refilling flask costs 2 rubies';
        updatedPotState = updatedPotState.copyWith(
          flaskAvailable: true,
          rubies: updatedPotState.rubies - 2,
        );
        break;
      default:
        throw 'Unknown ruby action: $action';
    }

    // Update player
    final updatedPlayer = player.copyWith(
      potState: updatedPotState,
      lastAction: DateTime.now(),
    );

    // Update state
    final updatedPlayers = [...state.players];
    updatedPlayers[playerIndex] = updatedPlayer;

    return state.copyWith(players: updatedPlayers, updatedAt: DateTime.now());
  }

  /// Calculate scores for all players (Evaluation D - Victory Points)
  Future<GameState> calculateScores(String gameId, int ingredientSet) async {
    final state = await getGameById(gameId);
    if (state == null) throw 'Game not found';

    final updatedPlayers = state.players.map((player) {
      // Skip scoring if pot exploded (they choose coins OR points, not both)
      if (player.potState.hasExploded) {
        return player; // No automatic scoring for exploded pots
      }

      // Calculate final score using scoring service
      final scoreResult = ScoringService.calculateFinalScore(
        placedChips: player.potState.placedChips,
        finalPosition: player.potState.scoringPosition,
        currentRound: state.currentTurn,
        ingredientSet: ingredientSet,
        receivedBonusDie: state.bonusDieWinners.contains(player.userId),
        bonusDieResult: 0, // TODO: Track actual bonus die result
        previousVictoryPoints: player.potState.victoryPoints,
        rubies: player.potState.rubies,
      );

      // Update player with new scores
      final updatedPotState = player.potState.copyWith(
        victoryPoints: scoreResult['totalVictoryPoints'] as int,
        coins: scoreResult['coins'] as int,
        rubies: scoreResult['rubies'] as int,
      );

      return player.copyWith(
        potState: updatedPotState,
        lastAction: DateTime.now(),
      );
    }).toList();

    final updatedState = state.copyWith(
      players: updatedPlayers,
      updatedAt: DateTime.now(),
    );

    // Save updated state
    await _firestore
        .collection(_gamesCollection)
        .doc(gameId)
        .update(JsonConverter.toFirestoreJson(updatedState));

    return updatedState;
  }

  /// Roll bonus die for eligible players (Evaluation A)
  Future<GameState> rollBonusDie(String gameId) async {
    final state = await getGameById(gameId);
    if (state == null) throw 'Game not found';

    final eligiblePlayers = state.bonusDieEligiblePlayers;
    final random = Random();

    // Roll bonus die for each eligible player
    final bonusDieResults = <String, int>{};
    for (final player in eligiblePlayers) {
      bonusDieResults[player.userId] = random.nextInt(6) + 1;
    }

    final updatedPlayers = state.players.map((player) {
      if (bonusDieResults.containsKey(player.userId)) {
        final dieResult = bonusDieResults[player.userId]!;
        var updatedPotState = player.potState;

        // Apply bonus die effects
        switch (dieResult) {
          case 1:
            updatedPotState = updatedPotState.copyWith(
              victoryPoints: updatedPotState.victoryPoints + 1,
            );
            break;
          case 2:
            updatedPotState = updatedPotState.copyWith(
              victoryPoints: updatedPotState.victoryPoints + 2,
            );
            break;
          case 3:
            updatedPotState = updatedPotState.copyWith(
              rubies: updatedPotState.rubies + 1,
            );
            break;
          case 4:
            // Add orange chip to bag (handled in ingredient bag update)
            break;
          case 5:
            updatedPotState = updatedPotState.copyWith(
              dropletPosition: (updatedPotState.dropletPosition + 1).clamp(
                0,
                33,
              ),
            );
            break;
          case 6:
            // Special effect based on Fortune Teller card
            // TODO: Implement Fortune Teller specific effects
            break;
        }

        return player.copyWith(
          potState: updatedPotState,
          lastAction: DateTime.now(),
        );
      }
      return player;
    }).toList();

    final updatedState = state.copyWith(
      players: updatedPlayers,
      bonusDieWinners: bonusDieResults.keys.toList(),
      updatedAt: DateTime.now(),
    );

    // Save updated state
    await _firestore
        .collection(_gamesCollection)
        .doc(gameId)
        .update(JsonConverter.toFirestoreJson(updatedState));

    return updatedState;
  }

  /// Award rubies to players on ruby spaces (Evaluation C)
  Future<GameState> awardRubies(String gameId) async {
    final state = await getGameById(gameId);
    if (state == null) throw 'Game not found';

    final updatedPlayers = state.players.map((player) {
      if (ScoringService.isRubySpace(player.potState.scoringPosition)) {
        final updatedPotState = player.potState.copyWith(
          rubies: player.potState.rubies + 1,
        );
        return player.copyWith(
          potState: updatedPotState,
          lastAction: DateTime.now(),
        );
      }
      return player;
    }).toList();

    final updatedState = state.copyWith(
      players: updatedPlayers,
      updatedAt: DateTime.now(),
    );

    // Save updated state
    await _firestore
        .collection(_gamesCollection)
        .doc(gameId)
        .update(JsonConverter.toFirestoreJson(updatedState));

    return updatedState;
  }

  /// Calculate rats positions (catch-up mechanic)
  Future<GameState> calculateRatsPositions(String gameId) async {
    final state = await getGameById(gameId);
    if (state == null) throw 'Game not found';

    // Find leader (highest scoring position)
    final leader = state.playersByScore.first;
    final leaderPosition = leader.potState.scoringPosition;

    // Update rat positions for all other players
    final updatedPlayers = state.players.map((player) {
      if (player.userId == leader.userId) {
        // Leader gets no rat
        return player.copyWith(
          potState: player.potState.copyWith(ratPosition: null),
        );
      } else {
        // Calculate rat position based on distance from leader
        final playerPosition = player.potState.scoringPosition;
        final distance = leaderPosition - playerPosition;
        final ratPosition = player.potState.dropletPosition + distance;

        return player.copyWith(
          potState: player.potState.copyWith(
            ratPosition: ratPosition.clamp(0, 33),
          ),
        );
      }
    }).toList();

    final updatedState = state.copyWith(
      players: updatedPlayers,
      updatedAt: DateTime.now(),
    );

    // Save updated state
    await _firestore
        .collection(_gamesCollection)
        .doc(gameId)
        .update(JsonConverter.toFirestoreJson(updatedState));

    return updatedState;
  }
}
