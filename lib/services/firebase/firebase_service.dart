import 'package:swustl/services/firebase/auth_service.dart';
import 'package:swustl/services/firebase/user_service.dart';
import 'package:swustl/services/firebase/project_service.dart';
import 'package:swustl/services/firebase/chat_service.dart';
import 'package:swustl/services/firebase/hackathon_service.dart';
import 'package:swustl/services/firebase/report_service.dart';
import 'package:swustl/services/firebase/storage_service.dart';
import 'package:swustl/services/firebase/notification_service.dart';
import 'package:swustl/services/firebase/firebase_config.dart';
import 'package:firebase_core/firebase_core.dart';

// Zentrale Klasse, die alle Firebase-Services bündelt
class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  
  FirebaseService._internal();
  
  // Einzelne Services
  late final AuthService auth;
  late final UserService users;
  late final ProjectService projects;
  late final ChatService chat;
  late final HackathonFirebaseService hackathons;
  late final ReportService reports;
  late final StorageService storage;
  late final NotificationService notifications;
  
  bool _isInitialized = false;
  
  // Initialisierung aller Firebase-Services
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Firebase Core initialisieren
      if (Firebase.apps.isEmpty) {
          await FirebaseConfig.init();
      }

      // Services initialisieren
      auth = AuthService();
      users = UserService();
      projects = ProjectService();
      chat = ChatService();
      hackathons = HackathonFirebaseService();
      reports = ReportService();
      storage = StorageService();
      notifications = NotificationService();
      
      // Spezielle Initialisierungen
      await notifications.initialize();
      
      _isInitialized = true;
      print('Firebase services initialized successfully');
    } catch (e) {
      print('Error initializing Firebase services: $e');
      rethrow;
    }
  }
  
  // Aufräumen bei App-Beendigung
  Future<void> dispose() async {
    if (!_isInitialized) return;
    
    try {
      // Services bereinigen
      await notifications.deleteFcmToken();
      
      _isInitialized = false;
      print('Firebase services disposed successfully');
    } catch (e) {
      print('Error disposing Firebase services: $e');
    }
  }
}