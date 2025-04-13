import 'package:flutter/material.dart';
import 'package:swustl/views/registration/workReg.dart';
import 'package:swustl/views/registration/goalsReg.dart';
import 'package:swustl/models/user_data.dart';

class RegistrationPage4 extends StatefulWidget {
  final UserData userData;
  
  const RegistrationPage4({
    super.key, 
    required this.userData,
  });

  @override
  State<RegistrationPage4> createState() => _RegistrationPage4State();
}

class _RegistrationPage4State extends State<RegistrationPage4> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  
  // Vordefinierte Technologien nach Kategorien
  final Map<String, List<String>> _predefinedTech = {
    'Programmiersprachen': [
      'JavaScript', 'TypeScript', 'Python', 'Java', 'C#', 'C++', 
      'PHP', 'Ruby', 'Swift', 'Kotlin', 'Go', 'Rust', 'Dart'
    ],
    'Frontend': [
      'React', 'Angular', 'Vue.js', 'Svelte', 'Next.js', 'HTML', 
      'CSS', 'SASS/SCSS', 'Bootstrap', 'Tailwind CSS', 'Material UI'
    ],
    'Backend': [
      'Node.js', 'Express', 'Django', 'Flask', 'Spring Boot', 'Laravel', 
      'ASP.NET Core', 'Ruby on Rails', 'NestJS', 'FastAPI'
    ],
    'Mobile': [
      'Flutter', 'React Native', 'SwiftUI', 'Android SDK', 'Jetpack Compose', 
      'Xamarin', 'Ionic'
    ],
    'Datenbanken': [
      'MySQL', 'PostgreSQL', 'MongoDB', 'SQLite', 'Oracle', 
      'Microsoft SQL Server', 'Redis', 'Elasticsearch', 'Firebase'
    ],
    'DevOps & Tools': [
      'Git', 'Docker', 'Kubernetes', 'AWS', 'Azure', 'Google Cloud', 
      'Jenkins', 'GitHub Actions', 'GitLab CI', 'Terraform', 'Ansible'
    ],
    'Sonstiges': [
      'GraphQL', 'REST API', 'WebSockets', 'Machine Learning', 'TensorFlow', 
      'PyTorch', 'Blockchain', 'AR/VR', 'Unity', 'Unreal Engine'
    ],
  };
  
  List<TechItem> _getFilteredTech() {
    if (_searchQuery.isEmpty) {
      return [];
    }
    
    List<TechItem> result = [];
    _predefinedTech.forEach((category, techs) {
      for (var tech in techs) {
        if (tech.toLowerCase().contains(_searchQuery.toLowerCase())) {
          result.add(TechItem(
            name: tech,
            category: category,
            isCustom: false,
          ));
        }
      }
    });
    
    // Add option to create custom entry if no exact match found
    bool exactMatchFound = result.any((tech) => 
      tech.name.toLowerCase() == _searchQuery.toLowerCase()
    );
    
    if (!exactMatchFound && _searchQuery.length > 2) {
      result.add(TechItem(
        name: _searchQuery,
        category: 'Benutzerdefiniert',
        isCustom: true,
      ));
    }
    
    return result;
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<TechItem> filteredTech = _getFilteredTech();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tech Stack', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bildplatzhalter
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.code,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              const Text(
                'Tech Stack hinzufügen',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 8),
              
              const Text(
                'Füge die Technologien hinzu, mit denen du bereits gearbeitet hast oder die du in deinem Projekt einsetzen möchtest.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Search Bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Technologie suchen',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
              
              const SizedBox(height: 16),
              
              // Search Results
              if (_searchQuery.isNotEmpty)
                Expanded(
                  flex: 1,
                  child: Card(
                    elevation: 2,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredTech.length,
                      itemBuilder: (context, index) {
                        final tech = filteredTech[index];
                        return ListTile(
                          title: Text(tech.name),
                          subtitle: Text(tech.category),
                          trailing: tech.isCustom 
                              ? const Text('Neu erstellen', style: TextStyle(color: Colors.blue))
                              : null,
                          onTap: () {
                            // Check if already in the list
                            bool alreadyExists = widget.userData.techStack.any(
                              (item) => item.name.toLowerCase() == tech.name.toLowerCase()
                            );
                            
                            if (!alreadyExists) {
                              setState(() {
                                widget.userData.techStack.add(tech);
                                _searchController.clear();
                                _searchQuery = '';
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Diese Technologie wurde bereits hinzugefügt'),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
              
              // Selected Tech Stack
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      'Dein Tech Stack (${widget.userData.techStack.length})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    Expanded(
                      child: widget.userData.techStack.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.code_outlined,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Noch keine Technologien hinzugefügt',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: widget.userData.techStack.map((tech) {
                                return Chip(
                                  label: Text(tech.name),
                                  deleteIcon: const Icon(Icons.close, size: 16),
                                  onDeleted: () {
                                    setState(() {
                                      widget.userData.techStack.remove(tech);
                                    });
                                  },
                                  backgroundColor: _getTechColor(tech.category),
                                  labelStyle: const TextStyle(color: Colors.white),
                                );
                              }).toList(),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Progress Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  return Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: index <= 3 ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }),
              ),
              
              const SizedBox(height: 16),
              
              // Navigation Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black, backgroundColor: Colors.grey[200],
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back, size: 16),
                        SizedBox(width: 8),
                        Text('Zurück'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegistrationPage5(userData: widget.userData),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Weiter'),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Color _getTechColor(String category) {
    switch (category) {
      case 'Programmiersprachen':
        return Colors.blue;
      case 'Frontend':
        return Colors.green;
      case 'Backend':
        return Colors.purple;
      case 'Mobile':
        return Colors.orange;
      case 'Datenbanken':
        return Colors.red;
      case 'DevOps & Tools':
        return Colors.teal;
      case 'Benutzerdefiniert':
        return Colors.deepPurple;
      default:
        return Colors.grey;
    }
  }
}