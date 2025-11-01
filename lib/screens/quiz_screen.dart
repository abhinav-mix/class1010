import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/question.dart';
import '../models/hindi_questions.dart';
import '../models/english_questions.dart';
import '../models/mathematics_questions.dart';

import '../models/physics_questions.dart';
import '../models/chemistry_questions.dart';
import '../models/biology_questions.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final String subject;
  final String subjectName;
  final int startLevel;
  
  const QuizScreen({
    super.key,
    required this.subject,
    required this.subjectName,
    this.startLevel = 1,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int score = 0;
  int? selectedAnswerIndex;
  bool hasAnswered = false;
  late List<Question> allQuestions;
  late List<Question> currentLevelQuestions;
  late int currentLevel;
  int totalScore = 0;
  static const int questionsPerLevel = 10;
  Set<int> savedQuestionIndices = {};
  int _questionsSinceLastAd = 0;

  @override
  void initState() {
    super.initState();
    currentLevel = widget.startLevel;
    // Get all questions for the subject
    allQuestions = _getAllQuestionsForSubject(widget.subject);
    // Load level questions
    _loadLevelQuestions();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _loadLevelQuestions() {
    int startIndex = (currentLevel - 1) * questionsPerLevel;
    int endIndex = startIndex + questionsPerLevel;
    
    if (endIndex > allQuestions.length) {
      endIndex = allQuestions.length;
    }
    
    currentLevelQuestions = allQuestions.sublist(
      startIndex,
      endIndex,
    );
    
    currentQuestionIndex = 0;
    score = 0;
    selectedAnswerIndex = null;
    hasAnswered = false;
  }

  List<Question> _getAllQuestionsForSubject(String subject) {
    switch (subject) {
      case 'hindi':
        return hindiQuestions;
      case 'english':
        return englishQuestions;
      case 'mathematics':
        return mathematicsQuestions;
      case 'science':
        // Using physics questions as default for science
        return physicsQuestions;
      case 'social_science':
        // Using chemistry questions as default for social science
        return chemistryQuestions;
      case 'physics':
        return physicsQuestions;
      case 'chemistry':
        return chemistryQuestions;
      case 'biology':
        return bilingualBiologyQuestions;
      default:
        // Using physics questions as default
        return physicsQuestions;
    }
  }

  void selectAnswer(int index) {
    if (hasAnswered) return;

    setState(() {
      selectedAnswerIndex = index;
      hasAnswered = true;
      if (index == currentLevelQuestions[currentQuestionIndex].correctAnswerIndex) {
        score++;
        totalScore++;
      }
    });
  }

  void nextQuestion() {
    if (!hasAnswered) return;

    if (currentQuestionIndex < currentLevelQuestions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswerIndex = null;
        hasAnswered = false;
      });
    } else {
      // Level finished - show level result
      _showLevelResult();
    }
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    // Save current level score
    await prefs.setInt('${widget.subject}_level_${currentLevel}_score', score);
    
    // Unlock next level if scored 9 or more
    if (score >= 9) {
      await prefs.setBool('${widget.subject}_level_${currentLevel + 1}_unlocked', true);
    }
  }

  Future<void> _toggleSaveQuestion() async {
    final question = currentLevelQuestions[currentQuestionIndex];
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList('saved_questions') ?? [];
    
    final questionData = '${widget.subject}|||${question.question}|||${question.options[question.correctAnswerIndex]}';
    
    setState(() {
      if (savedQuestionIndices.contains(currentQuestionIndex)) {
        savedQuestionIndices.remove(currentQuestionIndex);
        savedList.remove(questionData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Question removed from saved'),
            backgroundColor: Color(0xFFEF4444),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        savedQuestionIndices.add(currentQuestionIndex);
        savedList.add(questionData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Question saved!'),
            backgroundColor: Color(0xFF22C55E),
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
    
    await prefs.setStringList('saved_questions', savedList);
  }

  void _showLevelResult() {
    final percentage = (score / currentLevelQuestions.length * 100).round();
    
    // Save progress
    _saveProgress();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF121833),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: const Color(0xFF7C9CFF).withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        title: Row(
          children: [
            Icon(
              score >= 7 ? Icons.emoji_events_rounded : Icons.thumb_up_rounded,
              color: score >= 7 ? const Color(0xFFFFD700) : const Color(0xFF7C9CFF),
              size: 28,
            ),
            const SizedBox(width: 12),
            Text('Level $currentLevel Complete!'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Current Level Score
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF7C9CFF).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF7C9CFF).withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Level Score',
                      style: TextStyle(fontSize: 14, color: Color(0xFF9AA4BF)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$score / ${currentLevelQuestions.length}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7C9CFF),
                      ),
                    ),
                    Text(
                      '$percentage%',
                      style: const TextStyle(fontSize: 18, color: Color(0xFF9AA4BF)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Total Score
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF22C55E).withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Total Score (All Levels)',
                      style: TextStyle(fontSize: 14, color: Color(0xFF9AA4BF)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$totalScore / ${currentLevel * questionsPerLevel}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF22C55E),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          if ((currentLevel * questionsPerLevel) < allQuestions.length)
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  currentLevel++;
                  _loadLevelQuestions();
                });
              },
              icon: const Icon(Icons.arrow_forward_rounded, size: 20),
              label: const Text('Next Level'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultScreen(
                    score: totalScore,
                    totalQuestions: currentLevel * questionsPerLevel,
                    subjectName: widget.subjectName,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.check_circle_rounded, size: 20),
            label: const Text('View Final Result'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              side: BorderSide(
                color: const Color(0xFF7C9CFF).withValues(alpha: 0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = currentLevelQuestions[currentQuestionIndex];
    
    // For questions that already have both languages combined (like biology), use as is
    // For questions with separate fields, combine them
    String displayQuestion;
    List<String> displayOptions;
    
    if (question.question.contains(' / ') && 
        (question.options.isEmpty || question.options.first.contains(' / '))) {
      // Question already has both languages combined
      displayQuestion = question.question;
      displayOptions = question.options;
    } else if (question.questionHindi != null && question.optionsHindi != null) {
      // Combine English and Hindi content
      displayQuestion = '${question.question} / ${question.questionHindi}';
      displayOptions = List.generate(question.options.length, (index) {
        return '${question.options[index]} / ${question.optionsHindi![index]}';
      });
    } else {
      // Fall back to English only
      displayQuestion = question.question;
      displayOptions = question.options;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
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
          child: Column(
            children: [
              // Header with progress
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.subjectName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7C9CFF).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFF7C9CFF),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            'Level $currentLevel',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF7C9CFF),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Q ${currentQuestionIndex + 1} of ${currentLevelQuestions.length}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF9AA4BF),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'Score: $totalScore',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF9AA4BF),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: Icon(
                                savedQuestionIndices.contains(currentQuestionIndex)
                                    ? Icons.bookmark_rounded
                                    : Icons.bookmark_border_rounded,
                                color: savedQuestionIndices.contains(currentQuestionIndex)
                                    ? const Color(0xFFFF6B6B)
                                    : const Color(0xFF9AA4BF),
                              ),
                              onPressed: _toggleSaveQuestion,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              iconSize: 24,
                              tooltip: 'Save Question',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Progress bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: LinearProgressIndicator(
                  value: (currentQuestionIndex + 1) / currentLevelQuestions.length,
                  backgroundColor: const Color(0xFF1B2447),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF7C9CFF),
                  ),
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),

              const SizedBox(height: 24),

              // Question card
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            displayQuestion,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ...List.generate(
                            displayOptions.length,
                            (index) => Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: _OptionButton(
                                option: displayOptions[index],
                                index: index,
                                isSelected: selectedAnswerIndex == index,
                                isCorrect: index == question.correctAnswerIndex,
                                hasAnswered: hasAnswered,
                                onTap: () => selectAnswer(index),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: hasAnswered ? nextQuestion : null,
                            child: Text(
                              currentQuestionIndex < currentLevelQuestions.length - 1
                                  ? 'Next'
                                  : 'Finish Level',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                      const SizedBox(height: 16),
                    ],
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

class _OptionButton extends StatelessWidget {
  final String option;
  final int index;
  final bool isSelected;
  final bool isCorrect;
  final bool hasAnswered;
  final VoidCallback onTap;

  const _OptionButton({
    required this.option,
    required this.index,
    required this.isSelected,
    required this.isCorrect,
    required this.hasAnswered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color? backgroundColor;
    Color? borderColor;

    if (hasAnswered) {
      if (isCorrect) {
        backgroundColor = const Color(0xFF22C55E).withValues(alpha: 0.1);
        borderColor = const Color(0xFF22C55E).withValues(alpha: 0.5);
      } else if (isSelected) {
        backgroundColor = const Color(0xFFEF4444).withValues(alpha: 0.1);
        borderColor = const Color(0xFFEF4444).withValues(alpha: 0.5);
      }
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor ?? const Color(0xFF141C3C),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor ?? Colors.white.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF1C2550),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                String.fromCharCode(65 + index), // A, B, C, D
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFAEB8D9),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                option,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
