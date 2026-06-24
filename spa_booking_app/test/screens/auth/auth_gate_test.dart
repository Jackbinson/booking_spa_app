import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spa_booking_app/models/user_profile.dart';
import 'package:spa_booking_app/providers/auth_provider.dart';
import 'package:spa_booking_app/screens/auth/auth_gate.dart';
import 'package:spa_booking_app/screens/auth/login_screen.dart';
import 'package:spa_booking_app/screens/auth/register_screen.dart';

void main() {
  late FakeAuthenticationRepository repository;
  late AuthProvider authProvider;

  setUp(() {
    repository = FakeAuthenticationRepository();
    authProvider = AuthProvider(repository: repository);
  });

  Future<void> pumpAuthGate(WidgetTester tester) {
    return tester.pumpWidget(
      MaterialApp(
        home: AuthGate(
          authProvider: authProvider,
          authenticatedBuilder: (_) => const Scaffold(
            body: Text(
              'Authenticated content',
              key: Key('authenticated_content'),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('shows loading screen while restoring session', (tester) async {
    repository.restoreCompleter = Completer<UserProfile?>();

    await pumpAuthGate(tester);
    await tester.pump();

    expect(
      find.byKey(const Key('auth_gate_progress_indicator')),
      findsOneWidget,
    );

    repository.restoreCompleter!.complete(null);
    await tester.pumpAndSettle();
  });

  testWidgets('shows login when there is no session', (tester) async {
    await pumpAuthGate(tester);
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byKey(const Key('authenticated_content')), findsNothing);
    expect(repository.restoreCalls, 1);
  });

  testWidgets('shows authenticated content for an existing session', (
    tester,
  ) async {
    repository.sessionUser = testUser;

    await pumpAuthGate(tester);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('authenticated_content')), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
  });

  testWidgets('reacts to authentication state changes', (tester) async {
    await pumpAuthGate(tester);
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);

    await authProvider.signIn(email: 'user@example.com', password: 'secret123');
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('authenticated_content')), findsOneWidget);

    await authProvider.signOut();
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('opens registration screen from login', (tester) async {
    await pumpAuthGate(tester);
    await tester.pumpAndSettle();

    final createAccountButton = find.text('Đăng ký ngay');
    await tester.ensureVisible(createAccountButton);
    await tester.pumpAndSettle();
    await tester.tap(createAccountButton);
    await tester.pumpAndSettle();

    expect(find.byType(RegisterScreen), findsOneWidget);
  });
}

const testUser = UserProfile(
  id: 'user-1',
  email: 'user@example.com',
  fullName: 'Nguyễn An',
);

class FakeAuthenticationRepository implements AuthenticationRepository {
  UserProfile? sessionUser;
  Completer<UserProfile?>? restoreCompleter;
  int restoreCalls = 0;

  @override
  Future<UserProfile?> restoreSession() async {
    restoreCalls++;
    return restoreCompleter?.future ?? sessionUser;
  }

  @override
  Future<UserProfile> signIn({
    required String email,
    required String password,
  }) async {
    sessionUser = testUser;
    return testUser;
  }

  @override
  Future<UserProfile> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    sessionUser = testUser;
    return testUser;
  }

  @override
  Future<void> signOut() async {
    sessionUser = null;
  }
}
