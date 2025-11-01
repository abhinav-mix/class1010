import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart';

class ResultScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final String subjectName;

  const ResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.subjectName,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _scoreController;
  late AnimationController _pulseController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<int> _scoreAnimation;
  late Animation<double> _pulseAnimation;
  int _bonusPoints = 0;

  @override
  void initState() {
    super.initState();
    
    // Main animation controller
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    // Slide up animation
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );
    
    // Fade in animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );
    
    // Scale animation
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );
    
    // Score counter animation
    _scoreController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _scoreAnimation = IntTween(begin: 0, end: widget.score).animate(
      CurvedAnimation(parent: _scoreController, curve: Curves.easeOutQuart),
    );
    
    // Pulse animation for icon
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    // Start animations
    _mainController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _scoreController.forward();
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _scoreController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (widget.score / widget.totalQuestions * 100).round();
    String remark;
    IconData icon;
    Color iconColor;

    if (percentage == 100) {
      remark = 'Perfect score!';
      icon = Icons.emoji_events;
      iconColor = const Color(0xFFFFD700);
    } else if (percentage >= 80) {
      remark = 'Great job!';
      icon = Icons.star;
      iconColor = const Color(0xFF22C55E);
    } else if (percentage >= 50) {
      remark = 'Good try!';
      icon = Icons.thumb_up;
      iconColor = const Color(0xFF7C9CFF);
    } else {
      remark = 'Keep practicing!';
      icon = Icons.school;
      iconColor = const Color(0xFF9AA4BF);
    }

    // Dynamic gradient colors based on score
    List<Color> gradientColors;
    if (percentage == 100) {
      gradientColors = [const Color(0xFF2D1B69), const Color(0xFF0B1020)];
    } else if (percentage >= 80) {
      gradientColors = [const Color(0xFF1B4D3E), const Color(0xFF0B1020)];
    } else if (percentage >= 50) {
      gradientColors = [const Color(0xFF1A2242), const Color(0xFF0B1020)];
    } else {
      gradientColors = [const Color(0xFF3D1F1F), const Color(0xFF0B1020)];
    }

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.8, -0.8),
            radius: 1.5,
            colors: gradientColors,
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _mainController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _slideAnimation.value),
                child: Opacity(
                  opacity: _fadeAnimation.value,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Card(
                        elevation: 8,
                        shadowColor: iconColor.withValues(alpha: 0.5),
                        child: Container(
                          padding: const EdgeInsets.all(32.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFF121833),
                                const Color(0xFF0D1428),
                              ],
                            ),
                            border: Border.all(
                              color: iconColor.withValues(alpha: 0.4),
                              width: 2,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Animated Icon with pulse and scale
                              ScaleTransition(
                                scale: _scaleAnimation,
                                child: ScaleTransition(
                                  scale: _pulseAnimation,
                                  child: Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [
                                          iconColor.withValues(alpha: 0.4),
                                          iconColor.withValues(alpha: 0.1),
                                          Colors.transparent,
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: iconColor.withValues(alpha: 0.6),
                                          blurRadius: 30,
                                          spreadRadius: 10,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      icon,
                                      size: 80,
                                      color: iconColor,
                                    ),
                                  ),
                                ),
                              ),
                      const SizedBox(height: 24),
                      
                      // Fade in content
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          children: [
                            Text(
                              '${widget.subjectName} Quiz',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Animated Score Counter
                            AnimatedBuilder(
                              animation: _scoreAnimation,
                              builder: (context, child) {
                                return Column(
                                  children: [
                                    Text(
                                      '${_scoreAnimation.value + _bonusPoints} / ${widget.totalQuestions}',
                                      style: const TextStyle(
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF7C9CFF),
                                      ),
                                    ),
                                    if (_bonusPoints > 0)
                                      Text(
                                        '(+$_bonusPoints bonus)',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF22C55E),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$percentage%',
                              style: const TextStyle(
                                fontSize: 24,
                                color: Color(0xFF9AA4BF),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              remark,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  ),
                                  (route) => false,
                                );
                              },
                              icon: const Icon(Icons.home_rounded, size: 20),
                              label: const Text('Back to Home'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                final text =
                                    'I scored ${widget.score}/${widget.totalQuestions} ($percentage%) on ${widget.subjectName} Quiz! $remark 🎓';
                                Clipboard.setData(ClipboardData(text: text));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('✓ Result copied to clipboard!'),
                                    backgroundColor: Color(0xFF22C55E),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.share_rounded, size: 20),
                              label: const Text('Share Result'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                side: BorderSide(
                                  color: const Color(0xFF7C9CFF).withValues(alpha: 0.5),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
