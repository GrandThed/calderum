import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the animation service
final animationServiceProvider = Provider<AnimationService>((ref) {
  return AnimationService();
});

/// Service for managing animations and effects throughout the app
class AnimationService {
  static const String _animationsEnabledKey = 'animations_enabled';
  static const String _reducedMotionKey = 'reduced_motion';

  bool _animationsEnabled = true;
  bool _reducedMotion = false;

  /// Initialize the animation service with default settings
  Future<void> initialize() async {
    // Using default values for now - can be enhanced with SharedPreferences later
    _animationsEnabled = true;
    _reducedMotion = false;
  }

  /// Get animation duration based on settings
  Duration getAnimationDuration(AnimationType type) {
    if (!_animationsEnabled || _reducedMotion) {
      return Duration.zero;
    }

    switch (type) {
      case AnimationType.quick:
        return const Duration(milliseconds: 150);
      case AnimationType.standard:
        return const Duration(milliseconds: 300);
      case AnimationType.slow:
        return const Duration(milliseconds: 500);
      case AnimationType.explosion:
        return const Duration(milliseconds: 800);
      case AnimationType.celebration:
        return const Duration(milliseconds: 1200);
    }
  }

  /// Get curve for animation type
  Curve getAnimationCurve(AnimationType type) {
    switch (type) {
      case AnimationType.quick:
        return Curves.easeOut;
      case AnimationType.standard:
        return Curves.easeInOut;
      case AnimationType.slow:
        return Curves.easeInOutCubic;
      case AnimationType.explosion:
        return Curves.elasticOut;
      case AnimationType.celebration:
        return Curves.bounceOut;
    }
  }

  /// Create a fade transition
  Widget fadeTransition({
    required Widget child,
    required Animation<double> animation,
    AnimationType type = AnimationType.standard,
  }) {
    if (!_animationsEnabled) return child;

    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animation,
          curve: getAnimationCurve(type),
        ),
      ),
      child: child,
    );
  }

  /// Create a scale transition
  Widget scaleTransition({
    required Widget child,
    required Animation<double> animation,
    AnimationType type = AnimationType.standard,
    double beginScale = 0.0,
    double endScale = 1.0,
  }) {
    if (!_animationsEnabled) return child;

    return ScaleTransition(
      scale: Tween<double>(begin: beginScale, end: endScale).animate(
        CurvedAnimation(
          parent: animation,
          curve: getAnimationCurve(type),
        ),
      ),
      child: child,
    );
  }

  /// Create a slide transition
  Widget slideTransition({
    required Widget child,
    required Animation<double> animation,
    required Offset beginOffset,
    AnimationType type = AnimationType.standard,
    Offset endOffset = Offset.zero,
  }) {
    if (!_animationsEnabled) return child;

    return SlideTransition(
      position: Tween<Offset>(begin: beginOffset, end: endOffset).animate(
        CurvedAnimation(
          parent: animation,
          curve: getAnimationCurve(type),
        ),
      ),
      child: child,
    );
  }

  /// Create a rotation transition
  Widget rotationTransition({
    required Widget child,
    required Animation<double> animation,
    AnimationType type = AnimationType.standard,
    double beginRotation = 0.0,
    double endRotation = 1.0,
  }) {
    if (!_animationsEnabled) return child;

    return RotationTransition(
      turns: Tween<double>(begin: beginRotation, end: endRotation).animate(
        CurvedAnimation(
          parent: animation,
          curve: getAnimationCurve(type),
        ),
      ),
      child: child,
    );
  }

  /// Create particle effect animation (for explosions, scoring, etc.)
  Widget particleEffect({
    required Widget child,
    required Animation<double> animation,
    ParticleType particleType = ParticleType.explosion,
  }) {
    if (!_animationsEnabled) return child;

    switch (particleType) {
      case ParticleType.explosion:
        return _explosionParticles(child, animation);
      case ParticleType.sparkle:
        return _sparkleParticles(child, animation);
      case ParticleType.score:
        return _scoreParticles(child, animation);
    }
  }

  Widget _explosionParticles(Widget child, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return Transform.scale(
          scale: 1.0 + (animation.value * 0.3),
          child: Opacity(
            opacity: 1.0 - animation.value,
            child: child,
          ),
        );
      },
    );
  }

  Widget _sparkleParticles(Widget child, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return Transform.rotate(
          angle: animation.value * 2 * 3.14159,
          child: Transform.scale(
            scale: 0.8 + (animation.value * 0.4),
            child: child,
          ),
        );
      },
    );
  }

  Widget _scoreParticles(Widget child, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(0, -50 * animation.value),
          child: Opacity(
            opacity: 1.0 - animation.value,
            child: child,
          ),
        );
      },
    );
  }

  /// Enable or disable animations
  Future<void> setAnimationsEnabled(bool enabled) async {
    _animationsEnabled = enabled;
    // TODO: Save to SharedPreferences when added to pubspec
  }

  /// Enable or disable reduced motion (accessibility)
  Future<void> setReducedMotion(bool reduced) async {
    _reducedMotion = reduced;
    // TODO: Save to SharedPreferences when added to pubspec
  }

  // Getters for current settings
  bool get animationsEnabled => _animationsEnabled;
  bool get reducedMotion => _reducedMotion;
}

/// Types of animations with different timing and curves
enum AnimationType {
  quick,
  standard,
  slow,
  explosion,
  celebration,
}

/// Types of particle effects
enum ParticleType {
  explosion,
  sparkle,
  score,
}