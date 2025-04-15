import 'package:swustl/models/user_data.dart';

// Icebreaker-Fragen Modell für die App

class IcebreakerQuestion {
  final String id;
  final String question;
  final String category;
  final List<String> predefinedAnswers; // Optional: Vordefinierte Antworten
  final bool allowCustomAnswer; // Erlaubt benutzerdefinierte Antworten

  IcebreakerQuestion({
    required this.id,
    required this.question,
    required this.category,
    this.predefinedAnswers = const [],
    this.allowCustomAnswer = true,
  });
}

class IcebreakerAnswer {
  final String questionId;
  final String answer;
  final DateTime answeredAt;

  IcebreakerAnswer({
    required this.questionId,
    required this.answer,
    required this.answeredAt,
  });
}

// Icebreaker-Dienst zum Verwalten der Fragen
class IcebreakerService {
  // Singleton-Instanz
  static final IcebreakerService _instance = IcebreakerService._internal();
  factory IcebreakerService() => _instance;
  IcebreakerService._internal();

  // Vorgegebene Icebreaker-Fragen für Entwickler und Projektpartner
  final List<IcebreakerQuestion> _questions = [
    IcebreakerQuestion(
      id: 'tech_motivation',
      question: 'Was motiviert dich am meisten, an Tech-Projekten zu arbeiten?',
      category: 'Motivation',
      predefinedAnswers: [
        'Neue Technologien lernen',
        'Probleme lösen',
        'Ein fertiges Produkt erschaffen',
        'Mit anderen zusammenarbeiten',
        'Meine Karriere vorantreiben',
      ],
      allowCustomAnswer: true,
    ),
    IcebreakerQuestion(
      id: 'work_style',
      question: 'Wie würdest du deinen Arbeitsstil beschreiben?',
      category: 'Arbeitsweise',
      predefinedAnswers: [
        'Strukturiert und planorientiert',
        'Agil und flexibel',
        'Kreativ und experimentierfreudig',
        'Gründlich und detailorientiert',
        'Ergebnisorientiert und effizient',
      ],
      allowCustomAnswer: true,
    ),
    IcebreakerQuestion(
      id: 'learn_method',
      question: 'Wie lernst du am liebsten neue Technologien?',
      category: 'Lernmethoden',
      predefinedAnswers: [
        'Durch praktische Projekte',
        'Mit Kursen und Tutorials',
        'Durch Dokumentation lesen',
        'Von anderen Entwicklern lernen',
        'Experimentieren und Fehler machen',
      ],
      allowCustomAnswer: true,
    ),
    IcebreakerQuestion(
      id: 'collaboration',
      question: 'Was ist dir bei der Zusammenarbeit im Team am wichtigsten?',
      category: 'Zusammenarbeit',
      predefinedAnswers: [
        'Klare Kommunikation',
        'Regelmäßiges Feedback',
        'Autonomie und Vertrauen',
        'Gemeinsame Zielsetzung',
        'Gegenseitiger Respekt',
      ],
      allowCustomAnswer: true,
    ),
    IcebreakerQuestion(
      id: 'challenge',
      question: 'Welche Herausforderung würdest du gerne mit deinem nächsten Projekt meistern?',
      category: 'Herausforderungen',
      predefinedAnswers: [
        'Eine neue Programmiersprache lernen',
        'Eine komplexe Benutzeroberfläche gestalten',
        'Mit großen Datenmengen arbeiten',
        'Eine Idee von Grund auf umsetzen',
        'Ein Technologie-Problem lösen',
      ],
      allowCustomAnswer: true,
    ),
    IcebreakerQuestion(
      id: 'free_time',
      question: 'Was machst du in deiner Freizeit, wenn du nicht programmierst?',
      category: 'Persönliches',
      predefinedAnswers: [
        'Sport und Fitness',
        'Lesen und Lernen',
        'Reisen und Entdecken',
        'Gaming',
        'Zeit mit Freunden und Familie',
      ],
      allowCustomAnswer: true,
    ),
    IcebreakerQuestion(
      id: 'project_size',
      question: 'Welche Projektgröße bevorzugst du?',
      category: 'Projektpräferenzen',
      predefinedAnswers: [
        'Kleine, fokussierte Projekte',
        'Mittelgroße Teams und Projekte',
        'Große, komplexe Systeme',
        'Verschiedene Größen, je nach Aufgabe',
        'Proof-of-Concept und Experimente',
      ],
      allowCustomAnswer: true,
    ),
    IcebreakerQuestion(
      id: 'dev_philosophy',
      question: 'Was ist deine Entwicklungsphilosophie?',
      category: 'Philosophie',
      predefinedAnswers: [
        'Code-Qualität über Geschwindigkeit',
        'Funktionalität zuerst, dann optimieren',
        'Benutzerzentrierung über alles',
        'Testgetriebene Entwicklung',
        'Keep it simple, stupid (KISS)',
      ],
      allowCustomAnswer: true,
    ),
    IcebreakerQuestion(
      id: 'dream_project',
      question: 'Wenn du ein Traumprojekt starten könntest, worum würde es gehen?',
      category: 'Ziele',
      predefinedAnswers: [],
      allowCustomAnswer: true,
    ),
    IcebreakerQuestion(
      id: 'tech_inspiration',
      question: 'Welche Person oder Firma inspiriert dich in der Tech-Welt am meisten?',
      category: 'Inspiration',
      predefinedAnswers: [],
      allowCustomAnswer: true,
    ),
  ];

  // Fragen nach Kategorie filtern
  List<IcebreakerQuestion> getQuestionsByCategory(String category) {
    return _questions.where((q) => q.category == category).toList();
  }

  // Alle Fragen abrufen
  List<IcebreakerQuestion> getAllQuestions() {
    return List.from(_questions);
  }

  // Eine bestimmte Anzahl zufälliger Fragen abrufen
  List<IcebreakerQuestion> getRandomQuestions(int count) {
    if (count >= _questions.length) {
      return List.from(_questions);
    }
    
    final List<IcebreakerQuestion> shuffled = List.from(_questions)..shuffle();
    return shuffled.take(count).toList();
  }

  // Eine Frage anhand der ID abrufen
  IcebreakerQuestion? getQuestionById(String id) {
    try {
      return _questions.firstWhere((q) => q.id == id);
    } catch (e) {
      return null;
    }
  }

  // Alle Kategorien abrufen
  List<String> getAllCategories() {
    return _questions.map((q) => q.category).toSet().toList();
  }

  // Fragen, die noch nicht beantwortet wurden
  List<IcebreakerQuestion> getUnansweredQuestions(UserData userData) {
    return _questions.where((q) => 
      !userData.icebreakerAnswers.containsKey(q.id)).toList();
  }
}