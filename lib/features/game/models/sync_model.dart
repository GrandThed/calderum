import 'package:freezed_annotation/freezed_annotation.dart';
import 'game_state_model.dart';

part 'sync_model.freezed.dart';
part 'sync_model.g.dart';

/// Network connection status
enum ConnectionStatus {
  connected,
  disconnected,
  synced,
  syncing,
  error,
}

/// Result of action broadcast attempt
@freezed
class ActionBroadcastResult with _$ActionBroadcastResult {
  const factory ActionBroadcastResult.success(String actionId) = _ActionBroadcastResultSuccess;
  const factory ActionBroadcastResult.rejected(String reason) = _ActionBroadcastResultRejected;  
  const factory ActionBroadcastResult.queued(String message) = _ActionBroadcastResultQueued;

  factory ActionBroadcastResult.fromJson(Map<String, dynamic> json) =>
      _$ActionBroadcastResultFromJson(json);
}

extension ActionBroadcastResultExtension on ActionBroadcastResult {
  bool get isSuccess => when(
    success: (_) => true,
    rejected: (_) => false,
    queued: (_) => false,
  );
}

/// Result of action validation
@freezed
class ActionValidationResult with _$ActionValidationResult {
  const factory ActionValidationResult.valid() = _ActionValidationResultValid;
  const factory ActionValidationResult.invalid(String reason) = _ActionValidationResultInvalid;

  factory ActionValidationResult.fromJson(Map<String, dynamic> json) =>
      _$ActionValidationResultFromJson(json);
}

extension ActionValidationResultExtension on ActionValidationResult {
  bool get isValid => when(
    valid: () => true,
    invalid: (_) => false,
  );

  String get reason => when(
    valid: () => '',
    invalid: (reason) => reason,
  );
}

/// Pending action in queue
@freezed
class PendingGameAction with _$PendingGameAction {
  const factory PendingGameAction({
    required String id,
    required GameAction action,
    required String playerId,
    required DateTime timestamp,
    @Default(0) int attempts,
  }) = _PendingGameAction;

  factory PendingGameAction.fromJson(Map<String, dynamic> json) =>
      _$PendingGameActionFromJson(json);
}

/// Network status information
@freezed
class NetworkStatus with _$NetworkStatus {
  const factory NetworkStatus({
    @Default(true) bool isOnline,
    @Default(true) bool isSynced,
    DateTime? lastSyncTime,
    @Default(0) int pendingActionsCount,
  }) = _NetworkStatus;

  factory NetworkStatus.fromJson(Map<String, dynamic> json) =>
      _$NetworkStatusFromJson(json);
}

/// Lag compensation data
@freezed
class LagCompensationData with _$LagCompensationData {
  const factory LagCompensationData({
    required String playerId,
    required Duration networkLatency,
    required DateTime serverTimestamp,
    required DateTime clientTimestamp,
    @Default(0) int sequenceNumber,
  }) = _LagCompensationData;

  factory LagCompensationData.fromJson(Map<String, dynamic> json) =>
      _$LagCompensationDataFromJson(json);
}

/// Sync conflict resolution data
@freezed
class SyncConflict with _$SyncConflict {
  const factory SyncConflict({
    required String conflictId,
    required String playerId,
    required GameAction localAction,
    required GameAction serverAction,
    required DateTime timestamp,
    @Default(ConflictResolution.serverWins) ConflictResolution resolution,
  }) = _SyncConflict;

  factory SyncConflict.fromJson(Map<String, dynamic> json) =>
      _$SyncConflictFromJson(json);
}

/// Conflict resolution strategy
enum ConflictResolution {
  serverWins,
  clientWins,
  merge,
  rollback,
}

/// Player connection info
@freezed
class PlayerConnection with _$PlayerConnection {
  const factory PlayerConnection({
    required String playerId,
    required String displayName,
    required bool isOnline,
    required DateTime lastHeartbeat,
    Duration? averageLatency,
    @Default(0) int missedHeartbeats,
  }) = _PlayerConnection;

  factory PlayerConnection.fromJson(Map<String, dynamic> json) =>
      _$PlayerConnectionFromJson(json);
}

/// Game synchronization state
@freezed
class GameSyncState with _$GameSyncState {
  const factory GameSyncState({
    required String gameId,
    @Default([]) List<PlayerConnection> playerConnections,
    @Default([]) List<PendingGameAction> pendingActions,
    @Default([]) List<SyncConflict> conflicts,
    required DateTime lastSyncTime,
    @Default(ConnectionStatus.connected) ConnectionStatus status,
  }) = _GameSyncState;

  factory GameSyncState.fromJson(Map<String, dynamic> json) =>
      _$GameSyncStateFromJson(json);
}