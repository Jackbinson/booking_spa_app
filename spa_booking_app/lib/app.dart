import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_colors.dart';
import 'models/user_profile.dart';
import 'providers/auth_provider.dart';
import 'providers/booking_provider.dart';
import 'screens/auth/auth_gate.dart';
import 'screens/main_shell.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            repository: _InMemoryAuthenticationRepository(),
          ),
        ),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
      ],
      child: MaterialApp(
        title: 'Lavender Spa Booking',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: AppColors.background,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            backgroundColor: AppColors.background,
            foregroundColor: AppColors.primary,
            elevation: 0,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColors.input,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        home: Builder(
          builder: (context) {
            final authProvider = context.read<AuthProvider>();
            return AuthGate(
              authProvider: authProvider,
              authenticatedBuilder: (_) => const MainShell(),
            );
          },
        ),
      ),
    );
  }
}

class _InMemoryAuthenticationRepository implements AuthenticationRepository {
  final Map<String, _LocalAccount> _accounts = {
    'user@example.com': const _LocalAccount(
      password: '123456',
      profile: UserProfile(
        id: 'demo-user',
        email: 'user@example.com',
        fullName: 'Nguyen An',
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
      throw const AuthException('Email hoac mat khau khong chinh xac.');
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
      throw const AuthException('Email da duoc su dung.');
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
