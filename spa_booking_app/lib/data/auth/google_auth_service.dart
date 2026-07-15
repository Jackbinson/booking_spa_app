import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/config/google_auth_config.dart';

class GoogleAuthException implements Exception {
  const GoogleAuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Obtains a short-lived Google ID token. The backend verifies this token
/// before the application creates a session for the user.
class GoogleAuthService {
  GoogleAuthService({GoogleSignIn? googleSignIn})
    : _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  final GoogleSignIn _googleSignIn;
  final StreamController<String> _webIdTokens =
      StreamController<String>.broadcast();

  Future<void>? _initialization;
  StreamSubscription<GoogleSignInAuthenticationEvent>? _authenticationEvents;

  Stream<String> get webIdTokens => _webIdTokens.stream;

  Future<void> initialize() {
    return _initialization ??= _initialize();
  }

  Future<void> _initialize() async {
    if (!GoogleAuthConfig.isSupportedOnCurrentPlatform) {
      throw const GoogleAuthException(
        'Đăng nhập Google chưa hỗ trợ trên nền tảng này.',
      );
    }

    if (!GoogleAuthConfig.isConfiguredForCurrentPlatform) {
      throw const GoogleAuthException(
        'Google Sign-In chưa được cấu hình cho ứng dụng này.',
      );
    }

    await _googleSignIn.initialize(
      clientId: GoogleAuthConfig.clientId,
      serverClientId: GoogleAuthConfig.backendClientId,
    );

    _authenticationEvents ??= _googleSignIn.authenticationEvents.listen(
      _handleAuthenticationEvent,
      onError: (Object error, StackTrace stackTrace) {
        if (kIsWeb) {
          _webIdTokens.addError(error, stackTrace);
        }
      },
    );
  }

  Future<String> signInInteractively() async {
    await initialize();

    if (!_googleSignIn.supportsAuthenticate()) {
      throw const GoogleAuthException(
        'Hãy dùng nút Google chính thức để đăng nhập trên trình duyệt.',
      );
    }

    try {
      final account = await _googleSignIn.authenticate();
      return _idTokenFrom(account);
    } on GoogleSignInException catch (error) {
      final details = error.toString().toLowerCase();
      if (details.contains('no credential available') ||
          details.contains('no credentials available')) {
        throw const GoogleAuthException(
          'Emulator chưa có tài khoản Google. Hãy thêm tài khoản trong Settings rồi thử lại.',
        );
      }
      if (details.contains('account reauth failed') ||
          details.contains('unregistered_on_api_console')) {
        throw const GoogleAuthException(
          'Google Cloud ch\u01b0a \u0111\u0103ng k\u00fd Android app n\u00e0y. '
          'Ki\u1ec3m tra OAuth Android v\u1edbi package '
          'com.example.spa_booking_app v\u00e0 SHA-1 '
          'AD:08:34:D0:C3:02:1F:4B:DC:86:F8:F1:46:BF:1C:2C:65:71:7F:3D.',
        );
      }
      rethrow;
    }
  }

  Future<void> signOut() async {
    if (_initialization == null) {
      return;
    }

    try {
      await _initialization;
      await _googleSignIn.signOut();
    } catch (_) {
      // Logging out must not fail when the Google SDK is unavailable.
    }
  }

  void _handleAuthenticationEvent(GoogleSignInAuthenticationEvent event) {
    // The web SDK reports logins through this stream. Native platforms return
    // the account directly from authenticate(), so forwarding both would log
    // the user in twice.
    if (!kIsWeb || event is! GoogleSignInAuthenticationEventSignIn) {
      return;
    }

    try {
      _webIdTokens.add(_idTokenFrom(event.user));
    } on Object catch (error, stackTrace) {
      _webIdTokens.addError(error, stackTrace);
    }
  }

  String _idTokenFrom(GoogleSignInAccount account) {
    final idToken = account.authentication.idToken;
    if (idToken == null || idToken.isEmpty) {
      throw const GoogleAuthException(
        'Google không trả về token xác thực. Vui lòng thử lại.',
      );
    }
    return idToken;
  }

  void dispose() {
    _authenticationEvents?.cancel();
    _webIdTokens.close();
  }
}
