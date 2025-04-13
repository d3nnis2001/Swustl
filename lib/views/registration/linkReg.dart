import 'package:flutter/material.dart';
import 'package:swustl/views/registration/goalsReg.dart';
import 'package:swustl/models/user_data.dart';

class RegistrationPage6 extends StatefulWidget {
  final UserData userData;
  
  const RegistrationPage6({
    super.key, 
    required this.userData,
  });

  @override
  State<RegistrationPage6> createState() => _RegistrationPage6State();
}

class _RegistrationPage6State extends State<RegistrationPage6> {
  final _formKey = GlobalKey<FormState>();
  
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, IconData> _socialIcons = {
    'github': Icons.code,
    'linkedin': Icons.work,
    'twitter': Icons.chat,
    'portfolio': Icons.language,
    'stackoverflow': Icons.help,
    'medium': Icons.article,
  };
  
  final Map<String, String> _socialLabels = {
    'github': 'GitHub',
    'linkedin': 'LinkedIn',
    'twitter': 'Twitter',
    'portfolio': 'Portfolio / Website',
    'stackoverflow': 'Stack Overflow',
    'medium': 'Medium',
  };
  
  final Map<String, String> _socialHints = {
    'github': 'https://github.com/deinbenutzername',
    'linkedin': 'https://linkedin.com/in/deinbenutzername',
    'twitter': 'https://twitter.com/deinbenutzername',
    'portfolio': 'https://deinewebsite.com',
    'stackoverflow': 'https://stackoverflow.com/users/123456',
    'medium': 'https://medium.com/@deinbenutzername',
  };
  
  @override
  void initState() {
    super.initState();
    // Controller für jedes Social Link-Feld erstellen und mit vorhandenen Daten befüllen
    widget.userData.socialLinks.forEach((key, value) {
      _controllers[key] = TextEditingController(text: value);
    });
  }
  
  @override
  void dispose() {
    // Alle Controller freigeben
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }
  
  bool _validateForm() {
    if (_formKey.currentState!.validate()) {
      // Speichere alle Links
      _controllers.forEach((key, controller) {
        widget.userData.socialLinks[key] = controller.text;
      });
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Links', style: TextStyle(color: Colors.black)),
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
                      Icons.link,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              const Text(
                'Social Media & Links',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 8),
              
              const Text(
                'Füge Links zu deinen Profilen hinzu, damit andere Projektteilnehmer mehr über dich erfahren können.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Social Links Formular
              Expanded(
                child: ListView.builder(
                  itemCount: _socialLabels.length,
                  itemBuilder: (context, index) {
                    final key = _socialLabels.keys.elementAt(index);
                    final label = _socialLabels[key];
                    final hint = _socialHints[key];
                    final icon = _socialIcons[key];
                    
                    // Stelle sicher, dass ein Controller für diesen Link existiert
                    if (!_controllers.containsKey(key)) {
                      _controllers[key] = TextEditingController(text: widget.userData.socialLinks[key] ?? '');
                    }
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextFormField(
                        controller: _controllers[key],
                        decoration: InputDecoration(
                          labelText: label,
                          border: const OutlineInputBorder(),
                          hintText: hint,
                          prefixIcon: Icon(icon),
                          suffixIcon: _controllers[key]!.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      _controllers[key]!.clear();
                                    });
                                  },
                                )
                              : null,
                        ),
                        keyboardType: TextInputType.url,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null; // Optional
                          }
                          
                          // Einfache URL-Validierung
                          if (!value.startsWith('http://') && !value.startsWith('https://')) {
                            return 'Bitte gib eine gültige URL mit http:// oder https:// ein';
                          }
                          
                          return null;
                        },
                      ),
                    );
                  },
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
                      color: index <= 5 ? Colors.blue : Colors.grey[300],
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
                      if (_validateForm()) {
                        // Hier kannst du die Registrierung abschließen
                        // z.B. Daten an die API senden oder zur Hauptseite navigieren
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Registrierung abgeschlossen'),
                            content: const Text('Dein Profil wurde erfolgreich erstellt!'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  // Hier zur Hauptseite oder Login navigieren
                                  Navigator.of(context).popUntil((route) => route.isFirst);
                                },
                                child: const Text('Zum Login'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Registrierung abschließen'),
                        SizedBox(width: 8),
                        Icon(Icons.check, size: 16),
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
}