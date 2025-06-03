import 'package:calderum/core/widgets/app_loader.dart';
import 'package:flutter/material.dart';

class CalderumButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool filled;
  final bool isLoading;

  const CalderumButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.filled = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = filled
        ? const Color(0xFFFFB347)
        : Colors.transparent;
    final textColor = filled ? Colors.black : const Color(0xFFFFB347);
    final border = BorderSide(color: const Color(0xFFFFB347), width: 2);

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: filled ? BorderSide.none : border,
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          fontFamily: 'Caudex',
        ),
      ),
      child: isLoading ? AppLoader(size: 26, strokeWidth: 4) : Text(label),
    );
  }
}
