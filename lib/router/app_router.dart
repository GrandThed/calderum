import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/account/views/login_view.dart';
import '../features/account/views/signup_view.dart';
import '../features/account/views/forgot_password_view.dart';
import '../features/account/views/profile_view.dart';
import '../features/home/views/home_view.dart';
import '../features/room/views/room_lobby_view.dart';
import '../shared/constants/route_paths.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RoutePaths.home,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: RoutePaths.login,
        name: 'login',
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const LoginView()),
      ),
      GoRoute(
        path: RoutePaths.signup,
        name: 'signup',
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const SignupView()),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const ForgotPasswordView()),
      ),
      GoRoute(
        path: RoutePaths.home,
        name: 'home',
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const HomeView()),
      ),
      GoRoute(
        path: '${RoutePaths.room}/:roomId',
        name: 'room',
        pageBuilder: (context, state) {
          final roomId = state.pathParameters['roomId']!;
          return MaterialPage(
            key: state.pageKey,
            child: RoomLobbyView(roomId: roomId),
          );
        },
      ),
      GoRoute(
        path: RoutePaths.profile,
        name: 'profile',
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const ProfileView()),
      ),
    ],
  );
});
