import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CalderumAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CalderumAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    final location =
        router.routerDelegate.currentConfiguration.last.route.name ?? '/';
    final canGoBack = router.canPop();

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      title: Text(
        _routeTitle(location),
        style: Theme.of(context).textTheme.titleLarge,
      ),
      leading: canGoBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Back',
              onPressed: () => context.pop(),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  String _routeTitle(String location) {
    switch (location) {
      case '/home':
        return 'Home';
      case '/login':
        return 'Login';
      case '/signup':
        return 'Sign Up';
      default:
        return 'Calderum';
    }
  }
}
