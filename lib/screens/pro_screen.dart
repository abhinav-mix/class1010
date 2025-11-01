import 'package:flutter/material.dart';
import 'dart:math';
import 'points_system_screen.dart';

class ProScreen extends StatefulWidget {
  const ProScreen({super.key});

  @override
  State<ProScreen> createState() => _ProScreenState();
}

class _ProScreenState extends State<ProScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  List<Map<String, dynamic>> proFeatures = [];
  final Random _random = Random();

  // Pro features list
  final List<Map<String, dynamic>> _features = [
    {
      'title': 'Unlimited Access',
      'description': 'Access to all 10,000+ questions across all subjects',
      'icon': Icons.lock_open_rounded,
      'color': Color(0xFF7C9CFF),
    },
    {
      'title': 'Ad-Free Experience',
      'description': 'Study without interruptions from advertisements',
      'icon': Icons.ad_units_rounded,
      'color': Color(0xFF4ECDC4),
    },
    {
      'title': '🎁 Upgrade to Pro & Get Free Gift! 🎁',
      'description': 'Study without interruptions from advertisements',
      'icon': Icons.ad_units_rounded,
      'color': Color(0xFF4ECDC4),
    },
    {
      'title': 'Offline Downloads',
      'description': 'Download content for offline studying anytime',
      'icon': Icons.download_rounded,
      'color': Color(0xFFFFBE0B),
    },
    {
      'title': 'Advanced Analytics',
      'description': 'Detailed performance reports and insights',
      'icon': Icons.bar_chart_rounded,
      'color': Color(0xFF95E1D3),
    },
    {
      'title': 'Personalized Learning',
      'description': 'AI-powered study recommendations',
      'icon': Icons.auto_awesome_rounded,
      'color': Color(0xFFF38181),
    },
    {
      'title': 'Priority Support',
      'description': 'Get faster help from our expert team',
      'icon': Icons.support_agent_rounded,
      'color': Color(0xFF818CF8),
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    
    _generateFeatures();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _generateFeatures() {
    final shuffledFeatures = List<Map<String, dynamic>>.from(_features)..shuffle(_random);
    // Generate only 3 entries
    proFeatures = List.generate(3, (index) {
      return shuffledFeatures[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PRO Features'),
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
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFFFD700).withOpacity(0.3),
                            const Color(0xFFFFD700).withOpacity(0.1),
                          ],
                        ),
                      ),
                      child: const Icon(
                        Icons.workspace_premium_rounded,
                        size: 48,
                        color: Color(0xFFFFD700),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFFFFD700), Color(0xFFFFBE0B)],
                      ).createShader(bounds),
                      child: const Text(
                        'BoardPrep PRO',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Upgrade to unlock premium features',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              
              // PRO Features List
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    itemCount: proFeatures.length, // This will now be 3
                    itemBuilder: (context, index) {
                    final feature = proFeatures[index];
                    final color = feature['color'] as Color;
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF121833).withOpacity(0.6),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: color.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Feature Icon
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  color.withValues(alpha: 0.3),
                                  color.withValues(alpha: 0.1),
                                ],
                              ),
                              border: Border.all(
                                color: color.withValues(alpha: 0.5),
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              feature['icon'] as IconData,
                              color: color,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          
                          // Feature Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  feature['title'] as String,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  feature['description'] as String,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white.withValues(alpha: 0.6),
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
                ),
              ),
              
              // Points System Section
              Container(
                margin: const EdgeInsets.all(24.0),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF121833).withOpacity(0.6),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFFFD700).withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFFFD700).withValues(alpha: 0.2),
                          ),
                          child: const Icon(
                            Icons.stars_rounded,
                            color: Color(0xFFFFD700),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Flexible( // Added Flexible to prevent overflow
                          child: Text(
                            'Enhanced Points System',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'As a PRO member, you get X points on all quizzes, bonus points for streaks, and access to exclusive leaderboards. Invite friends to earn 150 points for yourself and give them 50 points!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF9AA4BF),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox( // Ensure button has proper width constraints
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PointsSystemScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFD700),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Learn About Points'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}