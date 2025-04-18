import 'package:flutter/material.dart';
import 'package:swustl/models/user_data.dart';

class WorkExperienceEditScreen extends StatefulWidget {
  final UserData userData;
  
  const WorkExperienceEditScreen({
    super.key, 
    required this.userData,
  });

  @override
  State<WorkExperienceEditScreen> createState() => _WorkExperienceEditScreenState();
}

class _WorkExperienceEditScreenState extends State<WorkExperienceEditScreen> {
  final _formKey = GlobalKey<FormState>();
  
  void _showWorkDialog({WorkExperience? workExperience}) {
    final TextEditingController companyController = TextEditingController(
      text: workExperience?.company ?? '',
    );
    final TextEditingController positionController = TextEditingController(
      text: workExperience?.position ?? '',
    );
    final TextEditingController descriptionController = TextEditingController(
      text: workExperience?.description ?? '',
    );
    
    bool isCurrentPosition = workExperience?.isCurrentPosition ?? false;
    
    DateTime? startDate = workExperience?.startDate;
    DateTime? endDate = workExperience?.endDate;
    
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(workExperience == null ? 'Berufserfahrung hinzufügen' : 'Berufserfahrung bearbeiten'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: companyController,
                      decoration: const InputDecoration(
                        labelText: 'Unternehmen *',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: positionController,
                      decoration: const InputDecoration(
                        labelText: 'Position *',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Tätigkeitsbeschreibung',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
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
                            onPressed: isCurrentPosition 
                                ? null 
                                : () async {
                                    final DateTime? picked = await showDatePicker(
                                      context: context,
                                      initialDate: endDate ?? DateTime.now(),
                                      firstDate: DateTime(1950),
                                      lastDate: DateTime.now(),
                                    );
                                    if (picked != null) {
                                      setState(() {
                                        endDate = picked;
                                      });
                                    }
                                  },
                            child: Text(
                              isCurrentPosition
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
                          value: isCurrentPosition,
                          onChanged: (value) {
                            setState(() {
                              isCurrentPosition = value ?? false;
                              if (isCurrentPosition) {
                                endDate = null;
                              }
                            });
                          },
                        ),
                        const Text('Aktuelle Position'),
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
                    if (companyController.text.isEmpty || positionController.text.isEmpty || startDate == null) {
                      // Zeige Fehler
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Bitte fülle alle Pflichtfelder aus'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    
                    final newWork = WorkExperience(
                      company: companyController.text,
                      position: positionController.text,
                      description: descriptionController.text,
                      startDate: startDate!,
                      endDate: isCurrentPosition ? null : endDate,
                      isCurrentPosition: isCurrentPosition,
                    );
                    
                    if (workExperience != null) {
                      // Update existing
                      setState(() {
                        final index = widget.userData.workExperience.indexOf(workExperience);
                        widget.userData.workExperience[index] = newWork;
                      });
                    } else {
                      // Add new
                      setState(() {
                        widget.userData.workExperience.add(newWork);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Berufserfahrung bearbeiten', style: TextStyle(color: Colors.black)),
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
                      Icons.work,
                      size: 40,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              const Text(
                'Berufserfahrung bearbeiten',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 8),
              
              const Text(
                'Teile deine berufliche Erfahrung, um anderen Projektteilnehmern zu zeigen, welche praktischen Kenntnisse du mitbringst.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 24),
              
              // Berufserfahrungsliste
              Expanded(
                child: widget.userData.workExperience.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.work_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Noch keine Berufserfahrung hinzugefügt',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: widget.userData.workExperience.length,
                        itemBuilder: (context, index) {
                          final work = widget.userData.workExperience[index];
                          return WorkCard(
                            work: work,
                            onDelete: () {
                              setState(() {
                                widget.userData.workExperience.removeAt(index);
                              });
                            },
                            onEdit: () {
                              _showWorkDialog(workExperience: work);
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
                    _showWorkDialog();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Berufserfahrung hinzufügen'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue, 
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.blue),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
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

class WorkCard extends StatelessWidget {
  final WorkExperience work;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  
  const WorkCard({
    super.key,
    required this.work,
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
                    work.company,
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
                            title: const Text('Berufserfahrung löschen'),
                            content: const Text('Bist du sicher, dass du diese Berufserfahrung löschen möchtest?'),
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
              work.position,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            if (work.description.isNotEmpty) ...[
              Text(
                work.description,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
            ],
            Text(
              work.isCurrentPosition
                  ? 'Von ${_formatDate(work.startDate)} bis Aktuell'
                  : 'Von ${_formatDate(work.startDate)} bis ${_formatDate(work.endDate!)}',
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