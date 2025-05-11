import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'api_service.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String? _serverAuthToken;
  String _role = 'user';

  AuthService() {
    // Подписываемся на изменения состояния авторизации
    _firebaseAuth.authStateChanges().listen((user) {
      if (user != null) {
        _loadUserRole();
      } else {
        _role = 'user';
        notifyListeners();
      }
    });
  }

  // Геттеры
  User? get currentUser => _firebaseAuth.currentUser;
  bool get isLoggedIn => currentUser != null;
  String? get userEmail => currentUser?.email;
  String? get userName => currentUser?.displayName;
  String get userRole => _role;
  bool get isAdmin => _role == 'admin';
  bool get isManager => _role == 'manager';

  // Внутренний метод для чтения custom-claim "role"
  Future<void> _loadUserRole() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        // true — чтобы получить свежие claims
        final idTokenResult = await user.getIdTokenResult(true);
        _role = (idTokenResult.claims?['role'] as String?) ?? 'user';
        notifyListeners();
      }
    } catch (e) {
      // на случай ошибок — оставляем роль по умолчанию
      _role = 'user';
      notifyListeners();
    }
  }

  Future<String?> getServerToken() async {
    try {
      if (_serverAuthToken == null || currentUser == null) {
        if (currentUser != null) {
          _serverAuthToken = await currentUser!.getIdToken(true);
        }
      }
      return _serverAuthToken;
    } catch (e) {
      throw Exception('Failed to get server token: $e');
    }
  }

  @override
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential =
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _serverAuthToken = await userCredential.user!.getIdToken(true);
      await ApiService.verifyAuth(_serverAuthToken!);
      // Загружаем роль сразу после успешного входа
      await _loadUserRole();
      notifyListeners();
      return userCredential;
    } catch (e) {
      throw Exception('Sign-in failed: $e');
    }
  }

  @override
  Future<UserCredential> createAccount({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential =
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _serverAuthToken = await userCredential.user!.getIdToken(true);
      await ApiService.verifyAuth(_serverAuthToken!);
      // И здесь тоже
      await _loadUserRole();
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

  // auth_service.dart
  Future<void> updatePhotoURL({required String url}) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) throw Exception('No user');
    await user.updatePhotoURL(url);
    await user.reload();
    notifyListeners();
  }
}