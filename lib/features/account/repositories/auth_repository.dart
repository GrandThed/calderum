import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user.dart';
import '../services/auth_service.dart';

part 'auth_repository.g.dart';

@riverpod
AuthService authService(AuthServiceRef ref) {
  return AuthService();
}

@riverpod
class AuthRepository extends _$AuthRepository {
  late final AuthService _authService;

  @override
  AsyncValue<AppUser?> build() {
    _authService = ref.watch(authServiceProvider);
    return const AsyncData(null);
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    
    try {
      await _authService.signInWithEmail(
        email: email,
        password: password,
      );
      final user = await _authService.getCurrentUser();
      state = AsyncData(user);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    
    try {
      await _authService.signUpWithEmail(
        email: email,
        password: password,
      );
      final user = await _authService.getCurrentUser();
      state = AsyncData(user);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> refreshCurrentUser() async {
    try {
      final user = await _authService.getCurrentUser();
      state = AsyncData(user);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}

@riverpod
Stream<AuthState> authStateChanges(AuthStateChangesRef ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
}

@riverpod
bool isLoggedIn(IsLoggedInRef ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.supabaseUser != null;
}