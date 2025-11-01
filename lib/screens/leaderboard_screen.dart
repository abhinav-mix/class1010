import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> with SingleTickerProviderStateMixin {
  late Timer _timer;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  List<Map<String, dynamic>> leaderboardData = [];
  final Random _random = Random();
  int _remainingSeconds = 600; // 10 minutes in seconds
  late Timer _countdownTimer;

  // Pool of names for random generation
  final List<String> _names = [
    'Rahul Sharma', 'Priya Singh', 'Amit Kumar', 'Sneha Patel', 'Rohan Verma',
    'Anjali Gupta', 'Vikram Rao', 'Pooja Reddy', 'Karan Mehta', 'Divya Joshi',
    'Arjun Nair', 'Riya Desai', 'Siddharth Jain', 'Neha Kapoor', 'Aditya Shah',
    'Kavya Iyer', 'Harsh Agarwal', 'Ishita Malhotra', 'Varun Bose', 'Tanvi Rao',
    // Adding 10 more names
    'Dev Sharma', 'Ananya Singh', 'Rajesh Kumar', 'Meera Patel', 'Vikash Verma',
    'Sonia Gupta', 'Manoj Rao', 'Preeti Reddy', 'Suresh Mehta', 'Kavita Joshi',
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
    
    _generateLeaderboard();
    _animationController.forward();
    
    // Auto-refresh every 10 minutes
    _timer = Timer.periodic(const Duration(minutes: 10), (timer) {
      print('Leaderboard refreshed at ${DateTime.now()}');
      _refreshLeaderboard();
    });
    
    // Countdown timer for UI
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _remainingSeconds = 600; // Reset to 10 minutes
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    _countdownTimer.cancel();
    super.dispose();
  }

  void _generateLeaderboard() {
    final shuffledNames = List<String>.from(_names)..shuffle(_random);
    // Generate only 3 entries instead of 10
    leaderboardData = List.generate(3, (index) {
      return {
        'rank': index + 1,
        'name': shuffledNames[index],
      };
    });
  }

  void _refreshLeaderboard() {
    _animationController.reverse().then((_) {
      setState(() {
        _generateLeaderboard();
        _remainingSeconds = 600; // Reset countdown
      });
      _animationController.forward();
    });
  }
  
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
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
                        Icons.emoji_events_rounded,
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
                        'Top Performers',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Changed from timer to "Next Update"
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.update_rounded,
                          size: 16,
                          color: Color(0xFF7C9CFF),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Next Update',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF7C9CFF),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF7C9CFF),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Leaderboard List - Now showing only top 3
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    itemCount: leaderboardData.length, // This will now be 3
                    itemBuilder: (context, index) {
                    final player = leaderboardData[index];
                    final rank = player['rank'] as int;
                    
                    Color rankColor = const Color(0xFFFFD700); // Gold for all
                    IconData rankIcon = Icons.workspace_premium_rounded;
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF121833).withOpacity(0.6),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: rank <= 3 
                              ? rankColor.withValues(alpha: 0.3)
                              : Colors.white.withValues(alpha: 0.05),
                          width: rank <= 3 ? 1.5 : 1,
                        ),
                        boxShadow: rank <= 3
                            ? [
                                BoxShadow(
                                  color: rankColor.withValues(alpha: 0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        children: [
                          // Rank Badge
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: rank <= 3
                                  ? LinearGradient(
                                      colors: [
                                        rankColor.withValues(alpha: 0.3),
                                        rankColor.withValues(alpha: 0.1),
                                      ],
                                    )
                                  : null,
                              color: rank > 3 
                                  ? const Color(0xFF1C2550)
                                  : null,
                              border: Border.all(
                                color: rankColor.withValues(alpha: 0.5),
                                width: 2,
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Icon(
                                  rankIcon,
                                  color: rankColor,
                                  size: rank <= 3 ? 28 : 24,
                                ),
                                if (rank <= 3)
                                  Positioned(
                                    bottom: 8,
                                    child: Text(
                                      '$rank',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: rankColor,
                                      ),
                                    ),
                                  )
                                else
                                  Text(
                                    '$rank',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: rankColor,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          
                          // Player Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  player['name'] as String,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
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
            ],
          ),
        ),
      ),
    );
  }
}