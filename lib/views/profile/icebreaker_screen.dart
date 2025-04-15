import 'package:flutter/material.dart';
import 'package:swustl/models/user_data.dart';
import 'package:swustl/models/icebreaker_data.dart';

class IcebreakerScreen extends StatefulWidget {
  final UserData userData;
  
  const IcebreakerScreen({
    super.key, 
    required this.userData,
  });

  @override
  State<IcebreakerScreen> createState() => _IcebreakerScreenState();
}

class _IcebreakerScreenState extends State<IcebreakerScreen> {
  final IcebreakerService _icebreakerService = IcebreakerService();
  final TextEditingController _customAnswerController = TextEditingController();
  
  List<IcebreakerQuestion> _allQuestions = [];
  List<IcebreakerQuestion> _displayedQuestions = [];
  String _selectedCategory = 'Alle';
  bool _showOnlyUnanswered = false;
  
  @override
  void initState() {
    super.initState();
    _allQuestions = _icebreakerService.getAllQuestions();
    _updateDisplayedQuestions();
  }
  
  @override
  void dispose() {
    _customAnswerController.dispose();
    super.dispose();
  }
  
  void _updateDisplayedQuestions() {
    setState(() {
      if (_selectedCategory == 'Alle') {
        _displayedQuestions = List.from(_allQuestions);
      } else {
        _displayedQuestions = _icebreakerService.getQuestionsByCategory(_selectedCategory);
      }
      
      if (_showOnlyUnanswered) {
        _displayedQuestions = _displayedQuestions.where((q) => 
            !widget.userData.hasAnsweredQuestion(q.id)).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> categories = ['Alle', ..._icebreakerService.getAllCategories()];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Icebreaker Fragen', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          // Filter-Button
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterOptions(context, categories);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header-Bereich mit Erklärung
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.withOpacity(0.1),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.lightbulb_outline, color: Colors.blue),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Beantworte diese Fragen, um bessere Projektmatches zu finden!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Deine Antworten helfen anderen, dich besser kennenzulernen und sind auch ein guter Gesprächseinstieg.',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Kategorie: $_selectedCategory',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    Row(
                      children: [
                        const Text('Nur unbeantwortete'),
                        Switch(
                          value: _showOnlyUnanswered,
                          onChanged: (value) {
                            setState(() {
                              _showOnlyUnanswered = value;
                              _updateDisplayedQuestions();
                            });
                          },
                          activeColor: Colors.blue,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Liste der Icebreaker-Fragen
          Expanded(
            child: _displayedQuestions.isEmpty
                ? const Center(
                    child: Text(
                      'Keine unbeantworteten Fragen mehr!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _displayedQuestions.length,
                    itemBuilder: (context, index) {
                      final question = _displayedQuestions[index];
                      final hasAnswer = widget.userData.hasAnsweredQuestion(question.id);
                      final answer = widget.userData.getAnswer(question.id);
                      
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: hasAnswer ? Colors.blue.withOpacity(0.5) : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Frage und Kategorie
                            ListTile(
                              title: Text(
                                question.question,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(
                                'Kategorie: ${question.category}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              trailing: hasAnswer
                                  ? IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () {
                                        _showAnswerDialog(question, initialAnswer: answer?.answer);
                                      },
                                    )
                                  : IconButton(
                                      icon: const Icon(Icons.add_circle_outline, color: Colors.grey),
                                      onPressed: () {
                                        _showAnswerDialog(question);
                                      },
                                    ),
                            ),
                            
                            // Antwort anzeigen, falls vorhanden
                            if (hasAnswer)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Deine Antwort:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              answer?.answer ?? '',
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                                            onPressed: () {
                                              _confirmDeleteAnswer(question.id);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                            // Vordefinierte Antworten, wenn keine eigene Antwort existiert
                            if (!hasAnswer && question.predefinedAnswers.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Antwortvorschläge:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: question.predefinedAnswers.map((answer) => 
                                        InkWell(
                                          onTap: () {
                                            _saveAnswer(question.id, answer);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius: BorderRadius.circular(16),
                                              border: Border.all(color: Colors.grey.shade300),
                                            ),
                                            child: Text(
                                              answer,
                                              style: const TextStyle(fontSize: 13),
                                            ),
                                          ),
                                        ),
                                      ).toList(),
                                    ),
                                    if (question.allowCustomAnswer) ...[
                                      const SizedBox(height: 8),
                                      OutlinedButton.icon(
                                        onPressed: () {
                                          _showAnswerDialog(question);
                                        },
                                        icon: const Icon(Icons.edit, size: 16),
                                        label: const Text('Eigene Antwort'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      // Schwebende Action-Button zum zufälligen Beantworten einer Frage
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showRandomQuestion();
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.shuffle),
      ),
    );
  }
  
  void _showFilterOptions(BuildContext context, List<String> categories) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filter',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Kategorie',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: categories.map((category) => 
                      ChoiceChip(
                        label: Text(category),
                        selected: _selectedCategory == category,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          }
                        },
                        selectedColor: Colors.blue.withOpacity(0.2),
                      ),
                    ).toList(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text(
                        'Nur unbeantwortete Fragen',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Switch(
                        value: _showOnlyUnanswered,
                        onChanged: (value) {
                          setState(() {
                            _showOnlyUnanswered = value;
                          });
                        },
                        activeColor: Colors.blue,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _updateDisplayedQuestions();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Filter anwenden',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }
  
  void _showRandomQuestion() {
    // Hole unbeantwortet Fragen
    final unansweredQuestions = _icebreakerService.getUnansweredQuestions(widget.userData);
    
    if (unansweredQuestions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Du hast bereits alle Fragen beantwortet!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    // Wähle eine zufällige Frage
    unansweredQuestions.shuffle();
    final randomQuestion = unansweredQuestions.first;
    
    // Zeige Dialog zum Beantworten
    _showAnswerDialog(randomQuestion);
  }
  
  void _saveAnswer(String questionId, String answer) {
    setState(() {
      widget.userData.answerIcebreaker(questionId, answer);
      _updateDisplayedQuestions();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Antwort gespeichert!'),
        backgroundColor: Colors.green,
      ),
    );
  }
  
  void _confirmDeleteAnswer(String questionId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Antwort löschen'),
        content: const Text('Möchtest du deine Antwort wirklich löschen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                widget.userData.removeIcebreakerAnswer(questionId);
                _updateDisplayedQuestions();
              });
            },
            child: const Text('Löschen', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
  
  void _showAnswerDialog(IcebreakerQuestion question, {String? initialAnswer}) {
    // Setze den Controller-Text, falls eine initiale Antwort vorhanden ist
    _customAnswerController.text = initialAnswer ?? '';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Frage beantworten'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.question,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _customAnswerController,
              decoration: const InputDecoration(
                labelText: 'Deine Antwort',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              maxLength: 200,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _customAnswerController.clear();
            },
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () {
              final answer = _customAnswerController.text.trim();
              if (answer.isNotEmpty) {
                Navigator.pop(context);
                _saveAnswer(question.id, answer);
                _customAnswerController.clear();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: const Text('Speichern'),
          ),
        ],
      ),
    );
  }
}