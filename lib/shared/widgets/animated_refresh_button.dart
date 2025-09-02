import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedRefreshButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Color? color;
  final double iconSize;
  final String? tooltip;

  const AnimatedRefreshButton({
    super.key,
    required this.onPressed,
    this.color,
    this.iconSize = 20,
    this.tooltip,
  });

  @override
  State<AnimatedRefreshButton> createState() => _AnimatedRefreshButtonState();
}

class _AnimatedRefreshButtonState extends State<AnimatedRefreshButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void _handleRefresh() {
    if (!_rotationController.isAnimating) {
      _rotationController.forward().then((_) {
        _rotationController.reset();
      });
      widget.onPressed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value * 2 * math.pi,
          child: IconButton(
            onPressed: _handleRefresh,
            icon: const Icon(Icons.refresh),
            color: widget.color,
            iconSize: widget.iconSize,
            tooltip: widget.tooltip,
          ),
        );
      },
    );
  }
}