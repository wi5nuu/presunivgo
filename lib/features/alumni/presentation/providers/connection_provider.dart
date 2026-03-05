import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

enum ConnectionStatus { pending, accepted, rejected, none }

class ConnectionRequest {
  final String id;
  final String fromUid;
  final String toUid;
  final ConnectionStatus status;
  final DateTime timestamp;

  ConnectionRequest({
    required this.id,
    required this.fromUid,
    required this.toUid,
    required this.status,
    required this.timestamp,
  });

  factory ConnectionRequest.fromMap(Map<String, dynamic> map, String id) {
    return ConnectionRequest(
      id: id,
      fromUid: map['fromUid'] ?? '',
      toUid: map['toUid'] ?? '',
      status: ConnectionStatus.values.firstWhere(
        (e) => e.name == (map['status'] ?? 'pending'),
        orElse: () => ConnectionStatus.pending,
      ),
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fromUid': fromUid,
      'toUid': toUid,
      'status': status.name,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}

final connectionRequestsProvider =
    StreamProvider<List<ConnectionRequest>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection('connection_requests')
      .where('toUid', isEqualTo: user.uid)
      .where('status', isEqualTo: 'pending')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => ConnectionRequest.fromMap(doc.data(), doc.id))
          .toList());
});

final sentRequestsProvider = StreamProvider<List<ConnectionRequest>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection('connection_requests')
      .where('fromUid', isEqualTo: user.uid)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => ConnectionRequest.fromMap(doc.data(), doc.id))
          .toList());
});

final connectionControllerProvider =
    Provider((ref) => ConnectionController(ref));

class ConnectionController {
  final Ref _ref;
  final _db = FirebaseFirestore.instance;

  ConnectionController(this._ref);

  Future<void> sendRequest(String toUid) async {
    final fromUid = _ref.read(authStateProvider).value?.uid;
    if (fromUid == null) return;

    final docId = '${fromUid}_$toUid';
    await _db.collection('connection_requests').doc(docId).set({
      'fromUid': fromUid,
      'toUid': toUid,
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> acceptRequest(ConnectionRequest request) async {
    await _db.collection('connection_requests').doc(request.id).update({
      'status': 'accepted',
    });

    final batch = _db.batch();
    batch.update(_db.collection('users').doc(request.fromUid), {
      'connections': FieldValue.arrayUnion([request.toUid]),
    });
    batch.update(_db.collection('users').doc(request.toUid), {
      'connections': FieldValue.arrayUnion([request.fromUid]),
    });
    await batch.commit();
  }

  Future<void> rejectRequest(ConnectionRequest request) async {
    await _db.collection('connection_requests').doc(request.id).update({
      'status': 'rejected',
    });
  }
}
