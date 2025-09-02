import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

class CalderumAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const CalderumAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Caudex',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppTheme.secondaryColor,
        ),
      ),
      backgroundColor: AppTheme.surfaceColor,
      elevation: 0,
      leading: showBackButton
          ? Container(
              margin: const EdgeInsets.only(left: 8),
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: onBackPressed ?? () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/home');
                  }
                },
              ),
            )
          : null,
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                AppTheme.primaryColor.withValues(alpha: 0.3),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}
