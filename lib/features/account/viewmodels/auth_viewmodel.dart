import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/auth_state.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late final AuthService _authService;

  @override
  AuthState build() {
    _authService = ref.watch(authServiceProvider);
    
    ref.listen(authStateStreamProvider, (previous, next) {
      next.when(
        data: (user) async {
          if (user != null) {
            final userModel = await _authService.getCurrentUserModel();
            if (userModel != null) {
              state = AuthState.authenticated(userModel);
            }
          } else {
            state = const AuthState.unauthenticated();
          }
        },
        loading: () => state = const AuthState.loading(),
        error: (error, _) => state = AuthState.error(error.toString()),
      );
    });

    return const AuthState.initial();
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();
    try {
      final user = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = const AuthState.loading();
    try {
      final user = await _authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
      );
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AuthState.loading();
    try {
      final user = await _authService.signInWithGoogle();
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> signOut() async {
    state = const AuthState.loading();
    try {
      await _authService.signOut();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _authService.resetPassword(email);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }
}

@riverpod
Stream<User?> authStateStream(AuthStateStreamRef ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
}

@riverpod
Future<UserModel?> currentUserModel(CurrentUserModelRef ref) async {
  final authService = ref.watch(authServiceProvider);
  return await authService.getCurrentUserModel();
}