import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/sound_service.dart';
import '../services/haptic_service.dart';

enum CalderumButtonStyle { primary, secondary, danger, outlined }

class CalderumButton extends ConsumerWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final CalderumButtonStyle style;
  final IconData? icon;
  final double? width;
  final double height;

  const CalderumButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.style = CalderumButtonStyle.primary,
    this.icon,
    this.width,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final soundService = ref.read(soundServiceProvider);
    final hapticService = ref.read(hapticServiceProvider);
    
    // Enhanced onPressed with feedback
    final enhancedOnPressed = onPressed == null ? null : () {
      soundService.playUISound(UISoundType.click);
      hapticService.gameEvent(GameHapticType.buttonPress);
      onPressed!();
    };
    
    final Widget child = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );

    final theme = Theme.of(context);

    switch (style) {
      case CalderumButtonStyle.outlined:
        return SizedBox(
          width: width,
          height: height,
          child: OutlinedButton(
            onPressed: isLoading ? null : enhancedOnPressed,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: theme.colorScheme.primary, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: child,
          ),
        );

      case CalderumButtonStyle.secondary:
        return SizedBox(
          width: width,
          height: height,
          child: ElevatedButton(
            onPressed: isLoading ? null : enhancedOnPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.secondaryContainer,
              foregroundColor: theme.colorScheme.onSecondaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: child,
          ),
        );

      case CalderumButtonStyle.danger:
        return SizedBox(
          width: width,
          height: height,
          child: ElevatedButton(
            onPressed: isLoading ? null : enhancedOnPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.errorContainer,
              foregroundColor: theme.colorScheme.onErrorContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: child,
          ),
        );

      case CalderumButtonStyle.primary:
        return SizedBox(
          width: width,
          height: height,
          child: ElevatedButton(
            onPressed: isLoading ? null : enhancedOnPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
            ),
            child: child,
          ),
        );
    }
  }
}
