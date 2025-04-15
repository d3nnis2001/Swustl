import 'package:flutter/material.dart';
import 'package:swustl/models/user_data.dart';
import 'package:swustl/models/icebreaker_data.dart';
import 'package:swustl/views/profile/profile_screen.dart';

/// Widget zur Anzeige einer Vorschau des Profils mit Icebreaker-Fragen
/// Kann verwendet werden, um Projektdetails anzuzeigen
class ProfilePreviewWidget extends StatelessWidget {
  final String name;
  final int age;
  final String imageUrl;
  final List<String> techStack;
  final Map<String, IcebreakerAnswer> icebreakerAnswers;
  
  const ProfilePreviewWidget({
    super.key,
    required this.name,
    required this.age,
    required this.imageUrl,
    required this.techStack,
    required this.icebreakerAnswers,
  });

  @override
  Widget build(BuildContext context) {
    final IcebreakerService icebreakerService = IcebreakerService();
    
    // Finde bis zu 2 Icebreaker-Antworten, die angezeigt werden sollen
    List<MapEntry<IcebreakerQuestion, IcebreakerAnswer>> icebreakerToShow = [];
    
    if (icebreakerAnswers.isNotEmpty) {
      // Sortiere nach dem neuesten Zeitstempel
      final sortedAnswers = icebreakerAnswers.entries.toList()
        ..sort((a, b) => b.value.answeredAt.compareTo(a.value.answeredAt));
      
      // Hole die neuesten 2 Antworten
      for (var entry in sortedAnswers.take(2)) {
        final question = icebreakerService.getQuestionById(entry.key);
        if (question != null) {
          icebreakerToShow.add(MapEntry(question, entry.value));
        }
      }
    }
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header mit Profilbild und Namen
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(imageUrl),
                  onBackgroundImageError: (e, s) => const Icon(Icons.person),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$name, $age',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tech: ${techStack.take(3).join(", ")}${techStack.length > 3 ? "..." : ""}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Icebreaker-Antworten
          if (icebreakerToShow.isNotEmpty) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline, color: Colors.amber, size: 16),
                  const SizedBox(width: 8),
                  const Text(
                    'Icebreaker',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ...icebreakerToShow.map((entry) {
              final question = entry.key;
              final answer = entry.value;
              
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      question.question,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        answer.answer,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
          
          // Button zum Anzeigen des vollständigen Profils
          const Divider(height: 1),
          InkWell(
            onTap: () {
              // Erstelle ein temporäres UserData-Objekt für die Anzeige
              final userData = UserData()
                ..firstName = name.split(' ').first
                ..lastName = name.contains(' ') ? name.split(' ').last : ''
                ..birthYear = DateTime.now().year - age
                ..icebreakerAnswers = Map.from(icebreakerAnswers);
              
              // Techstack erstellen
              userData.techStack = techStack.map((tech) => 
                TechItem(name: tech, category: 'Technologie')).toList();
              
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    userData: userData,
                    isOwnProfile: false,
                  ),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.05),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: const Center(
                child: Text(
                  'Vollständiges Profil anzeigen',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}