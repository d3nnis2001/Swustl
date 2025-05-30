import 'package:flutter/material.dart';
import 'package:swustl/models/user_data.dart';
import 'package:swustl/views/registration/workReg.dart';

class RegistrationPage2 extends StatefulWidget {
  final UserData userData;
  
  const RegistrationPage2({
    super.key, 
    required this.userData,
  });

  @override
  State<RegistrationPage2> createState() => _RegistrationPage2State();
}

class _RegistrationPage2State extends State<RegistrationPage2> {
  final _formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ausbildung', style: TextStyle(color: Colors.black)),
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
                      Icons.school,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              const Text(
                'Ausbildung hinzufügen',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 8),
              
              const Text(
                'Trage deine Ausbildungsinformationen ein, damit andere Projektteilnehmer deinen Hintergrund besser verstehen können.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Ausbildungsliste
              Expanded(
                child: widget.userData.education.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.school_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Noch keine Ausbildung hinzugefügt',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: widget.userData.education.length,
                        itemBuilder: (context, index) {
                          final education = widget.userData.education[index];
                          return EducationCard(
                            education: education,
                            onDelete: () {
                              setState(() {
                                widget.userData.education.removeAt(index);
                              });
                            },
                            onEdit: () {
                              _showEducationDialog(education: education);
                            },
                          );
                        },
                      ),
              ),
              
              const SizedBox(height: 16),
              
              // Hinzufügen Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showEducationDialog();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Ausbildung hinzufügen'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue, backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.blue),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
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
                        builder: (context) => RegistrationPage3(userData: widget.userData),
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

  void _showEducationDialog({Education? education}) {
    final TextEditingController institutionController = TextEditingController(
      text: education?.institution ?? '',
    );
    final TextEditingController degreeController = TextEditingController(
      text: education?.degree ?? '',
    );
    final TextEditingController fieldOfStudyController = TextEditingController(
      text: education?.fieldOfStudy ?? '',
    );
    
    bool isEnrolled = education?.isEnrolled ?? false;
    
    DateTime? startDate = education?.startDate;
    DateTime? endDate = education?.endDate;
    
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(education == null ? 'Ausbildung hinzufügen' : 'Ausbildung bearbeiten'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: institutionController,
                      decoration: const InputDecoration(
                        labelText: 'Institution *',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: degreeController,
                      decoration: const InputDecoration(
                        labelText: 'Abschluss *',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: fieldOfStudyController,
                      decoration: const InputDecoration(
                        labelText: 'Studienrichtung',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        const Text('Von: '),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: startDate ?? DateTime.now(),
                                firstDate: DateTime(1950),
                                lastDate: DateTime.now(),
                              );
                              if (picked != null) {
                                setState(() {
                                  startDate = picked;
                                });
                              }
                            },
                            child: Text(
                              startDate != null
                                  ? '${startDate!.month}/${startDate!.year}'
                                  : 'Start-Datum',
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        const Text('Bis: '),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: isEnrolled 
                                ? null 
                                : () async {
                                    final DateTime? picked = await showDatePicker(
                                      context: context,
                                      initialDate: endDate ?? DateTime.now(),
                                      firstDate: DateTime(1950),
                                      lastDate: DateTime.now().add(const Duration(days: 3650)),
                                    );
                                    if (picked != null) {
                                      setState(() {
                                        endDate = picked;
                                      });
                                    }
                                  },
                            child: Text(
                              isEnrolled
                                  ? 'Aktuell'
                                  : endDate != null
                                      ? '${endDate!.month}/${endDate!.year}'
                                      : 'End-Datum',
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Checkbox(
                          value: isEnrolled,
                          onChanged: (value) {
                            setState(() {
                              isEnrolled = value ?? false;
                              if (isEnrolled) {
                                endDate = null;
                              }
                            });
                          },
                        ),
                        const Text('Aktuell eingeschrieben'),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Abbrechen'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (institutionController.text.isEmpty || degreeController.text.isEmpty || startDate == null) {
                      // Zeige Fehler
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Bitte fülle alle Pflichtfelder aus'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    
                    final newEducation = Education(
                      institution: institutionController.text,
                      degree: degreeController.text,
                      fieldOfStudy: fieldOfStudyController.text,
                      startDate: startDate!,
                      endDate: isEnrolled ? null : endDate,
                      isEnrolled: isEnrolled,
                    );
                    
                    if (education != null) {
                      // Update existing
                      setState(() {
                        final index = widget.userData.education.indexOf(education);
                        widget.userData.education[index] = newEducation;
                      });
                    } else {
                      // Add new
                      setState(() {
                        widget.userData.education.add(newEducation);
                      });
                    }
                    
                    Navigator.pop(context);
                  },
                  child: const Text('Speichern'),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      setState(() {});
    });
  }
}

class EducationCard extends StatelessWidget {
  final Education education;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  
  const EducationCard({
    super.key,
    required this.education,
    required this.onDelete,
    required this.onEdit,
  });
  
  String _formatDate(DateTime date) {
    return '${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    education.institution,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: onEdit,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Ausbildung löschen'),
                            content: const Text('Bist du sicher, dass du diese Ausbildung löschen möchtest?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Abbrechen'),
                              ),
                              TextButton(
                                onPressed: () {
                                  onDelete();
                                  Navigator.pop(context);
                                },
                                child: const Text('Löschen', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            Text(
              education.degree + (education.fieldOfStudy.isNotEmpty ? ' - ${education.fieldOfStudy}' : ''),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              education.isEnrolled
                  ? 'Von ${_formatDate(education.startDate)} bis Aktuell'
                  : 'Von ${_formatDate(education.startDate)} bis ${_formatDate(education.endDate!)}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}