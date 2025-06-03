import 'package:calderum/features/account/services/auth_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'signup_viewmodel.g.dart';

@riverpod
class SignUpViewModel extends _$SignUpViewModel {
  final _authService = AuthService();

  @override
  AsyncValue<void> build() {
    return const AsyncData(null);
  }

  Future<void> signUp(String email, String password) async {
    state = const AsyncLoading();

    try {
      await _authService.signUpWithEmail(email, password);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
