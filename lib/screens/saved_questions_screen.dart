import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedQuestionsScreen extends StatefulWidget {
  const SavedQuestionsScreen({super.key});

  @override
  State<SavedQuestionsScreen> createState() => _SavedQuestionsScreenState();
}

class _SavedQuestionsScreenState extends State<SavedQuestionsScreen> {
  List<Map<String, dynamic>> savedQuestions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedQuestions();
  }

  Future<void> _loadSavedQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList('saved_questions') ?? [];
    
    setState(() {
      savedQuestions = savedList.map((item) {
        final parts = item.split('|||');
        return {
          'subject': parts[0],
          'question': parts[1],
          'answer': parts[2],
        };
      }).toList();
      isLoading = false;
    });
  }

  Future<void> _removeSavedQuestion(int index) async {
    final prefs = await SharedPreferences.getInstance();
    savedQuestions.removeAt(index);
    
    final savedList = savedQuestions.map((item) {
      return '${item['subject']}|||${item['question']}|||${item['answer']}';
    }).toList();
    
    await prefs.setStringList('saved_questions', savedList);
    setState(() {});
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Question removed from saved'),
          backgroundColor: Color(0xFFEF4444),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Questions'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.8, -0.8),
            radius: 1.5,
            colors: [
              Color(0xFF1A2242),
              Color(0xFF0B1020),
            ],
          ),
        ),
        child: SafeArea(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : savedQuestions.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bookmark_border_rounded,
                            size: 80,
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No Saved Questions',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Save questions while practicing\nto review them later',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.4),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        // Header
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFFFF6B6B).withValues(alpha: 0.3),
                                      const Color(0xFFFF6B6B).withValues(alpha: 0.1),
                                    ],
                                  ),
                                ),
                                child: const Icon(
                                  Icons.bookmark_rounded,
                                  size: 28,
                                  color: Color(0xFFFF6B6B),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Saved Questions',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${savedQuestions.length} questions saved',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white.withValues(alpha: 0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Questions List
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            itemCount: savedQuestions.length,
                            itemBuilder: (context, index) {
                              final item = savedQuestions[index];
                              return _SavedQuestionCard(
                                subject: item['subject'] as String,
                                question: item['question'] as String,
                                answer: item['answer'] as String,
                                onRemove: () => _removeSavedQuestion(index),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}

class _SavedQuestionCard extends StatelessWidget {
  final String subject;
  final String question;
  final String answer;
  final VoidCallback onRemove;

  const _SavedQuestionCard({
    required this.subject,
    required this.question,
    required this.answer,
    required this.onRemove,
  });

  Color _getSubjectColor(String subject) {
    switch (subject.toLowerCase()) {
      case 'hindi':
        return const Color(0xFFFF6B6B);
      case 'english':
        return const Color(0xFF4ECDC4);
      case 'mathematics':
        return const Color(0xFFFFBE0B);
      case 'science':
        return const Color(0xFF95E1D3);
      case 'social_science':
        return const Color(0xFFF38181);
      case 'physics':
        return const Color(0xFF818CF8);
      case 'chemistry':
        return const Color(0xFFFBBF24);
      case 'biology':
        return const Color(0xFF34D399);
      default:
        return const Color(0xFF7C9CFF);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getSubjectColor(subject);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF121833).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  subject.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.delete_rounded, size: 20),
                color: const Color(0xFFEF4444),
                onPressed: onRemove,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Question
          Text(
            question,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          
          // Answer
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF22C55E).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF22C55E).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF22C55E),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    answer,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF22C55E),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
