import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Shared across the whole app, so every avatar updates together.
  /// Holds a data: URI string (e.g. "data:image/jpeg;base64,...") or null.
  static final ValueNotifier<String?> photoUrlNotifier = ValueNotifier<String?>(null);

  /// Call this any time you want the notifier to match Firestore right now.
  static Future<void> syncNow() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      photoUrlNotifier.value = null;
      return;
    }
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      photoUrlNotifier.value = doc.data()?['photoBase64'] as String?;
    } catch (_) {
      photoUrlNotifier.value = null;
    }
  }

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges {
    return _auth.authStateChanges().map((user) {
      if (user != null) {
        syncNow();
      } else {
        photoUrlNotifier.value = null;
      }
      return user;
    });
  }

  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await credential.user?.updateDisplayName(name);
    return credential;
  }

  Future<UserCredential> logIn({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logOut() {
    return _auth.signOut();
  }

  Future<void> resetPassword(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateDisplayName(String name) async {
    await currentUser?.updateDisplayName(name);
    await currentUser?.reload();
  }

  /// Sends a verification link to the new address. The account's email
  /// only changes once the user opens that link, not immediately.
  Future<void> updateEmail(String newEmail) async {
    await currentUser?.verifyBeforeUpdateEmail(newEmail);
  }

  /// Firebase requires a recent login before letting the email change.
  Future<void> reauthenticateWithPassword(String password) async {
    final user = currentUser;
    if (user == null || user.email == null) return;
    final credential =
        EmailAuthProvider.credential(email: user.email!, password: password);
    await user.reauthenticateWithCredential(credential);
  }

  /// Stores the already-compressed JPEG bytes as a Base64 data URI on the
  /// user's own Firestore document. No external storage needed.
  Future<String> uploadProfilePhoto(Uint8List bytes) async {
    final user = currentUser;
    if (user == null) throw Exception('You must be logged in to do that.');

    if (bytes.lengthInBytes > 700 * 1024) {
      throw Exception('That image is too large. Please choose a smaller photo.');
    }

    final dataUri = 'data:image/jpeg;base64,${base64Encode(bytes)}';

    await _db.collection('users').doc(user.uid).set(
      {'photoBase64': dataUri},
      SetOptions(merge: true),
    );

    photoUrlNotifier.value = dataUri;
    return dataUri;
  }

  String friendlyError(Object e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return 'No account found for that email.';
        case 'wrong-password':
        case 'invalid-credential':
          return 'Incorrect email or password.';
        case 'email-already-in-use':
          return 'That email is already registered.';
        case 'weak-password':
          return 'Password should be at least 6 characters.';
        case 'invalid-email':
          return 'That email address looks invalid.';
        case 'requires-recent-login':
          return 'Please re-enter your password to confirm this change.';
        default:
          return e.message ?? 'Something went wrong. Please try again.';
      }
    }
    return e.toString().replaceFirst('Exception: ', '');
  }
}
