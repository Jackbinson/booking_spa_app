import 'package:flutter/material.dart';

import 'models/user_profile.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/auth_gate.dart';
import 'screens/profile/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final _authenticationRepository = _InMemoryAuthenticationRepository();
  late final AuthProvider _authProvider = AuthProvider(
    repository: _authenticationRepository,
  );

  @override
  void dispose() {
    _authProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lavender Spa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C4D9E),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFFCF9FF),
        useMaterial3: true,
      ),
      home: AuthGate(
        authProvider: _authProvider,
        authenticatedBuilder: (_) => ProfileScreen(
          authProvider: _authProvider,
          // Sẽ nối sang màn hình lịch hẹn khi feature đó hoàn thành.
          onAppointments: null,
        ),
      ),
    );
  }
}

/// Repository tạm để chạy luồng xác thực khi chưa kết nối backend.
///
/// Tài khoản mẫu:
/// - Email: user@example.com
/// - Mật khẩu: 123456
class _InMemoryAuthenticationRepository implements AuthenticationRepository {
  final Map<String, _LocalAccount> _accounts = {
    'user@example.com': const _LocalAccount(
      password: '123456',
      profile: UserProfile(
        id: 'demo-user',
        email: 'user@example.com',
        fullName: 'Nguyễn An',
        phoneNumber: '0901234567',
      ),
    ),
  };

  UserProfile? _currentUser;

  @override
  Future<UserProfile?> restoreSession() async {
    return _currentUser;
  }

  @override
  Future<UserProfile> signIn({
    required String email,
    required String password,
  }) async {
    final account = _accounts[email];

    if (account == null || account.password != password) {
      throw const AuthException('Email hoặc mật khẩu không chính xác.');
    }

    _currentUser = account.profile;
    return account.profile;
  }

  @override
  Future<UserProfile> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    if (_accounts.containsKey(email)) {
      throw const AuthException('Email đã được sử dụng.');
    }

    final profile = UserProfile(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      email: email,
      fullName: fullName,
    );

    _accounts[email] = _LocalAccount(password: password, profile: profile);
    _currentUser = profile;
    return profile;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
  }
}

class _LocalAccount {
  const _LocalAccount({required this.password, required this.profile});

  final String password;
  final UserProfile profile;
}
