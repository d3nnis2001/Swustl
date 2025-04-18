import 'package:flutter/material.dart';
import 'package:swustl/models/user_data.dart';

class SocialLinksEditScreen extends StatefulWidget {
  final UserData userData;
  
  const SocialLinksEditScreen({
    super.key, 
    required this.userData,
  });

  @override
  State<SocialLinksEditScreen> createState() => _SocialLinksEditScreenState();
}

class _SocialLinksEditScreenState extends State<SocialLinksEditScreen> {
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
        title: const Text('Social Links bearbeiten', style: TextStyle(color: Colors.black)),
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
                      Icons.link,
                      size: 40,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              const Text(
                'Social Media & Links',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 8),
              
              const Text(
                'Füge Links zu deinen Profilen hinzu, damit andere mehr über dich erfahren können.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
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
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: TextFormField(
                        controller: _controllers[key],
                        decoration: InputDecoration(
                          labelText: label,
                          border: const OutlineInputBorder(),
                          hintText: hint,
                          prefixIcon: Icon(icon),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                          suffixIcon: _controllers[key]!.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 18),
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
              
              const SizedBox(height: 16),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_validateForm()) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Social Links gespeichert'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
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