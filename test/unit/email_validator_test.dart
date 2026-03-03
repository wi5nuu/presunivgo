import 'package:flutter_test/flutter_test.dart';
import 'package:presunivgo/core/utils/email_validator.dart';

void main() {
  group('EmailValidator Tests', () {
    test('Empty email returns error', () {
      expect(EmailValidator.validate(''), 'Email is required');
      expect(EmailValidator.validate(null), 'Email is required');
    });

    test('Invalid email format returns error', () {
      expect(EmailValidator.validate('invalid-email'),
          'Please enter a valid email address');
    });

    test('University email detection works', () {
      expect(EmailValidator.isUniversityEmail('test@president.ac.id'), true);
      expect(
          EmailValidator.isUniversityEmail('student@student.president.ac.id'),
          true);
      expect(EmailValidator.isUniversityEmail('other@gmail.com'), false);
    });
  });
}
