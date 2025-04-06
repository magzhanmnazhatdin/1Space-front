import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'api_service.dart';

ValueNotifier<AuthService> authService = ValueNotifier(AuthService());

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String? _serverAuthToken;

  User? get currentUser => firebaseAuth.currentUser;
  bool get isLoggedIn => currentUser != null;
  String? get userEmail => currentUser?.email;
  String? get userName => currentUser?.displayName;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

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
    final userCredential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Получаем токен для бэкенда
    _serverAuthToken = await userCredential.user!.getIdToken();

    // Проверяем аутентификацию на бэкенде
    await ApiService.verifyAuth(_serverAuthToken!);

    return userCredential;
  }

  Future<UserCredential> createAccount({
    required String email,
    required String password,
  }) async {
    final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Получаем токен для бэкенда
    _serverAuthToken = await userCredential.user!.getIdToken();

    // Проверяем аутентификацию на бэкенде
    await ApiService.verifyAuth(_serverAuthToken!);

    return userCredential;
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
    _serverAuthToken = null;
  }

  Future<void> resetPassword({required String email}) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateUsername({required String username}) async {
    await currentUser!.updateDisplayName(username);
    await currentUser!.reload();
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
  }
}