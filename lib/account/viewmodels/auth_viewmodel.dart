import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../services/auth_service.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  final _authService = AuthService();

  @override
  AsyncValue<void> build() {
    return const AsyncData(null);
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();

    try {
      await _authService.signInWithEmail(email, password);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
  }

  Stream<void> get authStateChanges => _authService.authStateChanges;
  bool get isLoggedIn => _authService.currentUser != null;
}
