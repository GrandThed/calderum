import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_state_model.dart';
import '../models/ingredient_model.dart';
import '../models/sync_model.dart';

/// Provider for current game state
class GameStateNotifier extends StateNotifier<GameState?> {
  GameStateNotifier() : super(null);

  void updateState(GameState newState) {
    state = newState;
  }

  void forceUpdateState(GameState newState) {
    state = newState;
  }

  void applyAction(GameAction action) {
    if (state == null) return;
    
    // Apply action to current state
    final updatedState = _applyActionToState(state!, action);
    state = updatedState;
  }

  GameState _applyActionToState(GameState currentState, GameAction action) {
    return action.when(
      drawChip: (playerId, chip) => _applyDrawChip(currentState, playerId, chip),
      placeChip: (playerId, chip, position) => 
          _applyPlaceChip(currentState, playerId, chip, position),
      useFlask: (playerId, returnedChip) => 
          _applyUseFlask(currentState, playerId, returnedChip),
      stopDrawing: (playerId) => _applyStopDrawing(currentState, playerId),
      completePhase: (playerId) => _applyCompletePhase(currentState, playerId),
      nextPhase: () => _applyNextPhase(currentState),
      nextTurn: () => _applyNextTurn(currentState),
      buyIngredient: (playerId, ingredient) => 
          _applyBuyIngredient(currentState, playerId, ingredient),
      useRubies: (playerId, action, rubyCount) => 
          _applyUseRubies(currentState, playerId, action, rubyCount),
    );
  }

  GameState _applyDrawChip(GameState state, String playerId, IngredientChip chip) {
    final players = state.players.map((player) {
      if (player.userId == playerId) {
        // Update player's bag to remove drawn chip
        final updatedBag = player.ingredientBag.copyWith(
          chips: player.ingredientBag.chips
              .where((c) => c.id != chip.id)
              .toList(),
        );
        return player.copyWith(
          ingredientBag: updatedBag,
          lastAction: DateTime.now(),
        );
      }
      return player;
    }).toList();

    return state.copyWith(
      players: players,
      updatedAt: DateTime.now(),
    );
  }

  GameState _applyPlaceChip(GameState state, String playerId, IngredientChip chip, int position) {
    final players = state.players.map((player) {
      if (player.userId == playerId) {
        final placedChip = chip.copyWith(
          positionOnBoard: position,
          isOnBoard: true,
        );
        
        final updatedPot = player.potState.copyWith(
          placedChips: [...player.potState.placedChips, placedChip],
        );

        return player.copyWith(
          potState: updatedPot,
          lastAction: DateTime.now(),
        );
      }
      return player;
    }).toList();

    return state.copyWith(
      players: players,
      updatedAt: DateTime.now(),
    );
  }

  GameState _applyUseFlask(GameState state, String playerId, IngredientChip returnedChip) {
    final players = state.players.map((player) {
      if (player.userId == playerId) {
        final updatedChips = player.potState.placedChips
            .where((chip) => chip.id != returnedChip.id)
            .toList();

        final updatedPot = player.potState.copyWith(
          placedChips: updatedChips,
          flaskAvailable: false,
        );

        return player.copyWith(
          potState: updatedPot,
          lastAction: DateTime.now(),
        );
      }
      return player;
    }).toList();

    return state.copyWith(
      players: players,
      updatedAt: DateTime.now(),
    );
  }

  GameState _applyStopDrawing(GameState state, String playerId) {
    final players = state.players.map((player) {
      if (player.userId == playerId) {
        return player.copyWith(
          hasCompletedPhase: true,
          lastAction: DateTime.now(),
        );
      }
      return player;
    }).toList();

    return state.copyWith(
      players: players,
      updatedAt: DateTime.now(),
    );
  }

  GameState _applyCompletePhase(GameState state, String playerId) {
    final players = state.players.map((player) {
      if (player.userId == playerId) {
        return player.copyWith(
          hasCompletedPhase: true,
          lastAction: DateTime.now(),
        );
      }
      return player;
    }).toList();

    return state.copyWith(
      players: players,
      updatedAt: DateTime.now(),
    );
  }

  GameState _applyNextPhase(GameState state) {
    final nextPhase = _getNextPhase(state.currentPhase);
    
    // Reset player completion status for new phase
    final players = state.players.map((player) {
      return player.copyWith(hasCompletedPhase: false);
    }).toList();

    return state.copyWith(
      currentPhase: nextPhase,
      players: players,
      updatedAt: DateTime.now(),
    );
  }

  GameState _applyNextTurn(GameState state) {
    final players = state.players.map((player) {
      return player.copyWith(
        hasCompletedPhase: false,
        potState: player.potState.copyWith(
          flaskAvailable: true, // Reset flask for new turn
          hasExploded: false, // Reset explosion status
        ),
      );
    }).toList();

    return state.copyWith(
      currentTurn: state.currentTurn + 1,
      currentPhase: GamePhase.fortuneTeller,
      players: players,
      updatedAt: DateTime.now(),
    );
  }

  GameState _applyBuyIngredient(GameState state, String playerId, AvailableIngredient ingredient) {
    final players = state.players.map((player) {
      if (player.userId == playerId) {
        final updatedPot = player.potState.copyWith(
          coins: player.potState.coins - ingredient.cost,
        );
        
        // Add ingredient to bag (simplified)
        final newChip = IngredientChip(
          id: '${playerId}_${ingredient.color.name}_${ingredient.value}_${DateTime.now().millisecondsSinceEpoch}',
          color: ingredient.color,
          value: ingredient.value.toInt(),
          isInBag: true,
        );

        final updatedBag = player.ingredientBag.copyWith(
          chips: [...player.ingredientBag.chips, newChip],
        );

        return player.copyWith(
          potState: updatedPot,
          ingredientBag: updatedBag,
          lastAction: DateTime.now(),
        );
      }
      return player;
    }).toList();

    return state.copyWith(
      players: players,
      updatedAt: DateTime.now(),
    );
  }

  GameState _applyUseRubies(GameState state, String playerId, String action, int rubyCount) {
    final players = state.players.map((player) {
      if (player.userId == playerId) {
        var updatedPot = player.potState.copyWith(
          rubies: player.potState.rubies - rubyCount,
        );

        if (action == 'move_droplet') {
          updatedPot = updatedPot.copyWith(
            dropletPosition: updatedPot.dropletPosition + 1,
          );
        } else if (action == 'refill_flask') {
          updatedPot = updatedPot.copyWith(flaskAvailable: true);
        }

        return player.copyWith(
          potState: updatedPot,
          lastAction: DateTime.now(),
        );
      }
      return player;
    }).toList();

    return state.copyWith(
      players: players,
      updatedAt: DateTime.now(),
    );
  }

  GamePhase _getNextPhase(GamePhase currentPhase) {
    switch (currentPhase) {
      case GamePhase.fortuneTeller:
        return GamePhase.rats;
      case GamePhase.rats:
        return GamePhase.potions;
      case GamePhase.potions:
        return GamePhase.evaluationA;
      case GamePhase.evaluationA:
        return GamePhase.evaluationB;
      case GamePhase.evaluationB:
        return GamePhase.evaluationC;
      case GamePhase.evaluationC:
        return GamePhase.evaluationD;
      case GamePhase.evaluationD:
        return GamePhase.evaluationE;
      case GamePhase.evaluationE:
        return GamePhase.evaluationF;
      case GamePhase.evaluationF:
        return GamePhase.gameOver;
      case GamePhase.gameOver:
        return GamePhase.gameOver;
    }
  }
}

/// Provider for connection status
class ConnectionStatusNotifier extends StateNotifier<ConnectionStatus> {
  ConnectionStatusNotifier() : super(ConnectionStatus.connected);

  void updateStatus(ConnectionStatus status) {
    state = status;
  }
}

/// Game state provider
final gameStateProvider = StateNotifierProvider<GameStateNotifier, GameState?>(
  (ref) => GameStateNotifier(),
);

/// Connection status provider
final connectionStatusProvider = StateNotifierProvider<ConnectionStatusNotifier, ConnectionStatus>(
  (ref) => ConnectionStatusNotifier(),
);