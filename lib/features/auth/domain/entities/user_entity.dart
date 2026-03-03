enum UserRole { student, alumni, lecturer, admin }

enum ActivityStatus { searching, internship, working, student }

class UserEntity {
  final String uid;
  final String name;
  final String email;
  final UserRole role;
  final String? major;
  final String? faculty;
  final int? batch;
  final String? nimOrEid;
  final String? headline;
  final String? bio;
  final String? location;
  final String? profileImageUrl;
  final String? bannerImageUrl;
  final bool isVerified;
  final bool isOpenToWork;
  final List<String> skills;
  final List<String> connections;
  final List<String> followers;
  final List<String> following;
  final List<Map<String, dynamic>> experience;
  final List<Map<String, dynamic>> education;
  final List<Map<String, dynamic>> projects;
  final List<Map<String, dynamic>> certifications;
  final double profileCompletion;
  final int profileViews;
  final ActivityStatus activityStatus;
  final String? currentCompany;
  final DateTime lastActive;
  final DateTime createdAt;
  final String? fcmToken;
  final Map<String, dynamic> settings;

  UserEntity({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    this.major,
    this.faculty,
    this.batch,
    this.nimOrEid,
    this.headline,
    this.bio,
    this.location,
    this.profileImageUrl,
    this.bannerImageUrl,
    this.isVerified = false,
    this.isOpenToWork = false,
    this.skills = const [],
    this.connections = const [],
    this.followers = const [],
    this.following = const [],
    this.experience = const [],
    this.education = const [],
    this.projects = const [],
    this.certifications = const [],
    this.profileCompletion = 0,
    this.profileViews = 0,
    this.activityStatus = ActivityStatus.student,
    this.currentCompany,
    required this.lastActive,
    required this.createdAt,
    this.fcmToken,
    this.settings = const {},
  });

  UserEntity copyWith({
    String? name,
    String? headline,
    String? bio,
    String? location,
    String? profileImageUrl,
    String? bannerImageUrl,
    bool? isVerified,
    bool? isOpenToWork,
    List<String>? skills,
    List<Map<String, dynamic>>? experience,
    List<Map<String, dynamic>>? education,
    List<Map<String, dynamic>>? projects,
    List<Map<String, dynamic>>? certifications,
    ActivityStatus? activityStatus,
    String? currentCompany,
    String? fcmToken,
  }) {
    return UserEntity(
      uid: uid,
      name: name ?? this.name,
      email: email,
      role: role,
      major: major,
      faculty: faculty,
      batch: batch,
      nimOrEid: nimOrEid,
      headline: headline ?? this.headline,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bannerImageUrl: bannerImageUrl ?? this.bannerImageUrl,
      isVerified: isVerified ?? this.isVerified,
      isOpenToWork: isOpenToWork ?? this.isOpenToWork,
      skills: skills ?? this.skills,
      connections: connections,
      followers: followers,
      following: following,
      experience: experience ?? this.experience,
      education: education ?? this.education,
      projects: projects ?? this.projects,
      certifications: certifications ?? this.certifications,
      profileCompletion: profileCompletion,
      profileViews: profileViews,
      activityStatus: activityStatus ?? this.activityStatus,
      currentCompany: currentCompany ?? this.currentCompany,
      lastActive: lastActive,
      createdAt: createdAt,
      fcmToken: fcmToken ?? this.fcmToken,
      settings: settings,
    );
  }
}
