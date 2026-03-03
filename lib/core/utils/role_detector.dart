import '../../features/auth/domain/entities/user_entity.dart';

class RoleDetector {
  static UserRole detectRole(String email) {
    email = email.toLowerCase().trim();

    if (email.contains('@student.president.ac.id')) {
      return UserRole.student;
    } else if (email.contains('@president.ac.id')) {
      // Typically staff/lecturers use @president.ac.id
      // Alumni often retain their student email or use private ones,
      // but in this system we might have specific logic for them.
      return UserRole.lecturer;
    }

    return UserRole.student; // Default
  }
}
