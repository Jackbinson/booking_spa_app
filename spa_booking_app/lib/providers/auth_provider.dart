import 'package:flutter/foundation.dart';

import '../models/user_profile.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, failure }

abstract interface class AuthenticationRepository {
  Future<UserProfile?> restoreSession();

  Future<UserProfile> signIn({required String email, required String password});

  Future<UserProfile> register({
    required String fullName,
    required String email,
    required String password,
  });

  Future<void> signOut();
}

class AuthProvider extends ChangeNotifier {
  AuthProvider({required AuthenticationRepository repository})
    : _repository = repository;

  final AuthenticationRepository _repository;

  AuthStatus _status = AuthStatus.initial;
  UserProfile? _user;
  String? _errorMessage;

  AuthStatus get status => _status;
  UserProfile? get user => _user;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _status == AuthStatus.loading;
  bool get isAuthenticated =>
      _status == AuthStatus.authenticated && _user != null;

  Future<void> initialize() async {
    _setLoading();

    try {
      _user = await _repository.restoreSession();
      _status = _user == null
          ? AuthStatus.unauthenticated
          : AuthStatus.authenticated;
    } catch (error) {
      _setFailure(error);
      return;
    }

    notifyListeners();
  }

  Future<bool> signIn({required String email, required String password}) async {
    final normalizedEmail = email.trim().toLowerCase();
    final validationError = _validateCredentials(
      email: normalizedEmail,
      password: password,
    );

    if (validationError != null) {
      _setFailure(validationError);
      return false;
    }

    _setLoading();

    try {
      _user = await _repository.signIn(
        email: normalizedEmail,
        password: password,
      );
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (error) {
      _setFailure(error);
      return false;
    }
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final normalizedName = fullName.trim();
    final normalizedEmail = email.trim().toLowerCase();

    if (normalizedName.length < 2) {
      _setFailure('Họ và tên phải có ít nhất 2 ký tự.');
      return false;
    }

    final validationError = _validateCredentials(
      email: normalizedEmail,
      password: password,
    );
    if (validationError != null) {
      _setFailure(validationError);
      return false;
    }

    _setLoading();

    try {
      _user = await _repository.register(
        fullName: normalizedName,
        email: normalizedEmail,
        password: password,
      );
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (error) {
      _setFailure(error);
      return false;
    }
  }

  Future<void> signOut() async {
    _setLoading();

    try {
      await _repository.signOut();
      _user = null;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    } catch (error) {
      _setFailure(error);
    }
  }

  void clearError() {
    if (_errorMessage == null) return;

    _errorMessage = null;
    if (_status == AuthStatus.failure) {
      _status = _user == null
          ? AuthStatus.unauthenticated
          : AuthStatus.authenticated;
    }
    notifyListeners();
  }

  void _setLoading() {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setFailure(Object error) {
    _status = AuthStatus.failure;
    _errorMessage = error is AuthException
        ? error.message
        : 'Đã có lỗi xảy ra. Vui lòng thử lại.';
    notifyListeners();
  }

  String? _validateCredentials({
    required String email,
    required String password,
  }) {
    final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailPattern.hasMatch(email)) {
      return 'Email không hợp lệ.';
    }
    if (password.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự.';
    }
    return null;
  }
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}
