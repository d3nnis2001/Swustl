class Message {
  String id;
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime timestamp;
  final bool isCode;
  final String language;
  bool isRead;

  Message({
    this.id = '',
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
    this.isCode = false,
    this.language = 'dart',
    this.isRead = false,
  });

  // Konvertiere Nachricht aus Firestore Map
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      text: map['text'] ?? '',
      timestamp: (map['timestamp'] as dynamic)?.toDate() ?? DateTime.now(),
      isCode: map['isCode'] ?? false,
      language: map['language'] ?? 'dart',
      isRead: map['isRead'] ?? false,
    );
  }

  // Konvertiere Nachricht zu Map für Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'timestamp': timestamp,
      'isCode': isCode,
      'language': language,
      'isRead': isRead,
    };
  }
}

class ChatMatch {
  final String id;
  final List<String> userIds;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final DateTime createdAt;
  
  ChatMatch({
    required this.id,
    required this.userIds,
    this.lastMessage,
    this.lastMessageTime,
    required this.createdAt,
  });
  
  // Konvertiere Match aus Firestore Map
  factory ChatMatch.fromMap(Map<String, dynamic> map, String documentId) {
    return ChatMatch(
      id: documentId,
      userIds: List<String>.from(map['users'] ?? []),
      lastMessage: map['lastMessage'],
      lastMessageTime: (map['lastMessageTime'] as dynamic)?.toDate(),
      createdAt: (map['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
    );
  }

  // Finde die ID des anderen Nutzers (nicht der aktuelle Nutzer)
  String getOtherUserId(String currentUserId) {
    return userIds.firstWhere((id) => id != currentUserId, orElse: () => '');
  }
}