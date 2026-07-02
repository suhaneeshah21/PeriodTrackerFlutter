import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cycle_entry.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Save a new cycle log
  Future<void> saveCycleEntry(String userId, CycleEntry entry) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('cycles')
        .add(entry.toMap());
  }

  // Get all cycle logs for a user
  Stream<List<CycleEntry>> getCycleEntries(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('cycles')
        .orderBy('startDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CycleEntry.fromMap(doc.id, doc.data()))
            .toList());
  }
}