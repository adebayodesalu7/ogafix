class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String text;
  final String type; // 'text', 'image', 'video', 'document', 'voice'
  final String? mediaUrl;
  final bool read;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.type,
    this.mediaUrl,
    this.read = false,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'text': text,
      'type': type,
      'mediaUrl': mediaUrl,
      'read': read,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] ?? '',
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? '',
      text: map['text'] ?? '',
      type: map['type'] ?? 'text',
      mediaUrl: map['mediaUrl'],
      read: map['read'] ?? false,
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'])
          : DateTime.now(),
    );
  }
}
