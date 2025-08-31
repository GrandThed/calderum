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
      print('🔄 Auth state stream update received');
      next.when(
        data: (user) async {
          print('📊 Auth stream data: user=${user?.uid}, isAnonymous=${user?.isAnonymous}');
          if (user != null) {
            if (user.isAnonymous) {
              print('🧙 Processing anonymous user from stream');
              // Create/retrieve anonymous user model from Firestore
              final anonymousUser = await _authService.createAnonymousUserModel(user);
              state = AuthState.anonymous(anonymousUser);
              print('✅ Set state to anonymous');
            } else {
              print('🔐 Processing authenticated user from stream');
              // Get authenticated user from Firestore
              final userModel = await _authService.getCurrentUserModel();
              if (userModel != null) {
                state = AuthState.authenticated(userModel);
                print('✅ Set state to authenticated');
              }
            }
          } else {
            print('❓ No user found in stream, signing in anonymously...');
            // Sign in anonymously automatically
            try {
              final anonymousUser = await _authService.signInAnonymously();
              state = AuthState.anonymous(anonymousUser);
              print('✅ Auto anonymous sign-in successful');
            } catch (e) {
              print('❌ Auto anonymous sign-in failed: $e');
              state = AuthState.error(e.toString());
            }
          }
        },
        loading: () {
          print('⏳ Auth state stream loading');
          state = const AuthState.loading();
        },
        error: (error, _) {
          print('❌ Auth state stream error: $error');
          state = AuthState.error(error.toString());
        },
      );
    });

    return const AuthState.initial();
  }

  Future<void> signIn({required String email, required String password}) async {
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

  Future<void> linkAnonymousToEmailPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final currentState = state;
    if (!currentState.maybeWhen(
      anonymous: (_) => true,
      orElse: () => false,
    )) {
      state = const AuthState.error('No anonymous user to link');
      return;
    }

    state = const AuthState.loading();
    try {
      final anonymousUser = currentState.maybeWhen(
        anonymous: (user) => user,
        orElse: () => null,
      );
      
      if (anonymousUser == null) {
        throw 'No anonymous user found';
      }

      final user = await _authService.linkAnonymousToEmailPassword(
        anonymousUser: anonymousUser,
        email: email,
        password: password,
        displayName: displayName,
      );
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> linkAnonymousToGoogle() async {
    final currentState = state;
    if (!currentState.maybeWhen(
      anonymous: (_) => true,
      orElse: () => false,
    )) {
      state = const AuthState.error('No anonymous user to link');
      return;
    }

    state = const AuthState.loading();
    try {
      final anonymousUser = currentState.maybeWhen(
        anonymous: (user) => user,
        orElse: () => null,
      );
      
      if (anonymousUser == null) {
        throw 'No anonymous user found';
      }

      final user = await _authService.linkAnonymousToGoogle(
        anonymousUser: anonymousUser,
      );
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> continueAsAnonymous() async {
    state = const AuthState.loading();
    try {
      final anonymousUser = await _authService.signInAnonymously();
      state = AuthState.anonymous(anonymousUser);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  UserModel? getCurrentUser() {
    return state.maybeWhen(
      authenticated: (user) => user,
      anonymous: (user) => user,
      orElse: () => null,
    );
  }

  bool get isAnonymous => state.maybeWhen(
    anonymous: (_) => true,
    orElse: () => false,
  );

  bool get isAuthenticated => state.maybeWhen(
    authenticated: (_) => true,
    orElse: () => false,
  );

  bool get hasUser => getCurrentUser() != null;
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
