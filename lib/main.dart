import 'package:flutter/material.dart';
import 'package:swustl/views/messager/messageMain.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project Match',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.person, size: 28),
                    onPressed: () {
                      // Navigiere zum Profil
                    },
                  ),
                  Image.asset(
                    'assets/logo.png', 
                    height: 40,
                    // Platzhalter für Logo
                    errorBuilder: (context, error, stackTrace) => 
                      const Icon(Icons.handshake, size: 32, color: Colors.blue),
                  ),
                  IconButton(
                    icon: const Icon(Icons.message, size: 28),
                    onPressed: () {
                      // Navigiere zu Nachrichten
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MessagesPage(),
                        ),
                      );
                    },
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