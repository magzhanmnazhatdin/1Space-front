import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'api_service.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String? _serverAuthToken;

  User? get currentUser => _firebaseAuth.currentUser;
  bool get isLoggedIn => currentUser != null;
  String? get userEmail => currentUser?.email;
  String? get userName => currentUser?.displayName;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String?> getServerToken() async {
    try {
      if (_serverAuthToken == null || currentUser == null) {
        if (currentUser != null) {
          _serverAuthToken = await currentUser!.getIdToken(true); // Обновляем токен
        }
      }
      return _serverAuthToken;
    } catch (e) {
      throw Exception('Failed to get server token: $e');
    }
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _serverAuthToken = await userCredential.user!.getIdToken();
      await ApiService.verifyAuth(_serverAuthToken!);
      notifyListeners();
      return userCredential;
    } catch (e) {
      throw Exception('Sign-in failed: $e');
    }
  }

  Future<UserCredential> createAccount({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _serverAuthToken = await userCredential.user!.getIdToken();
      await ApiService.verifyAuth(_serverAuthToken!);
      notifyListeners();
      return userCredential;
    } catch (e) {
      throw Exception('Account creation failed: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      _serverAuthToken = null;
      notifyListeners();
    } catch (e) {
      throw Exception('Sign-out failed: $e');
    }
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  Future<void> updateUsername({required String username}) async {
    try {
      await currentUser!.updateDisplayName(username);
      await currentUser!.reload();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to update username: $e');
    }
  }

  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await currentUser!.reauthenticateWithCredential(credential);
      await currentUser!.delete();
      await signOut();
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }

  Future<void> resetPasswordFromCurrentPassword({
    required String currentPassword,
    required String newPassword,
    required String email,
  }) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: currentPassword,
      );
      await currentUser!.reauthenticateWithCredential(credential);
      await currentUser!.updatePassword(newPassword);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to reset password: $e');
    }
  }
}