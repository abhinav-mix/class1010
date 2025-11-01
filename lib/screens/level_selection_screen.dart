import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'quiz_screen.dart';

class LevelSelectionScreen extends StatefulWidget {
  final String subjectName;
  final String subject;
  final int totalLevels;

  const LevelSelectionScreen({
    super.key,
    required this.subjectName,
    required this.subject,
    required this.totalLevels,
  });

  @override
  State<LevelSelectionScreen> createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  Map<int, bool> unlockedLevels = {1: true}; // Level 1 always unlocked
  Map<int, int> levelScores = {};

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (int i = 1; i <= widget.totalLevels; i++) {
        final isUnlocked = prefs.getBool('${widget.subject}_level_${i}_unlocked') ?? (i == 1);
        final score = prefs.getInt('${widget.subject}_level_${i}_score') ?? 0;
        unlockedLevels[i] = isUnlocked;
        levelScores[i] = score;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.subjectName} - Select Level'),
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
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Choose Your Level',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Complete 9/10 questions to unlock next level',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Total levels badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C9CFF).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF7C9CFF).withOpacity(0.5),
                        ),
                      ),
                      child: Text(
                        '${widget.totalLevels} Levels',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7C9CFF),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Levels Grid
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: widget.totalLevels,
                    itemBuilder: (context, index) {
                      final level = index + 1;
                      final isUnlocked = unlockedLevels[level] ?? false;
                      final score = levelScores[level] ?? 0;
                      
                      return _LevelCard(
                        level: level,
                        isUnlocked: isUnlocked,
                        score: score,
                        onTap: isUnlocked
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QuizScreen(
                                      subjectName: widget.subjectName,
                                      subject: widget.subject,
                                      startLevel: level,
                                    ),
                                  ),
                                ).then((_) => _loadProgress());
                              }
                            : null,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final int level;
  final bool isUnlocked;
  final int score;
  final VoidCallback? onTap;

  const _LevelCard({
    required this.level,
    required this.isUnlocked,
    required this.score,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isUnlocked
                ? [
                    const Color(0xFF7C9CFF).withOpacity(0.3),
                    const Color(0xFF4ECDC4).withOpacity(0.2),
                  ]
                : [
                    const Color(0xFF1B2447).withOpacity(0.5),
                    const Color(0xFF0D1428).withOpacity(0.5),
                  ],
          ),
          border: Border.all(
            color: isUnlocked
                ? const Color(0xFF7C9CFF).withOpacity(0.5)
                : const Color(0xFF9AA4BF).withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: const Color(0xFF7C9CFF).withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lock/Star Icon
            Icon(
              isUnlocked
                  ? (score >= 9 ? Icons.star_rounded : Icons.play_circle_rounded)
                  : Icons.lock_rounded,
              size: 24,
              color: isUnlocked
                  ? (score >= 9 ? const Color(0xFFFFD700) : const Color(0xFF7C9CFF))
                  : const Color(0xFF9AA4BF).withOpacity(0.5),
            ),
            const SizedBox(height: 4),
            
            // Level Number
            Text(
              '$level',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isUnlocked
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.4),
              ),
            ),
            
            // Score (if unlocked and played)
            if (isUnlocked && score > 0) ...[
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: score >= 9
                      ? const Color(0xFF22C55E).withOpacity(0.2)
                      : const Color(0xFF7C9CFF).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '$score/10',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    color: score >= 9
                        ? const Color(0xFF22C55E)
                        : const Color(0xFF7C9CFF),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
