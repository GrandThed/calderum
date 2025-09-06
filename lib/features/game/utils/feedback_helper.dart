import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/services/sound_service.dart';
import '../../../shared/services/haptic_service.dart';

/// Helper class for coordinating audio and haptic feedback in game
class GameFeedbackHelper {
  final SoundService _soundService;
  final HapticService _hapticService;

  GameFeedbackHelper(this._soundService, this._hapticService);

  /// Provide feedback when player draws an ingredient chip
  Future<void> onIngredientDraw() async {
    await _soundService.playSound(GameSoundEffect.ingredientDraw);
    await _hapticService.gameEvent(GameHapticType.ingredientDrag);
  }

  /// Provide feedback when player places an ingredient chip
  Future<void> onIngredientDrop() async {
    await _soundService.playSound(GameSoundEffect.ingredientDrop);
    await _hapticService.gameEvent(GameHapticType.ingredientDrop);
  }

  /// Provide feedback when cauldron bubbles or scores
  Future<void> onCauldronBubble() async {
    await _soundService.playSound(GameSoundEffect.cauldronBubble);
    await _hapticService.gameEvent(GameHapticType.scoring);
  }

  /// Provide feedback when explosion occurs
  Future<void> onExplosion() async {
    await _soundService.playSound(GameSoundEffect.explosion);
    await _hapticService.gameEvent(GameHapticType.explosion);
  }

  /// Provide feedback when using flask
  Future<void> onFlaskUse() async {
    await _soundService.playSound(GameSoundEffect.flaskUse);
    await _hapticService.gameEvent(GameHapticType.success);
  }

  /// Provide feedback when scoring points
  Future<void> onScoring() async {
    await _soundService.playSound(GameSoundEffect.scoring);
    await _hapticService.gameEvent(GameHapticType.scoring);
  }

  /// Provide feedback when round completes
  Future<void> onRoundComplete() async {
    await _soundService.playSound(GameSoundEffect.roundComplete);
    await _hapticService.gameEvent(GameHapticType.roundComplete);
  }

  /// Provide feedback when game is won
  Future<void> onGameWin() async {
    await _soundService.playSound(GameSoundEffect.gameWin);
    await _hapticService.gameEvent(GameHapticType.gameWin);
  }

  /// Provide feedback when game is lost
  Future<void> onGameLose() async {
    await _soundService.playSound(GameSoundEffect.gameLose);
    await _hapticService.gameEvent(GameHapticType.gameLose);
  }

  /// Provide feedback for UI interactions (buttons, etc.)
  Future<void> onButtonPress() async {
    await _soundService.playUISound(UISoundType.click);
    await _hapticService.gameEvent(GameHapticType.buttonPress);
  }

  /// Provide feedback for errors
  Future<void> onError() async {
    await _soundService.playUISound(UISoundType.error);
    await _hapticService.gameEvent(GameHapticType.error);
  }

  /// Provide feedback for success actions
  Future<void> onSuccess() async {
    await _soundService.playUISound(UISoundType.success);
    await _hapticService.gameEvent(GameHapticType.success);
  }
}

/// Provider for the game feedback helper
final gameFeedbackHelperProvider = Provider<GameFeedbackHelper>((ref) {
  final soundService = ref.read(soundServiceProvider);
  final hapticService = ref.read(hapticServiceProvider);
  return GameFeedbackHelper(soundService, hapticService);
});