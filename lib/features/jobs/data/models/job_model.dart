import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/job_entity.dart';

class JobModel extends JobEntity {
  JobModel({
    required super.jobId,
    required super.postedByUid,
    required super.companyName,
    super.companyLogoUrl,
    required super.title,
    required super.type,
    required super.location,
    required super.isRemote,
    super.salaryMin,
    super.salaryMax,
    required super.description,
    super.requirements,
    super.requiredSkills,
    super.applicantsCount,
    required super.deadline,
    super.isActive,
    super.isApproved,
    required super.createdAt,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      jobId: json['job_id'] as String,
      postedByUid: json['posted_by_uid'] as String,
      companyName: json['company_name'] as String,
      companyLogoUrl: json['company_logo_url'] as String?,
      title: json['title'] as String,
      type: json['type'] as String,
      location: json['location'] as String,
      isRemote: json['is_remote'] as bool? ?? false,
      salaryMin: (json['salary_min'] as num?)?.toDouble(),
      salaryMax: (json['salary_max'] as num?)?.toDouble(),
      description: json['description'] as String,
      requirements: List<String>.from(json['requirements'] ?? []),
      requiredSkills: List<String>.from(json['required_skills'] ?? []),
      applicantsCount: json['applicants_count'] as int? ?? 0,
      deadline: (json['deadline'] as Timestamp).toDate(),
      isActive: json['is_active'] as bool? ?? true,
      isApproved: json['is_approved'] as bool? ?? false,
      createdAt: (json['created_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'job_id': jobId,
      'posted_by_uid': postedByUid,
      'company_name': companyName,
      'company_logo_url': companyLogoUrl,
      'title': title,
      'type': type,
      'location': location,
      'is_remote': isRemote,
      'salary_min': salaryMin,
      'salary_max': salaryMax,
      'description': description,
      'requirements': requirements,
      'required_skills': requiredSkills,
      'applicants_count': applicantsCount,
      'deadline': Timestamp.fromDate(deadline),
      'is_active': isActive,
      'is_approved': isApproved,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }
}
