import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the sound service
final soundServiceProvider = Provider<SoundService>((ref) {
  return SoundService();
});

/// Service for managing game sounds and audio feedback
class SoundService {
  static const String _soundEnabledKey = 'sound_enabled';
  static const String _musicEnabledKey = 'music_enabled';
  static const String _soundVolumeKey = 'sound_volume';
  static const String _musicVolumeKey = 'music_volume';

  bool _soundEnabled = true;
  bool _musicEnabled = true;
  double _soundVolume = 0.7;
  double _musicVolume = 0.5;

  // Sound effect types
  static const Map<GameSoundEffect, String> _soundAssets = {
    // UI Sounds
    GameSoundEffect.buttonClick: 'sounds/ui/button_click.wav',
    GameSoundEffect.buttonHover: 'sounds/ui/button_hover.wav',
    GameSoundEffect.navigation: 'sounds/ui/page_transition.wav',
    GameSoundEffect.error: 'sounds/ui/error.wav',
    GameSoundEffect.success: 'sounds/ui/success.wav',
    
    // Game Actions
    GameSoundEffect.ingredientDraw: 'sounds/game/ingredient_draw.wav',
    GameSoundEffect.ingredientDrop: 'sounds/game/ingredient_drop.wav',
    GameSoundEffect.cauldronBubble: 'sounds/game/cauldron_bubble.wav',
    GameSoundEffect.explosion: 'sounds/game/explosion.wav',
    GameSoundEffect.scoring: 'sounds/game/scoring.wav',
    GameSoundEffect.roundComplete: 'sounds/game/round_complete.wav',
    GameSoundEffect.gameWin: 'sounds/game/victory.wav',
    GameSoundEffect.gameLose: 'sounds/game/defeat.wav',
    
    // Special Effects
    GameSoundEffect.flaskUse: 'sounds/game/flask_use.wav',
    GameSoundEffect.abilityActivate: 'sounds/game/ability_activate.wav',
    GameSoundEffect.countdown: 'sounds/game/countdown.wav',
    GameSoundEffect.notification: 'sounds/ui/notification.wav',
  };

  /// Initialize the sound service with default settings
  Future<void> initialize() async {
    // Using default values for now - can be enhanced with SharedPreferences later
    _soundEnabled = true;
    _musicEnabled = true;
    _soundVolume = 0.7;
    _musicVolume = 0.5;
  }

  /// Play a game sound effect
  Future<void> playSound(GameSoundEffect effect) async {
    if (!_soundEnabled) return;

    try {
      // For now, use system sound as placeholder
      // In a full implementation, you would use audioplayers package
      await SystemSound.play(SystemSoundType.click);
    } catch (e) {
      // Silently fail - sound is not critical for gameplay
    }
  }

  /// Play UI feedback sound
  Future<void> playUISound(UISoundType type) async {
    if (!_soundEnabled) return;

    try {
      switch (type) {
        case UISoundType.click:
          await SystemSound.play(SystemSoundType.click);
          break;
        case UISoundType.error:
          // Use system sound for now
          await SystemSound.play(SystemSoundType.alert);
          break;
        case UISoundType.success:
          await SystemSound.play(SystemSoundType.click);
          break;
      }
    } catch (e) {
      // Silently fail
    }
  }

  /// Enable or disable sound effects
  Future<void> setSoundEnabled(bool enabled) async {
    _soundEnabled = enabled;
    // TODO: Save to SharedPreferences when added to pubspec
  }

  /// Enable or disable background music
  Future<void> setMusicEnabled(bool enabled) async {
    _musicEnabled = enabled;
    // TODO: Save to SharedPreferences when added to pubspec
  }

  /// Set sound effects volume (0.0 - 1.0)
  Future<void> setSoundVolume(double volume) async {
    _soundVolume = volume.clamp(0.0, 1.0);
    // TODO: Save to SharedPreferences when added to pubspec
  }

  /// Set music volume (0.0 - 1.0)
  Future<void> setMusicVolume(double volume) async {
    _musicVolume = volume.clamp(0.0, 1.0);
    // TODO: Save to SharedPreferences when added to pubspec
  }

  // Getters for current settings
  bool get soundEnabled => _soundEnabled;
  bool get musicEnabled => _musicEnabled;
  double get soundVolume => _soundVolume;
  double get musicVolume => _musicVolume;
}

/// Game sound effects enumeration
enum GameSoundEffect {
  // UI Sounds
  buttonClick,
  buttonHover,
  navigation,
  error,
  success,
  
  // Game Actions
  ingredientDraw,
  ingredientDrop,
  cauldronBubble,
  explosion,
  scoring,
  roundComplete,
  gameWin,
  gameLose,
  
  // Special Effects
  flaskUse,
  abilityActivate,
  countdown,
  notification,
}

/// UI sound types for quick access
enum UISoundType {
  click,
  error,
  success,
}