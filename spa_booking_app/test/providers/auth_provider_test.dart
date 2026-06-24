import 'package:flutter_test/flutter_test.dart';
import 'package:spa_booking_app/models/user_profile.dart';
import 'package:spa_booking_app/providers/auth_provider.dart';

void main() {
  group('AuthProvider', () {
    late FakeAuthenticationRepository repository;
    late AuthProvider provider;

    setUp(() {
      repository = FakeAuthenticationRepository();
      provider = AuthProvider(repository: repository);
    });

    test('restores an existing session', () async {
      repository.sessionUser = testUser;

      await provider.initialize();

      expect(provider.status, AuthStatus.authenticated);
      expect(provider.user, testUser);
      expect(provider.isAuthenticated, isTrue);
    });

    test('signs in and normalizes the email', () async {
      final result = await provider.signIn(
        email: '  USER@EXAMPLE.COM ',
        password: 'secret123',
      );

      expect(result, isTrue);
      expect(repository.lastEmail, 'user@example.com');
      expect(provider.status, AuthStatus.authenticated);
      expect(provider.user, testUser);
    });

    test('rejects invalid credentials before calling repository', () async {
      final result = await provider.signIn(
        email: 'invalid-email',
        password: '123',
      );

      expect(result, isFalse);
      expect(repository.signInCalls, 0);
      expect(provider.status, AuthStatus.failure);
      expect(provider.errorMessage, isNotEmpty);
    });

    test('registers a user', () async {
      final result = await provider.register(
        fullName: '  Nguyễn An  ',
        email: 'AN@EXAMPLE.COM',
        password: 'secret123',
      );

      expect(result, isTrue);
      expect(repository.lastFullName, 'Nguyễn An');
      expect(repository.lastEmail, 'an@example.com');
      expect(provider.isAuthenticated, isTrue);
    });

    test('exposes repository errors', () async {
      repository.error = const AuthException('Sai email hoặc mật khẩu.');

      final result = await provider.signIn(
        email: 'user@example.com',
        password: 'secret123',
      );

      expect(result, isFalse);
      expect(provider.status, AuthStatus.failure);
      expect(provider.errorMessage, 'Sai email hoặc mật khẩu.');
    });

    test('signs out and clears the current user', () async {
      repository.sessionUser = testUser;
      await provider.initialize();

      await provider.signOut();

      expect(repository.didSignOut, isTrue);
      expect(provider.status, AuthStatus.unauthenticated);
      expect(provider.user, isNull);
    });
  });
}

const testUser = UserProfile(
  id: 'user-1',
  email: 'user@example.com',
  fullName: 'Nguyễn An',
);

class FakeAuthenticationRepository implements AuthenticationRepository {
  UserProfile? sessionUser;
  Object? error;
  String? lastEmail;
  String? lastFullName;
  int signInCalls = 0;
  bool didSignOut = false;

  @override
  Future<UserProfile?> restoreSession() async {
    if (error case final currentError?) throw currentError;
    return sessionUser;
  }

  @override
  Future<UserProfile> signIn({
    required String email,
    required String password,
  }) async {
    signInCalls++;
    lastEmail = email;
    if (error case final currentError?) throw currentError;
    return testUser;
  }

  @override
  Future<UserProfile> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    lastFullName = fullName;
    lastEmail = email;
    if (error case final currentError?) throw currentError;
    return testUser;
  }

  @override
  Future<void> signOut() async {
    if (error case final currentError?) throw currentError;
    didSignOut = true;
    sessionUser = null;
  }
}
