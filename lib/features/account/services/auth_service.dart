import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(FirebaseAuth.instance, FirebaseFirestore.instance);
});

class AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  // final GoogleSignIn _googleSignIn = GoogleSignIn(
  //   scopes: ['email'],
  // );

  AuthService(this._auth, this._firestore);

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserModel?> getCurrentUserModel() async {
    final user = currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;

    return UserModel.fromJson({...doc.data()!, 'uid': user.uid});
  }

  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return await _updateUserData(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user!.updateDisplayName(displayName);

      return await _createUserData(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<UserModel> signInWithGoogle() async {
    // TODO: Implement Google Sign-In once API is clarified
    throw 'Google Sign-In not implemented yet';
  }

  Future<void> signOut() async {
    await _auth.signOut();
    // await _googleSignIn.signOut(); // TODO: Add back when Google Sign-In is implemented
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<UserModel> _createUserData(User user) async {
    final userModel = UserModel(
      uid: user.uid,
      email: user.email!,
      displayName: user.displayName ?? '',
      photoUrl: user.photoURL,
      createdAt: DateTime.now(),
      lastLogin: DateTime.now(),
    );

    await _firestore.collection('users').doc(user.uid).set(userModel.toJson());

    return userModel;
  }

  Future<UserModel> _updateUserData(User user) async {
    final doc = await _firestore.collection('users').doc(user.uid).get();

    if (!doc.exists) {
      return await _createUserData(user);
    }

    await _firestore.collection('users').doc(user.uid).update({
      'lastLogin': DateTime.now().toIso8601String(),
    });

    return UserModel.fromJson({
      ...doc.data()!,
      'uid': user.uid,
      'lastLogin': DateTime.now().toIso8601String(),
    });
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      default:
        return e.message ?? 'An error occurred. Please try again.';
    }
  }
}
