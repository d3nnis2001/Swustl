import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:swustl/models/project_data.dart';

class ProjectService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String collectionName = 'projects';

  // Projekt erstellen
  Future<String> createProject(ProjectData project) async {
    try {
      // Konvertiere Projektdaten für Firestore
      final Map<String, dynamic> projectMap = _convertProjectToMap(project);
      
      // Referenz für neues Dokument
      final docRef = _firestore.collection(collectionName).doc();
      project.id = docRef.id;
      projectMap['id'] = docRef.id;
      
      // Projekt in Firestore speichern
      await docRef.set(projectMap);
      
      // Bilder hochladen, falls vorhanden
      if (project.localImagePaths.isNotEmpty) {
        await _uploadProjectImages(project);
      }
      
      return docRef.id;
    } catch (e) {
      rethrow;
    }
  }

  // Projekt aktualisieren
  Future<void> updateProject(ProjectData project) async {
    try {
      // Bilder hochladen, falls neue vorhanden
      if (project.localImagePaths.isNotEmpty) {
        await _uploadProjectImages(project);
      }
      
      // Konvertiere aktualisierten Projektdaten für Firestore
      final Map<String, dynamic> projectMap = _convertProjectToMap(project);
      projectMap['updatedAt'] = FieldValue.serverTimestamp();
      
      // Projekt in Firestore aktualisieren
      await _firestore.collection(collectionName).doc(project.id).update(projectMap);
    } catch (e) {
      rethrow;
    }
  }

  // Projekt nach ID abrufen
  Future<ProjectData?> getProjectById(String projectId) async {
    try {
      final DocumentSnapshot doc = await _firestore.collection(collectionName).doc(projectId).get();
      
      if (doc.exists) {
        return _convertMapToProject(doc.data() as Map<String, dynamic>);
      }
      
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Projekt löschen
  Future<void> deleteProject(String projectId) async {
    try {
      // Projekt-Dokument löschen
      await _firestore.collection(collectionName).doc(projectId).delete();
      
      // Projektbilder löschen
      final ListResult result = await _storage.ref().child('project_images/$projectId').listAll();
      for (var item in result.items) {
        await item.delete();
      }
    } catch (e) {
      rethrow;
    }
  }

  // Projekte für die Swipe-Funktion abrufen
  Future<List<ProjectData>> getProjectsForSwiping(String userId, {int limit = 10}) async {
    try {
      // Projekte abrufen, die der Nutzer noch nicht gesehen hat
      // Dies würde eine separate Collection voraussetzen, um zu verfolgen, welche Projekte ein Nutzer bereits gesehen hat
      final QuerySnapshot alreadySeenProjects = await _firestore
          .collection('users')
          .doc(userId)
          .collection('swipedProjects')
          .get();
      
      final List<String> seenProjectIds = alreadySeenProjects.docs
          .map((doc) => doc.id)
          .toList();
      
      // Projekte vom Nutzer selbst abrufen, um sie auszuschließen
      final QuerySnapshot userProjects = await _firestore
          .collection(collectionName)
          .where('creatorId', isEqualTo: userId)
          .get();
      
      final List<String> userProjectIds = userProjects.docs
          .map((doc) => doc.id)
          .toList();
      
      // Kombiniere beide Listen von auszuschließenden Projekten
      final List<String> excludeProjectIds = [...seenProjectIds, ...userProjectIds];
      
      // Projekte nach Aktualität abrufen, mit Ausschluss der bereits gesehenen
      QuerySnapshot snapshot;
      if (excludeProjectIds.isEmpty) {
        // Wenn keine Projekte ausgeschlossen werden müssen
        snapshot = await _firestore
            .collection(collectionName)
            .orderBy('createdAt', descending: true)
            .limit(limit)
            .get();
      } else {
        // Da Firestore keine direkte "not in" Abfrage unterstützt, müssen wir eine Workaround-Lösung verwenden
        // Hier verwenden wir einen einfachen Ansatz, der für kleine bis mittlere Datensätze funktionieren sollte
        snapshot = await _firestore
            .collection(collectionName)
            .orderBy('createdAt', descending: true)
            .get();
        
        // Filterung auf Client-Seite
        final filteredDocs = snapshot.docs
            .where((doc) => !excludeProjectIds.contains(doc.id))
            .take(limit)
            .toList();
        
        // Erstelle eine neue QuerySnapshot mit den gefilterten Dokumenten
        return filteredDocs.map((doc) => 
          _convertMapToProject(doc.data() as Map<String, dynamic>)
        ).toList();
      }
      
      return snapshot.docs.map((doc) => 
        _convertMapToProject(doc.data() as Map<String, dynamic>)
      ).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Projektbilder hochladen
  Future<void> _uploadProjectImages(ProjectData project) async {
    try {
      List<String> imageUrls = [];
      
      for (int i = 0; i < project.localImagePaths.length; i++) {
        final String localPath = project.localImagePaths[i];
        final File file = File(localPath);
        
        if (file.existsSync()) {
          final String fileName = '${project.id}_${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
          final Reference storageRef = _storage.ref().child('project_images/${project.id}/$fileName');
          
          // Bild hochladen
          final UploadTask uploadTask = storageRef.putFile(file);
          final TaskSnapshot taskSnapshot = await uploadTask;
          
          // Download-URL hinzufügen
          final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
          imageUrls.add(downloadUrl);
        }
      }
      
      // Neue URLs zu bestehenden hinzufügen
      project.imageUrls.addAll(imageUrls);
      
      // Lokale Pfade leeren, da die Bilder jetzt hochgeladen wurden
      project.localImagePaths = [];
      
      // Projekt in Firestore aktualisieren mit den neuen URLs
      await _firestore.collection(collectionName).doc(project.id).update({
        'imageUrls': project.imageUrls,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  // ProjectData in Map für Firestore konvertieren
  Map<String, dynamic> _convertProjectToMap(ProjectData project) {
    return {
      'title': project.title,
      'description': project.description,
      'shortDescription': project.shortDescription,
      'creatorId': project.creatorId,
      'techStack': project.techStack,
      'imageUrls': project.imageUrls,
      'memberLimit': project.memberLimit,
      'currentMemberCount': project.currentMemberCount,
      'projectStatus': project.projectStatus.toString().split('.').last,
      'projectType': project.projectType.toString().split('.').last,
      'lookingFor': project.lookingFor,
      'createdAt': project.id.isEmpty ? FieldValue.serverTimestamp() : project.createdAt,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  // Map aus Firestore in ProjectData konvertieren
  ProjectData _convertMapToProject(Map<String, dynamic> map) {
    final projectData = ProjectData(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      shortDescription: map['shortDescription'] ?? '',
      creatorId: map['creatorId'] ?? '',
      techStack: List<String>.from(map['techStack'] ?? []),
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      memberLimit: map['memberLimit'] ?? 5,
      currentMemberCount: map['currentMemberCount'] ?? 1,
      projectStatus: _stringToProjectStatus(map['projectStatus']),
      projectType: _stringToProjectType(map['projectType']),
      lookingFor: List<String>.from(map['lookingFor'] ?? []),
    );

    // Zeitstempel konvertieren
    if (map['createdAt'] != null) {
      projectData.createdAt = (map['createdAt'] as Timestamp).toDate();
    }
    
    return projectData;
  }

  // String in ProjectStatus Enum konvertieren
  ProjectStatus _stringToProjectStatus(String? statusString) {
    if (statusString == null) return ProjectStatus.planning;
    
    switch (statusString) {
      case 'inProgress':
        return ProjectStatus.inProgress;
      case 'completed':
        return ProjectStatus.completed;
      case 'onHold':
        return ProjectStatus.onHold;
      default:
        return ProjectStatus.planning;
    }
  }

  // String in ProjectType Enum konvertieren
  ProjectType _stringToProjectType(String? typeString) {
    if (typeString == null) return ProjectType.app;
    
    switch (typeString) {
      case 'website':
        return ProjectType.website;
      case 'game':
        return ProjectType.game;
      case 'ai':
        return ProjectType.ai;
      case 'other':
        return ProjectType.other;
      default:
        return ProjectType.app;
    }
  }

  // Projekt-Swipe Aktion speichern (Like/Dislike)
  Future<void> saveProjectSwipe(String userId, String projectId, bool isLike) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('swipedProjects')
          .doc(projectId)
          .set({
        'isLike': isLike,
        'swipedAt': FieldValue.serverTimestamp(),
      });
      
      // Wenn es ein Like ist, auch bei den Projekt-Likes speichern
      if (isLike) {
        await _firestore
            .collection('projects')
            .doc(projectId)
            .collection('likes')
            .doc(userId)
            .set({
          'likedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      rethrow;
    }
  }
}