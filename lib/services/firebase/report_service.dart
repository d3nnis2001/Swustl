import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum ReportType {
  user,
  project,
  message,
  hackathon,
}

class ReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String collectionName = 'reports';
  
  // Aktueller Nutzer
  String? get currentUserId => _auth.currentUser?.uid;

  // Meldung erstellen
  Future<void> createReport({
    required String itemId,
    required ReportType reportType,
    required String reason,
    String? details,
  }) async {
    if (currentUserId == null) {
      throw Exception('Nutzer ist nicht angemeldet');
    }
    
    // Meldung validieren
    if (reason.isEmpty) {
      throw Exception('Bitte gib einen Grund für die Meldung an');
    }
    
    // Meldung in Firestore speichern
    await _firestore.collection(collectionName).add({
      'reporterId': currentUserId,
      'itemId': itemId,
      'reportType': reportType.toString().split('.').last,
      'reason': reason,
      'details': details,
      'status': 'pending', // Status: 'pending', 'reviewed', 'resolved'
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Nutzer melden
  Future<void> reportUser(String userId, String reason, {String? details}) async {
    await createReport(
      itemId: userId,
      reportType: ReportType.user,
      reason: reason,
      details: details,
    );
  }

  // Projekt melden
  Future<void> reportProject(String projectId, String reason, {String? details}) async {
    await createReport(
      itemId: projectId,
      reportType: ReportType.project,
      reason: reason,
      details: details,
    );
  }

  // Nachricht melden
  Future<void> reportMessage(String messageId, String reason, {String? details}) async {
    await createReport(
      itemId: messageId,
      reportType: ReportType.message,
      reason: reason,
      details: details,
    );
  }

  // Hackathon melden
  Future<void> reportHackathon(String hackathonId, String reason, {String? details}) async {
    await createReport(
      itemId: hackathonId,
      reportType: ReportType.hackathon,
      reason: reason,
      details: details,
    );
  }

  // Für Administratoren: Holen aller offenen Meldungen
  Future<List<Map<String, dynamic>>> getPendingReports() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(collectionName)
          .where('status', isEqualTo: 'pending')
          .orderBy('createdAt', descending: true)
          .get();
      
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // ID hinzufügen
        return data;
      }).toList();
    } catch (e) {
      print('Error getting pending reports: $e');
      rethrow;
    }
  }

  // Für Administratoren: Status einer Meldung aktualisieren
  Future<void> updateReportStatus(String reportId, String status, {String? adminComment}) async {
    try {
      await _firestore.collection(collectionName).doc(reportId).update({
        'status': status,
        'adminComment': adminComment,
        'reviewedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating report status: $e');
      rethrow;
    }
  }
  
  // Für Administratoren: Meldung löschen
  Future<void> deleteReport(String reportId) async {
    try {
      await _firestore.collection(collectionName).doc(reportId).delete();
    } catch (e) {
      print('Error deleting report: $e');
      rethrow;
    }
  }
}