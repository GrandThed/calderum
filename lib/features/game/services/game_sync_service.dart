import 'dart:async';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_state_model.dart';
import '../models/ingredient_model.dart';
import '../models/sync_model.dart';
import '../providers/game_providers.dart';

/// Service for real-time multiplayer game synchronization
class GameSyncService {
  final FirebaseFirestore _firestore;
  final Ref _ref;

  // Connection tracking
  StreamSubscription<DocumentSnapshot>? _gameStateSubscription;
  StreamSubscription<QuerySnapshot>? _actionsSubscription;
  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;

  // Action queue for offline/sync issues
  final List<PendingGameAction> _pendingActions = [];
  final Map<String, DateTime> _lastActionTimestamps = {};

  // Network status
  bool _isOnline = true;
  bool _isSynced = true;
  DateTime? _lastSyncTime;

  GameSyncService(this._firestore, this._ref);

  /// Initialize real-time synchronization for a game
  Future<void> initializeSync({
    required String gameId,
    required String playerId,
  }) async {
    await _setupGameStateListener(gameId);
    await _setupActionsListener(gameId);
    await _startHeartbeat(gameId, playerId);
  }

  /// Setup listener for game state changes
  Future<void> _setupGameStateListener(String gameId) async {
    _gameStateSubscription = _firestore
        .collection('games')
        .doc(gameId)
        .snapshots()
        .listen(
          _handleGameStateUpdate,
          onError: _handleSyncError,
        );
  }

  /// Setup listener for player actions
  Future<void> _setupActionsListener(String gameId) async {
    _actionsSubscription = _firestore
        .collection('games')
        .doc(gameId)
        .collection('actions')
        .where('timestamp', isGreaterThan: DateTime.now())
        .orderBy('timestamp')
        .snapshots()
        .listen(
          _handleActionsUpdate,
          onError: _handleSyncError,
        );
  }

  /// Start heartbeat to maintain connection
  Future<void> _startHeartbeat(String gameId, String playerId) async {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _sendHeartbeat(gameId, playerId),
    );
  }

  /// Send heartbeat to indicate player is still connected
  Future<void> _sendHeartbeat(String gameId, String playerId) async {
    try {
      await _firestore
          .collection('games')
          .doc(gameId)
          .collection('heartbeats')
          .doc(playerId)
          .set({
        'playerId': playerId,
        'timestamp': FieldValue.serverTimestamp(),
        'isOnline': true,
      });

      if (!_isOnline) {
        _isOnline = true;
        _notifyConnectionStatusChange(ConnectionStatus.connected);
      }
    } catch (e) {
      _isOnline = false;
      _notifyConnectionStatusChange(ConnectionStatus.disconnected);
      _startReconnection(gameId, playerId);
    }
  }

  /// Handle game state updates from Firestore
  void _handleGameStateUpdate(DocumentSnapshot snapshot) {
    if (!snapshot.exists) return;

    try {
      final gameState = GameState.fromJson(
        snapshot.data() as Map<String, dynamic>,
      );

      // Check for state reconciliation needs
      _reconcileGameState(gameState);

      // Update local state
      _ref.read(gameStateProvider.notifier).updateState(gameState);

      _lastSyncTime = DateTime.now();
      if (!_isSynced) {
        _isSynced = true;
        _notifyConnectionStatusChange(ConnectionStatus.synced);
      }
    } catch (e) {
      _handleSyncError(e);
    }
  }

  /// Handle incoming player actions
  void _handleActionsUpdate(QuerySnapshot snapshot) {
    for (final change in snapshot.docChanges) {
      if (change.type != DocumentChangeType.added) continue;

      try {
        final actionDoc = change.doc.data() as Map<String, dynamic>;
        final action = GameAction.fromJson(actionDoc);
        final timestamp = (actionDoc['timestamp'] as Timestamp).toDate();

        // Process action if it's valid and not duplicate
        if (_isValidAction(action, timestamp)) {
          _processIncomingAction(action, timestamp);
        }
      } catch (e) {
        print('Error processing action: $e');
      }
    }
  }

  /// Broadcast action to other players
  Future<ActionBroadcastResult> broadcastAction({
    required String gameId,
    required String playerId,
    required GameAction action,
  }) async {
    // Validate action timing and player state
    final validationResult = await _validateAction(gameId, playerId, action);
    if (!validationResult.isValid) {
      return ActionBroadcastResult.rejected(validationResult.reason);
    }

    final pendingAction = PendingGameAction(
      id: _generateActionId(),
      action: action,
      playerId: playerId,
      timestamp: DateTime.now(),
      attempts: 0,
    );

    try {
      // Add to pending queue
      _pendingActions.add(pendingAction);

      // Broadcast to Firestore
      await _firestore
          .collection('games')
          .doc(gameId)
          .collection('actions')
          .doc(pendingAction.id)
          .set({
        'id': pendingAction.id,
        'playerId': playerId,
        'action': action.toJson(),
        'timestamp': FieldValue.serverTimestamp(),
        'processed': false,
      });

      // Update last action timestamp
      _lastActionTimestamps[playerId] = DateTime.now();

      return ActionBroadcastResult.success(pendingAction.id);
    } catch (e) {
      // Keep in pending queue for retry
      return ActionBroadcastResult.queued('Network error, will retry');
    }
  }

  /// Validate action before broadcasting
  Future<ActionValidationResult> _validateAction(
    String gameId,
    String playerId,
    GameAction action,
  ) async {
    // Check action timing
    final lastAction = _lastActionTimestamps[playerId];
    if (lastAction != null) {
      final timeSinceLastAction = DateTime.now().difference(lastAction);
      if (timeSinceLastAction.inMilliseconds < 100) {
        return ActionValidationResult.invalid('Action too frequent');
      }
    }

    // Get current game state for validation
    try {
      final gameDoc = await _firestore.collection('games').doc(gameId).get();
      if (!gameDoc.exists) {
        return ActionValidationResult.invalid('Game not found');
      }

      final gameState = GameState.fromJson(
        gameDoc.data() as Map<String, dynamic>,
      );

      // Validate action against current game state
      return _validateActionAgainstState(action, gameState, playerId);
    } catch (e) {
      return ActionValidationResult.invalid('Validation error: $e');
    }
  }

  /// Validate action against game state
  ActionValidationResult _validateActionAgainstState(
    GameAction action,
    GameState gameState,
    String playerId,
  ) {
    final player = gameState.players
        .where((p) => p.userId == playerId)
        .firstOrNull;

    if (player == null) {
      return ActionValidationResult.invalid('Player not in game');
    }

    return action.when(
      drawChip: (playerId, chip) => _validateDrawChip(gameState, player, chip),
      placeChip: (playerId, chip, position) =>
          _validatePlaceChip(gameState, player, chip, position),
      useFlask: (playerId, returnedChip) =>
          _validateUseFlask(gameState, player, returnedChip),
      stopDrawing: (playerId) => _validateStopDrawing(gameState, player),
      completePhase: (playerId) => _validateCompletePhase(gameState, player),
      nextPhase: () => _validateNextPhase(gameState),
      nextTurn: () => _validateNextTurn(gameState),
      buyIngredient: (playerId, ingredient) =>
          _validateBuyIngredient(gameState, player, ingredient),
      useRubies: (playerId, action, rubyCount) =>
          _validateUseRubies(gameState, player, action, rubyCount),
    );
  }

  /// Validate draw chip action
  ActionValidationResult _validateDrawChip(
    GameState gameState,
    GamePlayer player,
    IngredientChip chip,
  ) {
    if (gameState.currentPhase != GamePhase.potions) {
      return ActionValidationResult.invalid('Not in potions phase');
    }

    if (player.hasCompletedPhase) {
      return ActionValidationResult.invalid('Player already completed phase');
    }

    if (player.potState.hasExploded) {
      return ActionValidationResult.invalid('Cannot draw - pot exploded');
    }

    return ActionValidationResult.valid();
  }

  /// Validate place chip action
  ActionValidationResult _validatePlaceChip(
    GameState gameState,
    GamePlayer player,
    IngredientChip chip,
    int position,
  ) {
    if (gameState.currentPhase != GamePhase.potions) {
      return ActionValidationResult.invalid('Not in potions phase');
    }

    if (!player.potState.isValidPosition(position)) {
      return ActionValidationResult.invalid('Invalid position');
    }

    final expectedPosition = player.potState.getNextPosition(chip.value);
    if (position != expectedPosition) {
      return ActionValidationResult.invalid('Incorrect chip position');
    }

    return ActionValidationResult.valid();
  }

  /// Validate flask usage
  ActionValidationResult _validateUseFlask(
    GameState gameState,
    GamePlayer player,
    IngredientChip returnedChip,
  ) {
    if (!player.potState.flaskAvailable) {
      return ActionValidationResult.invalid('Flask not available');
    }

    if (returnedChip.color != IngredientColor.white) {
      return ActionValidationResult.invalid('Can only return white chips');
    }

    return ActionValidationResult.valid();
  }

  /// Validate stop drawing action
  ActionValidationResult _validateStopDrawing(
    GameState gameState,
    GamePlayer player,
  ) {
    if (gameState.currentPhase != GamePhase.potions) {
      return ActionValidationResult.invalid('Not in potions phase');
    }

    if (player.hasCompletedPhase) {
      return ActionValidationResult.invalid('Already completed phase');
    }

    return ActionValidationResult.valid();
  }

  /// Validate complete phase action
  ActionValidationResult _validateCompletePhase(
    GameState gameState,
    GamePlayer player,
  ) {
    if (player.hasCompletedPhase) {
      return ActionValidationResult.invalid('Already completed phase');
    }

    return ActionValidationResult.valid();
  }

  /// Validate next phase transition
  ActionValidationResult _validateNextPhase(GameState gameState) {
    if (!gameState.allPlayersReady) {
      return ActionValidationResult.invalid('Not all players ready');
    }

    return ActionValidationResult.valid();
  }

  /// Validate next turn transition
  ActionValidationResult _validateNextTurn(GameState gameState) {
    if (gameState.currentPhase != GamePhase.evaluationF) {
      return ActionValidationResult.invalid('Not at end of turn');
    }

    return ActionValidationResult.valid();
  }

  /// Validate buy ingredient action
  ActionValidationResult _validateBuyIngredient(
    GameState gameState,
    GamePlayer player,
    AvailableIngredient ingredient,
  ) {
    if (gameState.currentPhase != GamePhase.evaluationE) {
      return ActionValidationResult.invalid('Not in buying phase');
    }

    if (player.potState.coins < ingredient.cost) {
      return ActionValidationResult.invalid('Insufficient coins');
    }

    return ActionValidationResult.valid();
  }

  /// Validate ruby usage
  ActionValidationResult _validateUseRubies(
    GameState gameState,
    GamePlayer player,
    String action,
    int rubyCount,
  ) {
    if (player.potState.rubies < rubyCount) {
      return ActionValidationResult.invalid('Insufficient rubies');
    }

    if (rubyCount != 2) {
      return ActionValidationResult.invalid('Ruby actions cost 2 rubies');
    }

    return ActionValidationResult.valid();
  }

  /// Check if action is valid and not duplicate
  bool _isValidAction(GameAction action, DateTime timestamp) {
    // Check timestamp is reasonable (not too old, not in future)
    final now = DateTime.now();
    final age = now.difference(timestamp);

    if (age.inMinutes > 5 || timestamp.isAfter(now.add(Duration(minutes: 1)))) {
      return false;
    }

    return true;
  }

  /// Process incoming action from other players
  void _processIncomingAction(GameAction action, DateTime timestamp) {
    // Apply action to local state
    _ref.read(gameStateProvider.notifier).applyAction(action);

    // Remove from pending if it was our action
    _pendingActions.removeWhere((pending) => 
        _actionsMatch(pending.action, action));
  }

  /// Check if two actions are the same
  bool _actionsMatch(GameAction action1, GameAction action2) {
    return action1.toString() == action2.toString();
  }

  /// Reconcile local state with server state
  void _reconcileGameState(GameState serverState) {
    final currentState = _ref.read(gameStateProvider);
    
    if (currentState == null) return;

    // Check for significant differences that need reconciliation
    if (_needsReconciliation(currentState, serverState)) {
      // Server state wins in conflicts
      _ref.read(gameStateProvider.notifier).forceUpdateState(serverState);
      
      // Clear pending actions that are now invalid
      _clearInvalidPendingActions(serverState);
    }
  }

  /// Check if reconciliation is needed
  bool _needsReconciliation(GameState local, GameState server) {
    // Check turn/phase differences
    if (local.currentTurn != server.currentTurn ||
        local.currentPhase != server.currentPhase) {
      return true;
    }

    // Check player state differences
    for (int i = 0; i < local.players.length; i++) {
      final localPlayer = local.players[i];
      final serverPlayer = server.players
          .where((p) => p.userId == localPlayer.userId)
          .firstOrNull;

      if (serverPlayer == null) continue;

      // Check significant differences
      if (localPlayer.potState.scoringPosition != 
          serverPlayer.potState.scoringPosition ||
          localPlayer.potState.victoryPoints != 
          serverPlayer.potState.victoryPoints ||
          localPlayer.potState.hasExploded != 
          serverPlayer.potState.hasExploded) {
        return true;
      }
    }

    return false;
  }

  /// Clear pending actions that are invalid with new state
  void _clearInvalidPendingActions(GameState newState) {
    _pendingActions.removeWhere((pending) {
      final validation = _validateActionAgainstState(
        pending.action,
        newState,
        pending.playerId,
      );
      return !validation.isValid;
    });
  }

  /// Handle synchronization errors
  void _handleSyncError(dynamic error) {
    print('Sync error: $error');
    _isSynced = false;
    _notifyConnectionStatusChange(ConnectionStatus.error);
  }

  /// Start reconnection attempts
  void _startReconnection(String gameId, String playerId) {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _attemptReconnection(gameId, playerId),
    );
  }

  /// Attempt to reconnect
  Future<void> _attemptReconnection(String gameId, String playerId) async {
    try {
      await _sendHeartbeat(gameId, playerId);
      
      if (_isOnline) {
        _reconnectTimer?.cancel();
        await _retryPendingActions(gameId);
      }
    } catch (e) {
      // Continue trying
    }
  }

  /// Retry pending actions after reconnection
  Future<void> _retryPendingActions(String gameId) async {
    final actionsToRetry = List<PendingGameAction>.from(_pendingActions);
    _pendingActions.clear();

    for (final pending in actionsToRetry) {
      if (pending.attempts < 3) {
        final result = await broadcastAction(
          gameId: gameId,
          playerId: pending.playerId,
          action: pending.action,
        );

        if (!result.isSuccess) {
          final updatedPending = pending.copyWith(
            attempts: pending.attempts + 1,
          );
          if (updatedPending.attempts < 3) {
            _pendingActions.add(updatedPending);
          }
        }
      }
    }
  }

  /// Notify connection status changes
  void _notifyConnectionStatusChange(ConnectionStatus status) {
    _ref.read(connectionStatusProvider.notifier).updateStatus(status);
  }

  /// Generate unique action ID
  String _generateActionId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = math.Random().nextInt(1000);
    return '${timestamp}_$random';
  }

  /// Get current network status
  NetworkStatus get networkStatus => NetworkStatus(
        isOnline: _isOnline,
        isSynced: _isSynced,
        lastSyncTime: _lastSyncTime,
        pendingActionsCount: _pendingActions.length,
      );

  /// Dispose resources
  void dispose() {
    _gameStateSubscription?.cancel();
    _actionsSubscription?.cancel();
    _heartbeatTimer?.cancel();
    _reconnectTimer?.cancel();
    _pendingActions.clear();
    _lastActionTimestamps.clear();
  }
}

/// Provider for game sync service
final gameSyncServiceProvider = Provider.family<GameSyncService, String>(
  (ref, gameId) => GameSyncService(FirebaseFirestore.instance, ref),
);