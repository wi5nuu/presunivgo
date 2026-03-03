class JobEntity {
  final String jobId;
  final String postedByUid;
  final String companyName;
  final String? companyLogoUrl;
  final String title;
  final String type; // internship | part-time | full-time | project | research
  final String location;
  final bool isRemote;
  final double? salaryMin;
  final double? salaryMax;
  final String description;
  final List<String> requirements;
  final List<String> requiredSkills;
  final int applicantsCount;
  final DateTime deadline;
  final bool isActive;
  final bool isApproved;
  final DateTime createdAt;

  JobEntity({
    required this.jobId,
    required this.postedByUid,
    required this.companyName,
    this.companyLogoUrl,
    required this.title,
    required this.type,
    required this.location,
    required this.isRemote,
    this.salaryMin,
    this.salaryMax,
    required this.description,
    this.requirements = const [],
    this.requiredSkills = const [],
    this.applicantsCount = 0,
    required this.deadline,
    this.isActive = true,
    this.isApproved = false,
    required this.createdAt,
  });
}
