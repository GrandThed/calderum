import 'package:calderum/features/account/repositories/auth_repository.dart';
import 'package:calderum/features/account/views/login_view.dart';
import 'package:calderum/features/account/views/signup_view.dart';
import 'package:calderum/features/home/views/home_view.dart';
import 'package:calderum/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider);
  final isLoggedIn = ref.watch(isLoggedInProvider);

  return GoRouter(
    initialLocation: LoginView.routeName,
    refreshListenable: notifier,
    redirect: (context, state) {
      final loggedIn = isLoggedIn;
      final isLoggingIn =
          state.matchedLocation == LoginView.routeName ||
          state.matchedLocation == SignUpView.routeName;
      if (!loggedIn && !isLoggingIn) return LoginView.routeName;
      if (loggedIn && isLoggingIn) return HomeView.routeName;
      return null;
    },
    routes: [
      GoRoute(
        path: LoginView.routeName,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: SignUpView.routeName,
        builder: (context, state) => const SignUpView(),
      ),
      GoRoute(
        path: HomeView.routeName,
        builder: (context, state) => const HomeView(),
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
