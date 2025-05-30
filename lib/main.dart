import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:swustl/views/messager/messageMain.dart';
import 'package:swustl/views/profile/profile_screen_updated.dart';
import 'package:swustl/models/user_data.dart';
import 'package:swustl/views/shared/report_dialog.dart';
import 'package:swustl/views/hackathon/hackathon_screen.dart';
import 'package:swustl/services/firebase/firebase_service.dart';
import 'package:swustl/services/firebase/firebase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /*
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: FirebaseConfig.currentPlatform,
    );
  } */
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TechMate',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MainNavigationScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Neue Hauptnavigationsklasse mit Bottom Navigation Bar
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  MainNavigationScreenState createState() => MainNavigationScreenState();
}

class MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  
  // Erstelle den UserData-Objekt, der im gesamten App geteilt wird
  final UserData userData = UserData();

  @override
  Widget build(BuildContext context) {
    // Liste der Screens für die Navigation
    final List<Widget> screens = [
      const HomePage(), // Projekt-Swipe (Home)
      const HackathonScreen(), // Hackathon-Suche
      const MessagesPage(), // Nachrichten
      ProfileScreen(userData: userData), // Profil
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Projekte',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event),
              label: 'Hackathons',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'Nachrichten',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int currentImageIndex = 0;
  void _showReportProjectDialog(BuildContext context, Project project) {
  showDialog(
    context: context,
    builder: (context) => ReportDialog(
      itemId: project.name, // Da wir keine eigentliche ID haben, verwenden wir den Namen
      itemName: "${project.name}'s Projekt: ${project.description}",
      reportType: ReportType.project,
    ),
  );
}
  final List<Project> projects = [
    Project(
      name: "Anna Schmidt",
      age: 28,
      description: "Suche Full-Stack Entwickler für E-Commerce App",
      techStack: ["Flutter", "Firebase", "Node.js", "React"],
      images: [
        "assets/project1_1.jpg",
        "assets/project1_2.jpg",
        "assets/project1_3.jpg",
      ],
    ),
    Project(
      name: "Thomas Weber",
      age: 32,
      description: "KI-basierte Finanzanalyse-App für Studenten",
      techStack: ["Python", "TensorFlow", "AWS", "Flutter"],
      images: [
        "assets/project2_1.jpg",
        "assets/project2_2.jpg",
      ],
    ),
    Project(
      name: "Julia Becker",
      age: 25,
      description: "Nachhaltigkeits-Tracking für lokale Unternehmen",
      techStack: ["React Native", "GraphQL", "MongoDB", "Express"],
      images: [
        "assets/project3_1.jpg",
        "assets/project3_2.jpg",
        "assets/project3_3.jpg",
      ],
    ),
  ];

  int currentProjectIndex = 0;
  
  void nextImage() {
    setState(() {
      if (currentImageIndex < projects[currentProjectIndex].images.length - 1) {
        currentImageIndex++;
      }
    });
  }

  void previousImage() {
    setState(() {
      if (currentImageIndex > 0) {
        currentImageIndex--;
      }
    });
  }

  void nextProject() {
    setState(() {
      if (currentProjectIndex < projects.length - 1) {
        currentProjectIndex++;
        currentImageIndex = 0;
      }
    });
  }

  void rejectProject() {
    // Hier könnte später Logik zum Ablehnen hinzugefügt werden
    nextProject();
  }

  void acceptProject() {
    // Hier könnte später Logik zum Annehmen/Matchen hinzugefügt werden
    nextProject();
  }

  @override
  Widget build(BuildContext context) {
    final Project currentProject = projects[currentProjectIndex];
    
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo.png', 
                    height: 40,
                    // Platzhalter für Logo
                    errorBuilder: (context, error, stackTrace) => 
                      const Icon(Icons.handshake, size: 32, color: Colors.blue),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 10),
            
            // Main Project Card
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Stack(
                    children: [
                      // Project Image with Swipe Detection
                      GestureDetector(
                        onHorizontalDragEnd: (details) {
                          if (details.primaryVelocity! > 0) {
                            // Swipe nach rechts
                            previousImage();
                          } else if (details.primaryVelocity! < 0) {
                            // Swipe nach links
                            nextImage();
                          }
                        },
                        child: Stack(
                          children: [
                            // Image Container
                            Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.grey[300],
                              child: Image.asset(
                                currentProject.images[currentImageIndex],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => 
                                  Center(child: Icon(Icons.image, size: 80, color: Colors.grey[600])),
                              ),
                            ),
                            
                            // Left tap area for previous image
                            Positioned(
                              left: 0,
                              top: 0,
                              bottom: 0,
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: GestureDetector(
                                onTap: previousImage,
                                child: Container(color: Colors.transparent),
                              ),
                            ),
                            
                            // Right tap area for next image
                            Positioned(
                              right: 0,
                              top: 0,
                              bottom: 0,
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: GestureDetector(
                                onTap: nextImage,
                                child: Container(color: Colors.transparent),
                              ),
                            ),
                            
                            // Image indicator dots
                            Positioned(
                              bottom: 16,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  currentProject.images.length, 
                                  (index) => Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: index == currentImageIndex 
                                          ? Colors.white 
                                          : Colors.white.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Project Info Overlay
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.7),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              currentProject.name,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              "${currentProject.age}",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 22,
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Neuer Report-Button
                                        IconButton(
                                          icon: const Icon(Icons.more_vert, color: Colors.white),
                                          onPressed: () {
                                            showModalBottomSheet(
                                              context: context,
                                              shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                              ),
                                              builder: (context) => Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ListTile(
                                                    leading: const Icon(Icons.flag, color: Colors.red),
                                                    title: const Text('Projekt melden'),
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      _showReportProjectDialog(context, currentProject);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      currentProject.description,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Tech Stack
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tech Stack:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: currentProject.techStack.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: TechStackItem(tech: currentProject.techStack[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            
            // Action Buttons
            Padding(
              padding: const EdgeInsets.only(left: 32.0, right: 32.0, bottom: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: rejectProject,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.red,
                      elevation: 5,
                    ),
                    child: const Icon(Icons.close, size: 30),
                  ),
                  ElevatedButton(
                    onPressed: acceptProject,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      elevation: 5,
                    ),
                    child: const Icon(Icons.check, size: 30),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TechStackItem extends StatelessWidget {
  final String tech;
  
  const TechStackItem({super.key, required this.tech});
  
  IconData getIconForTech(String tech) {
    switch (tech.toLowerCase()) {
      case 'flutter':
        return Icons.flutter_dash;
      case 'firebase':
        return Icons.local_fire_department;
      case 'react':
      case 'react native':
        return Icons.code;
      case 'node.js':
        return Icons.settings;
      case 'python':
        return Icons.code;
      case 'tensorflow':
        return Icons.memory;
      case 'aws':
        return Icons.cloud;
      case 'graphql':
        return Icons.public;
      case 'mongodb':
        return Icons.storage;
      case 'express':
        return Icons.web;
      default:
        return Icons.developer_mode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(getIconForTech(tech), size: 18),
          const SizedBox(width: 4),
          Text(
            tech,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class Project {
  final String name;
  final int age;
  final String description;
  final List<String> techStack;
  final List<String> images;

  Project({
    required this.name,
    required this.age,
    required this.description,
    required this.techStack,
    required this.images,
  });
}