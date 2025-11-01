import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'level_selection_screen.dart';
import 'about_screen.dart';
import 'leaderboard_screen.dart';
import 'profile_edit_screen.dart';
import 'progress_screen.dart';
import 'saved_questions_screen.dart';
import 'pro_screen.dart'; // Added PRO screen import
import 'points_system_screen.dart'; // Added Points System screen import
import '../services/whatsapp_service.dart'; // WhatsApp service import
import 'qr_payment_screen.dart'; // Import QR payment screen
import 'qr_display_screen.dart'; // Import QR display screen
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  final Function(ThemeMode)? themeChanger; // Made theme changer parameter optional

  const HomeScreen({super.key, this.themeChanger});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  String? _profileImagePath;
  int _totalPoints = 0;
  int _totalLevelsCompleted = 0;
  int _totalQuizzesCompleted = 0;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    _loadUserStats();
    
    // Initialize animation controller and animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    // Start the animation
    _animationController.forward();
    
    // Remove the payment check from here since it's handled in main.dart
  }

  Future<void> _checkAndNavigateToQrScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final storedTransactionId = prefs.getString('transaction_id');
    bool paymentValid = false;

    if (storedTransactionId != null) {
      try {
        final response = await http.get(
          Uri.parse('http://localhost:3001/check-payment-status?transactionId=$storedTransactionId'),
        );

        if (response.statusCode == 200) {
          final responseBody = jsonDecode(response.body);
          paymentValid = responseBody['valid'] ?? false;
        }
      } catch (e) {
        print('Error checking payment status: $e');
      }
    }

    // If payment is not valid, navigate to QR display screen
    if (!paymentValid && mounted) {
      // Navigate to QR display screen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => QrDisplayScreen(themeChanger: widget.themeChanger ?? (ThemeMode mode) {}),
        ),
      );
    }
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profile_image');
    
    if (mounted) {
      setState(() {
        _profileImagePath = imagePath;
      });
    }
  }

  Future<void> _loadUserStats() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load points
    final totalPoints = prefs.getInt('total_points') ?? 0;
    
    // For now, we'll use simple counters for levels and quizzes
    // In a real app, you'd calculate these from the saved quiz data
    final totalLevelsCompleted = 1;
    final totalQuizzesCompleted = 0;
    
    if (mounted) {
      setState(() {
        _totalPoints = totalPoints;
        _totalLevelsCompleted = totalLevelsCompleted;
        _totalQuizzesCompleted = totalQuizzesCompleted;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showProfileDialog(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('profile_name') ?? 'Guest User';
    final section = prefs.getString('profile_section') ?? 'A';
    final board = prefs.getString('profile_board') ?? 'CBSE';
    final imagePath = prefs.getString('profile_image');
    
    // Refresh stats when showing profile
    _loadUserStats();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF121833),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: const Color(0xFF7C9CFF).withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Profile Image
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF7C9CFF).withValues(alpha: 0.1),
                  border: Border.all(
                    color: const Color(0xFF7C9CFF),
                    width: 3,
                  ),
                  image: imagePath != null && imagePath.isNotEmpty
                      ? DecorationImage(
                          image: FileImage(File(imagePath)),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: imagePath == null || imagePath.isEmpty
                    ? const Icon(
                        Icons.person_rounded,
                        size: 60,
                        color: Color(0xFF7C9CFF),
                      )
                    : null,
              ),
              const SizedBox(height: 20),
              
              // User Name
              Text(
                name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              // User Stats
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF7C9CFF).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF7C9CFF).withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  '🎓 Class 12 - Section $section ($board)',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF9AA4BF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Stats Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: _StatCard(
                      icon: Icons.emoji_events_rounded,
                      value: '$_totalPoints',
                      label: 'Points',
                      color: const Color(0xFFFFD700),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: _StatCard(
                      icon: Icons.stars_rounded,
                      value: '$_totalLevelsCompleted',
                      label: 'Level',
                      color: const Color(0xFF7C9CFF),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: _StatCard(
                      icon: Icons.check_circle_rounded,
                      value: '$_totalQuizzesCompleted',
                      label: 'Done',
                      color: const Color(0xFF22C55E),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        Navigator.pop(context);
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileEditScreen(),
                          ),
                        );
                        if (result == true) {
                          // Reload profile image
                          _loadProfileImage();
                        }
                      },
                      icon: const Icon(Icons.edit_rounded, size: 18),
                      label: const Text('Edit Profile'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded, size: 18),
                      label: const Text('Close'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(
                          color: const Color(0xFF7C9CFF).withValues(alpha: 0.3),
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
    );
  }

  // Function to toggle between dark and light mode
  void _toggleTheme() {
    if (widget.themeChanger != null) {
      final currentTheme = Theme.of(context).brightness;
      if (currentTheme == Brightness.dark) {
        widget.themeChanger!(ThemeMode.light);
      } else {
        widget.themeChanger!(ThemeMode.dark);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final subjects = [
      {'name': 'Hindi', 'icon': Icons.menu_book_rounded, 'color': const Color(0xFFFF6B6B), 'subject': 'hindi', 'emoji': '📚'},
      {'name': 'English', 'icon': Icons.translate_rounded, 'color': const Color(0xFF4ECDC4), 'subject': 'english', 'emoji': '🔤'},
      {'name': 'Mathematics', 'icon': Icons.functions_rounded, 'color': const Color(0xFFFFBE0B), 'subject': 'mathematics', 'emoji': '➗'},
      {'name': 'Physics', 'icon': Icons.flash_on_rounded, 'color': const Color(0xFF818CF8), 'subject': 'physics', 'emoji': '⚡'},
      {'name': 'Chemistry', 'icon': Icons.science_outlined, 'color': const Color(0xFFFBBF24), 'subject': 'chemistry', 'emoji': '🧪'},
      {'name': 'Biology', 'icon': Icons.local_florist_rounded, 'color': const Color(0xFF34D399), 'subject': 'biology', 'emoji': '🌱'},
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Color(0xFF7C9CFF), size: 28),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        actions: [
          // Theme toggle button (only show if themeChanger is available)
          if (widget.themeChanger != null) ...[
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                icon: Icon(
                  Theme.of(context).brightness == Brightness.dark 
                    ? Icons.light_mode_outlined 
                    : Icons.dark_mode_outlined,
                  color: const Color(0xFF7C9CFF),
                  size: 28,
                ),
                onPressed: _toggleTheme,
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: _profileImagePath == null
                      ? LinearGradient(
                          colors: [
                            const Color(0xFF7C9CFF).withValues(alpha: 0.3),
                            const Color(0xFF4ECDC4).withValues(alpha: 0.2),
                          ],
                        )
                      : null,
                  border: Border.all(
                    color: const Color(0xFF7C9CFF).withValues(alpha: 0.5),
                    width: 2,
                  ),
                  image: _profileImagePath != null
                      ? DecorationImage(
                          image: FileImage(File(_profileImagePath!)),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _profileImagePath == null
                    ? const Icon(
                        Icons.person_rounded,
                        color: Color(0xFF7C9CFF),
                        size: 24,
                      )
                    : null,
              ),
              onPressed: () {
                _showProfileDialog(context);
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
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
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.school,
                        size: 40,
                        color: Color(0xFF7C9CFF),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'BoardPrep PRO',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Class 12 Board Exam Prep',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Divider(color: Color(0xFF1B2447), height: 1),
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.home, color: Color(0xFF7C9CFF), size: 22),
                  title: const Text('Home', style: TextStyle(fontSize: 15)),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.emoji_events, color: Color(0xFFFFD700), size: 22),
                  title: const Text('Leaderboard', style: TextStyle(fontSize: 15)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LeaderboardScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.bar_chart, color: Color(0xFF22C55E), size: 22),
                  title: const Text('Progress', style: TextStyle(fontSize: 15)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProgressScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.bookmark, color: Color(0xFFFF6B6B), size: 22),
                  title: const Text('Saved Questions', style: TextStyle(fontSize: 15)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SavedQuestionsScreen(),
                      ),
                    );
                  },
                ),
                const Divider(color: Color(0xFF1B2447)),
                // Added PRO screen navigation
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.workspace_premium, color: Color(0xFFFFD700), size: 22),
                  title: const Text('PRO Features', style: TextStyle(fontSize: 15)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.settings, color: Color(0xFF9AA4BF), size: 22),
                  title: const Text('Settings', style: TextStyle(fontSize: 15)),
                  onTap: () {
                    Navigator.pop(context);
                    // Add settings functionality later
                  },
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.stars, color: Color(0xFFFFD700), size: 22),
                  title: const Text('Points System', style: TextStyle(fontSize: 15)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PointsSystemScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.info, color: Color(0xFF9AA4BF), size: 22),
                  title: const Text('About', style: TextStyle(fontSize: 15)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(context).brightness == Brightness.dark
            ? const RadialGradient(
                center: Alignment(-0.8, -0.8),
                radius: 1.5,
                colors: [
                  Color(0xFF1A2242),
                  Color(0xFF0B1020),
                ],
              )
            : null,
          color: Theme.of(context).brightness == Brightness.light 
            ? Colors.white 
            : null,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with Animation
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF7C9CFF).withOpacity(0.3),
                                const Color(0xFF7C9CFF).withOpacity(0.1),
                              ],
                            ),
                          ),
                          child: const Icon(
                            Icons.school_rounded,
                            size: 48,
                            color: Color(0xFF7C9CFF),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Color(0xFF7C9CFF), Color(0xFF4ECDC4)],
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
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7C9CFF).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFF7C9CFF).withValues(alpha: 0.3),
                            ),
                          ),
                          child: const Text(
                            '🎓 Class 12 Board Exam Prep',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF9AA4BF),
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
              
              // Subjects Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.15,
                  ),
                  itemCount: subjects.length,
                  itemBuilder: (context, index) {
                    final subject = subjects[index];
                    return _SubjectCard(
                      name: subject['name'] as String,
                      icon: subject['icon'] as IconData,
                      emoji: subject['emoji'] as String,
                      color: subject['color'] as Color,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LevelSelectionScreen(
                              subject: subject['subject'] as String,
                              subjectName: subject['name'] as String,
                              totalLevels: 100, // 100 levels per subject
                            ),
                          ),
                        );
                      },
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

class _SubjectCard extends StatefulWidget {
  final String name;
  final IconData icon;
  final String emoji;
  final Color color;
  final VoidCallback onTap;

  const _SubjectCard({
    required this.name,
    required this.icon,
    required this.emoji,
    required this.color,
    required this.onTap,
  });

  @override
  State<_SubjectCard> createState() => _SubjectCardState();
}

class _SubjectCardState extends State<_SubjectCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.color.withValues(alpha: 0.25),
                widget.color.withValues(alpha: 0.08),
              ],
            ),
            border: Border.all(
              color: widget.color.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.3),
                blurRadius: _isPressed ? 8 : 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  // Outer glow circle
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          widget.color.withValues(alpha: 0.3),
                          widget.color.withValues(alpha: 0.05),
                        ],
                      ),
                    ),
                  ),
                  // Inner circle with icon
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.color.withValues(alpha: 0.25),
                      border: Border.all(
                        color: widget.color.withValues(alpha: 0.4),
                        width: 2,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          widget.icon,
                          size: 28,
                          color: widget.color.withValues(alpha: 0.6),
                        ),
                        // Emoji overlay
                        Positioned(
                          bottom: -2,
                          right: -2,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark
                                ? const Color(0xFF0B1020)
                                : Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: widget.color.withValues(alpha: 0.5),
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              widget.emoji,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    widget.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                      color: Colors.white.withValues(alpha: 0.95),
                      letterSpacing: 0.3,
                    ),
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

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}