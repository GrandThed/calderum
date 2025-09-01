import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import 'package:calderum/shared/utils/anonymous_name_generator.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(FirebaseAuth.instance, FirebaseFirestore.instance);
});

class AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  AuthService(this._auth, this._firestore);

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserModel?> getCurrentUserModel() async {
    final user = currentUser;

    if (user == null) {
      return null;
    }

    final doc = await _firestore.collection('users').doc(user.uid).get();

    if (!doc.exists) {
      return null;
    }

    final userData = doc.data()!;

    return UserModel.fromJson({...userData, 'uid': user.uid});
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
    try {
      // Initialize Google Sign-In with proper configuration
      await _googleSignIn.initialize(
        clientId:
            '549073578108-2rmn4e2k4jooqg3r89lda3be39aoobvs.apps.googleusercontent.com',
        serverClientId:
            '549073578108-ka9hs571k3qan6mof1g5bgcrhtjsv1qh.apps.googleusercontent.com',
      );

      // ignore: unnecessary_nullable_for_final_variable_declarations
      final GoogleSignInAccount? googleUser = await _googleSignIn
          .authenticate();

      if (googleUser == null) {
        throw 'Google sign-in was cancelled';
      }

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      final userModel = await _updateUserData(userCredential.user!);

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Failed to sign in with Google: $e';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  Future<void> updateDisplayName(String displayName) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      await currentUser.updateDisplayName(displayName);

      // Update Firestore document
      await _firestore.collection('users').doc(currentUser.uid).update({
        'displayName': displayName,
      });
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<UserModel> signInAnonymously() async {
    try {
      final credential = await _auth.signInAnonymously();
      final user = credential.user!;

      // Check if anonymous user already exists in Firestore
      final existingDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (existingDoc.exists) {
        // Update last login for existing anonymous user
        await _firestore.collection('users').doc(user.uid).update({
          'lastLogin': DateTime.now().toIso8601String(),
        });

        return UserModel.fromJson({
          ...existingDoc.data()!,
          'uid': user.uid,
          'lastLogin': DateTime.now().toIso8601String(),
        });
      } else {
        // Generate a random mage name for new anonymous users
        final mageName = AnonymousNameGenerator.generateRandomMageName();

        final userModel = UserModel(
          uid: user.uid,
          displayName: mageName,
          isAnonymous: true,
          createdAt: DateTime.now(),
          lastLogin: DateTime.now(),
        );

        // Save anonymous user to Firestore
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userModel.toJson());

        return userModel;
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Failed to sign in anonymously: $e';
    }
  }

  Future<UserModel> createAnonymousUserModel(User firebaseUser) async {
    try {
      // Check if anonymous user already exists in Firestore
      final existingDoc = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (existingDoc.exists) {
        // Update last login for existing anonymous user
        await _firestore.collection('users').doc(firebaseUser.uid).update({
          'lastLogin': DateTime.now().toIso8601String(),
        });

        return UserModel.fromJson({
          ...existingDoc.data()!,
          'uid': firebaseUser.uid,
          'lastLogin': DateTime.now().toIso8601String(),
        });
      } else {
        final mageName = AnonymousNameGenerator.generateRandomMageName();

        final userModel = UserModel(
          uid: firebaseUser.uid,
          displayName: mageName,
          isAnonymous: true,
          createdAt: DateTime.now(),
          lastLogin: DateTime.now(),
        );

        // Save anonymous user to Firestore
        await _firestore
            .collection('users')
            .doc(firebaseUser.uid)
            .set(userModel.toJson());

        return userModel;
      }
    } catch (e) {
      // Fallback to in-memory model if Firestore fails
      final mageName = AnonymousNameGenerator.generateRandomMageName();
      return UserModel(
        uid: firebaseUser.uid,
        displayName: mageName,
        isAnonymous: true,
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
      );
    }
  }

  Future<UserModel> linkAnonymousToEmailPassword({
    required UserModel anonymousUser,
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null || !currentUser.isAnonymous) {
        throw 'No anonymous user to link';
      }

      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      // Link the anonymous account with email/password credential
      final userCredential = await currentUser.linkWithCredential(credential);
      await userCredential.user!.updateDisplayName(displayName);

      // Create authenticated user model preserving all anonymous user data
      final authenticatedUser = UserModel(
        uid: userCredential.user!.uid, // Same UID as anonymous user
        email: email,
        displayName: displayName,
        photoUrl: userCredential.user!.photoURL,
        isAnonymous: false, // Now authenticated
        gamesPlayed: anonymousUser.gamesPlayed,
        gamesWon: anonymousUser.gamesWon,
        totalPoints: anonymousUser.totalPoints,
        createdAt: anonymousUser.createdAt, // Preserve original creation date
        lastLogin: DateTime.now(),
      );

      // Update the existing Firestore document (same UID, just change isAnonymous and add auth data)
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .update({
            'email': email,
            'displayName': displayName,
            'photoUrl': userCredential.user!.photoURL,
            'isAnonymous': false,
            'lastLogin': DateTime.now().toIso8601String(),
          });

      return authenticatedUser;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Failed to link anonymous account to email/password: $e';
    }
  }

  Future<UserModel> linkAnonymousToGoogle({
    required UserModel anonymousUser,
  }) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null || !currentUser.isAnonymous) {
        throw 'No anonymous user to link';
      }

      await _googleSignIn.initialize(
        clientId:
            '549073578108-2rmn4e2k4jooqg3r89lda3be39aoobvs.apps.googleusercontent.com',
        serverClientId:
            '549073578108-ka9hs571k3qan6mof1g5bgcrhtjsv1qh.apps.googleusercontent.com',
      );
      // ignore: unnecessary_nullable_for_final_variable_declarations
      final GoogleSignInAccount? googleUser = await _googleSignIn
          .authenticate();

      if (googleUser == null) {
        throw 'Google sign-in was cancelled';
      }

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Link the anonymous account with Google credential
      final userCredential = await currentUser.linkWithCredential(credential);

      // Create authenticated user model preserving all anonymous user data
      final authenticatedUser = UserModel(
        uid: userCredential.user!.uid, // Same UID as anonymous user
        email: userCredential.user!.email,
        displayName:
            userCredential.user!.displayName ??
            googleUser.displayName ??
            'User',
        photoUrl: userCredential.user!.photoURL,
        isAnonymous: false, // Now authenticated
        gamesPlayed: anonymousUser.gamesPlayed,
        gamesWon: anonymousUser.gamesWon,
        totalPoints: anonymousUser.totalPoints,
        createdAt: anonymousUser.createdAt, // Preserve original creation date
        lastLogin: DateTime.now(),
      );

      // Update the existing Firestore document (same UID, just change isAnonymous and add auth data)
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .update({
            'email': userCredential.user!.email,
            'displayName':
                userCredential.user!.displayName ??
                googleUser.displayName ??
                'User',
            'photoUrl': userCredential.user!.photoURL,
            'isAnonymous': false,
            'lastLogin': DateTime.now().toIso8601String(),
          });

      return authenticatedUser;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Failed to link with Google: $e';
    }
  }

  Future<UserModel> _createUserData(User user) async {
    return await _retryFirestoreOperation(() async {
      final userModel = UserModel(
        uid: user.uid,
        email: user.email,
        displayName: user.displayName ?? '',
        photoUrl: user.photoURL,
        isAnonymous: false,
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
      );

      try {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userModel.toJson());
        return userModel;
      } catch (e) {
        // If user already exists, fetch the existing data
        if (e.toString().contains('DUPLICATE_RAW_ID') ||
            e.toString().contains('already exists')) {
          final doc = await _firestore.collection('users').doc(user.uid).get();
          if (doc.exists) {
            return UserModel.fromJson({...doc.data()!, 'uid': user.uid});
          }
        }
        rethrow;
      }
    });
  }

  Future<UserModel> _updateUserData(User user) async {
    return await _retryFirestoreOperation(() async {
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
    });
  }

  Future<T> _retryFirestoreOperation<T>(Future<T> Function() operation) async {
    int retryCount = 0;
    const maxRetries = 3;
    const baseDelay = Duration(seconds: 1);

    while (retryCount < maxRetries) {
      try {
        return await operation();
      } catch (e) {
        retryCount++;

        if (e.toString().contains('unavailable') && retryCount < maxRetries) {
          await Future.delayed(baseDelay * retryCount);
          continue;
        }

        // If it's a duplicate user error, let the specific method handle it
        if (e.toString().contains('DUPLICATE_RAW_ID') ||
            e.toString().contains('already exists')) {
          rethrow;
        }

        rethrow;
      }
    }

    throw Exception('Maximum retries exceeded for Firestore operation');
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
