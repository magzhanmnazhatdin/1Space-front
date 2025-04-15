// services/auth_service.dart

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
    if (_serverAuthToken == null && currentUser != null) {
      _serverAuthToken = await currentUser!.getIdToken();
    }
    return _serverAuthToken;
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    _serverAuthToken = await userCredential.user!.getIdToken();
    await ApiService.verifyAuth(_serverAuthToken!);
    notifyListeners();
    return userCredential;
  }

  Future<UserCredential> createAccount({
    required String email,
    required String password,
  }) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    _serverAuthToken = await userCredential.user!.getIdToken();
    await ApiService.verifyAuth(_serverAuthToken!);
    notifyListeners();
    return userCredential;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    _serverAuthToken = null;
    notifyListeners();
  }

  Future<void> resetPassword({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateUsername({required String username}) async {
    await currentUser!.updateDisplayName(username);
    await currentUser!.reload();
    notifyListeners();
  }

  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.delete();
    await signOut();
  }

  Future<void> resetPasswordFromCurrentPassword({
    required String currentPassword,
    required String newPassword,
    required String email,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.updatePassword(newPassword);
    notifyListeners();
  }
}