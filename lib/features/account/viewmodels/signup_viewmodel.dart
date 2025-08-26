import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repositories/auth_repository.dart';

part 'signup_viewmodel.g.dart';

@riverpod
class SignUpViewModel extends _$SignUpViewModel {
  @override
  AsyncValue<void> build() {
    return const AsyncData(null);
  }

  Future<void> signUp(String email, String password) async {
    state = const AsyncLoading();

    try {
      await ref.read(authRepositoryProvider.notifier).signUp(
        email: email,
        password: password,
      );
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}
