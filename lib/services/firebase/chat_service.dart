import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swustl/models/message_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Collection names
  final String _matchesCollection = 'matches';
  final String _messagesCollection = 'messages';
  
  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;
  
  // Create or get a chat between two users
  Future<String> createOrGetChat(String otherUserId) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }
    
    // Sort IDs alphabetically to ensure consistent chat ID
    final List<String> sortedIds = [currentUserId!, otherUserId]..sort();
    final String chatId = sortedIds.join('_');
    
    // Check if chat already exists
    final chatDoc = await _firestore.collection(_matchesCollection).doc(chatId).get();
    
    if (!chatDoc.exists) {
      // Create new chat
      await _firestore.collection(_matchesCollection).doc(chatId).set({
        'users': sortedIds,
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': null,
        'lastMessageTime': null,
      });
    }
    
    return chatId;
  }
  
  // Get all chats for the current user
  Stream<QuerySnapshot> getChats() {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }
    
    return _firestore
        .collection(_matchesCollection)
        .where('users', arrayContains: currentUserId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }
  
  // Send a message
  Future<void> sendMessage(String chatId, Message message) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }
    
    // Create message in Firestore
    final messageRef = _firestore
        .collection(_matchesCollection)
        .doc(chatId)
        .collection(_messagesCollection)
        .doc();
    
    message.id = messageRef.id;
    
    // Convert message to map
    final messageMap = {
      'id': message.id,
      'senderId': message.senderId,
      'receiverId': message.receiverId,
      'text': message.text,
      'timestamp': FieldValue.serverTimestamp(),
      'isCode': message.isCode,
      'language': message.language,
    };
    
    // Add message to chat
    await messageRef.set(messageMap);
    
    // Update chat with last message
    await _firestore.collection(_matchesCollection).doc(chatId).update({
      'lastMessage': message.text,
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
  }
  
  // Get messages for a chat
  Stream<QuerySnapshot> getMessages(String chatId) {
    return _firestore
        .collection(_matchesCollection)
        .doc(chatId)
        .collection(_messagesCollection)
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
  
  // Mark messages as read
  Future<void> markMessagesAsRead(String chatId, String senderId) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }
    
    // Get unread messages from the sender
    final unreadMessages = await _firestore
        .collection(_matchesCollection)
        .doc(chatId)
        .collection(_messagesCollection)
        .where('senderId', isEqualTo: senderId)
        .where('isRead', isEqualTo: false)
        .get();
    
    // Update each message
    final batch = _firestore.batch();
    for (var doc in unreadMessages.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    
    // Commit batch update
    await batch.commit();
  }
  
  // Delete a message
  Future<void> deleteMessage(String chatId, String messageId) async {
    await _firestore
        .collection(_matchesCollection)
        .doc(chatId)
        .collection(_messagesCollection)
        .doc(messageId)
        .delete();
        
    // Update last message if needed
    final lastMessage = await _firestore
        .collection(_matchesCollection)
        .doc(chatId)
        .collection(_messagesCollection)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();
    
    if (lastMessage.docs.isNotEmpty) {
      final doc = lastMessage.docs.first;
      await _firestore.collection(_matchesCollection).doc(chatId).update({
        'lastMessage': doc['text'],
        'lastMessageTime': doc['timestamp'],
      });
    } else {
      // No messages left
      await _firestore.collection(_matchesCollection).doc(chatId).update({
        'lastMessage': null,
        'lastMessageTime': null,
      });
    }
  }
  
  // Report a message
  Future<void> reportMessage(String chatId, String messageId, String reason) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }
    
    await _firestore.collection('reports').add({
      'reporterId': currentUserId,
      'chatId': chatId,
      'messageId': messageId,
      'reason': reason,
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'pending',
    });
  }
}