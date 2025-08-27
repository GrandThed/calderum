import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/account/views/login_view.dart';
import '../features/account/views/signup_view.dart';
import '../features/account/views/forgot_password_view.dart';
import '../features/home/views/home_view.dart';
import '../shared/constants/route_paths.dart';
import '../features/account/viewmodels/auth_viewmodel.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateStreamProvider);
  
  return GoRouter(
    initialLocation: RoutePaths.login,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: RoutePaths.login,
        name: 'login',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const LoginView(),
        ),
      ),
      GoRoute(
        path: RoutePaths.signup,
        name: 'signup',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const SignupView(),
        ),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const ForgotPasswordView(),
        ),
      ),
      GoRoute(
        path: RoutePaths.home,
        name: 'home',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const HomeView(),
        ),
        routes: [
          GoRoute(
            path: 'create-room',
            name: 'create-room',
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: const Scaffold(
                body: Center(child: Text('Create Room - Coming Soon')),
              ),
            ),
          ),
          GoRoute(
            path: 'join-room',
            name: 'join-room',
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: const Scaffold(
                body: Center(child: Text('Join Room - Coming Soon')),
              ),
            ),
          ),
        ],
      ),
      GoRoute(
        path: RoutePaths.profile,
        name: 'profile',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const Scaffold(
            body: Center(child: Text('Profile - Coming Soon')),
          ),
        ),
      ),
    ],
    redirect: (context, state) {
      final isAuth = authState.value != null;
      final isLoggingIn = state.matchedLocation == RoutePaths.login;
      final isSigningUp = state.matchedLocation == RoutePaths.signup;
      
      // If not authenticated and not on auth pages, redirect to login
      if (!isAuth && !isLoggingIn && !isSigningUp) {
        return RoutePaths.login;
      }
      
      // If authenticated and on auth pages, redirect to home
      if (isAuth && (isLoggingIn || isSigningUp)) {
        return RoutePaths.home;
      }
      
      return null;
    },
  );
});