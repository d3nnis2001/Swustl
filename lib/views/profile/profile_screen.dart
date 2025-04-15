import 'package:flutter/material.dart';
import 'package:swustl/models/user_data.dart';
import 'package:swustl/views/profile/icebreaker_screen.dart';
import 'package:swustl/widgets/icebreaker_widget.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  final UserData userData;
  final bool isOwnProfile;
  
  const ProfileScreen({
    super.key, 
    required this.userData,
    this.isOwnProfile = true,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isOwnProfile ? 'Mein Profil' : '${widget.userData.firstName} ${widget.userData.lastName}',
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          if (widget.isOwnProfile)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // Hier könnte man zur Profilbearbeitung navigieren
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profilkopf mit Bild und Grundinfo
            _buildProfileHeader(),
            
            // Tech Stack
            _buildTechStack(),
            
            // Icebreaker-Integration
            IcebreakerWidget(
              userData: widget.userData,
              showRandomUnanswered: widget.isOwnProfile, // Nur unbeantwortet zeigen, wenn es das eigene Profil ist
              showAllAnswered: true,
              maxAnswersToShow: 3,
              onAnswered: () {
                setState(() {}); // UI aktualisieren, wenn Änderungen vorgenommen wurden
              },
            ),
            
            // Ausbildung
            _buildEducation(),
            
            // Berufserfahrung
            _buildWorkExperience(),
            
            // Social Media Links
            _buildSocialLinks(),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
      floatingActionButton: widget.isOwnProfile ? FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => IcebreakerScreen(userData: widget.userData),
            ),
          ).then((_) {
            setState(() {}); // Aktualisiere die UI beim Zurückkehren
          });
        },
        label: const Text('Icebreaker'),
        icon: const Icon(Icons.lightbulb_outline),
        backgroundColor: Colors.blue,
      ) : null,
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profilbild
              CircleAvatar(
                radius: 50,
                backgroundImage: widget.userData.profileImagePath != null
                    ? FileImage(File(widget.userData.profileImagePath!))
                    : widget.userData.avatarPath != null
                        ? AssetImage(widget.userData.avatarPath!) as ImageProvider
                        : const AssetImage('assets/default_avatar.png'),
                child: widget.userData.profileImagePath == null && 
                      widget.userData.avatarPath == null ? 
                      const Icon(Icons.person, size: 50, color: Colors.grey) : null,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.userData.firstName} ${widget.userData.lastName}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (widget.userData.username.isNotEmpty)
                      Text(
                        '@${widget.userData.username}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    const SizedBox(height: 8),
                    if (widget.userData.birthYear != 0) ...[
                      Text(
                        'Alter: ${DateTime.now().year - widget.userData.birthYear}',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                    if (widget.userData.country.isNotEmpty) ...[
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            widget.userData.country,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                    ],
                    if (widget.userData.phoneNumber.isNotEmpty) ...[
                      Row(
                        children: [
                          const Icon(Icons.phone, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            widget.userData.phoneNumber,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (widget.userData.selectedGoals.isNotEmpty || widget.userData.customGoal.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Meine Ziele:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...widget.userData.selectedGoals.map((goal) => 
                  Chip(
                    label: Text(goal),
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    labelStyle: const TextStyle(color: Colors.blue),
                  ),
                ),
                if (widget.userData.customGoal.isNotEmpty)
                  Chip(
                    label: Text(widget.userData.customGoal),
                    backgroundColor: Colors.purple.withOpacity(0.1),
                    labelStyle: const TextStyle(color: Colors.purple),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTechStack() {
    if (widget.userData.techStack.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tech Stack',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.userData.techStack.map((tech) => 
              Chip(
                label: Text(tech.name),
                backgroundColor: _getTechColor(tech.category).withOpacity(0.1),
                labelStyle: TextStyle(color: _getTechColor(tech.category)),
              ),
            ).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEducation() {
    if (widget.userData.education.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ausbildung',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...widget.userData.education.map((edu) => 
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      edu.institution,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      edu.degree + (edu.fieldOfStudy.isNotEmpty ? ' - ${edu.fieldOfStudy}' : ''),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      edu.isEnrolled
                          ? 'Von ${edu.startDate.month}/${edu.startDate.year} bis Aktuell'
                          : 'Von ${edu.startDate.month}/${edu.startDate.year} bis ${edu.endDate!.month}/${edu.endDate!.year}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkExperience() {
    if (widget.userData.workExperience.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Berufserfahrung',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...widget.userData.workExperience.map((work) => 
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      work.company,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(work.position),
                    if (work.description.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        work.description,
                        style: TextStyle(color: Colors.grey[700], fontSize: 14),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      work.isCurrentPosition
                          ? 'Von ${work.startDate.month}/${work.startDate.year} bis Aktuell'
                          : 'Von ${work.startDate.month}/${work.startDate.year} bis ${work.endDate!.month}/${work.endDate!.year}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLinks() {
    final links = widget.userData.socialLinks.entries
        .where((entry) => entry.value.isNotEmpty)
        .toList();
    
    if (links.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Social Media & Links',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...links.map((entry) => 
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Icon(_getSocialIcon(entry.key), color: _getSocialColor(entry.key)),
                title: Text(_getSocialLabel(entry.key)),
                subtitle: Text(
                  entry.value,
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () {
                  // Hier könnte die URL geöffnet werden
                },
                dense: true,
              ),
            ),
          ),
        ],
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

  IconData _getSocialIcon(String platform) {
    switch (platform) {
      case 'github':
        return Icons.code;
      case 'linkedin':
        return Icons.work;
      case 'twitter':
        return Icons.chat;
      case 'portfolio':
        return Icons.language;
      case 'stackoverflow':
        return Icons.help;
      case 'medium':
        return Icons.article;
      default:
        return Icons.link;
    }
  }

  Color _getSocialColor(String platform) {
    switch (platform) {
      case 'github':
        return Colors.black87;
      case 'linkedin':
        return Colors.blue[800]!;
      case 'twitter':
        return Colors.blue;
      case 'portfolio':
        return Colors.purple;
      case 'stackoverflow':
        return Colors.orange;
      case 'medium':
        return Colors.black;
      default:
        return Colors.grey;
    }
  }

  String _getSocialLabel(String platform) {
    switch (platform) {
      case 'github':
        return 'GitHub';
      case 'linkedin':
        return 'LinkedIn';
      case 'twitter':
        return 'Twitter';
      case 'portfolio':
        return 'Portfolio';
      case 'stackoverflow':
        return 'Stack Overflow';
      case 'medium':
        return 'Medium';
      default:
        return platform;
    }
  }
}