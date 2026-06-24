import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spa_booking_app/models/user_profile.dart';
import 'package:spa_booking_app/providers/auth_provider.dart';
import 'package:spa_booking_app/screens/auth/register_screen.dart';

void main() {
  late FakeAuthenticationRepository repository;
  late AuthProvider authProvider;

  setUp(() {
    repository = FakeAuthenticationRepository();
    authProvider = AuthProvider(repository: repository);
  });

  Future<void> pumpRegisterScreen(
    WidgetTester tester, {
    VoidCallback? onRegisterSuccess,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        home: RegisterScreen(
          authProvider: authProvider,
          onRegisterSuccess: onRegisterSuccess,
        ),
      ),
    );
  }

  Future<void> fillValidForm(WidgetTester tester) async {
    await tester.enterText(
      find.byKey(const Key('register_full_name_field')),
      'Nguyễn An',
    );
    await tester.enterText(
      find.byKey(const Key('register_email_field')),
      'AN@EXAMPLE.COM',
    );
    await tester.enterText(
      find.byKey(const Key('register_password_field')),
      'secret123',
    );
    await tester.enterText(
      find.byKey(const Key('register_confirm_password_field')),
      'secret123',
    );
    final termsCheckbox = find.byKey(const Key('register_terms_checkbox'));
    await tester.ensureVisible(termsCheckbox);
    await tester.pumpAndSettle();
    await tester.tap(termsCheckbox);
  }

  Future<void> tapRegisterButton(WidgetTester tester) async {
    final button = find.byKey(const Key('register_submit_button'));
    await tester.ensureVisible(button);
    await tester.pumpAndSettle();
    await tester.tap(button);
  }

  testWidgets('renders registration form', (tester) async {
    await pumpRegisterScreen(tester);

    expect(find.text('Bắt đầu hành trình thư giãn'), findsOneWidget);
    expect(find.byKey(const Key('register_full_name_field')), findsOneWidget);
    expect(find.byKey(const Key('register_email_field')), findsOneWidget);
    expect(find.byKey(const Key('register_password_field')), findsOneWidget);
    expect(
      find.byKey(const Key('register_confirm_password_field')),
      findsOneWidget,
    );
  });

  testWidgets('validates required fields and terms', (tester) async {
    await pumpRegisterScreen(tester);

    await tapRegisterButton(tester);
    await tester.pump();

    expect(find.text('Họ và tên phải có ít nhất 2 ký tự.'), findsOneWidget);
    expect(find.text('Vui lòng nhập email.'), findsOneWidget);
    expect(find.text('Vui lòng nhập mật khẩu.'), findsOneWidget);
    expect(find.text('Vui lòng xác nhận mật khẩu.'), findsOneWidget);
    expect(find.byKey(const Key('register_terms_error')), findsOneWidget);
    expect(repository.registerCalls, 0);
  });

  testWidgets('rejects mismatched passwords', (tester) async {
    await pumpRegisterScreen(tester);
    await fillValidForm(tester);
    await tester.enterText(
      find.byKey(const Key('register_confirm_password_field')),
      'different',
    );

    await tapRegisterButton(tester);
    await tester.pump();

    expect(find.text('Mật khẩu xác nhận không khớp.'), findsOneWidget);
    expect(repository.registerCalls, 0);
  });

  testWidgets('registers and calls success callback', (tester) async {
    var didRegister = false;
    await pumpRegisterScreen(
      tester,
      onRegisterSuccess: () => didRegister = true,
    );
    await fillValidForm(tester);

    await tapRegisterButton(tester);
    await tester.pumpAndSettle();

    expect(repository.lastFullName, 'Nguyễn An');
    expect(repository.lastEmail, 'an@example.com');
    expect(didRegister, isTrue);
  });

  testWidgets('shows loading state while registering', (tester) async {
    repository.registerCompleter = Completer<UserProfile>();
    await pumpRegisterScreen(tester);
    await fillValidForm(tester);

    await tapRegisterButton(tester);
    await tester.pump();

    expect(
      find.byKey(const Key('register_progress_indicator')),
      findsOneWidget,
    );

    repository.registerCompleter!.complete(testUser);
    await tester.pumpAndSettle();
  });

  testWidgets('shows registration error', (tester) async {
    repository.error = const AuthException('Email đã được sử dụng.');
    await pumpRegisterScreen(tester);
    await fillValidForm(tester);

    await tapRegisterButton(tester);
    await tester.pumpAndSettle();

    expect(find.text('Email đã được sử dụng.'), findsOneWidget);
  });
}

const testUser = UserProfile(
  id: 'user-1',
  email: 'an@example.com',
  fullName: 'Nguyễn An',
);

class FakeAuthenticationRepository implements AuthenticationRepository {
  int registerCalls = 0;
  String? lastFullName;
  String? lastEmail;
  Object? error;
  Completer<UserProfile>? registerCompleter;

  @override
  Future<UserProfile?> restoreSession() async => null;

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
  }) async {
    registerCalls++;
    lastFullName = fullName;
    lastEmail = email;
    if (error case final currentError?) throw currentError;
    return registerCompleter?.future ?? testUser;
  }

  @override
  Future<void> signOut() async {}
}
