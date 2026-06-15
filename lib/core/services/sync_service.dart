import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Defines the type of data mutation for a sync operation.
enum SyncOperationType { create, update, delete }

/// Represents an entity that needs to be synchronized with the cloud.
class PendingSyncItem {
  final String id;
  final String collectionName;
  final String documentId;
  final SyncOperationType operation;
  final Map<String, dynamic> data;
  final DateTime queuedAt;
  int retryCount;

  PendingSyncItem({
    required this.id,
    required this.collectionName,
    required this.documentId,
    required this.operation,
    required this.data,
    required this.queuedAt,
    this.retryCount = 0,
  });

  PendingSyncItem copyWith({
    int? retryCount,
  }) {
    return PendingSyncItem(
      id: id,
      collectionName: collectionName,
      documentId: documentId,
      operation: operation,
      data: data,
      queuedAt: queuedAt,
      retryCount: retryCount ?? this.retryCount,
    );
  }
}

/// Abstract contract for synchronization services.
/// Handles the local queue, retry mechanisms, and exponential backoff.
abstract class SyncService extends ChangeNotifier {
  final Queue<PendingSyncItem> _pendingQueue = Queue<PendingSyncItem>();
  bool _isSyncing = false;
  Timer? _retryTimer;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  
  /// Base delay for exponential backoff (in milliseconds)
  static const int _baseDelayMs = 2000;
  /// Maximum delay for exponential backoff (in milliseconds)
  static const int _maxDelayMs = 60000;

  SyncService() {
    _initConnectivityListener();
  }

  void _initConnectivityListener() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (results.contains(ConnectivityResult.mobile) || 
          results.contains(ConnectivityResult.wifi) ||
          results.contains(ConnectivityResult.ethernet)) {
        debugPrint('Network connected. Triggering sync...');
        triggerSync();
      }
    });
  }

  bool get isSyncing => _isSyncing;
  int get pendingCount => _pendingQueue.length;

  /// Enqueue a mutation to be synchronized with the cloud backend.
  void enqueueOperation({
    required String collectionName,
    required String documentId,
    required SyncOperationType operation,
    required Map<String, dynamic> data,
  }) {
    final item = PendingSyncItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      collectionName: collectionName,
      documentId: documentId,
      operation: operation,
      data: data,
      queuedAt: DateTime.now(),
    );
    
    _pendingQueue.add(item);
    notifyListeners();
    
    // Attempt sync immediately when an item is added
    triggerSync();
  }

  /// Trigger a synchronization pass.
  /// This should also be called when network connectivity is restored.
  Future<void> triggerSync() async {
    if (_isSyncing || _pendingQueue.isEmpty) return;
    
    _isSyncing = true;
    notifyListeners();
    
    _retryTimer?.cancel();

    bool hasErrors = false;
    
    while (_pendingQueue.isNotEmpty) {
      final item = _pendingQueue.first;
      try {
        await executeSyncOperation(item);
        // If successful, remove from queue
        _pendingQueue.removeFirst();
      } catch (e) {
        debugPrint('Sync failed for item $1: $e');
        hasErrors = true;
        // Increment retry count and move to back of queue
        final updatedItem = item.copyWith(retryCount: item.retryCount + 1);
        _pendingQueue.removeFirst();
        _pendingQueue.addLast(updatedItem);
        break; // Stop processing further items to respect ordered dependencies
      }
    }
    
    _isSyncing = false;
    notifyListeners();
    
    if (hasErrors && _pendingQueue.isNotEmpty) {
      _scheduleRetry();
    }
  }

  /// Calculates the next delay using exponential backoff.
  void _scheduleRetry() {
    if (_pendingQueue.isEmpty) return;
    
    final maxRetriesInQueue = _pendingQueue.fold<int>(
      0, (maxVal, item) => item.retryCount > maxVal ? item.retryCount : maxVal
    );
    
    // Exponential backoff formula: base_delay * 2^retries
    final delayMs = min(_maxDelayMs, _baseDelayMs * pow(2, maxRetriesInQueue)).toInt();
    
    debugPrint('Scheduling sync retry in $1ms');
    
    _retryTimer = Timer(Duration(milliseconds: delayMs), () {
      triggerSync();
    });
  }

  /// Abstract method to be implemented by specific backend providers (e.g., Firebase).
  /// This method should throw an exception if the sync fails, triggering the retry logic.
  Future<void> executeSyncOperation(PendingSyncItem item);

  @override
  void dispose() {
    _retryTimer?.cancel();
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}
