import 'package:flutter/material.dart';
import 'package:swustl/models/user_data.dart';

class GoalsEditScreen extends StatefulWidget {
  final UserData userData;
  
  const GoalsEditScreen({
    super.key, 
    required this.userData,
  });

  @override
  State<GoalsEditScreen> createState() => _GoalsEditScreenState();
}

class _GoalsEditScreenState extends State<GoalsEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _customGoalController = TextEditingController();
  
  // Vordefinierte Ziele
  final List<Map<String, dynamic>> _predefinedGoals = [
    {
      'title': 'Neue Skills erlernen',
      'description': 'Ich möchte meine Fähigkeiten erweitern und neue Technologien erlernen.',
      'icon': Icons.school,
    },
    {
      'title': 'Portfolio erweitern',
      'description': 'Ich möchte Projekte für mein Portfolio sammeln, um meine beruflichen Chancen zu verbessern.',
      'icon': Icons.work,
    },
    {
      'title': 'Startup gründen',
      'description': 'Ich habe eine Geschäftsidee und möchte ein Startup aufbauen.',
      'icon': Icons.rocket_launch,
    },
    {
      'title': 'Networking',
      'description': 'Ich möchte andere Entwickler kennenlernen und mein berufliches Netzwerk erweitern.',
      'icon': Icons.people,
    },
    {
      'title': 'Nebenprojekt mit Einnahmen',
      'description': 'Ich möchte ein Nebenprojekt entwickeln, das Einnahmen generiert.',
      'icon': Icons.attach_money,
    },
    {
      'title': 'Spaß am Programmieren',
      'description': 'Ich programmiere aus Leidenschaft und möchte an interessanten Projekten arbeiten.',
      'icon': Icons.favorite,
    },
  ];
  
  @override
  void initState() {
    super.initState();
    _customGoalController.text = widget.userData.customGoal;
  }
  
  @override
  void dispose() {
    _customGoalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projektziele bearbeiten', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header mit Icon
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.flag,
                      size: 40,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              const Text(
                'Was sind deine Ziele?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 8),
              
              const Text(
                'Wähle die Ziele aus, die du mit deinen Projekten verfolgen möchtest.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 24),
              
              // Vorgegebene Ziele
              Expanded(
                child: ListView.builder(
                  itemCount: _predefinedGoals.length,
                  itemBuilder: (context, index) {
                    final goal = _predefinedGoals[index];
                    final title = goal['title'] as String;
                    final description = goal['description'] as String;
                    final icon = goal['icon'] as IconData;
                    
                    final isSelected = widget.userData.selectedGoals.contains(title);
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      elevation: isSelected ? 2 : 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: isSelected ? Colors.blue : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              widget.userData.selectedGoals.remove(title);
                            } else {
                              widget.userData.selectedGoals.add(title);
                            }
                          });
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Icon(
                                  icon,
                                  color: isSelected ? Colors.blue : Colors.grey,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: isSelected ? Colors.blue : Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      description,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Transform.scale(
                                scale: 0.9,
                                child: Checkbox(
                                  value: isSelected,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value!) {
                                        widget.userData.selectedGoals.add(title);
                                      } else {
                                        widget.userData.selectedGoals.remove(title);
                                      }
                                    });
                                  },
                                  activeColor: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Eigenes Ziel
              TextFormField(
                controller: _customGoalController,
                decoration: const InputDecoration(
                  labelText: 'Eigenes Ziel (optional)',
                  border: OutlineInputBorder(),
                  hintText: 'Beschreibe dein eigenes Ziel...',
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                maxLines: 2,
                onChanged: (value) {
                  widget.userData.customGoal = value;
                },
              ),
              
              const SizedBox(height: 16),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Eigenes Ziel speichern
                    widget.userData.customGoal = _customGoalController.text.trim();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Fertig',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}