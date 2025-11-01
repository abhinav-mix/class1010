import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Logo
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF7C9CFF).withValues(alpha: 0.3),
                          const Color(0xFF7C9CFF).withValues(alpha: 0.1),
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      size: 60,
                      color: Color(0xFF7C9CFF),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // App Name
                Center(
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF7C9CFF), Color(0xFF4ECDC4)],
                    ).createShader(bounds),
                    child: const Text(
                      'BoardPrep PRO',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                
                // Version
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7C9CFF).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF7C9CFF).withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF9AA4BF),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                
                // About Section
                _SectionCard(
                  title: 'About BoardPrep PRO',
                  icon: Icons.info_outline_rounded,
                  color: const Color(0xFF7C9CFF),
                  child: const Text(
                    'This app provides students with easy access to important questions and study materials for board exams, significantly improving their preparation and performance. It offers a comprehensive collection of essential exam questions and helps students study in the right direction with confidence, enabling them to perform well in their exams.',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Color(0xFFCDD5E8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Features Section
                _SectionCard(
                  title: 'Key Features',
                  icon: Icons.star_rounded,
                  color: const Color(0xFFFFD700),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _FeatureItem(
                        icon: Icons.check_circle_rounded,
                        text: '6000+ Class 12 Board Exam Questions',
                      ),
                      _FeatureItem(
                        icon: Icons.check_circle_rounded,
                        text: '6 Subjects: Hindi, English, Maths, Science & More',
                      ),
                      _FeatureItem(
                        icon: Icons.check_circle_rounded,
                        text: 'Level-based Learning System',
                      ),
                      _FeatureItem(
                        icon: Icons.check_circle_rounded,
                        text: 'Beautiful & User-Friendly Interface',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Subjects Section
                _SectionCard(
                  title: 'Available Subjects',
                  icon: Icons.menu_book_rounded,
                  color: const Color(0xFF4ECDC4),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      _SubjectChip(label: '📚 Hindi', color: Color(0xFFFF6B6B)),
                      _SubjectChip(label: '🔤 English', color: Color(0xFF4ECDC4)),
                      _SubjectChip(label: '➗ Mathematics', color: Color(0xFFFFBE0B)),
                      _SubjectChip(label: '⚡ Physics', color: Color(0xFF818CF8)),
                      _SubjectChip(label: '🧪 Chemistry', color: Color(0xFFFBBF24)),
                      _SubjectChip(label: '🌱 Biology', color: Color(0xFF34D399)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Developer Section
                _SectionCard(
                  title: 'Developer',
                  icon: Icons.code_rounded,
                  color: const Color(0xFF34D399),
                  child: const Text(
                    'Developed by ABHI with ❤️ for Class 12 Students\n\n'
                    'This app is designed to help students prepare effectively for their board examinations with comprehensive question banks and an intuitive learning experience.',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Color(0xFFCDD5E8),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Copyright
                Center(
                  child: Text(
                    '© 2025 BoardPrep PRO\nAll Rights Reserved',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.5),
                      height: 1.5,
                    ),
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

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF121833).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFF22C55E),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFFCDD5E8),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubjectChip extends StatelessWidget {
  final String label;
  final Color color;

  const _SubjectChip({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}