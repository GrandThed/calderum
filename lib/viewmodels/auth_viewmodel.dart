import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../services/supabase/auth_service.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  final _authService = AuthService();

  @override
  bool build() => false; // isLoading

  Future<String?> login(String email, String password) async {
    state = true;
    try {
      await _authService.signInWithEmail(email, password);
      return null;
    } catch (e) {
      return e.toString();
    } finally {
      state = false;
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
  }

  bool get isLoggedIn => _authService.currentUser != null;
}
