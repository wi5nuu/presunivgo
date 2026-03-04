import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../jobs/domain/entities/job_entity.dart';
import '../../../jobs/data/models/job_model.dart';
import '../../../profile/data/repositories/profile_repository_impl.dart';

// ─── Query State ──────────────────────────────────────────────────────────────

final searchQueryProvider = StateProvider<String>((ref) => '');

// ─── Search People ────────────────────────────────────────────────────────────

final searchPeopleProvider =
    FutureProvider.family<List<UserEntity>, String>((ref, query) async {
  if (query.trim().isEmpty) return [];
  final q = query.trim();
  final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .orderBy('name')
      .startAt([q])
      .endAt(['$q\uf8ff'])
      .limit(15)
      .get();
  final repo = ProfileRepositoryImpl(FirebaseFirestore.instance);
  final profiles =
      await Future.wait(snapshot.docs.map((doc) => repo.getProfile(doc.id)));
  return profiles.whereType<UserEntity>().toList();
});

// ─── Search Jobs ──────────────────────────────────────────────────────────────

final searchJobsProvider =
    FutureProvider.family<List<JobEntity>, String>((ref, query) async {
  if (query.trim().isEmpty) return [];
  final q = query.trim();
  final snapshot = await FirebaseFirestore.instance
      .collection('jobs')
      .where('is_active', isEqualTo: true)
      .orderBy('title')
      .startAt([q])
      .endAt(['$q\uf8ff'])
      .limit(15)
      .get();
  return snapshot.docs.map((doc) => JobModel.fromJson(doc.data())).toList();
});

// ─── Search Posts ─────────────────────────────────────────────────────────────

final searchPostsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>(
        (ref, query) async {
  if (query.trim().isEmpty) return [];
  final q = query.trim();
  final snapshot = await FirebaseFirestore.instance
      .collection('posts')
      .orderBy('content')
      .startAt([q])
      .endAt(['$q\uf8ff'])
      .limit(15)
      .get();
  return snapshot.docs.map((doc) => doc.data()).toList();
});
