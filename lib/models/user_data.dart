// user_data.dart
class UserData {
  // Page 1: Personal Information
  String firstName = '';
  String lastName = '';
  String username = '';
  int birthDay = 0;
  int birthMonth = 0;
  int birthYear = 0;
  String country = '';
  String phoneNumber = '';
  
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