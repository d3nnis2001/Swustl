import 'package:flutter/material.dart';
import 'package:swustl/models/icebreaker_data.dart';
import 'package:swustl/views/messager/messageMain.dart';

class IcebreakerChatWidget extends StatelessWidget {
  final Match match;
  final Map<String, IcebreakerAnswer> userAnswers;
  final Map<String, IcebreakerAnswer> matchAnswers;
  final Function(String) onStartConversation;
  
  const IcebreakerChatWidget({
    super.key,
    required this.match,
    required this.userAnswers,
    required this.matchAnswers,
    required this.onStartConversation,
  });

  @override
  Widget build(BuildContext context) {
    // Finde gemeinsame Fragen, die beide beantwortet haben
    final Set<String> commonQuestionIds = 
        userAnswers.keys.toSet().intersection(matchAnswers.keys.toSet());
    
    if (commonQuestionIds.isEmpty) {
      return const SizedBox.shrink();
    }
    
    final icebreakerService = IcebreakerService();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              const Icon(Icons.lightbulb_outline, color: Colors.amber, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Gesprächsthemen',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(${commonQuestionIds.length})',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 140,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: commonQuestionIds.length,
            itemBuilder: (context, index) {
              final questionId = commonQuestionIds.elementAt(index);
              final question = icebreakerService.getQuestionById(questionId);
              final yourAnswer = userAnswers[questionId];
              final theirAnswer = matchAnswers[questionId];
              
              if (question == null || yourAnswer == null || theirAnswer == null) {
                return const SizedBox.shrink();
              }
              
              return Container(
                margin: const EdgeInsets.only(right: 12),
                width: 280,
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          question.question,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.person_outline, size: 14, color: Colors.blue),
                            const SizedBox(width: 4),
                            const Text(
                              'Du:',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                yourAnswer.answer,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.person_outline, size: 14, color: Colors.orange[700]),
                            const SizedBox(width: 4),
                            Text(
                              '${match.name}:',
                              style: TextStyle(
                                color: Colors.orange[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                theirAnswer.answer,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final messageStarter = _generateIcebreakerMessage(question, theirAnswer.answer);
                              onStartConversation(messageStarter);
                            },
                            icon: const Icon(Icons.chat_bubble_outline, size: 16),
                            label: const Text('Gespräch starten'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              textStyle: const TextStyle(fontSize: 12),
                            ),
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
      ],
    );
  }
  
  String _generateIcebreakerMessage(IcebreakerQuestion question, String theirAnswer) {
    final List<String> openers = [
      "Ich habe gesehen, dass du bei \"${question.question}\" geantwortet hast: \"${theirAnswer}\". Dazu würde ich gerne mehr erfahren!",
      "\"${theirAnswer}\" - Das fand ich interessant als Antwort auf \"${question.question}\". Was genau meinst du damit?",
      "Hey! Mir ist aufgefallen, dass du zu \"${question.question}\" eine ähnliche Meinung hast. Lass uns darüber sprechen!",
      "Deine Antwort \"${theirAnswer}\" auf die Frage \"${question.question}\" hat mich neugierig gemacht. Magst du mir mehr dazu erzählen?",
    ];
    
    // Zufällige Eröffnung wählen
    openers.shuffle();
    return openers.first;
  }
}