import 'dart:async';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_state_model.dart';
import '../models/ingredient_model.dart';
import '../models/anti_cheat_model.dart';

/// Service for anti-cheat detection and prevention
class AntiCheatService {
  final FirebaseFirestore _firestore;
  final Map<String, PlayerBehaviorTracker> _behaviorTrackers = {};
  final Map<String, List<ActionTiming>> _actionTimings = {};
  final Map<String, GameStateSnapshot> _gameStateSnapshots = {};

  AntiCheatService(this._firestore);

  /// Validate action against anti-cheat rules
  Future<AntiCheatResult> validateAction({
    required String gameId,
    required String playerId,
    required GameAction action,
    required GameState currentState,
  }) async {
    final results = <AntiCheatCheck>[];

    // 1. Timing validation
    final timingResult = await _validateActionTiming(playerId, action);
    results.add(timingResult);

    // 2. Game state validation
    final stateResult = await _validateGameStateConsistency(
      gameId,
      playerId,
      action,
      currentState,
    );
    results.add(stateResult);

    // 3. Action sequence validation
    final sequenceResult = await _validateActionSequence(playerId, action);
    results.add(sequenceResult);

    // 4. Resource validation
    final resourceResult = await _validateResourceConstraints(
      playerId,
      action,
      currentState,
    );
    results.add(resourceResult);

    // 5. Behavioral pattern analysis
    final behaviorResult = await _analyzeBehaviorPattern(playerId, action);
    results.add(behaviorResult);

    // Update behavior tracking
    await _updateBehaviorTracker(playerId, action, results);

    // Calculate overall suspicion score
    final suspicionScore = _calculateSuspicionScore(results);
    final isBlocked = suspicionScore >= SuspicionLevel.high.threshold;

    return AntiCheatResult(
      isValid: !isBlocked,
      suspicionScore: suspicionScore,
      checks: results,
      action: isBlocked ? AntiCheatAction.blockAction : AntiCheatAction.allow,
      message: isBlocked ? 'Action blocked due to suspicious behavior' : null,
    );
  }

  /// Validate action timing patterns
  Future<AntiCheatCheck> _validateActionTiming(
    String playerId,
    GameAction action,
  ) async {
    final now = DateTime.now();
    final timings = _actionTimings[playerId] ??= [];

    // Add current action timing
    timings.add(ActionTiming(
      action: action,
      timestamp: now,
    ));

    // Keep only last 50 actions
    if (timings.length > 50) {
      timings.removeRange(0, timings.length - 50);
    }

    // Check for suspicious timing patterns
    if (timings.length >= 3) {
      final recentTimings = timings.takeLast(3);
      final intervals = <Duration>[];

      for (int i = 1; i < recentTimings.length; i++) {
        intervals.add(recentTimings.elementAt(i).timestamp
            .difference(recentTimings.elementAt(i - 1).timestamp));
      }

      // Check for inhuman timing (actions too fast)
      final avgInterval = intervals
          .map((d) => d.inMilliseconds)
          .reduce((a, b) => a + b) / intervals.length;

      if (avgInterval < 50) { // Less than 50ms between actions
        return AntiCheatCheck(
          type: AntiCheatType.timing,
          severity: SuspicionLevel.high,
          message: 'Actions performed too quickly (${avgInterval.toInt()}ms avg)',
          evidence: {'avgInterval': avgInterval, 'intervals': intervals},
        );
      }

      // Check for robotic timing (too consistent)
      final variance = _calculateVariance(intervals.map((d) => d.inMilliseconds.toDouble()));
      if (variance < 10 && avgInterval < 200) { // Very consistent timing
        return AntiCheatCheck(
          type: AntiCheatType.timing,
          severity: SuspicionLevel.medium,
          message: 'Suspiciously consistent timing pattern',
          evidence: {'variance': variance, 'avgInterval': avgInterval},
        );
      }
    }

    return AntiCheatCheck(
      type: AntiCheatType.timing,
      severity: SuspicionLevel.none,
      message: 'Timing validation passed',
    );
  }

  /// Validate game state consistency
  Future<AntiCheatCheck> _validateGameStateConsistency(
    String gameId,
    String playerId,
    GameAction action,
    GameState currentState,
  ) async {
    try {
      // Get server-side game state
      final serverDoc = await _firestore.collection('games').doc(gameId).get();
      if (!serverDoc.exists) {
        return AntiCheatCheck(
          type: AntiCheatType.stateValidation,
          severity: SuspicionLevel.high,
          message: 'Game not found on server',
        );
      }

      final serverState = GameState.fromJson(
        serverDoc.data() as Map<String, dynamic>,
      );

      // Compare critical state values
      final inconsistencies = <String>[];

      if (currentState.currentTurn != serverState.currentTurn) {
        inconsistencies.add('turn: local=${currentState.currentTurn}, server=${serverState.currentTurn}');
      }

      if (currentState.currentPhase != serverState.currentPhase) {
        inconsistencies.add('phase: local=${currentState.currentPhase}, server=${serverState.currentPhase}');
      }

      // Check player-specific state
      final localPlayer = currentState.players
          .where((p) => p.userId == playerId)
          .firstOrNull;
      final serverPlayer = serverState.players
          .where((p) => p.userId == playerId)
          .firstOrNull;

      if (localPlayer != null && serverPlayer != null) {
        if (localPlayer.potState.victoryPoints != serverPlayer.potState.victoryPoints) {
          inconsistencies.add('VP: local=${localPlayer.potState.victoryPoints}, server=${serverPlayer.potState.victoryPoints}');
        }

        if (localPlayer.potState.coins != serverPlayer.potState.coins) {
          inconsistencies.add('coins: local=${localPlayer.potState.coins}, server=${serverPlayer.potState.coins}');
        }

        if (localPlayer.potState.rubies != serverPlayer.potState.rubies) {
          inconsistencies.add('rubies: local=${localPlayer.potState.rubies}, server=${serverPlayer.potState.rubies}');
        }
      }

      if (inconsistencies.isNotEmpty) {
        return AntiCheatCheck(
          type: AntiCheatType.stateValidation,
          severity: SuspicionLevel.high,
          message: 'State inconsistencies detected',
          evidence: {'inconsistencies': inconsistencies},
        );
      }

      return AntiCheatCheck(
        type: AntiCheatType.stateValidation,
        severity: SuspicionLevel.none,
        message: 'State validation passed',
      );
    } catch (e) {
      return AntiCheatCheck(
        type: AntiCheatType.stateValidation,
        severity: SuspicionLevel.medium,
        message: 'State validation failed: $e',
      );
    }
  }

  /// Validate action sequence logic
  Future<AntiCheatCheck> _validateActionSequence(
    String playerId,
    GameAction action,
  ) async {
    final tracker = _behaviorTrackers[playerId];
    if (tracker == null) return AntiCheatCheck(
      type: AntiCheatType.sequenceValidation,
      severity: SuspicionLevel.none,
      message: 'No previous actions to validate',
    );

    final recentActions = tracker.recentActions;
    if (recentActions.isEmpty) return AntiCheatCheck(
      type: AntiCheatType.sequenceValidation,
      severity: SuspicionLevel.none,
      message: 'First action, sequence valid',
    );

    // Validate action sequence logic
    final lastAction = recentActions.last;
    final sequenceViolations = <String>[];

    // Check for impossible sequences
    if (lastAction is StopDrawingAction && action is DrawChipAction) {
      sequenceViolations.add('Drawing after stopping drawing');
    }

    if (lastAction is CompletePhaseAction && action is PlaceChipAction) {
      sequenceViolations.add('Placing chip after completing phase');
    }

    // Check for duplicate actions
    if (_isDuplicateAction(lastAction, action)) {
      sequenceViolations.add('Duplicate action detected');
    }

    if (sequenceViolations.isNotEmpty) {
      return AntiCheatCheck(
        type: AntiCheatType.sequenceValidation,
        severity: SuspicionLevel.high,
        message: 'Invalid action sequence',
        evidence: {'violations': sequenceViolations},
      );
    }

    return AntiCheatCheck(
      type: AntiCheatType.sequenceValidation,
      severity: SuspicionLevel.none,
      message: 'Action sequence valid',
    );
  }

  /// Validate resource constraints
  Future<AntiCheatCheck> _validateResourceConstraints(
    String playerId,
    GameAction action,
    GameState currentState,
  ) async {
    final player = currentState.players
        .where((p) => p.userId == playerId)
        .firstOrNull;

    if (player == null) {
      return AntiCheatCheck(
        type: AntiCheatType.resourceValidation,
        severity: SuspicionLevel.high,
        message: 'Player not found in game state',
      );
    }

    final violations = <String>[];

    return action.when(
      drawChip: (playerId, chip) {
        // Validate chip is available in bag
        final hasChip = player.ingredientBag.availableChips
            .any((c) => c.id == chip.id);
        if (!hasChip) {
          violations.add('Chip not available in bag');
        }
        return _createResourceCheck(violations);
      },
      placeChip: (playerId, chip, position) {
        // Validate position constraints
        if (position < 0 || position > 33) {
          violations.add('Invalid board position: $position');
        }
        return _createResourceCheck(violations);
      },
      useFlask: (playerId, returnedChip) {
        if (!player.potState.flaskAvailable) {
          violations.add('Flask not available');
        }
        return _createResourceCheck(violations);
      },
      buyIngredient: (playerId, ingredient) {
        if (player.potState.coins < ingredient.cost) {
          violations.add('Insufficient coins: need ${ingredient.cost}, have ${player.potState.coins}');
        }
        return _createResourceCheck(violations);
      },
      useRubies: (playerId, action, rubyCount) {
        if (player.potState.rubies < rubyCount) {
          violations.add('Insufficient rubies: need $rubyCount, have ${player.potState.rubies}');
        }
        return _createResourceCheck(violations);
      },
      stopDrawing: (playerId) => _createResourceCheck(violations),
      completePhase: (playerId) => _createResourceCheck(violations),
      nextPhase: () => _createResourceCheck(violations),
      nextTurn: () => _createResourceCheck(violations),
    );
  }

  AntiCheatCheck _createResourceCheck(List<String> violations) {
    if (violations.isNotEmpty) {
      return AntiCheatCheck(
        type: AntiCheatType.resourceValidation,
        severity: SuspicionLevel.high,
        message: 'Resource constraint violations',
        evidence: {'violations': violations},
      );
    }

    return AntiCheatCheck(
      type: AntiCheatType.resourceValidation,
      severity: SuspicionLevel.none,
      message: 'Resource validation passed',
    );
  }

  /// Analyze behavioral patterns for suspicious activity
  Future<AntiCheatCheck> _analyzeBehaviorPattern(
    String playerId,
    GameAction action,
  ) async {
    var tracker = _behaviorTrackers[playerId] ??= PlayerBehaviorTracker(
      playerId: playerId,
      firstSeen: DateTime.now(),
    );

    final suspiciousPatterns = <String>[];

    // Check for rapid-fire actions
    if (tracker.actionsPerMinute > 60) {
      suspiciousPatterns.add('Excessive actions per minute: ${tracker.actionsPerMinute}');
    }

    // Check for perfect play patterns
    if (tracker.perfectPlayStreak > 10) {
      suspiciousPatterns.add('Suspiciously optimal play streak: ${tracker.perfectPlayStreak}');
    }

    // Check for consistent timing
    if (tracker.timingVariance < 5) {
      suspiciousPatterns.add('Robotic timing patterns');
    }

    // Check for impossible knowledge
    if (tracker.impossibleKnowledgeCount > 0) {
      suspiciousPatterns.add('Actions suggesting impossible game knowledge');
    }

    final severity = suspiciousPatterns.isEmpty 
        ? SuspicionLevel.none 
        : suspiciousPatterns.length > 2 
            ? SuspicionLevel.high 
            : SuspicionLevel.medium;

    return AntiCheatCheck(
      type: AntiCheatType.behaviorAnalysis,
      severity: severity,
      message: suspiciousPatterns.isEmpty 
          ? 'Behavior analysis passed' 
          : 'Suspicious patterns detected',
      evidence: {'patterns': suspiciousPatterns},
    );
  }

  /// Update behavior tracker with new action
  Future<void> _updateBehaviorTracker(
    String playerId,
    GameAction action,
    List<AntiCheatCheck> checks,
  ) async {
    var tracker = _behaviorTrackers[playerId] ??= PlayerBehaviorTracker(
      playerId: playerId,
      firstSeen: DateTime.now(),
    );

    tracker = tracker.copyWith(totalActions: tracker.totalActions + 1);
    tracker = tracker.copyWith(
      recentActions: [...tracker.recentActions, action],
    );
    tracker = tracker.copyWith(lastActionTime: DateTime.now());

    // Keep only recent actions
    if (tracker.recentActions.length > 20) {
      tracker = tracker.copyWith(
        recentActions: tracker.recentActions.skip(1).toList(),
      );
    }

    // Update timing statistics
    if (tracker.recentActions.length >= 2) {
      final timings = <int>[];
      for (int i = 1; i < tracker.recentActions.length; i++) {
        final timing = tracker.lastActionTime!
            .difference(tracker.previousActionTime ?? tracker.lastActionTime!)
            .inMilliseconds;
        timings.add(timing);
      }
      
      if (timings.isNotEmpty) {
        tracker = tracker.copyWith(
          averageActionTiming: timings.reduce((a, b) => a + b) / timings.length,
          timingVariance: _calculateVariance(timings.map((t) => t.toDouble())),
        );
      }
    }

    tracker = tracker.copyWith(previousActionTime: tracker.lastActionTime);

    // Update actions per minute
    final now = DateTime.now();
    final minuteAgo = now.subtract(const Duration(minutes: 1));
    tracker = tracker.copyWith(
      actionsInLastMinute: tracker.recentActionTimes
          .where((time) => time.isAfter(minuteAgo))
          .length,
    );

    tracker = tracker.copyWith(
      recentActionTimes: [...tracker.recentActionTimes, now],
    );
    if (tracker.recentActionTimes.length > 100) {
      tracker = tracker.copyWith(
        recentActionTimes: tracker.recentActionTimes.skip(1).toList(),
      );
    }

    // Update suspicion scores
    final newEvents = <SuspicionEvent>[];
    for (final check in checks) {
      if (check.severity != SuspicionLevel.none) {
        newEvents.add(SuspicionEvent(
          type: check.type,
          severity: check.severity,
          timestamp: now,
          message: check.message,
        ));
      }
    }
    if (newEvents.isNotEmpty) {
      tracker = tracker.copyWith(
        suspicionEvents: [...tracker.suspicionEvents, ...newEvents],
      );
    }

    // Calculate overall suspicion score
    tracker = tracker.copyWith(
      overallSuspicionScore: _calculatePlayerSuspicionScore(tracker),
    );
    
    // Update the tracker in our map
    _behaviorTrackers[playerId] = tracker;
  }

  /// Calculate suspicion score from checks
  double _calculateSuspicionScore(List<AntiCheatCheck> checks) {
    double total = 0;
    
    for (final check in checks) {
      total += check.severity.score;
    }

    return (total / checks.length).clamp(0.0, 1.0);
  }

  /// Calculate player's overall suspicion score
  double _calculatePlayerSuspicionScore(PlayerBehaviorTracker tracker) {
    if (tracker.suspicionEvents.isEmpty) return 0.0;

    // Weight recent events more heavily
    final now = DateTime.now();
    double weightedScore = 0.0;
    double totalWeight = 0.0;

    for (final event in tracker.suspicionEvents) {
      final age = now.difference(event.timestamp);
      final weight = math.max(0.1, 1.0 - (age.inMinutes / 60.0)); // Decay over 1 hour
      
      weightedScore += event.severity.score * weight;
      totalWeight += weight;
    }

    return totalWeight > 0 ? (weightedScore / totalWeight).clamp(0.0, 1.0) : 0.0;
  }

  /// Check if action is duplicate of previous action
  bool _isDuplicateAction(GameAction action1, GameAction action2) {
    return action1.toString() == action2.toString();
  }

  /// Calculate variance of a list of numbers
  double _calculateVariance(Iterable<double> values) {
    if (values.isEmpty) return 0.0;
    
    final mean = values.reduce((a, b) => a + b) / values.length;
    final squaredDiffs = values.map((x) => math.pow(x - mean, 2));
    
    return squaredDiffs.reduce((a, b) => a + b) / values.length;
  }

  /// Record suspicious activity for later analysis
  Future<void> recordSuspiciousActivity({
    required String gameId,
    required String playerId,
    required AntiCheatResult result,
  }) async {
    if (result.suspicionScore < SuspicionLevel.medium.threshold) return;

    try {
      await _firestore
          .collection('games')
          .doc(gameId)
          .collection('anti_cheat_logs')
          .add({
        'playerId': playerId,
        'timestamp': FieldValue.serverTimestamp(),
        'suspicionScore': result.suspicionScore,
        'checks': result.checks.map((c) => c.toJson()).toList(),
        'action': result.action.name,
        'message': result.message,
      });
    } catch (e) {
      print('Failed to record suspicious activity: $e');
    }
  }

  /// Get player behavior summary
  PlayerBehaviorSummary? getPlayerBehaviorSummary(String playerId) {
    final tracker = _behaviorTrackers[playerId];
    if (tracker == null) return null;

    return PlayerBehaviorSummary(
      playerId: playerId,
      totalActions: tracker.totalActions,
      averageActionTiming: tracker.averageActionTiming,
      actionsPerMinute: tracker.actionsInLastMinute,
      suspicionScore: tracker.overallSuspicionScore,
      recentViolations: tracker.suspicionEvents
          .where((e) => DateTime.now().difference(e.timestamp).inMinutes < 30)
          .length,
    );
  }

  /// Dispose resources
  void dispose() {
    _behaviorTrackers.clear();
    _actionTimings.clear();
    _gameStateSnapshots.clear();
  }
}

/// Provider for anti-cheat service
final antiCheatServiceProvider = Provider<AntiCheatService>(
  (ref) => AntiCheatService(FirebaseFirestore.instance),
);

/// Extension for list operations
extension ListExtensions<T> on List<T> {
  Iterable<T> takeLast(int count) {
    if (count >= length) return this;
    return skip(length - count);
  }
}