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
              // Kleinerer Icon-Bereich
              Center(
                child: Container(
                  width: 80, // Reduziert von 120
                  height: 80, // Reduziert von 120
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.flag,
                      size: 40, // Reduziert von 60
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16), // Reduziert von 24
              
              const Text(
                'Was sind deine Ziele?',
                style: TextStyle(
                  fontSize: 18, // Reduziert von 20
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 4), // Reduziert von 8
              
              const Text(
                'Wähle die Ziele aus, die du mit deinen Projekten verfolgen möchtest.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14, // Reduziert von 16
                ),
              ),
              
              const SizedBox(height: 12), // Reduziert von 24
              
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
                      margin: const EdgeInsets.only(bottom: 8), // Reduziert von 12
                      elevation: isSelected ? 2 : 1, // Reduziert von 3
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Reduziert von 12
                        side: BorderSide(
                          color: isSelected ? Colors.blue : Colors.transparent,
                          width: 1.5, // Reduziert von 2
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
                        borderRadius: BorderRadius.circular(10), // Reduziert von 12
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), // Reduziert von 16
                          child: Row(
                            children: [
                              Container(
                                width: 36, // Reduziert von 48
                                height: 36, // Reduziert von 48
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(18), // Angepasst
                                ),
                                child: Icon(
                                  icon,
                                  color: isSelected ? Colors.blue : Colors.grey,
                                  size: 20, // Reduziert von 28
                                ),
                              ),
                              const SizedBox(width: 12), // Reduziert von 16
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15, // Reduziert von 16
                                        color: isSelected ? Colors.blue : Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 2), // Reduziert von 4
                                    Text(
                                      description,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 13, // Reduziert von 14
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Transform.scale(
                                scale: 0.9, // Checkbox etwas kleiner machen
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
              
              const SizedBox(height: 12), // Reduziert von 16
              
              // Eigenes Ziel
              TextFormField(
                controller: _customGoalController,
                decoration: const InputDecoration(
                  labelText: 'Eigenes Ziel (optional)',
                  border: OutlineInputBorder(),
                  hintText: 'Beschreibe dein eigenes Ziel...',
                  isDense: true, // Kompaktere Anzeige
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12), // Kompakter
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
                    color: index <= 4 ? Colors.blue : Colors.grey[300], // Korrigiert von 1 auf 4 für korrekte Anzeige
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