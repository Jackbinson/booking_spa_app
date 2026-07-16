import 'package:flutter_test/flutter_test.dart';
import 'package:spa_booking_app/models/user_profile.dart';

void main() {
  test('formats an API birth date for Vietnamese display', () {
    expect(formatProfileBirthDate('2000-01-06T17:00:00.000Z'), '07/01/2000');
  });

  test('keeps the profile edit value in API date format', () {
    expect(profileBirthDateInputValue('07/01/2000'), '2000-01-07');
  });
}
