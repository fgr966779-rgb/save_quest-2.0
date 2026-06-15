import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'sync_service.dart';

/// Implementation of SyncService that synchronizes data with Firebase Firestore.
/// Uses a Hybrid CRDT approach:
/// - LWW (Last-Write-Wins) for personal profile data using the `updatedAt` field.
/// - Additive Counter CRDT for collaborative deposits/goals (incrementing `FieldValue.increment()`).
class FirebaseSyncService extends SyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  @override
  Future<void> executeSyncOperation(PendingSyncItem item) async {
    final uid = currentUserId;
    if (uid == null) {
      throw Exception('Cannot sync: User is not authenticated.');
    }

    final docRef = _firestore.collection(item.collectionName).doc(item.documentId);

    switch (item.operation) {
      case SyncOperationType.create:
      case SyncOperationType.update:
        // Handle CRDT for Squad/Joint contributions vs Personal data
        if (item.collectionName == 'joint_goals' || item.collectionName == 'squads') {
          await _handleCrdtUpdate(docRef, item.data);
        } else {
          // LWW strategy (Set with merge to preserve other fields)
          await docRef.set(item.data, SetOptions(merge: true));
        }
        break;
      case SyncOperationType.delete:
        await docRef.delete();
        break;
    }
    
    debugPrint('Successfully synced $1 to $1/$1');
  }

  /// Implements Additive Counter CRDT logic for concurrent updates on shared assets.
  Future<void> _handleCrdtUpdate(DocumentReference docRef, Map<String, dynamic> data) async {
    final updateData = <String, dynamic>{...data};
    
    // Instead of overriding the total amount, we use FieldValue.increment()
    // based on a calculated delta if we are modifying an accumulative field.
    if (updateData.containsKey('_deltaAmount')) {
      final delta = updateData.remove('_deltaAmount') as num;
      updateData['currentAmount'] = FieldValue.increment(delta);
    }
    
    if (updateData.containsKey('_deltaXp')) {
      final delta = updateData.remove('_deltaXp') as num;
      updateData['totalXp'] = FieldValue.increment(delta);
    }
    
    // Set with merge ensures that if the document doesn't exist, it is created.
    await docRef.set(updateData, SetOptions(merge: true));
  }
  
  /// Listen to real-time updates for a specific Squad
  Stream<DocumentSnapshot<Map<String, dynamic>>> watchSquad(String squadId) {
    return _firestore.collection('squads').doc(squadId).snapshots();
  }
  
  /// Listen to real-time updates for Joint Goals within a Squad
  Stream<QuerySnapshot<Map<String, dynamic>>> watchJointGoals(String squadId) {
    return _firestore.collection('joint_goals')
        .where('squadId', isEqualTo: squadId)
        .snapshots();
  }
}
