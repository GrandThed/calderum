import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

part 'profile_viewmodel.g.dart';

class ProfileState {
  final bool isLoading;
  final String? errorMessage;

  const ProfileState({this.isLoading = false, this.errorMessage});

  ProfileState copyWith({bool? isLoading, String? errorMessage}) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

@riverpod
class ProfileViewModel extends _$ProfileViewModel {
  late final AuthService _authService;
  late final FirebaseFirestore _firestore;
  late final FirebaseAuth _auth;

  @override
  ProfileState build() {
    _authService = ref.watch(authServiceProvider);
    _firestore = FirebaseFirestore.instance;
    _auth = FirebaseAuth.instance;

    return const ProfileState();
  }

  Future<void> updateProfile({
    required String displayName,
    String? photoUrl,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw 'No user logged in';
      }

      // Update Firebase Auth profile
      await user.updateDisplayName(displayName);
      if (photoUrl != null) {
        await user.updatePhotoURL(photoUrl);
      }

      // Update Firestore document
      await _firestore.collection('users').doc(user.uid).update({
        'displayName': displayName,
        if (photoUrl != null) 'photoUrl': photoUrl,
      });

      // Refresh the user model - refresh is handled by the auth state stream

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> updateGameStats({
    int? gamesPlayed,
    int? gamesWon,
    int? totalPoints,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw 'No user logged in';
      }

      final updates = <String, dynamic>{};
      if (gamesPlayed != null) updates['gamesPlayed'] = gamesPlayed;
      if (gamesWon != null) updates['gamesWon'] = gamesWon;
      if (totalPoints != null) updates['totalPoints'] = totalPoints;

      if (updates.isNotEmpty) {
        await _firestore.collection('users').doc(user.uid).update(updates);
        // Refresh is handled by the auth state stream
      }

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> deleteAccount() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw 'No user logged in';
      }

      // Delete user data from Firestore
      await _firestore.collection('users').doc(user.uid).delete();

      // Delete the Firebase Auth account
      await user.delete();

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());

      // If deletion requires recent authentication
      if (e is FirebaseAuthException && e.code == 'requires-recent-login') {
        throw 'Please sign out and sign in again before deleting your account';
      }

      rethrow;
    }
  }
}
