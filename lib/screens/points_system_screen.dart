import 'package:flutter/material.dart';
import 'invite_friends_screen.dart';

class PointsSystemScreen extends StatelessWidget {
  const PointsSystemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Points System',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
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
                const SizedBox(height: 20),
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C9CFF).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF7C9CFF).withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.stars_rounded,
                        size: 50,
                        color: Color(0xFF7C9CFF),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'How Points Work',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Understand how you earn points and level up',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF9AA4BF),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Points Earning Methods
                const Text(
                  'How to Earn Points',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                _buildPointCard(
                  icon: Icons.check_circle_rounded,
                  title: 'Correct Answers',
                  points: '+1 Point',
                  description: 'Earn 1 point for each correct answer in any quiz',
                  color: const Color(0xFF22C55E),
                ),
                
                const SizedBox(height: 16),
                
                _buildPointCard(
                  icon: Icons.emoji_events_rounded,
                  title: 'Level Completion Bonus',
                  points: '+5 to +20 Points',
                  description: 'Complete levels with high scores to earn bonus points',
                  color: const Color(0xFFFFD700),
                ),
                
                const SizedBox(height: 16),
                
                // Removed PRO-only features and replaced with general features
                _buildPointCard(
                  icon: Icons.camera_alt_rounded,
                  title: 'Daily Photo Check-in (PRO Only)',
                  points: '+10 Points Per Day',
                  description: 'PRO members earn 10 points daily by opening the app and sending a photo to WhatsApp number 7253076678',
                  color: const Color(0xFF4ECDC4),
                ),
                
                _buildPointCard(
                  icon: Icons.group_rounded,
                  title: 'Invite Friends',
                  points: '+150 Points (You) +50 Points (Friend)',
                  description: 'Share BoardPrep PRO with friends and earn points for both of you',
                  color: const Color(0xFF9F7BFF),
                ),
                
                const SizedBox(height: 16),
                
                // Invite Friends Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const InviteFriendsScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.send_rounded),
                    label: const Text('Invite Friends Now'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFF9F7BFF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 30),
                
                _buildPointCard(
                  icon: Icons.calendar_today_rounded,
                  title: 'Daily Streak',
                  points: '+5 Points Per Day',
                  description: 'Maintain a daily quiz streak for bonus points (max 7 days)',
                  color: const Color(0xFFFF6B6B),
                ),
                
                const SizedBox(height: 30),
                
                // Level System
                const Text(
                  'Level System',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141C3C),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.trending_up_rounded,
                            color: Color(0xFF7C9CFF),
                            size: 28,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Progression',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        '• Each subject has 100 levels\n'
                        '• Each level has 10 questions\n'
                        '• Score 9+ in a level to unlock the next\n'
                        '• Higher scores earn more bonus points\n'
                        '• Complete all levels to become a master!',
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.6,
                          color: Color(0xFF9AA4BF),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Leaderboard Benefits
                const Text(
                  'Leaderboard & Recognition',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141C3C),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.leaderboard_rounded,
                            color: Color(0xFFFF6B6B),
                            size: 28,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Top Performers',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        '• Top 10 students get special badges\n'
                        '• Monthly champions get featured\n'
                        '• Share your achievements with friends',
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.6,
                          color: Color(0xFF9AA4BF),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Tips Section
                const Text(
                  'Tips to Earn More Points',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141C3C),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb_rounded,
                            color: Color(0xFFFFD700),
                            size: 28,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Smart Strategies',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        '• Review saved questions regularly\n'
                        '• Focus on weak subjects\n'
                        '• Attempt quizzes daily\n'
                        '• Aim for 90%+ accuracy\n'
                        '• Challenge higher levels progressively\n'
                        '• Invite friends to earn bonus points\n'
                        '• Maintain your daily streak',
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.6,
                          color: Color(0xFF9AA4BF),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
                
                _buildPointCard(
                  icon: Icons.workspace_premium_rounded,
                  title: 'PRO Features',
                  points: '+Extra Bonuses',
                  description: 'Unlock exclusive bonuses with PRO membership',
                  color: const Color(0xFFFFD700),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildPointCard({
    required IconData icon,
    required String title,
    required String points,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF141C3C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: color.withValues(alpha: 0.4),
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  points,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF9AA4BF),
                    height: 1.4,
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