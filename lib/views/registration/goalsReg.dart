import 'package:flutter/material.dart';
import 'package:swustl/views/registration/linkReg.dart';
import 'package:swustl/models/user_data.dart';

class RegistrationPage5 extends StatefulWidget {
  final UserData userData;
  
  const RegistrationPage5({
    super.key, 
    required this.userData,
  });

  @override
  State<RegistrationPage5> createState() => _RegistrationPage5State();
}

class _RegistrationPage5State extends State<RegistrationPage5> {
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
        title: const Text('Projektziele', style: TextStyle(color: Colors.black)),
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
                      Icons.flag,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              const Text(
                'Was sind deine Ziele?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 8),
              
              const Text(
                'Wähle die Ziele aus, die du mit deinen Projekten verfolgen möchtest. Du kannst mehrere auswählen.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
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
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: isSelected ? 3 : 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isSelected ? Colors.blue : Colors.transparent,
                          width: 2,
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
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Icon(
                                  icon,
                                  color: isSelected ? Colors.blue : Colors.grey,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: isSelected ? Colors.blue : Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      description,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Checkbox(
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
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Eigenes Ziel
              TextFormField(
                controller: _customGoalController,
                decoration: const InputDecoration(
                  labelText: 'Eigenes Ziel (optional)',
                  border: OutlineInputBorder(),
                  hintText: 'Beschreibe dein eigenes Ziel...',
                ),
                maxLines: 2,
                onChanged: (value) {
                  widget.userData.customGoal = value;
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
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
                    color: index <= 1 ? Colors.blue : Colors.grey[300],
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
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.grey[200],
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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
                    // Hier ist keine Validierung nötig, da Ausbildung optional ist
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegistrationPage6(userData: widget.userData),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
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
    );
  }
}