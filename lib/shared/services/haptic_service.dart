import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the haptic feedback service
final hapticServiceProvider = Provider<HapticService>((ref) {
  return HapticService();
});

/// Service for managing haptic feedback throughout the app
class HapticService {
  static const String _hapticEnabledKey = 'haptic_enabled';
  static const String _hapticIntensityKey = 'haptic_intensity';

  bool _hapticEnabled = true;
  HapticIntensity _hapticIntensity = HapticIntensity.medium;

  /// Initialize the haptic service with default settings
  Future<void> initialize() async {
    // Using default values for now - can be enhanced with SharedPreferences later
    _hapticEnabled = true;
    _hapticIntensity = HapticIntensity.medium;
  }

  /// Light haptic feedback for subtle interactions
  Future<void> light() async {
    if (!_hapticEnabled) return;
    
    try {
      await HapticFeedback.lightImpact();
    } catch (e) {
      // Silently fail - haptic feedback is not critical
    }
  }

  /// Medium haptic feedback for standard interactions
  Future<void> medium() async {
    if (!_hapticEnabled) return;
    
    try {
      await HapticFeedback.mediumImpact();
    } catch (e) {
      // Silently fail
    }
  }

  /// Heavy haptic feedback for important interactions
  Future<void> heavy() async {
    if (!_hapticEnabled) return;
    
    try {
      await HapticFeedback.heavyImpact();
    } catch (e) {
      // Silently fail
    }
  }

  /// Selection feedback for UI interactions
  Future<void> selection() async {
    if (!_hapticEnabled) return;
    
    try {
      await HapticFeedback.selectionClick();
    } catch (e) {
      // Silently fail
    }
  }

  /// Vibrate for game events based on type
  Future<void> gameEvent(GameHapticType type) async {
    if (!_hapticEnabled) return;

    switch (type) {
      case GameHapticType.ingredientDrag:
        await light();
        break;
      case GameHapticType.ingredientDrop:
        await medium();
        break;
      case GameHapticType.explosion:
        await heavy();
        break;
      case GameHapticType.scoring:
        await light();
        break;
      case GameHapticType.roundComplete:
        await medium();
        break;
      case GameHapticType.gameWin:
        // Double vibration for victory
        await heavy();
        await Future.delayed(const Duration(milliseconds: 100));
        await heavy();
        break;
      case GameHapticType.gameLose:
        await heavy();
        break;
      case GameHapticType.buttonPress:
        await selection();
        break;
      case GameHapticType.error:
        await heavy();
        break;
      case GameHapticType.success:
        await light();
        break;
    }
  }

  /// Enable or disable haptic feedback
  Future<void> setHapticEnabled(bool enabled) async {
    _hapticEnabled = enabled;
    // TODO: Save to SharedPreferences when added to pubspec
  }

  /// Set haptic feedback intensity
  Future<void> setHapticIntensity(HapticIntensity intensity) async {
    _hapticIntensity = intensity;
    // TODO: Save to SharedPreferences when added to pubspec
  }

  // Getters for current settings
  bool get hapticEnabled => _hapticEnabled;
  HapticIntensity get hapticIntensity => _hapticIntensity;
}

/// Types of haptic feedback for different game events
enum GameHapticType {
  ingredientDrag,
  ingredientDrop,
  explosion,
  scoring,
  roundComplete,
  gameWin,
  gameLose,
  buttonPress,
  error,
  success,
}

/// Haptic feedback intensity levels
enum HapticIntensity {
  light,
  medium,
  heavy,
}

extension HapticIntensityExtension on HapticIntensity {
  String get displayName {
    switch (this) {
      case HapticIntensity.light:
        return 'Light';
      case HapticIntensity.medium:
        return 'Medium';
      case HapticIntensity.heavy:
        return 'Heavy';
    }
  }
}