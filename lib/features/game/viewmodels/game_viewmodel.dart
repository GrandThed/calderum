import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_state_model.dart';
import '../models/ingredient_model.dart';
import '../services/game_service.dart';
import '../../account/services/auth_service.dart';

part 'game_viewmodel.g.dart';

/// Stream provider for game state
@riverpod
Stream<GameState> gameStream(Ref ref, String gameId) {
  final gameService = ref.watch(gameServiceProvider);
  return gameService.streamGame(gameId);
}

/// Provider for game actions
@riverpod
class GameViewModel extends _$GameViewModel {
  @override
  AsyncValue<void> build(String gameId) {
    return const AsyncValue.data(null);
  }

  Future<void> drawChip() async {
    state = const AsyncValue.loading();

    try {
      final authService = ref.read(authServiceProvider);
      final gameService = ref.read(gameServiceProvider);

      final currentUser = await authService.getCurrentUserModel();
      if (currentUser == null) {
        throw 'User not authenticated';
      }

      // Get current game state to determine available chips
      final gameState = await gameService.getGameById(gameId);
      if (gameState == null) throw 'Game not found';

      final player = gameState.players.firstWhere(
        (p) => p.userId == currentUser.uid,
        orElse: () => throw 'Player not found in game',
      );

      final availableChips = player.ingredientBag.availableChips;
      if (availableChips.isEmpty) {
        throw 'No chips available to draw';
      }

      // Create draw action with placeholder chip (will be randomly selected by service)
      final action = GameAction.drawChip(
        playerId: currentUser.uid,
        chip: availableChips.first, // Service will select random chip
      );

      await gameService.applyAction(gameId, action);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> placeChip(IngredientChip chip, int position) async {
    state = const AsyncValue.loading();

    try {
      final authService = ref.read(authServiceProvider);
      final gameService = ref.read(gameServiceProvider);

      final currentUser = await authService.getCurrentUserModel();
      if (currentUser == null) {
        throw 'User not authenticated';
      }

      final action = GameAction.placeChip(
        playerId: currentUser.uid,
        chip: chip,
        position: position,
      );

      await gameService.applyAction(gameId, action);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> useFlask(IngredientChip whiteChip) async {
    state = const AsyncValue.loading();

    try {
      final authService = ref.read(authServiceProvider);
      final gameService = ref.read(gameServiceProvider);

      final currentUser = await authService.getCurrentUserModel();
      if (currentUser == null) {
        throw 'User not authenticated';
      }

      final action = GameAction.useFlask(
        playerId: currentUser.uid,
        returnedChip: whiteChip,
      );

      await gameService.applyAction(gameId, action);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> stopDrawing() async {
    state = const AsyncValue.loading();

    try {
      final authService = ref.read(authServiceProvider);
      final gameService = ref.read(gameServiceProvider);

      final currentUser = await authService.getCurrentUserModel();
      if (currentUser == null) {
        throw 'User not authenticated';
      }

      final action = GameAction.stopDrawing(playerId: currentUser.uid);

      await gameService.applyAction(gameId, action);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> buyIngredient(AvailableIngredient ingredient) async {
    state = const AsyncValue.loading();

    try {
      final authService = ref.read(authServiceProvider);
      final gameService = ref.read(gameServiceProvider);

      final currentUser = await authService.getCurrentUserModel();
      if (currentUser == null) {
        throw 'User not authenticated';
      }

      final action = GameAction.buyIngredient(
        playerId: currentUser.uid,
        ingredient: ingredient,
      );

      await gameService.applyAction(gameId, action);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> useRubies(String rubyAction, int rubyCount) async {
    state = const AsyncValue.loading();

    try {
      final authService = ref.read(authServiceProvider);
      final gameService = ref.read(gameServiceProvider);

      final currentUser = await authService.getCurrentUserModel();
      if (currentUser == null) {
        throw 'User not authenticated';
      }

      final action = GameAction.useRubies(
        playerId: currentUser.uid,
        action: rubyAction,
        rubyCount: rubyCount,
      );

      await gameService.applyAction(gameId, action);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> completePhase() async {
    state = const AsyncValue.loading();

    try {
      final authService = ref.read(authServiceProvider);
      final gameService = ref.read(gameServiceProvider);

      final currentUser = await authService.getCurrentUserModel();
      if (currentUser == null) {
        throw 'User not authenticated';
      }

      final action = GameAction.completePhase(playerId: currentUser.uid);

      await gameService.applyAction(gameId, action);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

/// Provider for phase management (host only)
@riverpod
class PhaseManagerViewModel extends _$PhaseManagerViewModel {
  @override
  AsyncValue<void> build(String gameId) {
    return const AsyncValue.data(null);
  }

  Future<void> nextPhase() async {
    state = const AsyncValue.loading();

    try {
      final gameService = ref.read(gameServiceProvider);
      final action = GameAction.nextPhase();

      await gameService.applyAction(gameId, action);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> nextTurn() async {
    state = const AsyncValue.loading();

    try {
      final gameService = ref.read(gameServiceProvider);
      final action = GameAction.nextTurn();

      await gameService.applyAction(gameId, action);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> calculateRatsPositions() async {
    state = const AsyncValue.loading();

    try {
      final gameService = ref.read(gameServiceProvider);
      await gameService.calculateRatsPositions(gameId);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

/// Convenience provider to get current player from game
@riverpod
GamePlayer? currentPlayer(Ref ref, String gameId) {
  final gameState = ref.watch(gameStreamProvider(gameId));
  final currentUser = ref.watch(authServiceProvider).currentUser;

  return gameState.whenOrNull(
    data: (state) => state.players.firstWhere(
      (p) => p.userId == currentUser?.uid,
      orElse: () => throw 'Player not found in game',
    ),
  );
}

/// Provider to check if current user is host
@riverpod
bool isHost(Ref ref, String gameId) {
  final gameState = ref.watch(gameStreamProvider(gameId));
  final currentUser = ref.watch(authServiceProvider).currentUser;

  return gameState.whenOrNull(
        data: (state) {
          // In this game, the first player in turn order is considered the host
          return state.turnOrder.isNotEmpty &&
              state.turnOrder.first == currentUser?.uid;
        },
      ) ??
      false;
}

/// Provider for opponent players (all except current user)
@riverpod
List<GamePlayer> opponents(Ref ref, String gameId) {
  final gameState = ref.watch(gameStreamProvider(gameId));
  final currentUser = ref.watch(authServiceProvider).currentUser;

  return gameState.whenOrNull(
        data: (state) =>
            state.players.where((p) => p.userId != currentUser?.uid).toList(),
      ) ??
      [];
}
