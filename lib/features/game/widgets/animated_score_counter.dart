import 'package:flutter/material.dart';
import '../../../shared/theme/app_theme.dart';

/// Animated score counter that smoothly transitions between score values
class AnimatedScoreCounter extends StatefulWidget {
  final int score;
  final String label;
  final IconData? icon;
  final Color? color;
  final double fontSize;
  final Duration animationDuration;
  final bool showPlusSign;

  const AnimatedScoreCounter({
    super.key,
    required this.score,
    this.label = 'Score',
    this.icon,
    this.color,
    this.fontSize = 24,
    this.animationDuration = const Duration(milliseconds: 800),
    this.showPlusSign = false,
  });

  @override
  State<AnimatedScoreCounter> createState() => _AnimatedScoreCounterState();
}

class _AnimatedScoreCounterState extends State<AnimatedScoreCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  late Animation<Color?> _colorAnimation;

  int _displayScore = 0;
  int _previousScore = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOutBack),
      ),
    );

    final baseColor = widget.color ?? AppTheme.primaryColor;
    _colorAnimation = ColorTween(
      begin: baseColor,
      end: Colors.green,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _displayScore = widget.score;
    _previousScore = widget.score;
  }

  @override
  void didUpdateWidget(AnimatedScoreCounter oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.score != widget.score) {
      _previousScore = _displayScore;
      _animateScoreChange();
    }
  }

  void _animateScoreChange() {
    if (_controller.isAnimating) {
      _controller.stop();
    }

    _controller.forward(from: 0.0).then((_) {
      _controller.reverse().then((_) {
        setState(() {
          _displayScore = widget.score;
        });
      });
    });

    // Animate the number counting up/down
    _animateNumberChange();
  }

  void _animateNumberChange() {
    final difference = widget.score - _previousScore;
    if (difference == 0) return;

    final steps = difference.abs().clamp(
      1,
      20,
    ); // Max 20 steps for smooth animation
    final stepDuration = widget.animationDuration.inMilliseconds ~/ steps;

    for (int i = 1; i <= steps; i++) {
      Future.delayed(Duration(milliseconds: i * stepDuration), () {
        if (mounted) {
          setState(() {
            _displayScore = _previousScore + ((difference * i) ~/ steps);
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final isAnimating = _controller.isAnimating;
        final currentColor = isAnimating
            ? _colorAnimation.value
            : (widget.color ?? AppTheme.primaryColor);

        return Transform.scale(
          scale: isAnimating ? _scaleAnimation.value : 1.0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: currentColor?.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    currentColor?.withValues(alpha: 0.3) ?? Colors.transparent,
                width: 2,
              ),
              boxShadow: isAnimating
                  ? [
                      BoxShadow(
                        color:
                            currentColor?.withValues(alpha: 0.3) ??
                            Colors.transparent,
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon (if provided)
                if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    color: currentColor,
                    size: widget.fontSize * 0.8,
                  ),
                  const SizedBox(height: 4),
                ],

                // Score display
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Plus sign animation (for score increases)
                    if (widget.showPlusSign && _displayScore > _previousScore)
                      Transform.translate(
                        offset: Offset(0, -_slideAnimation.value * 10),
                        child: Opacity(
                          opacity: _slideAnimation.value,
                          child: Text(
                            '+',
                            style: AppTheme.titleStyle.copyWith(
                              fontSize: widget.fontSize * 0.7,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),

                    // Main score
                    Text(
                      '$_displayScore',
                      style: AppTheme.titleStyle.copyWith(
                        fontSize: widget.fontSize,
                        fontWeight: FontWeight.bold,
                        color: currentColor,
                        fontFamily: 'Caudex',
                      ),
                    ),
                  ],
                ),

                // Score change indicator
                if (isAnimating && _displayScore != _previousScore)
                  Transform.translate(
                    offset: Offset(0, _slideAnimation.value * 15),
                    child: Opacity(
                      opacity: 1 - _slideAnimation.value,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _displayScore > _previousScore
                              ? Colors.green.withValues(alpha: 0.2)
                              : Colors.red.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _displayScore > _previousScore
                              ? '+${_displayScore - _previousScore}'
                              : '${_displayScore - _previousScore}',
                          style: AppTheme.bodyStyle.copyWith(
                            fontSize: widget.fontSize * 0.4,
                            fontWeight: FontWeight.bold,
                            color: _displayScore > _previousScore
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),

                // Label
                const SizedBox(height: 2),
                Text(
                  widget.label,
                  style: AppTheme.bodyStyle.copyWith(
                    fontSize: widget.fontSize * 0.4,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Specialized score counter for victory points
class VictoryPointsCounter extends StatelessWidget {
  final int victoryPoints;
  final bool showAnimation;

  const VictoryPointsCounter({
    super.key,
    required this.victoryPoints,
    this.showAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScoreCounter(
      score: victoryPoints,
      label: 'Victory Points',
      icon: Icons.emoji_events,
      color: AppTheme.secondaryColor,
      fontSize: 28,
      showPlusSign: showAnimation,
    );
  }
}

/// Specialized score counter for coins
class CoinsCounter extends StatelessWidget {
  final int coins;
  final bool showAnimation;

  const CoinsCounter({
    super.key,
    required this.coins,
    this.showAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScoreCounter(
      score: coins,
      label: 'Coins',
      icon: Icons.monetization_on,
      color: Colors.amber,
      fontSize: 20,
      showPlusSign: showAnimation,
    );
  }
}

/// Specialized score counter for rubies
class RubiesCounter extends StatelessWidget {
  final int rubies;
  final bool showAnimation;

  const RubiesCounter({
    super.key,
    required this.rubies,
    this.showAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScoreCounter(
      score: rubies,
      label: 'Rubies',
      icon: Icons.diamond,
      color: Colors.red.shade400,
      fontSize: 20,
      showPlusSign: showAnimation,
    );
  }
}

/// Row of score counters for a player
class PlayerScoreRow extends StatelessWidget {
  final int victoryPoints;
  final int coins;
  final int rubies;
  final bool showAnimations;

  const PlayerScoreRow({
    super.key,
    required this.victoryPoints,
    required this.coins,
    required this.rubies,
    this.showAnimations = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        VictoryPointsCounter(
          victoryPoints: victoryPoints,
          showAnimation: showAnimations,
        ),
        CoinsCounter(coins: coins, showAnimation: showAnimations),
        RubiesCounter(rubies: rubies, showAnimation: showAnimations),
      ],
    );
  }
}
