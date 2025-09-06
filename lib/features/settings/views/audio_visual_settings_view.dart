import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/services/sound_service.dart';
import '../../../shared/services/haptic_service.dart';
import '../../../shared/services/animation_service.dart';
import '../../../shared/widgets/calderum_app_bar.dart';
import '../../../shared/theme/app_theme.dart';

class AudioVisualSettingsView extends ConsumerWidget {
  const AudioVisualSettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final soundService = ref.read(soundServiceProvider);
    final hapticService = ref.read(hapticServiceProvider);
    final animationService = ref.read(animationServiceProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const CalderumAppBar(
        title: '🎵 Audio & Visual',
        showBackButton: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Sound Settings Section
          _buildSection(
            title: 'Sound Effects',
            icon: Icons.volume_up,
            children: [
              _buildSoundEnabledToggle(soundService),
              if (soundService.soundEnabled) ...[
                const SizedBox(height: 16),
                _buildSoundVolumeSlider(soundService),
              ],
            ],
          ),

          const SizedBox(height: 24),

          // Music Settings Section
          _buildSection(
            title: 'Background Music',
            icon: Icons.music_note,
            children: [
              _buildMusicEnabledToggle(soundService),
              if (soundService.musicEnabled) ...[
                const SizedBox(height: 16),
                _buildMusicVolumeSlider(soundService),
              ],
            ],
          ),

          const SizedBox(height: 24),

          // Haptic Settings Section
          _buildSection(
            title: 'Haptic Feedback',
            icon: Icons.vibration,
            children: [
              _buildHapticEnabledToggle(hapticService),
              if (hapticService.hapticEnabled) ...[
                const SizedBox(height: 16),
                _buildHapticIntensitySelector(hapticService),
              ],
            ],
          ),

          const SizedBox(height: 24),

          // Animation Settings Section
          _buildSection(
            title: 'Animations',
            icon: Icons.animation,
            children: [
              _buildAnimationsEnabledToggle(animationService),
              const SizedBox(height: 16),
              _buildReducedMotionToggle(animationService),
            ],
          ),

          const SizedBox(height: 32),

          // Test Section
          _buildSection(
            title: 'Test Settings',
            icon: Icons.play_circle,
            children: [
              _buildTestButtons(soundService, hapticService),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.secondaryColor, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: AppTheme.headingStyle.copyWith(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSoundEnabledToggle(SoundService soundService) {
    return _buildToggleRow(
      title: 'Enable Sound Effects',
      subtitle: 'Play sounds for game actions and UI interactions',
      value: soundService.soundEnabled,
      onChanged: (value) => soundService.setSoundEnabled(value),
    );
  }

  Widget _buildMusicEnabledToggle(SoundService soundService) {
    return _buildToggleRow(
      title: 'Enable Background Music',
      subtitle: 'Play ambient music during gameplay',
      value: soundService.musicEnabled,
      onChanged: (value) => soundService.setMusicEnabled(value),
    );
  }

  Widget _buildHapticEnabledToggle(HapticService hapticService) {
    return _buildToggleRow(
      title: 'Enable Haptic Feedback',
      subtitle: 'Feel vibrations for game interactions',
      value: hapticService.hapticEnabled,
      onChanged: (value) => hapticService.setHapticEnabled(value),
    );
  }

  Widget _buildAnimationsEnabledToggle(AnimationService animationService) {
    return _buildToggleRow(
      title: 'Enable Animations',
      subtitle: 'Show visual effects and transitions',
      value: animationService.animationsEnabled,
      onChanged: (value) => animationService.setAnimationsEnabled(value),
    );
  }

  Widget _buildReducedMotionToggle(AnimationService animationService) {
    return _buildToggleRow(
      title: 'Reduce Motion',
      subtitle: 'Minimize animations for accessibility',
      value: animationService.reducedMotion,
      onChanged: (value) => animationService.setReducedMotion(value),
    );
  }

  Widget _buildToggleRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.bodyStyle.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTheme.bodyStyle.copyWith(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppTheme.primaryColor,
          activeTrackColor: AppTheme.primaryColor.withValues(alpha: 0.3),
        ),
      ],
    );
  }

  Widget _buildSoundVolumeSlider(SoundService soundService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sound Volume',
          style: AppTheme.bodyStyle.copyWith(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Slider(
          value: soundService.soundVolume,
          onChanged: (value) => soundService.setSoundVolume(value),
          activeColor: AppTheme.primaryColor,
          inactiveColor: Colors.white24,
          divisions: 10,
          label: '${(soundService.soundVolume * 100).round()}%',
        ),
      ],
    );
  }

  Widget _buildMusicVolumeSlider(SoundService soundService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Music Volume',
          style: AppTheme.bodyStyle.copyWith(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Slider(
          value: soundService.musicVolume,
          onChanged: (value) => soundService.setMusicVolume(value),
          activeColor: AppTheme.primaryColor,
          inactiveColor: Colors.white24,
          divisions: 10,
          label: '${(soundService.musicVolume * 100).round()}%',
        ),
      ],
    );
  }

  Widget _buildHapticIntensitySelector(HapticService hapticService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Haptic Intensity',
          style: AppTheme.bodyStyle.copyWith(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: HapticIntensity.values.map((intensity) {
            final isSelected = hapticService.hapticIntensity == intensity;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () => hapticService.setHapticIntensity(intensity),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? AppTheme.primaryColor.withValues(alpha: 0.3)
                          : Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected 
                            ? AppTheme.primaryColor
                            : Colors.white.withValues(alpha: 0.2),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        intensity.displayName,
                        style: AppTheme.bodyStyle.copyWith(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTestButtons(SoundService soundService, HapticService hapticService) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              soundService.playUISound(UISoundType.success);
              hapticService.gameEvent(GameHapticType.success);
            },
            icon: const Icon(Icons.volume_up),
            label: const Text('Test Sound'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.2),
              foregroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              hapticService.gameEvent(GameHapticType.explosion);
            },
            icon: const Icon(Icons.vibration),
            label: const Text('Test Haptic'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.2),
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}