import 'package:flutter/material.dart';
import 'package:swustl/main.dart';
import 'package:flutter/services.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:swustl/views/shared/report_dialog.dart';  

class Message {
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime timestamp;
  final bool isCode;
  final String language;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
    this.isCode = false,
    this.language = 'dart',
  });
}

class Match {
  final String id;
  final String name;
  final int age;
  final String imageUrl;
  final String lastMessage;
  final DateTime lastMessageTime;
  final List<String> techStack;
  final String description;
  
  Match({
    required this.id,
    required this.name,
    required this.age,
    required this.imageUrl,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.techStack,
    required this.description,
  });
}

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  MessagesPageState createState() => MessagesPageState();
}

class MessagesPageState extends State<MessagesPage> {
  // Beispiel-Daten für Matches
  final List<Match> matches = [
    Match(
      id: '1',
      name: 'Anna Schmidt',
      age: 28,
      imageUrl: 'assets/project1_1.jpg',
      lastMessage: 'Ich könnte dir bei deinem Flutter-Teil helfen.',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
      techStack: ["Flutter", "Firebase", "Node.js", "React"],
      description: "Suche Full-Stack Entwickler für E-Commerce App",
    ),
    Match(
      id: '2',
      name: 'Thomas Weber',
      age: 32,
      imageUrl: 'assets/project2_1.jpg',
      lastMessage: 'Wann passt es dir, über das Projekt zu sprechen?',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
      techStack: ["Python", "TensorFlow", "AWS", "Flutter"],
      description: "KI-basierte Finanzanalyse-App für Studenten",
    ),
    Match(
      id: '3',
      name: 'Julia Becker',
      age: 25,
      imageUrl: 'assets/project3_1.jpg',
      lastMessage: 'Danke für dein Interesse an meinem Projekt!',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
      techStack: ["React Native", "GraphQL", "MongoDB", "Express"],
      description: "Nachhaltigkeits-Tracking für lokale Unternehmen",
    ),
  ];

  String formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'jetzt';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matches', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: matches.isEmpty
          ? const Center(
              child: Text(
                'Noch keine Matches',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: matches.length,
              itemBuilder: (context, index) {
                final match = matches[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(match: match),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade200, width: 1),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Profilbild
                        Hero(
                          tag: 'profile-${match.id}',
                          child: CircleAvatar(
                            radius: 28,
                            backgroundImage: AssetImage(match.imageUrl),
                            onBackgroundImageError: (e, s) => const Icon(Icons.person),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Name und letzte Nachricht
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${match.name}, ${match.age}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    formatTime(match.lastMessageTime),
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                match.lastMessage,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class ChatPage extends StatefulWidget {
  final Match match;
  
  const ChatPage({super.key, required this.match});

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final String currentUserId = 'currentUser';
  bool _isCodeMessage = false;
  String _selectedLanguage = 'dart'; 
  
  void _showReportDialog(BuildContext context) {
    final match = widget.match;
    
    showDialog(
      context: context,
      builder: (context) => ReportDialog(
        itemId: match.id,
        itemName: match.name,
        reportType: ReportType.user,
      ),
    );
  }
  void _reportMessage(Message message) {
    showDialog(
      context: context,
      builder: (context) => ReportDialog(
        itemId: "${message.senderId}_${message.timestamp.toString()}", // Pseudo ID für die Nachricht
        itemName: message.text.length > 25 ? "${message.text.substring(0, 25)}..." : message.text,
        reportType: ReportType.message,
      ),
    );
  }


  final List<String> _supportedLanguages = [
    'dart', 'javascript', 'python', 'java', 'c', 'cpp', 'csharp',
  ];
  
  List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    
    // Füge Beispiel-Nachrichten hinzu
    final now = DateTime.now();
    
    messages = [
      Message(
        senderId: widget.match.id,
        receiverId: currentUserId,
        text: 'Hallo! Danke für dein Match.',
        timestamp: now.subtract(const Duration(hours: 2)),
      ),
      Message(
        senderId: currentUserId,
        receiverId: widget.match.id,
        text: 'Hi! Dein Projekt klingt spannend. Wie weit bist du schon?',
        timestamp: now.subtract(const Duration(hours: 1, minutes: 50)),
      ),
      Message(
        senderId: widget.match.id,
        receiverId: currentUserId,
        text: 'Ich habe bereits einen Prototyp, aber brauche Hilfe bei der Skalierung.',
        timestamp: now.subtract(const Duration(hours: 1, minutes: 45)),
      ),
      Message(
        senderId: currentUserId,
        receiverId: widget.match.id,
        text: 'Da kann ich definitiv helfen. Ich habe Erfahrung mit ähnlichen Projekten.',
        timestamp: now.subtract(const Duration(hours: 1, minutes: 30)),
      ),
      Message(
        senderId: widget.match.id,
        receiverId: currentUserId,
        text: 'Hier ist ein Beispiel für die Architektur:',
        timestamp: now.subtract(const Duration(minutes: 20)),
      ),
      Message(
        senderId: widget.match.id,
        receiverId: currentUserId,
        text: '''class ApiService {
  final String baseUrl;
  final http.Client client;
  
  ApiService({required this.baseUrl, http.Client? client})
      : client = client ?? http.Client();
      
  Future<List<Product>> getProducts() async {
    final response = await client.get(Uri.parse('\$baseUrl/products'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}''',
        timestamp: now.subtract(const Duration(minutes: 15)),
        isCode: true,
        language: 'dart',
      ),
      Message(
        senderId: widget.match.id,
        receiverId: currentUserId,
        text: widget.match.lastMessage,
        timestamp: widget.match.lastMessageTime,
      ),
    ];
    
    // Scrolle automatisch zum Ende des Chats
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      messages.add(
        Message(
          senderId: currentUserId,
          receiverId: widget.match.id,
          text: _messageController.text.trim(),
          timestamp: DateTime.now(),
          isCode: _isCodeMessage,
          language: _selectedLanguage,
        ),
      );
      // Nach dem Senden einer Nachricht zurück zum normalen Textmodus
      _isCodeMessage = false;
    });

    _messageController.clear();
    _scrollToBottom();
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: InkWell(
          onTap: () {
            _showProfileModal(context);
          },
          child: Row(
            children: [
              Hero(
                tag: 'profile-${widget.match.id}',
                child: CircleAvatar(
                  backgroundImage: AssetImage(widget.match.imageUrl),
                  radius: 18,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${widget.match.name}, ${widget.match.age}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.flag_outlined),
            onPressed: () {
              _showReportDialog(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showProfileModal(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat-Verlauf
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isCurrentUser = message.senderId == currentUserId;
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: isCurrentUser 
                        ? MainAxisAlignment.end 
                        : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isCurrentUser) ...[
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: AssetImage(widget.match.imageUrl),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Container(
                          padding: message.isCode 
                              ? const EdgeInsets.all(2)  // Weniger Padding für Code
                              : const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: message.isCode
                                ? Colors.grey.shade900
                                : isCurrentUser 
                                    ? Colors.blue 
                                    : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (message.isCode) ...[
                                // Code-Nachricht mit Syntax-Highlighting
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: SyntaxView(
                                        code: message.text,
                                        syntax: _getSyntaxForLanguage(message.language),
                                        syntaxTheme: SyntaxTheme.dracula(),
                                        fontSize: 12.0,
                                        withZoom: false,
                                        withLinesCount: true,
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade800,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              message.language.toUpperCase(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          InkWell(
                                            onTap: () {
                                              Clipboard.setData(ClipboardData(text: message.text));
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Code in die Zwischenablage kopiert'),
                                                  duration: Duration(seconds: 2),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade800,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.copy,
                                                color: Colors.white,
                                                size: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ] else
                                // Normale Textnachricht
                                Text(
                                  message.text,
                                  style: TextStyle(
                                    color: isCurrentUser ? Colors.white : Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                              const SizedBox(height: 2),
                              Text(
                                _formatTimestamp(message.timestamp),
                                style: TextStyle(
                                  color: message.isCode 
                                      ? Colors.grey
                                      : isCurrentUser 
                                          ? Colors.white.withOpacity(0.7) 
                                          : Colors.black54,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isCurrentUser) const SizedBox(width: 4),
                    ],
                  ),
                );
              },
            ),
          ),
          
          // Code-Modus Anzeige
          if (_isCodeMessage)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.grey.shade900,
              child: Row(
                children: [
                  const Icon(
                    Icons.code,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Code-Modus: $_selectedLanguage',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  // Dropdown für Sprache
                  DropdownButton<String>(
                    value: _selectedLanguage,
                    dropdownColor: Colors.grey.shade800,
                    underline: Container(),
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedLanguage = newValue;
                        });
                      }
                    },
                    items: _supportedLanguages
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _isCodeMessage = false;
                      });
                    },
                  ),
                ],
              ),
            ),
          
          // Nachrichteneingabe
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, -1),
                  blurRadius: 5,
                  color: Colors.grey.withOpacity(0.1),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Code-Toggle-Button
                  IconButton(
                    icon: Icon(
                      Icons.code,
                      color: _isCodeMessage 
                          ? Colors.blue
                          : Colors.grey.shade600,
                    ),
                    onPressed: () {
                      setState(() {
                        _isCodeMessage = !_isCodeMessage;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.attachment_outlined),
                    color: Colors.grey.shade600,
                    onPressed: () {
                      // Implementiere Dateianhänge
                    },
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: _isCodeMessage
                              ? 'Code hier eingeben...'
                              : 'Nachricht schreiben...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        textCapitalization: _isCodeMessage
                            ? TextCapitalization.none
                            : TextCapitalization.sentences,
                        maxLines: _isCodeMessage ? 4 : 1,
                        minLines: 1,
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send_rounded),
                    color: Colors.blue,
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Syntax _getSyntaxForLanguage(String language) {
    switch (language.toLowerCase()) {
      case 'javascript':
      case 'js':
        return Syntax.JAVASCRIPT;
      case 'dart':
        return Syntax.DART;
      case 'python':
      case 'py':
        return Syntax.PYTHON;
      case 'java':
        return Syntax.JAVA;
      case 'c':
        return Syntax.C;
      case 'cpp':
      case 'c++':
        return Syntax.CPP;
      default:
        return Syntax.DART;
    }
  }

  void _showProfileModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle-Leiste
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 16),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                
                // Profilbild
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Image.asset(
                    widget.match.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => 
                      Center(child: Icon(Icons.image, size: 80, color: Colors.grey[600])),
                  ),
                ),
                
                // Profilinformationen
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.match.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${widget.match.age}',
                            style: const TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Projektbeschreibung',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.match.description,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Tech Stack',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.match.techStack.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: TechStackItem(tech: widget.match.techStack[index]),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text(
                            'Zurück zum Chat',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}