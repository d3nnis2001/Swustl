import 'package:flutter/material.dart';
import 'package:swustl/models/user_data.dart';
import 'package:swustl/views/profile/edit/personal_info_edit.dart';
import 'package:swustl/views/profile/edit/education_edit.dart';
import 'package:swustl/views/profile/edit/work_experience_edit.dart';
import 'package:swustl/views/profile/edit/tech_stack_edit.dart';
import 'package:swustl/views/profile/edit/goals_edit.dart';
import 'package:swustl/views/profile/edit/social_links_edit.dart';

class ProfileEditScreen extends StatefulWidget {
  final UserData userData;
  
  const ProfileEditScreen({
    super.key, 
    required this.userData,
  });

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil bearbeiten', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        children: [
          _buildSection(
            title: 'Persönliche Informationen',
            icon: Icons.person,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PersonalInfoEditScreen(userData: widget.userData),
                ),
              ).then((_) => setState(() {}));
            },
          ),
          _buildSection(
            title: 'Ausbildung',
            icon: Icons.school,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EducationEditScreen(userData: widget.userData),
                ),
              ).then((_) => setState(() {}));
            },
          ),
          _buildSection(
            title: 'Berufserfahrung',
            icon: Icons.work,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkExperienceEditScreen(userData: widget.userData),
                ),
              ).then((_) => setState(() {}));
            },
          ),
          _buildSection(
            title: 'Tech Stack',
            icon: Icons.code,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TechStackEditScreen(userData: widget.userData),
                ),
              ).then((_) => setState(() {}));
            },
          ),
          _buildSection(
            title: 'Projektziele',
            icon: Icons.flag,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GoalsEditScreen(userData: widget.userData),
                ),
              ).then((_) => setState(() {}));
            },
          ),
          _buildSection(
            title: 'Social Media & Links',
            icon: Icons.link,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SocialLinksEditScreen(userData: widget.userData),
                ),
              ).then((_) => setState(() {}));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.blue),
        ),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}