import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/club_entities.dart';
import '../../domain/repositories/club_repository.dart';
import '../models/club_models.dart';

class ClubRepositoryImpl implements ClubRepository {
  final FirebaseFirestore _firestore;

  ClubRepositoryImpl(this._firestore);

  @override
  Stream<List<ClubEntity>> getClubs() {
    return _firestore.collection('clubs').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => ClubModel.fromJson(doc.data())).toList());
  }

  @override
  Stream<List<ChannelEntity>> getChannels(String clubId) {
    return _firestore
        .collection('clubs')
        .doc(clubId)
        .collection('channels')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChannelModel.fromJson(doc.data()))
            .toList());
  }

  @override
  Future<void> joinClub(String clubId, String uid) async {
    await _firestore.collection('clubs').doc(clubId).update({
      'member_uids': FieldValue.arrayUnion([uid]),
    });
  }

  @override
  Future<void> leaveClub(String clubId, String uid) async {
    await _firestore.collection('clubs').doc(clubId).update({
      'member_uids': FieldValue.arrayRemove([uid]),
    });
  }

  @override
  Future<void> sendMessage(String channelId, String content) async {
    // Logic for sending message to a channel
  }
}
