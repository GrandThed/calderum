import 'package:calderum/account/viewmodels/auth_viewmodel.dart';
import 'package:calderum/account/views/login_view.dart';
import 'package:calderum/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider);
  final auth = ref.watch(authViewModelProvider.notifier);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: notifier,
    redirect: (context, state) {
      final loggedIn = auth.isLoggedIn;
      final isLoggingIn =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup';

      if (!loggedIn && !isLoggingIn) return '/login';
      if (loggedIn && isLoggingIn) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/signup',
        builder: (context, state) =>
            const MyHomePage(title: "Calderum Sign up"),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const MyHomePage(title: "Calderum"),
      ),
    ],
  );
});

final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier();
});

class RouterNotifier extends ChangeNotifier {
  RouterNotifier() {
    Supabase.instance.client.auth.onAuthStateChange.listen((_) {
      notifyListeners();
    });
  }

  bool get isLoggedIn => Supabase.instance.client.auth.currentUser != null;
}
