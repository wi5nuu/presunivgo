class EmailValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    if (!value.endsWith('@president.ac.id') &&
        !value.endsWith('@student.president.ac.id')) {
      // We allow this for now in Mock mode, but in production we'd return an error
      // return 'Only President University emails are allowed';
    }

    return null;
  }

  static bool isUniversityEmail(String email) {
    return email.endsWith('@president.ac.id') ||
        email.endsWith('@student.president.ac.id');
  }
}
