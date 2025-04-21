import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swustl/models/user_data.dart';
import 'package:swustl/models/icebreaker_data.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String collectionName = 'users';

  // Nutzer erstellen oder aktualisieren
  Future<void> createOrUpdateUser(UserData userData) async {
    try {
      // Wenn Profilbild als Datei vorhanden, hochladen
      if (userData.profileImagePath != null && File(userData.profileImagePath!).existsSync()) {
        final File file = File(userData.profileImagePath!);
        final String fileName = '${userData.id}_profile.jpg';
        final Reference storageRef = _storage.ref().child('profile_images/$fileName');
        
        // Bild hochladen
        final UploadTask uploadTask = storageRef.putFile(file);
        final TaskSnapshot taskSnapshot = await uploadTask;
        
        // Download-URL speichern
        final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        userData.profileImageUrl = downloadUrl;
        
        // Lokalen Pfad entfernen, da er auf anderen Geräten nicht gültig ist
        userData.profileImagePath = null;
      }
      
      // Konvertiere userData in Map
      final Map<String, dynamic> userMap = _convertUserDataToMap(userData);
      
      // In Firestore speichern
      await _firestore.collection(collectionName).doc(userData.id).set(userMap);
    } catch (e) {
      rethrow;
    }
  }

  // Nutzer nach ID abrufen
  Future<UserData?> getUserById(String userId) async {
    try {
      final DocumentSnapshot doc = await _firestore.collection(collectionName).doc(userId).get();
      
      if (doc.exists) {
        return _convertMapToUserData(doc.data() as Map<String, dynamic>, doc.id);
      }
      
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Nutzerdaten konvertieren für Firestore
  Map<String, dynamic> _convertUserDataToMap(UserData userData) {
    return {
      'firstName': userData.firstName,
      'lastName': userData.lastName,
      'username': userData.username,
      'birthDay': userData.birthDay,
      'birthMonth': userData.birthMonth,
      'birthYear': userData.birthYear,
      'country': userData.country,
      'phoneNumber': userData.phoneNumber,
      'profileImageUrl': userData.profileImageUrl,
      'avatarPath': userData.avatarPath,
      'education': userData.education.map((edu) => {
        'institution': edu.institution,
        'degree': edu.degree,
        'fieldOfStudy': edu.fieldOfStudy,
        'startDate': Timestamp.fromDate(edu.startDate),
        'endDate': edu.endDate != null ? Timestamp.fromDate(edu.endDate!) : null,
        'isEnrolled': edu.isEnrolled,
      }).toList(),
      'workExperience': userData.workExperience.map((work) => {
        'company': work.company,
        'position': work.position,
        'description': work.description,
        'startDate': Timestamp.fromDate(work.startDate),
        'endDate': work.endDate != null ? Timestamp.fromDate(work.endDate!) : null,
        'isCurrentPosition': work.isCurrentPosition,
      }).toList(),
      'techStack': userData.techStack.map((tech) => {
        'name': tech.name,
        'category': tech.category,
        'isCustom': tech.isCustom,
      }).toList(),
      'selectedGoals': userData.selectedGoals,
      'customGoal': userData.customGoal,
      'socialLinks': userData.socialLinks,
      'icebreakerAnswers': userData.icebreakerAnswers.map((key, value) => MapEntry(key, {
        'questionId': value.questionId,
        'answer': value.answer,
        'answeredAt': Timestamp.fromDate(value.answeredAt),
      })),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  // Map aus Firestore in UserData konvertieren
  UserData _convertMapToUserData(Map<String, dynamic> map, String userId) {
    final userData = UserData()
      ..id = userId
      ..firstName = map['firstName'] ?? ''
      ..lastName = map['lastName'] ?? ''
      ..username = map['username'] ?? ''
      ..birthDay = map['birthDay'] ?? 0
      ..birthMonth = map['birthMonth'] ?? 0
      ..birthYear = map['birthYear'] ?? 0
      ..country = map['country'] ?? ''
      ..phoneNumber = map['phoneNumber'] ?? ''
      ..profileImageUrl = map['profileImageUrl']
      ..avatarPath = map['avatarPath'];

    // Education
    if (map['education'] != null) {
      userData.education = (map['education'] as List).map((edu) {
        return Education(
          institution: edu['institution'],
          degree: edu['degree'],
          fieldOfStudy: edu['fieldOfStudy'] ?? '',
          startDate: (edu['startDate'] as Timestamp).toDate(),
          endDate: edu['endDate'] != null ? (edu['endDate'] as Timestamp).toDate() : null,
          isEnrolled: edu['isEnrolled'] ?? false,
        );
      }).toList();
    }

    // Work Experience
    if (map['workExperience'] != null) {
      userData.workExperience = (map['workExperience'] as List).map((work) {
        return WorkExperience(
          company: work['company'],
          position: work['position'],
          description: work['description'] ?? '',
          startDate: (work['startDate'] as Timestamp).toDate(),
          endDate: work['endDate'] != null ? (work['endDate'] as Timestamp).toDate() : null,
          isCurrentPosition: work['isCurrentPosition'] ?? false,
        );
      }).toList();
    }

    // Tech Stack
    if (map['techStack'] != null) {
      userData.techStack = (map['techStack'] as List).map((tech) {
        return TechItem(
          name: tech['name'],
          category: tech['category'],
          isCustom: tech['isCustom'] ?? false,
        );
      }).toList();
    }

    // Goals
    if (map['selectedGoals'] != null) {
      userData.selectedGoals = List<String>.from(map['selectedGoals']);
    }
    userData.customGoal = map['customGoal'] ?? '';

    // Social Links
    if (map['socialLinks'] != null) {
      userData.socialLinks = Map<String, String>.from(map['socialLinks']);
    }

    // Icebreaker Answers
    if (map['icebreakerAnswers'] != null) {
      final answers = map['icebreakerAnswers'] as Map<String, dynamic>;
      answers.forEach((key, value) {
        userData.icebreakerAnswers[key] = IcebreakerAnswer(
          questionId: value['questionId'],
          answer: value['answer'],
          answeredAt: (value['answeredAt'] as Timestamp).toDate(),
        );
      });
    }

    return userData;
  }

  // Nutzer nach Username suchen
  Future<List<UserData>> searchUsersByUsername(String query) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(collectionName)
          .where('username', isGreaterThanOrEqualTo: query)
          .where('username', isLessThan: query + 'z')
          .get();

      return snapshot.docs.map((doc) {
        return _convertMapToUserData(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }
}