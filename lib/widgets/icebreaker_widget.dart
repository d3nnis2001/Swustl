import 'package:flutter/material.dart';
import 'package:swustl/models/user_data.dart';
import 'package:swustl/models/icebreaker_data.dart';
import 'package:swustl/views/profile/icebreaker_screen.dart';

class IcebreakerWidget extends StatelessWidget {
  final UserData userData;
  final VoidCallback? onAnswered;
  final bool showRandomUnanswered;
  final bool showAllAnswered;
  final int maxAnswersToShow;
  
  const IcebreakerWidget({
    super.key,
    required this.userData,
    this.onAnswered,
    this.showRandomUnanswered = true,
    this.showAllAnswered = false,
    this.maxAnswersToShow = 3,
  });

  @override
  Widget build(BuildContext context) {
    final IcebreakerService icebreakerService = IcebreakerService();
    final Map<String, IcebreakerAnswer> userAnswers = userData.icebreakerAnswers;
    
    // Für die Anzeige
    List<Widget> icebreakerWidgets = [];
    
    // Bereits beantwortete Fragen anzeigen
    if (showAllAnswered && userAnswers.isNotEmpty) {
      // Sortiere nach dem neuesten Zeitstempel
      final sortedAnswers = userAnswers.values.toList()
        ..sort((a, b) => b.answeredAt.compareTo(a.answeredAt));
      
      // Begrenze auf die maximale Anzahl
      final answersToShow = sortedAnswers.take(maxAnswersToShow).toList();
      
      for (var answer in answersToShow) {
        final question = icebreakerService.getQuestionById(answer.questionId);
        if (question != null) {
          icebreakerWidgets.add(
            _buildAnsweredIcebreakerCard(context, question, answer),
          );
        }
      }
    }
    
    // Eine unbeantwortete Frage anzeigen, wenn gewünscht
    if (showRandomUnanswered) {
      final unansweredQuestions = icebreakerService.getUnansweredQuestions(userData);
      if (unansweredQuestions.isNotEmpty) {
        unansweredQuestions.shuffle();
        final randomQuestion = unansweredQuestions.first;
        
        icebreakerWidgets.add(
          _buildUnansweredIcebreakerCard(context, randomQuestion),
        );
      }
    }
    
    if (icebreakerWidgets.isEmpty) {
      return const SizedBox.shrink(); // Widget nicht anzeigen, wenn keine Icebreaker verfügbar sind
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.lightbulb_outline, color: Colors.amber),
                  const SizedBox(width: 8),
                  const Text(
                    'Icebreaker',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IcebreakerScreen(userData: userData),
                    ),
                  );
                },
                child: const Text('Alle anzeigen'),
              ),
            ],
          ),
        ),
        ...icebreakerWidgets,
      ],
    );
  }
  
  Widget _buildAnsweredIcebreakerCard(
    BuildContext context,
    IcebreakerQuestion question,
    IcebreakerAnswer answer,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.question_answer, color: Colors.blue, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question.question,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          answer.answer,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
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
  
  Widget _buildUnansweredIcebreakerCard(
    BuildContext context,
    IcebreakerQuestion question,
  ) {
    final TextEditingController answerController = TextEditingController();
    
    void saveAnswer(String answer) {
      userData.answerIcebreaker(question.id, answer);
      if (onAnswered != null) {
        onAnswered!();
      }
    }
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.orange.withOpacity(0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.lightbulb_outline, color: Colors.orange, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    question.question,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (question.predefinedAnswers.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: question.predefinedAnswers.map((predefinedAnswer) => 
                  InkWell(
                    onTap: () {
                      saveAnswer(predefinedAnswer);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        predefinedAnswer,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                ).toList(),
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: answerController,
                    decoration: const InputDecoration(
                      hintText: 'Deine Antwort...',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        saveAnswer(value);
                        answerController.clear();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final answer = answerController.text.trim();
                    if (answer.isNotEmpty) {
                      saveAnswer(answer);
                      answerController.clear();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Senden'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}