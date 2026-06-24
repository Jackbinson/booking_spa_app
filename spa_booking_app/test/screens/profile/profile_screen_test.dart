import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spa_booking_app/models/user_profile.dart';
import 'package:spa_booking_app/providers/auth_provider.dart';
import 'package:spa_booking_app/screens/profile/profile_screen.dart';

void main() {
  late FakeAuthenticationRepository repository;
  late AuthProvider authProvider;

  setUp(() async {
    repository = FakeAuthenticationRepository(sessionUser: testUser);
    authProvider = AuthProvider(repository: repository);
    await authProvider.initialize();
  });

  Future<void> pumpProfileScreen(
    WidgetTester tester, {
    VoidCallback? onEditProfile,
    VoidCallback? onAppointments,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        home: ProfileScreen(
          authProvider: authProvider,
          onEditProfile: onEditProfile,
          onAppointments: onAppointments,
        ),
      ),
    );
  }

  Future<void> tapVisible(WidgetTester tester, Finder finder) async {
    if (finder.evaluate().isEmpty) {
      await tester.scrollUntilVisible(
        finder,
        300,
        scrollable: find.byType(Scrollable).first,
      );
    } else {
      await tester.ensureVisible(finder);
    }
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  testWidgets('renders current user information', (tester) async {
    await pumpProfileScreen(tester);

    expect(find.text('Nguyễn Văn An'), findsOneWidget);
    expect(find.text('an@example.com'), findsOneWidget);
    expect(find.text('0901234567'), findsOneWidget);
    expect(find.text('NA'), findsOneWidget);
  });

  testWidgets('invokes profile actions', (tester) async {
    var editPressed = false;
    var appointmentsPressed = false;
    await pumpProfileScreen(
      tester,
      onEditProfile: () => editPressed = true,
      onAppointments: () => appointmentsPressed = true,
    );

    await tester.tap(find.byKey(const Key('profile_edit_button')));
    await tapVisible(
      tester,
      find.byKey(const Key('profile_appointments_tile')),
    );

    expect(editPressed, isTrue);
    expect(appointmentsPressed, isTrue);
  });

  testWidgets('cancels logout from confirmation dialog', (tester) async {
    await pumpProfileScreen(tester);

    await tapVisible(tester, find.byKey(const Key('profile_logout_button')));
    expect(find.text('Đăng xuất?'), findsOneWidget);

    await tester.tap(find.byKey(const Key('profile_cancel_logout_button')));
    await tester.pumpAndSettle();

    expect(repository.signOutCalls, 0);
    expect(authProvider.isAuthenticated, isTrue);
  });

  testWidgets('signs out after confirmation', (tester) async {
    await pumpProfileScreen(tester);

    await tapVisible(tester, find.byKey(const Key('profile_logout_button')));
    await tester.tap(find.byKey(const Key('profile_confirm_logout_button')));
    await tester.pumpAndSettle();

    expect(repository.signOutCalls, 1);
    expect(authProvider.isAuthenticated, isFalse);
    expect(find.byKey(const Key('profile_signed_out_message')), findsOneWidget);
  });

  testWidgets('shows loading state while signing out', (tester) async {
    repository.signOutCompleter = Completer<void>();
    await pumpProfileScreen(tester);

    await tapVisible(tester, find.byKey(const Key('profile_logout_button')));
    await tester.tap(find.byKey(const Key('profile_confirm_logout_button')));
    await tester.pump();

    expect(
      find.byKey(const Key('profile_logout_progress_indicator')),
      findsOneWidget,
    );

    repository.signOutCompleter!.complete();
    await tester.pumpAndSettle();
  });

  testWidgets('shows logout error and preserves user', (tester) async {
    repository.signOutError = const AuthException('Không thể đăng xuất.');
    await pumpProfileScreen(tester);

    await tapVisible(tester, find.byKey(const Key('profile_logout_button')));
    await tester.tap(find.byKey(const Key('profile_confirm_logout_button')));
    await tester.pumpAndSettle();

    expect(find.text('Không thể đăng xuất.'), findsOneWidget);
    expect(authProvider.user, testUser);
  });
}

const testUser = UserProfile(
  id: 'user-1',
  email: 'an@example.com',
  fullName: 'Nguyễn Văn An',
  phoneNumber: '0901234567',
);

class FakeAuthenticationRepository implements AuthenticationRepository {
  FakeAuthenticationRepository({this.sessionUser});

  UserProfile? sessionUser;
  int signOutCalls = 0;
  Object? signOutError;
  Completer<void>? signOutCompleter;

  @override
  Future<UserProfile?> restoreSession() async => sessionUser;

  @override
  Future<UserProfile> signIn({
    required String email,
    required String password,
  }) {
    throw UnimplementedError();
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
  Future<void> signOut() async {
    signOutCalls++;
    if (signOutError case final currentError?) throw currentError;
    await signOutCompleter?.future;
    sessionUser = null;
  }
}
