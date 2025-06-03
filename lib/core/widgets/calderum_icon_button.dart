import 'package:flutter/material.dart';

class CalderumIconButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool filled;
  final IconData? icon;

  const CalderumIconButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.filled = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = filled
        ? const Color(0xFFFFB347)
        : Colors.transparent;
    final textColor = filled ? Colors.black : const Color(0xFFFFB347);
    final border = BorderSide(color: const Color(0xFFFFB347), width: 2);

    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: textColor),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: filled ? BorderSide.none : border,
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      tooltip: label,
    );
  }
}
