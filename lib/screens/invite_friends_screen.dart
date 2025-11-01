import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InviteFriendsScreen extends StatefulWidget {
  const InviteFriendsScreen({super.key});

  @override
  State<InviteFriendsScreen> createState() => _InviteFriendsScreenState();
}

class _InviteFriendsScreenState extends State<InviteFriendsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('profile_name') ?? '';
    final email = prefs.getString('profile_email') ?? '';
    
    if (mounted) {
      setState(() {
        _nameController.text = name;
        _emailController.text = email;
      });
    }
  }

  Future<void> _sendInvitation() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final phone = _phoneController.text;
      final email = _emailController.text;
      final message = _messageController.text;

      // Award points for invitation
      await _awardReferralPoints();

      // Create invitation message
      final invitationMessage = 
          'Hello, I invited my friend to join BoardPrep PRO!\n\n'
          'Name: $name\n' +
          'Phone: $phone\n' +
          'Email: $email\n' +
          'Message: $message\n\n' +
          ' points!';
      
      // Send via WhatsApp
      final whatsappUrl = 'https://wa.me/7253076678?text=${Uri.encodeComponent(invitationMessage)}';
      
      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        await launchUrl(Uri.parse(whatsappUrl));
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open WhatsApp. Please check your connection.'),
              backgroundColor: Color(0xFFEF4444),
            ),
          );
        }
      }
    }
  }

  Future<void> _awardReferralPoints() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Award 150 points to the inviter
    int currentPoints = prefs.getInt('total_points') ?? 0;
    await prefs.setInt('total_points', currentPoints + 150);
    
    // Mark that this user has invited friends (for tracking)
    await prefs.setBool('has_invited_friends', true);
    
    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✓ 150 points awarded for inviting a friend!'),
          backgroundColor: Color(0xFF22C55E),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Invite Friends',
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
                        Icons.group_rounded,
                        size: 50,
                        color: Color(0xFF7C9CFF),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Invite Your Friends',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Share BoardPrep PRO with your friends and earn points!',
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
                
                // Points Info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9F7BFF).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF9F7BFF).withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        'You get 150 points and your friend gets 50 points!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF9F7BFF),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Share BoardPrep PRO with friends and earn points for both of you',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF9AA4BF),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Invitation Form
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Friend\'s Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Name Field
                      _buildTextField(
                        controller: _nameController,
                        label: 'Your Name',
                        hint: 'Enter your full name',
                        icon: Icons.person_rounded,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Friend's Name Field
                      _buildTextField(
                        controller: _phoneController,
                        label: 'Friend\'s Phone Number',
                        hint: 'Enter friend\'s phone number',
                        icon: Icons.phone_rounded,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter friend\'s phone number';
                          }
                          if (value.length < 10) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Friend's Email Field
                      _buildTextField(
                        controller: _emailController,
                        label: 'Friend\'s Email',
                        hint: 'Enter friend\'s email address',
                        icon: Icons.email_rounded,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter friend\'s email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Message Field
                      _buildTextField(
                        controller: _messageController,
                        label: 'Personal Message (Optional)',
                        hint: 'Add a personal note to your invitation',
                        icon: Icons.message_rounded,
                        maxLines: 3,
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Send Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _sendInvitation,
                          icon: const Icon(Icons.send_rounded),
                          label: const Text('Send Invitation via WhatsApp'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: const Color(0xFF25D366),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Info Card
                Container(
                  padding: const EdgeInsets.all(16),
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
                            Icons.info_rounded,
                            color: Color(0xFF7C9CFF),
                            size: 24,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'How It Works',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        '1. Fill in your friend\'s details\n'
                        '2. Click "Send Invitation via WhatsApp"\n'
                        '3. Your invitation will be sent to our WhatsApp number (7253076678)\n'
                        '4. We\'ll contact your friend about BoardPrep PRO\n'
                        '5. You\'ll earn 150 points when they join',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF9AA4BF),
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20),
            filled: true,
            fillColor: const Color(0xFF141C3C),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF7C9CFF),
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          style: const TextStyle(fontSize: 16),
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines,
        ),
      ],
    );
  }
}