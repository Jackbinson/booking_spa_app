import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spa_booking_app/models/user_profile.dart';
import 'package:spa_booking_app/providers/auth_provider.dart';
import 'package:spa_booking_app/screens/auth/login_screen.dart';

void main() {
  late FakeAuthenticationRepository repository;
  late AuthProvider authProvider;

  setUp(() {
    repository = FakeAuthenticationRepository();
    authProvider = AuthProvider(repository: repository);
  });

  Future<void> pumpLoginScreen(
    WidgetTester tester, {
    VoidCallback? onLoginSuccess,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(
          authProvider: authProvider,
          onLoginSuccess: onLoginSuccess,
        ),
      ),
    );
  }

  Future<void> tapLoginButton(WidgetTester tester) async {
    final button = find.byKey(const Key('login_submit_button'));
    await tester.ensureVisible(button);
    await tester.pumpAndSettle();
    await tester.tap(button);
  }

  testWidgets('renders login form', (tester) async {
    await pumpLoginScreen(tester);

    expect(find.text('Chào mừng trở lại'), findsOneWidget);
    expect(find.byKey(const Key('login_email_field')), findsOneWidget);
    expect(find.byKey(const Key('login_password_field')), findsOneWidget);
    expect(find.text('Đăng nhập'), findsOneWidget);
  });

  testWidgets('validates email and password', (tester) async {
    await pumpLoginScreen(tester);

    await tapLoginButton(tester);
    await tester.pump();

    expect(find.text('Vui lòng nhập email.'), findsOneWidget);
    expect(find.text('Vui lòng nhập mật khẩu.'), findsOneWidget);
    expect(repository.signInCalls, 0);
  });

  testWidgets('submits credentials and calls success callback', (tester) async {
    var didLogin = false;
    await pumpLoginScreen(tester, onLoginSuccess: () => didLogin = true);

    await tester.enterText(
      find.byKey(const Key('login_email_field')),
      'USER@EXAMPLE.COM',
    );
    await tester.enterText(
      find.byKey(const Key('login_password_field')),
      'secret123',
    );
    await tapLoginButton(tester);
    await tester.pumpAndSettle();

    expect(repository.lastEmail, 'user@example.com');
    expect(didLogin, isTrue);
  });

  testWidgets('shows loading state while signing in', (tester) async {
    repository.signInCompleter = Completer<UserProfile>();
    await pumpLoginScreen(tester);

    await tester.enterText(
      find.byKey(const Key('login_email_field')),
      'user@example.com',
    );
    await tester.enterText(
      find.byKey(const Key('login_password_field')),
      'secret123',
    );
    await tapLoginButton(tester);
    await tester.pump();

    expect(find.byKey(const Key('login_progress_indicator')), findsOneWidget);

    repository.signInCompleter!.complete(testUser);
    await tester.pumpAndSettle();
  });

  testWidgets('shows authentication error', (tester) async {
    repository.error = const AuthException('Sai email hoặc mật khẩu.');
    await pumpLoginScreen(tester);

    await tester.enterText(
      find.byKey(const Key('login_email_field')),
      'user@example.com',
    );
    await tester.enterText(
      find.byKey(const Key('login_password_field')),
      'secret123',
    );
    await tapLoginButton(tester);
    await tester.pumpAndSettle();

    expect(find.text('Sai email hoặc mật khẩu.'), findsOneWidget);
  });
}

const testUser = UserProfile(
  id: 'user-1',
  email: 'user@example.com',
  fullName: 'Nguyễn An',
);

class FakeAuthenticationRepository implements AuthenticationRepository {
  int signInCalls = 0;
  String? lastEmail;
  Object? error;
  Completer<UserProfile>? signInCompleter;

  @override
  Future<UserProfile?> restoreSession() async => null;

  @override
  Future<UserProfile> signIn({
    required String email,
    required String password,
  }) async {
    signInCalls++;
    lastEmail = email;
    if (error case final currentError?) throw currentError;
    return signInCompleter?.future ?? testUser;
  }

  @override
  Future<UserProfile> register({
    required String fullName,
    required String email,
    required String password,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() async {}
}
