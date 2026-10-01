import 'package:cloud_firestore/cloud_firestore.dart';

class AppNotification {
  final String id;
  final String userId;
  final String title;
  final String body;
  final DateTime timestamp;
  final bool read;

  AppNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.read,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
      'timestamp': timestamp.toIso8601String(),
      'read': read,
    };
  }

  factory AppNotification.fromMap(Map<String, dynamic> map) {
    DateTime parsedTime = DateTime.now();
    if (map['timestamp'] != null) {
      if (map['timestamp'] is Timestamp) {
        parsedTime = (map['timestamp'] as Timestamp).toDate();
      } else if (map['timestamp'] is String) {
        parsedTime = DateTime.tryParse(map['timestamp']) ?? DateTime.now();
      }
    }

    return AppNotification(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      timestamp: parsedTime,
      read: map['read'] ?? false,
    );
  }
}

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendNotification({
    required String userId,
    required String title,
    required String body,
  }) async {
    try {
      final notifId = DateTime.now().millisecondsSinceEpoch.toString();
      final notif = AppNotification(
        id: notifId,
        userId: userId,
        title: title,
        body: body,
        timestamp: DateTime.now(),
        read: false,
      );

      await _firestore
          .collection('notifications')
          .doc(userId)
          .collection('user_notifications')
          .doc(notifId)
          .set(notif.toMap());
    } catch (_) {}
  }

  Stream<QuerySnapshot> getNotificationsStream(String userId) {
    return _firestore
        .collection('notifications')
        .doc(userId)
        .collection('user_notifications')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> markAsRead(String userId, String notifId) async {
    try {
      await _firestore
          .collection('notifications')
          .doc(userId)
          .collection('user_notifications')
          .doc(notifId)
          .update({'read': true});
    } catch (_) {}
  }
}
