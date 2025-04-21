import 'package:flutter/material.dart';

enum ReportType { 
  user,    // Zum Melden von Nutzern
  project, // Zum Melden von Projekten
  message  // Zum Melden von Chat-Nachrichten
}

class ReportDialog extends StatefulWidget {
  final String itemId; // ID des gemeldeten Elements (Nutzer, Projekt, Nachricht)
  final String itemName; // Name des Elements (z.B. Username, Projektname)
  final ReportType reportType;
  
  const ReportDialog({
    super.key,
    required this.itemId,
    required this.itemName,
    required this.reportType,
  });

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  String _selectedReason = '';
  final TextEditingController _detailsController = TextEditingController();
  bool _isSubmitting = false;
  
  // Vordefinierte Gründe für verschiedene Report-Typen
  final Map<ReportType, List<String>> _reportReasons = {
    ReportType.user: [
      'Fake-Profil',
      'Beleidigendes Verhalten',
      'Unangemessene Inhalte',
      'Spam',
      'Andere Richtlinienverletzung',
    ],
    ReportType.project: [
      'Betrug/Scam',
      'Unangemessene Inhalte',
      'Urheberrechtsverletzung',
      'Spam/Werbung',
      'Falsche Beschreibung',
    ],
    ReportType.message: [
      'Belästigung',
      'Hassrede',
      'Betrug/Scam',
      'Unangemessene Inhalte',
      'Spam',
    ],
  };

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  void _submitReport() {
    if (_selectedReason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bitte wähle einen Grund für die Meldung aus'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    setState(() {
      _isSubmitting = true;
    });
    
    // Hier würde normalerweise der API-Aufruf zum Melden erfolgen
    // Für Demo-Zwecke simulieren wir einen API-Aufruf mit Verzögerung
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isSubmitting = false;
      });
      
      // Dialog schließen und Erfolgsmeldung anzeigen
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vielen Dank für deine Meldung. Wir werden sie überprüfen.'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Titel basierend auf Report-Typ
    String title = '';
    switch (widget.reportType) {
      case ReportType.user:
        title = 'Nutzer melden';
        break;
      case ReportType.project:
        title = 'Projekt melden';
        break;
      case ReportType.message:
        title = 'Nachricht melden';
        break;
    }
    
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Du möchtest "${widget.itemName}" melden.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Grund der Meldung:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            
            // Liste der Gründe
            ...(_reportReasons[widget.reportType] ?? []).map((reason) => 
              RadioListTile<String>(
                title: Text(reason),
                value: reason,
                groupValue: _selectedReason,
                onChanged: (value) {
                  setState(() {
                    _selectedReason = value ?? '';
                  });
                },
                activeColor: Colors.blue,
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
            ),
            
            const SizedBox(height: 16),
            const Text(
              'Details (optional):',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _detailsController,
              decoration: const InputDecoration(
                hintText: 'Bitte gib weitere Details an...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            
            const SizedBox(height: 8),
            Text(
              'Hinweis: Deine Meldung wird vertraulich behandelt.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Abbrechen'),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submitReport,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: _isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text('Melden'),
        ),
      ],
    );
  }
}