import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  Map<String, Map<String, dynamic>> subjectProgress = {};
  bool isLoading = true;

  final List<Map<String, dynamic>> subjects = [
    {'name': 'Hindi', 'subject': 'hindi', 'color': Color(0xFFFF6B6B), 'emoji': '📚'},
    {'name': 'English', 'subject': 'english', 'color': Color(0xFF4ECDC4), 'emoji': '🔤'},
    {'name': 'Mathematics', 'subject': 'mathematics', 'color': Color(0xFFFFBE0B), 'emoji': '➗'},
    {'name': 'Physics', 'subject': 'physics', 'color': Color(0xFF818CF8), 'emoji': '⚡'},
    {'name': 'Chemistry', 'subject': 'chemistry', 'color': Color(0xFFFBBF24), 'emoji': '🧪'},
    {'name': 'Biology', 'subject': 'biology', 'color': Color(0xFF34D399), 'emoji': '🌱'},
  ];

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, Map<String, dynamic>> progress = {};

    for (var subject in subjects) {
      String subjectKey = subject['subject'] as String;
      int unlockedLevels = 0;
      int completedLevels = 0;
      int totalScore = 0;

      for (int i = 1; i <= 100; i++) {
        final isUnlocked = prefs.getBool('${subjectKey}_level_${i}_unlocked') ?? (i == 1);
        final score = prefs.getInt('${subjectKey}_level_${i}_score') ?? 0;

        if (isUnlocked) unlockedLevels++;
        if (score >= 9) completedLevels++;
        totalScore += score;
      }

      progress[subjectKey] = {
        'unlockedLevels': unlockedLevels,
        'completedLevels': completedLevels,
        'totalScore': totalScore,
        'percentage': (completedLevels / 100 * 100).round(),
      };
    }

    setState(() {
      subjectProgress = progress;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Progress'),
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
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      const Text(
                        'Track Your Progress',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Complete levels to master each subject',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Overall Stats
                      _buildOverallStats(),
                      const SizedBox(height: 24),

                      // Subject Progress Cards
                      ...subjects.map((subject) {
                        final subjectKey = subject['subject'] as String;
                        final progress = subjectProgress[subjectKey] ?? {
                          'unlockedLevels': 1,
                          'completedLevels': 0,
                          'totalScore': 0,
                          'percentage': 0,
                        };

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _SubjectProgressCard(
                            name: subject['name'] as String,
                            emoji: subject['emoji'] as String,
                            color: subject['color'] as Color,
                            unlockedLevels: progress['unlockedLevels'] as int,
                            completedLevels: progress['completedLevels'] as int,
                            totalScore: progress['totalScore'] as int,
                            percentage: progress['percentage'] as int,
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildOverallStats() {
    int totalCompleted = 0;
    int totalScore = 0;

    for (var progress in subjectProgress.values) {
      totalCompleted += progress['completedLevels'] as int;
      totalScore += progress['totalScore'] as int;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF7C9CFF).withValues(alpha: 0.2),
            const Color(0xFF4ECDC4).withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF7C9CFF).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Overall Progress',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                icon: Icons.emoji_events_rounded,
                value: '$totalCompleted',
                label: 'Levels\nCompleted',
                color: const Color(0xFFFFD700),
              ),
              _StatItem(
                icon: Icons.star_rounded,
                value: '$totalScore',
                label: 'Total\nScore',
                color: const Color(0xFF7C9CFF),
              ),
              _StatItem(
                icon: Icons.trending_up_rounded,
                value: '${(totalCompleted / 1000 * 100).toStringAsFixed(1)}%',
                label: 'Overall\nProgress',
                color: const Color(0xFF22C55E),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SubjectProgressCard extends StatelessWidget {
  final String name;
  final String emoji;
  final Color color;
  final int unlockedLevels;
  final int completedLevels;
  final int totalScore;
  final int percentage;

  const _SubjectProgressCard({
    required this.name,
    required this.emoji,
    required this.color,
    required this.unlockedLevels,
    required this.completedLevels,
    required this.totalScore,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Row(
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$completedLevels/100 levels completed',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$percentage%',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: const Color(0xFF1B2447),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          
          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _MiniStat(
                icon: Icons.lock_open_rounded,
                value: '$unlockedLevels',
                label: 'Unlocked',
              ),
              _MiniStat(
                icon: Icons.check_circle_rounded,
                value: '$completedLevels',
                label: 'Completed',
              ),
              _MiniStat(
                icon: Icons.stars_rounded,
                value: '$totalScore',
                label: 'Score',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _MiniStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF9AA4BF)),
        const SizedBox(width: 4),
        Text(
          '$value $label',
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF9AA4BF),
          ),
        ),
      ],
    );
  }
}
