import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SeedDataPopulator {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> populateAll() async {
    if (!kDebugMode) return; // Safety check

    await _seedUsers();
    await _seedPosts();
    await _seedJobs();
  }

  Future<void> _seedUsers() async {
    final users = [
      {
        'uid': 'student1',
        'name': 'John Doe',
        'role': 'student',
        'major': 'Information Technology',
        'batch': 2022,
        'headline': 'Flutter Enthusiast',
      },
      {
        'uid': 'alumni1',
        'name': 'Jane Smith',
        'role': 'alumni',
        'major': 'Computer Science',
        'batch': 2018,
        'headline': 'Senior Dev at Google',
      }
    ];

    for (var user in users) {
      await _firestore.collection('users').doc(user['uid'] as String).set(user);
    }
  }

  Future<void> _seedPosts() async {
    await _firestore.collection('posts').add({
      'author_uid': 'student1',
      'content':
          'Just finished the PresUnivGo v2.0 upgrade! 🚀 #Flutter #PresidentUniversity',
      'timestamp': FieldValue.serverTimestamp(),
      'reactions': {'like': []},
    });
  }

  Future<void> _seedJobs() async {
    await _firestore.collection('jobs').add({
      'title': 'Flutter Developer Intern',
      'company_name': 'Tech Corp',
      'location': 'Remote',
      'type': 'internship',
      'requirements': ['Flutter', 'Riverpod'],
      'is_active': true,
      'created_at': FieldValue.serverTimestamp(),
    });
  }
}
