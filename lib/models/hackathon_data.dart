class HackathonEvent {
  final String id;
  final String title;
  final String date;
  final String location;
  final String description;
  final List<String> technologies;
  final String image;
  final bool isVirtual;
  final String organizerName;
  
  HackathonEvent({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.description,
    required this.technologies,
    required this.image,
    required this.isVirtual,
    required this.organizerName,
  });
}

// Service für Hackathon-Daten (könnte später mit einer API verbunden werden)
class HackathonService {
  // Singleton-Instanz
  static final HackathonService _instance = HackathonService._internal();
  factory HackathonService() => _instance;
  HackathonService._internal();
  
  // Beispieldaten für Hackathons
  final List<HackathonEvent> _hackathons = [
    HackathonEvent(
      id: '1',
      title: 'TechMate Code Challenge',
      date: '24.-26. Mai 2025',
      location: 'Berlin',
      description: 'Ein 48-Stunden-Hackathon für innovative Tech-Lösungen. Richte dein eigenes Team ein oder finde Teammitglieder vor Ort.',
      technologies: ['Web', 'Mobile', 'AI', 'Cloud'],
      image: 'assets/hackathon1.jpg',
      isVirtual: false,
      organizerName: 'TechMate Community',
    ),
    HackathonEvent(
      id: '2',
      title: 'AI Sustainability Hackathon',
      date: '15.-16. Juni 2025',
      location: 'München',
      description: 'Entwickle KI-Lösungen für nachhaltige Entwicklung und Umweltschutz. Preise im Wert von 10.000€.',
      technologies: ['AI', 'ML', 'Data Science', 'IoT'],
      image: 'assets/hackathon2.jpg',
      isVirtual: false,
      organizerName: 'Sustainability Tech Alliance',
    ),
    HackathonEvent(
      id: '3',
      title: 'Virtual FinTech Challenge',
      date: '8.-10. Juli 2025',
      location: 'Online',
      description: 'Transformiere die Finanzbranche mit innovativen Tech-Lösungen. Arbeite von überall aus mit Entwicklern weltweit.',
      technologies: ['FinTech', 'Blockchain', 'API', 'Security'],
      image: 'assets/hackathon3.jpg',
      isVirtual: true,
      organizerName: 'Future Finance Group',
    ),
    HackathonEvent(
      id: '4',
      title: 'Health Tech Innovation',
      date: '29.-31. August 2025',
      location: 'Hamburg',
      description: 'Entwickle Lösungen für die Gesundheitsbranche und hilf dabei, Leben zu verbessern. Mentoring von führenden Health-Tech-Experten.',
      technologies: ['Health', 'Mobile', 'Data', 'UX/UI'],
      image: 'assets/hackathon4.jpg',
      isVirtual: false,
      organizerName: 'MedTech Innovation Hub',
    ),
    HackathonEvent(
      id: '5',
      title: 'DevOps Collaboration Hackathon',
      date: '5.-6. September 2025',
      location: 'Online',
      description: 'Verbessere die Zusammenarbeit zwischen Entwicklern und Operations mit automatisierten Workflows und Tools.',
      technologies: ['DevOps', 'Cloud', 'Automation', 'CI/CD'],
      image: 'assets/hackathon5.jpg',
      isVirtual: true,
      organizerName: 'Cloud Native Group',
    ),
  ];
  
  // Alle Hackathons abrufen
  List<HackathonEvent> getAllHackathons() {
    return List.from(_hackathons);
  }
  
  // Hackathons nach Suchkriterien filtern
  List<HackathonEvent> searchHackathons(String query) {
    if (query.isEmpty) {
      return List.from(_hackathons);
    }
    
    final searchLower = query.toLowerCase();
    return _hackathons.where((hackathon) =>
      hackathon.title.toLowerCase().contains(searchLower) ||
      hackathon.description.toLowerCase().contains(searchLower) ||
      hackathon.location.toLowerCase().contains(searchLower) ||
      hackathon.technologies.any((tech) => 
          tech.toLowerCase().contains(searchLower))
    ).toList();
  }
  
  // Nur virtuelle Hackathons abrufen
  List<HackathonEvent> getVirtualHackathons() {
    return _hackathons.where((hackathon) => hackathon.isVirtual).toList();
  }
  
  // Nur Vor-Ort-Hackathons abrufen
  List<HackathonEvent> getInPersonHackathons() {
    return _hackathons.where((hackathon) => !hackathon.isVirtual).toList();
  }
  
  // Hackathon nach ID abrufen
  HackathonEvent? getHackathonById(String id) {
    try {
      return _hackathons.firstWhere((hackathon) => hackathon.id == id);
    } catch (e) {
      return null;
    }
  }
}