import 'dart:async';
import 'package:flutter/foundation.dart';

import '../core/network/api_client.dart';
import '../data/api/auth_api_service.dart';
import '../data/api/profile_api_service.dart';
import '../data/auth/google_auth_service.dart';
import '../data/mock_user.dart';
import '../models/user_profile.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({
    AuthApiService? apiService,
    ProfileApiService? profileApiService,
    GoogleAuthService? googleAuthService,
  }) : _apiService = apiService ?? AuthApiService(),
       _profileApiService = profileApiService ?? ProfileApiService(),
       _googleAuthService = googleAuthService ?? GoogleAuthService() {
    unawaited(_listenForWebGoogleSignIn());
  }

  final AuthApiService _apiService;
  final ProfileApiService _profileApiService;
  final GoogleAuthService _googleAuthService;
  StreamSubscription<String>? _webGoogleTokenSubscription;

  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _errorMessage;
  UserProfile _currentUser = mockUser;
  String? _accessToken;
  String? _refreshToken;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserProfile get currentUser => _currentUser;
  bool get isAdmin => _isAuthenticated && _currentUser.isAdmin;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;

  Future<bool> login({
    required String account,
    required String password,
  }) async {
    _setLoading(true);
    try {
      final session = await _apiService.login(
        account: account.trim(),
        password: password,
      );
      _applySession(session);
      return true;
    } catch (error) {
      _errorMessage = _messageFrom(error, 'Đăng nhập thất bại.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    _setLoading(true);
    try {
      final session = await _apiService.register(
        fullName: fullName.trim(),
        email: email.trim(),
        phone: phone.trim(),
        password: password,
      );
      _applySession(session);
      return true;
    } catch (error) {
      _errorMessage = _messageFrom(error, 'Đăng ký thất bại.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> loginWithGoogle() async {
    _setLoading(true);
    try {
      final idToken = await _googleAuthService.signInInteractively();
      final session = await _apiService.loginWithGoogle(idToken: idToken);
      _applySession(session);
      return true;
    } catch (error) {
      _errorMessage = _messageFrom(error, 'Đăng nhập Google thất bại.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateProfile({
    required String fullName,
    required String phone,
    required String birthDate,
    required String gender,
    required String address,
  }) async {
    _setLoading(true);
    try {
      final user = await _profileApiService.updateProfile(
        fullName: fullName.trim(),
        phone: phone.trim().isEmpty ? null : phone.trim(),
        birthDate: birthDate.isEmpty ? null : birthDate,
        gender: gender.isEmpty ? null : gender,
        address: address.trim().isEmpty ? null : address.trim(),
      );
      _currentUser = UserProfile.fromApiJson(user);
      _errorMessage = null;
      return true;
    } catch (error) {
      _errorMessage = _messageFrom(error, 'Không thể lưu hồ sơ.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> uploadAvatar({
    required Uint8List bytes,
    required String contentType,
  }) async {
    _setLoading(true);
    try {
      final user = await _profileApiService.uploadAvatar(
        bytes: bytes,
        contentType: contentType,
      );
      _currentUser = UserProfile.fromApiJson(user);
      _errorMessage = null;
      return true;
    } catch (error) {
      _errorMessage = _messageFrom(error, 'Không thể cập nhật ảnh đại diện.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateNotificationPreferences({
    required bool bookingUpdates,
    required bool promotions,
  }) async {
    _setLoading(true);
    try {
      final user = await _profileApiService.updateProfile(
        preferences: {
          'notifications': {
            'bookingUpdates': bookingUpdates,
            'promotions': promotions,
          },
        },
      );
      _currentUser = UserProfile.fromApiJson(user);
      _errorMessage = null;
      return true;
    } catch (error) {
      _errorMessage = _messageFrom(error, 'Không thể lưu cài đặt thông báo.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    _accessToken = null;
    _refreshToken = null;
    _currentUser = mockUser;
    _errorMessage = null;
    ApiClient.instance.setAccessToken(null);
    unawaited(_googleAuthService.signOut());
    notifyListeners();
  }

  Future<void> _listenForWebGoogleSignIn() async {
    try {
      await _googleAuthService.initialize();
      _webGoogleTokenSubscription = _googleAuthService.webIdTokens.listen(
        _loginWithGoogleIdToken,
        onError: (Object error, StackTrace stackTrace) {
          if (_isLoading) {
            return;
          }
          _errorMessage = _messageFrom(error, 'Đăng nhập Google thất bại.');
          notifyListeners();
        },
      );
    } catch (_) {
      // The button action shows any platform configuration error.
    }
  }

  Future<void> _loginWithGoogleIdToken(String idToken) async {
    if (_isLoading) {
      return;
    }

    _setLoading(true);
    try {
      final session = await _apiService.loginWithGoogle(idToken: idToken);
      _applySession(session);
    } catch (error) {
      _errorMessage = _messageFrom(error, 'Đăng nhập Google thất bại.');
    } finally {
      _setLoading(false);
    }
  }

  void _applySession(AuthSession session) {
    _currentUser = session.user;
    _accessToken = session.accessToken;
    _refreshToken = session.refreshToken;
    _isAuthenticated = session.accessToken.isNotEmpty;
    _errorMessage = null;
    ApiClient.instance.setAccessToken(session.accessToken);
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    if (value) {
      _errorMessage = null;
    }
    notifyListeners();
  }

  String _messageFrom(Object error, String fallback) {
    final message = error.toString().trim();
    return message.isEmpty ? fallback : message;
  }

  @override
  void dispose() {
    _webGoogleTokenSubscription?.cancel();
    _googleAuthService.dispose();
    super.dispose();
  }
}
