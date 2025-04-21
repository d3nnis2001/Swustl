import 'package:swustl/models/icebreaker_data.dart';

class UserData {
  // Page 1: Personal Information
  String id = '';
  String firstName = '';
  String lastName = '';
  String username = '';
  int birthDay = 0;
  int birthMonth = 0;
  int birthYear = 0;
  String country = '';
  String phoneNumber = '';
  String? profileImagePath; // Added for custom profile image
  String? avatarPath; // Added for predefined avatar selection
  String? profileImageUrl;
  // Page 2: Education
  List<Education> education = [];
  
  // Page 3: Work Experience
  List<WorkExperience> workExperience = [];
  
  // Page 4: Tech Stack
  List<TechItem> techStack = [];
  
  // Page 5: Goals
  List<String> selectedGoals = [];
  String customGoal = '';
  
  // Page 6: Social Links
  Map<String, String> socialLinks = {
    'github': '',
    'linkedin': '',
    'twitter': '',
    'portfolio': '',
    'stackoverflow': '',
    'medium': '',
  };
  
  // Icebreaker-Antworten
  Map<String, IcebreakerAnswer> icebreakerAnswers = {};
  
  // Füge eine neue Antwort hinzu oder aktualisiere eine bestehende
  void answerIcebreaker(String questionId, String answer) {
    icebreakerAnswers[questionId] = IcebreakerAnswer(
      questionId: questionId,
      answer: answer,
      answeredAt: DateTime.now(),
    );
  }

  // Entferne eine Antwort
  void removeIcebreakerAnswer(String questionId) {
    icebreakerAnswers.remove(questionId);
  }

  // Überprüfen, ob eine bestimmte Frage beantwortet wurde
  bool hasAnsweredQuestion(String questionId) {
    return icebreakerAnswers.containsKey(questionId);
  }

  // Hole eine spezifische Antwort
  IcebreakerAnswer? getAnswer(String questionId) {
    return icebreakerAnswers[questionId];
  }
}

class Education {
  final String institution;
  final String degree;
  final String fieldOfStudy;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isEnrolled;
  
  Education({
    required this.institution,
    required this.degree,
    required this.fieldOfStudy,
    required this.startDate,
    this.endDate,
    required this.isEnrolled,
  });
}

class WorkExperience {
  final String company;
  final String position;
  final String description;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isCurrentPosition;
  
  WorkExperience({
    required this.company,
    required this.position,
    required this.description,
    required this.startDate,
    this.endDate,
    required this.isCurrentPosition,
  });
}

class TechItem {
  final String name;
  final String category; // 'Programming Language', 'Framework', 'Tool', 'Other'
  final bool isCustom; // Whether user added it or was predefined
  
  TechItem({
    required this.name,
    required this.category,
    this.isCustom = false,
  });
}