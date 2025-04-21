import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Für lokale Benachrichtigungen
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  
  // Aktuelle Nutzer-ID
  String? get currentUserId => _auth.currentUser?.uid;
  
  // Initialisierung des Notification-Service
  Future<void> initialize() async {
    try {
      // Berechtigungen anfordern
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
      
      print('Notification permission status: ${settings.authorizationStatus}');
      
      // FCM-Token speichern
      await _saveFcmToken();
      
      // FCM-Token-Aktualisierung überwachen
      _messaging.onTokenRefresh.listen(_updateFcmToken);
      
      // Lokale Benachrichtigungen initialisieren
      await _initLocalNotifications();
      
      // Hintergrund-Nachrichten-Handler
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      
      // Vordergrund-Nachrichten-Handler
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      
      // Nachricht bei App-Öffnung durch Benachrichtigung
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
    } catch (e) {
      print('Error initializing notification service: $e');
    }
  }
  
  // Lokale Benachrichtigungen initialisieren
  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    final DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        // iOS 10+ wird diese Callback-Methode nicht aufrufen
      }
    );
    
    final InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) async {
        // Hier kann auf das Tippen einer lokalen Benachrichtigung reagiert werden
        if (details.payload != null) {
          print('Notification payload: ${details.payload}');
          // Navigiere zu entsprechendem Screen basierend auf payload
        }
      },
    );
  }
  
  // FCM-Token speichern
  Future<void> _saveFcmToken() async {
    if (currentUserId == null) return;
    
    String? token = await _messaging.getToken();
    if (token != null) {
      await _updateFcmToken(token);
    }
  }
  
  // FCM-Token aktualisieren
  Future<void> _updateFcmToken(String token) async {
    if (currentUserId == null) return;
    
    await _firestore.collection('users').doc(currentUserId).update({
      'fcmTokens': FieldValue.arrayUnion([token]),
      'lastTokenUpdate': FieldValue.serverTimestamp(),
    });
  }
  
  // FCM-Token löschen (bei Abmeldung)
  Future<void> deleteFcmToken() async {
    if (currentUserId == null) return;
    
    String? token = await _messaging.getToken();
    if (token != null) {
      await _firestore.collection('users').doc(currentUserId).update({
        'fcmTokens': FieldValue.arrayRemove([token]),
      });
      await _messaging.deleteToken();
    }
  }
  
  // Benachrichtigung anzeigen
  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'swustl_channel',
      'Swustl Notifications',
      channelDescription: 'Notifications for TechMate app',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _localNotifications.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
  
  // Benachrichtigung an Nutzer senden
  Future<void> sendNotificationToUser({
    required String userId,
    required String title,
    required String body,
    required String type,
    Map<String, dynamic>? data,
  }) async {
    try {
      // Nutzer-Dokument abrufen, um FCM-Token zu erhalten
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) return;
      
      final userData = userDoc.data();
      final List<dynamic>? fcmTokens = userData?['fcmTokens'];
      
      if (fcmTokens == null || fcmTokens.isEmpty) return;
      
      // Benachrichtigung in Firestore speichern
      final notificationRef = _firestore.collection('notifications').doc();
      
      final Map<String, dynamic> notificationData = {
        'id': notificationRef.id,
        'userId': userId,
        'title': title,
        'body': body,
        'type': type,
        'data': data ?? {},
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      };
      
      await notificationRef.set(notificationData);
      
      // Benachrichtigung wird über Cloud Functions an die FCM-Token gesendet
      // Dies erfordert eine Cloud Function, die auf neue Dokumente in der notifications-Collection reagiert
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
  
  // Hintergrund-Nachrichten-Handler
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print('Handling a background message: ${message.messageId}');
    // Hier können Hintergrund-Nachrichten verarbeitet werden
  }
  
  // Vordergrund-Nachrichten-Handler
  void _handleForegroundMessage(RemoteMessage message) {
    print('Got a message in the foreground!');
    print('Message data: ${message.data}');
    
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
      
      // Lokale Benachrichtigung anzeigen
      showLocalNotification(
        id: message.hashCode,
        title: message.notification!.title ?? 'Neue Benachrichtigung',
        body: message.notification!.body ?? '',
        payload: message.data.toString(),
      );
    }
  }
  
  // Handler für das Öffnen der App durch eine Benachrichtigung
  void _handleMessageOpenedApp(RemoteMessage message) {
    print('Message opened app: ${message.data}');
    // Hier kann zur entsprechenden Seite navigiert werden, basierend auf message.data
  }
  
  // Benachrichtigungen für einen Nutzer als gelesen markieren
  Future<void> markNotificationAsRead(String notificationId) async {
    if (currentUserId == null) return;
    
    await _firestore.collection('notifications').doc(notificationId).update({
      'isRead': true,
      'readAt': FieldValue.serverTimestamp(),
    });
  }
  
  // Alle Benachrichtigungen für einen Nutzer als gelesen markieren
  Future<void> markAllNotificationsAsRead() async {
    if (currentUserId == null) return;
    
    final batch = _firestore.batch();
    
    final notifications = await _firestore
        .collection('notifications')
        .where('userId', isEqualTo: currentUserId)
        .where('isRead', isEqualTo: false)
        .get();
    
    for (var doc in notifications.docs) {
      batch.update(doc.reference, {
        'isRead': true,
        'readAt': FieldValue.serverTimestamp(),
      });
    }
    
    await batch.commit();
  }
  
  // Benachrichtigungen für einen Nutzer abrufen
  Stream<QuerySnapshot> getNotificationsForUser() {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }
    
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: currentUserId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
  
  // Anzahl ungelesener Benachrichtigungen abrufen
  Stream<int> getUnreadNotificationCount() {
    if (currentUserId == null) {
      return Stream.value(0);
    }
    
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: currentUserId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}