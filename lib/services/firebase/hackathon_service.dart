import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:swustl/models/hackathon_data.dart';

class HackathonFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String collectionName = 'hackathons';

  // Alle Hackathons abrufen
  Future<List<HackathonEvent>> getAllHackathons() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(collectionName)
          .orderBy('startDate', descending: false)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // ID hinzufügen
        return _convertMapToHackathon(data);
      }).toList();
    } catch (e) {
      print('Error getting hackathons: $e');
      rethrow;
    }
  }

  // Hackathons nach Suchkriterien filtern
  Future<List<HackathonEvent>> searchHackathons(String query) async {
    try {
      // Basisabfrage für alle Hackathons
      final QuerySnapshot snapshot = await _firestore
          .collection(collectionName)
          .get();

      // Filtern auf Client-Seite, da Firestore keine Volltextsuche unterstützt
      final searchLower = query.toLowerCase();
      
      return snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            return data;
          })
          .where((data) =>
              data['title'].toString().toLowerCase().contains(searchLower) ||
              data['description'].toString().toLowerCase().contains(searchLower) ||
              data['location'].toString().toLowerCase().contains(searchLower) ||
              (data['technologies'] as List).any((tech) =>
                  tech.toString().toLowerCase().contains(searchLower)))
          .map((data) => _convertMapToHackathon(data))
          .toList();
    } catch (e) {
      print('Error searching hackathons: $e');
      rethrow;
    }
  }

  // Nur virtuelle Hackathons abrufen
  Future<List<HackathonEvent>> getVirtualHackathons() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(collectionName)
          .where('isVirtual', isEqualTo: true)
          .orderBy('startDate', descending: false)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return _convertMapToHackathon(data);
      }).toList();
    } catch (e) {
      print('Error getting virtual hackathons: $e');
      rethrow;
    }
  }

  // Nur Vor-Ort-Hackathons abrufen
  Future<List<HackathonEvent>> getInPersonHackathons() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(collectionName)
          .where('isVirtual', isEqualTo: false)
          .orderBy('startDate', descending: false)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return _convertMapToHackathon(data);
      }).toList();
    } catch (e) {
      print('Error getting in-person hackathons: $e');
      rethrow;
    }
  }

  // Hackathon nach ID abrufen
  Future<HackathonEvent?> getHackathonById(String id) async {
    try {
      final DocumentSnapshot doc = await _firestore.collection(collectionName).doc(id).get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return _convertMapToHackathon(data);
      }

      return null;
    } catch (e) {
      print('Error getting hackathon by ID: $e');
      rethrow;
    }
  }

  // Für Administratoren: Hackathon erstellen
  Future<String> createHackathon(HackathonEvent hackathon, {File? imageFile}) async {
    try {
      // Erstelle Map für Firestore
      final hackathonMap = _convertHackathonToMap(hackathon);
      
      // Referenz für neues Dokument
      final docRef = _firestore.collection(collectionName).doc();
      
      // Wenn ein Bild vorhanden ist, lade es hoch
      if (imageFile != null && imageFile.existsSync()) {
        final String fileName = '${docRef.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final Reference storageRef = _storage.ref().child('hackathon_images/$fileName');
        
        // Bild hochladen
        final UploadTask uploadTask = storageRef.putFile(imageFile);
        final TaskSnapshot taskSnapshot = await uploadTask;
        
        // Download-URL speichern
        final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        hackathonMap['image'] = downloadUrl;
      }
      
      // Hackathon in Firestore speichern
      await docRef.set(hackathonMap);
      
      return docRef.id;
    } catch (e) {
      print('Error creating hackathon: $e');
      rethrow;
    }
  }

  // Für Administratoren: Hackathon aktualisieren
  Future<void> updateHackathon(HackathonEvent hackathon, {File? imageFile}) async {
    try {
      // Erstelle Map für Firestore
      final hackathonMap = _convertHackathonToMap(hackathon);
      hackathonMap['updatedAt'] = FieldValue.serverTimestamp();
      
      // Wenn ein neues Bild vorhanden ist, lade es hoch
      if (imageFile != null && imageFile.existsSync()) {
        final String fileName = '${hackathon.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final Reference storageRef = _storage.ref().child('hackathon_images/$fileName');
        
        // Bild hochladen
        final UploadTask uploadTask = storageRef.putFile(imageFile);
        final TaskSnapshot taskSnapshot = await uploadTask;
        
        // Download-URL speichern
        final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        hackathonMap['image'] = downloadUrl;
      }
      
      // Hackathon in Firestore aktualisieren
      await _firestore.collection(collectionName).doc(hackathon.id).update(hackathonMap);
    } catch (e) {
      print('Error updating hackathon: $e');
      rethrow;
    }
  }

  // Für Administratoren: Hackathon löschen
  Future<void> deleteHackathon(String id) async {
    try {
      // Hackathon-Dokument löschen
      await _firestore.collection(collectionName).doc(id).delete();
      
      // Hackathon-Bild löschen (falls vorhanden)
      try {
        final ListResult result = await _storage.ref().child('hackathon_images').listAll();
        for (var item in result.items) {
          if (item.name.startsWith('${id}_')) {
            await item.delete();
          }
        }
      } catch (e) {
        print('Error deleting hackathon image: $e');
        // Fehler beim Löschen des Bildes ignorieren
      }
    } catch (e) {
      print('Error deleting hackathon: $e');
      rethrow;
    }
  }

  // Anmeldung für einen Hackathon
  Future<void> registerForHackathon(String hackathonId, String userId) async {
    try {
      // Teilnahme in der Subcollection des Hackathons speichern
      await _firestore
          .collection(collectionName)
          .doc(hackathonId)
          .collection('participants')
          .doc(userId)
          .set({
        'registeredAt': FieldValue.serverTimestamp(),
        'status': 'registered', // z.B. 'registered', 'confirmed', 'cancelled'
      });
      
      // Teilnahme auch beim Nutzer speichern
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('hackathons')
          .doc(hackathonId)
          .set({
        'registeredAt': FieldValue.serverTimestamp(),
        'status': 'registered',
      });
      
      // Teilnehmerzahl aktualisieren
      await _firestore.collection(collectionName).doc(hackathonId).update({
        'participantCount': FieldValue.increment(1)
      });
    } catch (e) {
      print('Error registering for hackathon: $e');
      rethrow;
    }
  }

  // Abmeldung von einem Hackathon
  Future<void> unregisterFromHackathon(String hackathonId, String userId) async {
    try {
      // Teilnahme in der Subcollection des Hackathons löschen
      await _firestore
          .collection(collectionName)
          .doc(hackathonId)
          .collection('participants')
          .doc(userId)
          .update({
        'status': 'cancelled',
        'cancelledAt': FieldValue.serverTimestamp(),
      });
      
      // Teilnahme auch beim Nutzer aktualisieren
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('hackathons')
          .doc(hackathonId)
          .update({
        'status': 'cancelled',
        'cancelledAt': FieldValue.serverTimestamp(),
      });
      
      // Teilnehmerzahl aktualisieren
      await _firestore.collection(collectionName).doc(hackathonId).update({
        'participantCount': FieldValue.increment(-1)
      });
    } catch (e) {
      print('Error unregistering from hackathon: $e');
      rethrow;
    }
  }

  // Prüfen, ob ein Nutzer für einen Hackathon angemeldet ist
  Future<bool> isUserRegistered(String hackathonId, String userId) async {
    try {
      final doc = await _firestore
          .collection(collectionName)
          .doc(hackathonId)
          .collection('participants')
          .doc(userId)
          .get();
      
      return doc.exists && doc.data()?['status'] == 'registered';
    } catch (e) {
      print('Error checking if user is registered: $e');
      rethrow;
    }
  }

  // HackathonEvent in Map für Firestore konvertieren
  Map<String, dynamic> _convertHackathonToMap(HackathonEvent hackathon) {
    final Map<String, dynamic> parsedDate = _parseDateFromString(hackathon.date);
    
    return {
      'title': hackathon.title,
      'date': hackathon.date,
      'startDate': parsedDate['startDate'], // Timestamp für die Sortierung
      'endDate': parsedDate['endDate'], // Timestamp für die Sortierung
      'location': hackathon.location,
      'description': hackathon.description,
      'technologies': hackathon.technologies,
      'image': hackathon.image,
      'isVirtual': hackathon.isVirtual,
      'organizerName': hackathon.organizerName,
      'participantCount': 0, // Wird durch Anmeldungen erhöht
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  // Map aus Firestore in HackathonEvent konvertieren
  HackathonEvent _convertMapToHackathon(Map<String, dynamic> map) {
    return HackathonEvent(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      date: map['date'] ?? '',
      location: map['location'] ?? '',
      description: map['description'] ?? '',
      technologies: List<String>.from(map['technologies'] ?? []),
      image: map['image'] ?? '',
      isVirtual: map['isVirtual'] ?? false,
      organizerName: map['organizerName'] ?? '',
    );
  }

  // Hilfsfunktion zum Parsen des Datums aus dem String
  Map<String, dynamic> _parseDateFromString(String dateStr) {
    // Beispiel: "24.-26. Mai 2025"
    try {
      final parts = dateStr.split('.');
      if (parts.length >= 2) {
        // Extrahiere den ersten Tag (24)
        final startDay = int.tryParse(parts[0].replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;
        
        // Extrahiere den letzten Tag, falls vorhanden (26)
        int? endDay;
        if (parts[1].contains('-')) {
          final endDayStr = parts[1].split('-')[1].trim();
          endDay = int.tryParse(endDayStr) ?? startDay;
        }
        
        // Extrahiere Monat und Jahr
        String monthStr = parts[1];
        if (monthStr.contains(' ')) {
          monthStr = monthStr.split(' ')[1];
        }
        
        int month;
        switch (monthStr.toLowerCase()) {
          case 'januar': month = 1; break;
          case 'februar': month = 2; break;
          case 'märz': month = 3; break;
          case 'april': month = 4; break;
          case 'mai': month = 5; break;
          case 'juni': month = 6; break;
          case 'juli': month = 7; break;
          case 'august': month = 8; break;
          case 'september': month = 9; break;
          case 'oktober': month = 10; break;
          case 'november': month = 11; break;
          case 'dezember': month = 12; break;
          default: month = 1;
        }
        
        int year = 2025; // Standardwert
        if (parts.length > 2) {
          year = int.tryParse(parts[2].trim()) ?? 2025;
        } else if (dateStr.contains('20')) {
          // Versuche, das Jahr aus dem String zu extrahieren
          final yearMatch = RegExp(r'20\d{2}').firstMatch(dateStr);
          if (yearMatch != null) {
            year = int.tryParse(yearMatch.group(0) ?? '') ?? 2025;
          }
        }
        
        // Erstelle Timestamp für Start- und Enddatum
        final startDate = Timestamp.fromDate(DateTime(year, month, startDay));
        final endDate = Timestamp.fromDate(DateTime(year, month, endDay ?? startDay));
        
        return {
          'startDate': startDate,
          'endDate': endDate,
        };
      }
    } catch (e) {
      print('Error parsing date: $e');
    }
    
    // Fallback: aktuelles Datum
    return {
      'startDate': Timestamp.fromDate(DateTime.now()),
      'endDate': Timestamp.fromDate(DateTime.now()),
    };
  }
}