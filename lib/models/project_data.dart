enum ProjectStatus {
  planning,
  inProgress,
  onHold,
  completed,
}

enum ProjectType {
  app,
  website,
  game,
  ai,
  other,
}

class ProjectData {
  String id = '';
  String title = '';
  String description = '';
  String shortDescription = '';
  String creatorId = '';
  List<String> techStack = [];
  List<String> imageUrls = [];
  List<String> localImagePaths = []; // Temporäre lokale Pfade vor dem Upload
  int memberLimit = 5;
  int currentMemberCount = 1;
  ProjectStatus projectStatus = ProjectStatus.planning;
  ProjectType projectType = ProjectType.app;
  List<String> lookingFor = []; // Gesuchte Rollen oder Skills
  DateTime createdAt = DateTime.now();
  
  ProjectData({
    required this.id,
    required this.title,
    required this.description,
    required this.shortDescription,
    required this.creatorId,
    required this.techStack,
    required this.imageUrls,
    this.localImagePaths = const [],
    required this.memberLimit,
    required this.currentMemberCount,
    required this.projectStatus,
    required this.projectType,
    required this.lookingFor,
    DateTime? createdAt,
  }) : this.createdAt = createdAt ?? DateTime.now();
  
  // Erstelle eine leere Projektinstanz
  factory ProjectData.empty() {
    return ProjectData(
      id: '',
      title: '',
      description: '',
      shortDescription: '',
      creatorId: '',
      techStack: [],
      imageUrls: [],
      memberLimit: 5,
      currentMemberCount: 1,
      projectStatus: ProjectStatus.planning,
      projectType: ProjectType.app,
      lookingFor: [],
    );
  }
  
  // Kopiere das Projekt mit aktualisierten Werten
  ProjectData copyWith({
    String? id,
    String? title,
    String? description,
    String? shortDescription,
    String? creatorId,
    List<String>? techStack,
    List<String>? imageUrls,
    List<String>? localImagePaths,
    int? memberLimit,
    int? currentMemberCount,
    ProjectStatus? projectStatus,
    ProjectType? projectType,
    List<String>? lookingFor,
    DateTime? createdAt,
  }) {
    return ProjectData(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      shortDescription: shortDescription ?? this.shortDescription,
      creatorId: creatorId ?? this.creatorId,
      techStack: techStack ?? this.techStack,
      imageUrls: imageUrls ?? this.imageUrls,
      localImagePaths: localImagePaths ?? this.localImagePaths,
      memberLimit: memberLimit ?? this.memberLimit,
      currentMemberCount: currentMemberCount ?? this.currentMemberCount,
      projectStatus: projectStatus ?? this.projectStatus,
      projectType: projectType ?? this.projectType,
      lookingFor: lookingFor ?? this.lookingFor,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}