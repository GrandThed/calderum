import 'package:freezed_annotation/freezed_annotation.dart';
import 'game_state_model.dart';

part 'anti_cheat_model.freezed.dart';
part 'anti_cheat_model.g.dart';

/// Types of anti-cheat checks
enum AntiCheatType {
  timing,
  stateValidation,
  sequenceValidation,
  resourceValidation,
  behaviorAnalysis,
  networkIntegrity,
}

/// Suspicion levels with thresholds
enum SuspicionLevel {
  none(0.0, 0.0),
  low(0.1, 0.2),
  medium(0.3, 0.5),
  high(0.6, 1.0);

  const SuspicionLevel(this.score, this.threshold);
  final double score;
  final double threshold;
}

/// Actions to take based on anti-cheat results
enum AntiCheatAction {
  allow,
  warn,
  blockAction,
  slowDown,
  kickPlayer,
  banPlayer,
}

/// Result of anti-cheat validation
@freezed
class AntiCheatResult with _$AntiCheatResult {
  const factory AntiCheatResult({
    required bool isValid,
    required double suspicionScore,
    required List<AntiCheatCheck> checks,
    required AntiCheatAction action,
    String? message,
    Map<String, dynamic>? metadata,
  }) = _AntiCheatResult;

  factory AntiCheatResult.fromJson(Map<String, dynamic> json) =>
      _$AntiCheatResultFromJson(json);
}

/// Individual anti-cheat check result
@freezed
class AntiCheatCheck with _$AntiCheatCheck {
  const factory AntiCheatCheck({
    required AntiCheatType type,
    required SuspicionLevel severity,
    required String message,
    Map<String, dynamic>? evidence,
    DateTime? timestamp,
  }) = _AntiCheatCheck;

  factory AntiCheatCheck.fromJson(Map<String, dynamic> json) =>
      _$AntiCheatCheckFromJson(json);
}

/// Tracks player behavior over time
@freezed
class PlayerBehaviorTracker with _$PlayerBehaviorTracker {
  factory PlayerBehaviorTracker({
    required String playerId,
    required DateTime firstSeen,
    @Default(0) int totalActions,
    @Default([]) List<GameAction> recentActions,
    @Default([]) List<DateTime> recentActionTimes,
    @Default(0.0) double averageActionTiming,
    @Default(0.0) double timingVariance,
    @Default(0) int actionsInLastMinute,
    @Default(0) int perfectPlayStreak,
    @Default(0) int impossibleKnowledgeCount,
    @Default([]) List<SuspicionEvent> suspicionEvents,
    @Default(0.0) double overallSuspicionScore,
    DateTime? lastActionTime,
    DateTime? previousActionTime,
  }) = _PlayerBehaviorTracker;

  factory PlayerBehaviorTracker.fromJson(Map<String, dynamic> json) =>
      _$PlayerBehaviorTrackerFromJson(json);
}

extension PlayerBehaviorTrackerExtension on PlayerBehaviorTracker {
  int get actionsPerMinute {
    final now = DateTime.now();
    final oneMinuteAgo = now.subtract(const Duration(minutes: 1));
    
    return recentActionTimes
        .where((time) => time.isAfter(oneMinuteAgo))
        .length;
  }
}

/// Suspicion event record
@freezed
class SuspicionEvent with _$SuspicionEvent {
  const factory SuspicionEvent({
    required AntiCheatType type,
    required SuspicionLevel severity,
    required DateTime timestamp,
    required String message,
    Map<String, dynamic>? evidence,
  }) = _SuspicionEvent;

  factory SuspicionEvent.fromJson(Map<String, dynamic> json) =>
      _$SuspicionEventFromJson(json);
}

/// Action timing information
@freezed
class ActionTiming with _$ActionTiming {
  const factory ActionTiming({
    required GameAction action,
    required DateTime timestamp,
    Duration? processingTime,
    String? networkLatency,
  }) = _ActionTiming;

  factory ActionTiming.fromJson(Map<String, dynamic> json) =>
      _$ActionTimingFromJson(json);
}

/// Game state snapshot for validation
@freezed
class GameStateSnapshot with _$GameStateSnapshot {
  const factory GameStateSnapshot({
    required String gameId,
    required String playerId,
    required DateTime timestamp,
    required Map<String, dynamic> stateData,
    required String checksum,
  }) = _GameStateSnapshot;

  factory GameStateSnapshot.fromJson(Map<String, dynamic> json) =>
      _$GameStateSnapshotFromJson(json);
}

/// Player behavior summary for analysis
@freezed
class PlayerBehaviorSummary with _$PlayerBehaviorSummary {
  const factory PlayerBehaviorSummary({
    required String playerId,
    required int totalActions,
    required double averageActionTiming,
    required int actionsPerMinute,
    required double suspicionScore,
    required int recentViolations,
    String? riskLevel,
    List<String>? flaggedBehaviors,
  }) = _PlayerBehaviorSummary;

  factory PlayerBehaviorSummary.fromJson(Map<String, dynamic> json) =>
      _$PlayerBehaviorSummaryFromJson(json);
}

extension PlayerBehaviorSummaryExtension on PlayerBehaviorSummary {
  String get riskAssessment {
    if (suspicionScore >= 0.8) return 'HIGH RISK';
    if (suspicionScore >= 0.5) return 'MEDIUM RISK';
    if (suspicionScore >= 0.2) return 'LOW RISK';
    return 'CLEAN';
  }

  List<String> get behaviorFlags {
    final flags = <String>[];
    
    if (actionsPerMinute > 60) flags.add('RAPID_ACTIONS');
    if (averageActionTiming < 100) flags.add('INHUMAN_TIMING');
    if (recentViolations > 5) flags.add('REPEATED_VIOLATIONS');
    if (suspicionScore > 0.7) flags.add('HIGH_SUSPICION');
    
    return flags;
  }
}

/// Cheat detection configuration
@freezed
class AntiCheatConfig with _$AntiCheatConfig {
  const factory AntiCheatConfig({
    @Default(50) int minActionInterval, // milliseconds
    @Default(200) int maxActionInterval, // milliseconds
    @Default(60) int maxActionsPerMinute,
    @Default(0.5) double suspicionThreshold,
    @Default(10) double timingVarianceThreshold,
    @Default(5) int maxRecentViolations,
    @Default(true) bool enableTimingChecks,
    @Default(true) bool enableStateValidation,
    @Default(true) bool enableBehaviorAnalysis,
    @Default(true) bool enableResourceValidation,
  }) = _AntiCheatConfig;

  factory AntiCheatConfig.fromJson(Map<String, dynamic> json) =>
      _$AntiCheatConfigFromJson(json);
}

/// Network integrity check result
@freezed
class NetworkIntegrityCheck with _$NetworkIntegrityCheck {
  const factory NetworkIntegrityCheck({
    required String playerId,
    required DateTime timestamp,
    required Duration latency,
    required int packetLoss, // percentage
    required bool isStable,
    Map<String, dynamic>? networkMetrics,
  }) = _NetworkIntegrityCheck;

  factory NetworkIntegrityCheck.fromJson(Map<String, dynamic> json) =>
      _$NetworkIntegrityCheckFromJson(json);
}

/// Cheat report for suspicious activity
@freezed
class CheatReport with _$CheatReport {
  const factory CheatReport({
    required String reportId,
    required String gameId,
    required String suspiciousPlayerId,
    required String reporterPlayerId,
    required DateTime timestamp,
    required List<AntiCheatCheck> evidence,
    required double confidenceScore,
    @Default(CheatReportStatus.pending) CheatReportStatus status,
    String? moderatorNotes,
    DateTime? resolvedAt,
  }) = _CheatReport;

  factory CheatReport.fromJson(Map<String, dynamic> json) =>
      _$CheatReportFromJson(json);
}

/// Cheat report status
enum CheatReportStatus {
  pending,
  investigating,
  confirmed,
  dismissed,
  resolved,
}

/// Player trust score
@freezed
class PlayerTrustScore with _$PlayerTrustScore {
  const factory PlayerTrustScore({
    required String playerId,
    required double score, // 0.0 to 1.0
    required int gamesPlayed,
    required int cleanGames,
    required int flaggedGames,
    required DateTime lastUpdated,
    @Default([]) List<String> historicalFlags,
  }) = _PlayerTrustScore;

  factory PlayerTrustScore.fromJson(Map<String, dynamic> json) =>
      _$PlayerTrustScoreFromJson(json);
}

extension PlayerTrustScoreExtension on PlayerTrustScore {
  String get trustLevel {
    if (score >= 0.9) return 'HIGHLY_TRUSTED';
    if (score >= 0.7) return 'TRUSTED';
    if (score >= 0.5) return 'NEUTRAL';
    if (score >= 0.3) return 'SUSPICIOUS';
    return 'UNTRUSTED';
  }

  bool get isReliable => score >= 0.7 && flaggedGames < 3;
}