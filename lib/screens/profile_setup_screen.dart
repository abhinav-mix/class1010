import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'home_screen.dart';
import '../services/whatsapp_service.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _inviterController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController(); // Added school name controller
  String _selectedSection = 'A';
  String _selectedBoard = 'CBSE';
  bool _termsAccepted = false;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  final List<String> _sections = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N'];
  final List<String> _boards = ['CBSE', 'UP BOARD', 'ICSE', 'STATE BOARD', 'OTHER']; // Added more board options

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    if (_mobileController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your mobile number'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email address'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    // Basic email validation
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(_emailController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email address'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    // Basic mobile number validation (at least 10 digits)
    if (_mobileController.text.trim().length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid mobile number (at least 10 digits)'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    // School name is now required
    if (_schoolController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your school name'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    // Save profile data first
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_name', _nameController.text.trim());
    await prefs.setString('profile_mobile', _mobileController.text.trim());
    await prefs.setString('profile_email', _emailController.text.trim());
    await prefs.setString('profile_section', _selectedSection);
    await prefs.setString('profile_board', _selectedBoard);
    // Save school name if provided
    if (_schoolController.text.trim().isNotEmpty) {
      await prefs.setString('profile_school', _schoolController.text.trim());
    }
    // Save inviter number if provided
    if (_inviterController.text.trim().isNotEmpty) {
      await prefs.setString('profile_inviter', _inviterController.text.trim());
    }
    
    if (_profileImage != null) {
      await prefs.setString('profile_image', _profileImage!.path);
    }

    await prefs.setBool('profile_completed', true);

    // Create message with user details
    final userDetails = 
        'New User Registration:\n'
        'Name: ${_nameController.text.trim()}\n'
        'Mobile: ${_mobileController.text.trim()}\n'
        'Email: ${_emailController.text.trim()}\n'
        'Class: Class 12\n' // Automatically add Class 12
        'Section: $_selectedSection\n'
        'Board: $_selectedBoard\n'
        // Add school information if provided
        '${_schoolController.text.trim().isNotEmpty ? 'School: ${_schoolController.text.trim()}\n' : ''}'
        // Add inviter information if provided
        '${_inviterController.text.trim().isNotEmpty ? 'Inviter: ${_inviterController.text.trim()}\n' : ''}'
        'Registration Date: ${DateTime.now().toString()}';

    // Send via WhatsApp
    final whatsappUrl = 'https://wa.me/7253076678?text=${Uri.encodeComponent(userDetails)}';
    
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

    // Mark first time app open as handled
    await WhatsappService.markFirstTimeAppOpen();

    // Navigate back to main screen so it can handle the flow
    if (mounted) {
      Navigator.of(context).pop(); // Go back to main.dart which will show QR screen
    }
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '📜 BoardPrep PRO – Terms & Conditions',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const SingleChildScrollView(
            child: Text(
              '📜 BoardPrep PRO – Terms & Conditions\n\n'
              'Last Updated: April 2025\n\n'
              'Welcome to BoardPrep PRO!\n\n'
              'Thank you for choosing our app.\n'
              'By using BoardPrep PRO, you agree to all the terms and conditions mentioned below.\n'
              'BoardPrep PRO is an educational platform designed for Class 12 students, providing study materials, PDFs, quizzes, MCQs, and the last 10 years of question papers.\n\n\n'
              '---\n\n'
              '💎 1. About the App\n\n'
              'BoardPrep PRO is a learning platform where students can improve their exam preparation.\n\n'
              'Both Free and Paid (Pro) versions of the app are available.\n\n'
              'Our main goal is:\n\n'
              '👉 "Study Smart, Practice More, and Win Rewards!"\n\n'
              'The app is regularly updated with new features, study materials, and contests to make learning more engaging.\n\n\n'
              '---\n\n'
              '💰 2. Pro Subscription\n\n'
              'By purchasing the Pro Subscription, users get access to:\n\n'
              'Extra study materials,\n\n'
              'Premium PDFs,\n\n'
              'Exclusive MCQs,\n\n'
              'Leaderboards, and\n\n'
              'Special gifts.\n\n\n'
              'Once purchased, the subscription is non-refundable.\n\n'
              'Subscriptions are valid for a specific duration (1 month, 3 months, or yearly — depending on the chosen plan).\n\n'
              'Exclusive contests, bonuses, and rewards are often announced for Pro users.\n\n'
              'The company may update, add, or remove Pro features at any time without prior notice.\n\n\n'
              '---\n\n'
              '🎁 3. Gifts & Rewards\n\n'
              'Active and Pro users are eligible for special gifts and prizes, such as: 💻 Laptop | 📱 Smartphone | 🎧 Headphones | 🎒 Stylish Case | 🎮 Gaming Mouse | 🎁 Surprise Goodies\n\n'
              'Rewards are given based on:\n\n'
              'Leaderboard rankings\n\n'
              'Quiz performance\n\n'
              'Activity level\n\n'
              'Referral achievements\n\n\n'
              'Rules for each contest will be clearly mentioned within the app.\n\n'
              'Gifts are non-transferable and cannot be exchanged for cash.\n\n'
              'The company reserves the right to change, cancel, or delay any prize or winner list.\n\n'
              'If fake accounts, cheating, or fraud are detected, the user will be disqualified immediately.\n\n\n'
              '---\n\n'
              '🏆 4. Leaderboard System\n\n'
              'The Leaderboard displays the top active and performing users.\n\n'
              'Points are earned for: \n✅ Solving quizzes\n'
              '✅ Logging in daily\n'
              '✅ Inviting or sharing with friends\n'
              '✅ Regular activity and progress\n\n'
              'Any cheating, use of bots, or fake activity may result in account suspension or deletion.\n\n'
              'The company holds full authority to verify results and make final decisions regarding winners.\n\n\n'
              '---\n\n'
              '🔗 5. Share & Invite Program\n\n'
              'Users can invite their friends to join BoardPrep PRO.\n\n'
              'For every successful invite, users may earn: \n⭐ Bonus points\n'
              '⭐ Extra rewards\n'
              '⭐ Or a special gift\n\n'
              'Fake or duplicate referrals will result in reward cancellation.\n\n'
              'Misuse of the share/invite feature is strictly prohibited.\n\n\n'
              '---\n\n'
              '🔒 6. Privacy & Data Protection\n\n'
              'We respect your privacy.\n'
              'Your information (such as name, email, school info, and performance data) is collected only to improve your app experience.\n\n'
              'We never sell or share your data with third parties.\n\n'
              'All user data is stored securely.\n\n'
              'You may request account or data deletion by contacting our support team.\n\n'
              'By providing your contact information, you agree that we may contact you via call, SMS, or email for important updates, offers, and app-related communications.\n\n\n'
              '⚠ 7. Fair Use Policy\n\n'
              'All content in the app (PDFs, MCQs, quizzes, images, etc.) is for personal study use only.\n\n'
              'Copying, reselling, or re-uploading any content from the app is strictly prohibited.\n\n'
              'Any violation of this policy can result in immediate account suspension.\n\n\n'
              '---\n\n'
              '🚫 8. Account Suspension & Misuse\n\n'
              'Your account may be suspended or deleted if:\n\n'
              'False information is provided\n\n'
              'Fraudulent or fake activities are detected\n\n'
              'App features are misused\n\n'
              'Any of the Terms & Conditions are violated\n\n\n'
              'The company\'s decision will be final and binding.\n\n\n'
              '---\n\n'
              '💳 9. Refund Policy\n\n'
              'All Pro subscriptions are non-refundable.\n\n'
              'In case of a technical issue (like double payment or app error), contact our support team for assistance.\n\n'
              'Refunds are only granted for genuine cases, and the final decision will be made by the company.\n\n\n'
              '---\n\n'
              '🧠 10. Student Behaviour\n\n'
              'Users must use the app in a respectful and positive manner.\n\n'
              'Any abusive comments, fake reviews, or inappropriate content uploads will lead to disciplinary action.\n\n'
              'BoardPrep PRO aims to maintain a safe and supportive learning environment for all.\n\n\n'
              '---\n\n'
              '⚖ 11. Legal Notice\n\n'
              'All content, design, and materials within BoardPrep PRO are protected by copyright.\n\n'
              'Any unauthorized use or reproduction may result in legal action.\n\n'
              'All disputes will fall under the jurisdiction of [Your City/State] courts.\n\n\n'
              '---\n\n'
              '📩 12. Contact Us\n\n'
              'For any questions, suggestions, or support, reach out to us at:\n\n'
              '📧 boardprappro@gmail.com\n'
              '📍 Address (optional): [Your office/school name]\n\n\n'
              'By using BoardPrep, you agree to all the above Terms & Conditions.\n\n'
              'Let\'s study smart, play fair, and grow together! 🚀\n\n'
              'Study hard, win rewards, and share with your friends! 🎁💪',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '🔒 BoardPrep PRO – Privacy Policy',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const SingleChildScrollView(
            child: Text(
              '🔒 BoardPrep PRO – Privacy Policy\n\n'
              'Last Updated: Oct23 2025\n\n'
              'Your privacy is important to us. This privacy policy explains how we collect, use, and protect your personal information.\n\n\n'
              '📋 Information We Collect\n\n'
              'Personal Information:\n'
              '- Name and class information provided during profile setup\n'
              '- Profile picture (optional)\n'
              '- Section and board details\n\n'
              'Usage Information:\n'
              '- Quiz progress and scores\n'
              '- App usage statistics\n'
              '- Device information for app functionality\n\n\n'
              '🎯 How We Use Your Information\n\n'
              '- To personalize your learning experience\n'
              '- To track your progress and achievements\n'
              '- To improve our app and services\n'
              '- To communicate important updates\n'
              '- To display on leaderboards (if opted in)\n\n\n'
              '🛡️ Data Protection\n\n'
              '- We implement security measures to protect your data\n'
              '- We do not sell or share your personal information with third parties\n'
              '- Data is stored securely on your device\n'
              '- We use encryption for data transmission\n\n\n'
              '🔑 Your Rights\n\n'
              '- You can delete your profile at any time\n'
              '- You can request information about your data\n'
              '- You can opt out of certain data collection features\n'
        
              '🔄 Changes to This Policy\n\n'
              'We may update this policy from time to time. We will notify you of any changes by posting the new policy in the app and updating the "Last Updated" date.\n\n\n'
              '📧 Contact Us\n\n'
              'If you have any questions about this Privacy Policy, please contact us at:\n'
              'boardprappro@gmail.com',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                
                // Welcome Header
                const Icon(
                  Icons.account_circle_rounded,
                  size: 80,
                  color: Color(0xFF7C9CFF),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Welcome! 🎉',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Let\'s set up your profile',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 16),
                // Added confirmation message
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C9CFF).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF7C9CFF).withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Text(
                    'After filling all details and tapping Continue, your information will be automatically sent to our WhatsApp number. We will keep your details to contact you if you win any gifts.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF9AA4BF),
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),

                // Profile Photo
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF7C9CFF),
                        width: 3,
                      ),
                      image: _profileImage != null
                          ? DecorationImage(
                              image: FileImage(_profileImage!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _profileImage == null
                        ? const Icon(
                            Icons.add_a_photo_rounded,
                            size: 40,
                            color: Color(0xFF7C9CFF),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap to add photo (optional)',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 32),

                // Name Field
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF121833).withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF7C9CFF).withValues(alpha: 0.3),
                    ),
                  ),
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Your Name *',
                      hintText: 'Enter your full name',
                      prefixIcon: Icon(Icons.person_rounded, color: Color(0xFF7C9CFF)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                    textCapitalization: TextCapitalization.words,
                  ),
                ),
                const SizedBox(height: 16),

                // Mobile Number Field
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF121833).withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF7C9CFF).withValues(alpha: 0.3),
                    ),
                  ),
                  child: TextField(
                    controller: _mobileController,
                    decoration: const InputDecoration(
                      labelText: 'Mobile Number *',
                      hintText: 'Enter your mobile number',
                      prefixIcon: Icon(Icons.phone_rounded, color: Color(0xFF7C9CFF)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ),
                const SizedBox(height: 16),

                // Email Field
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF121833).withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF7C9CFF).withValues(alpha: 0.3),
                    ),
                  ),
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email Address *',
                      hintText: 'Enter your email address',
                      prefixIcon: Icon(Icons.email_rounded, color: Color(0xFF7C9CFF)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                const SizedBox(height: 16),

                // School Name Field (Required)
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF121833).withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF4ECDC4).withValues(alpha: 0.3), // Teal border for school field
                    ),
                  ),
                  child: TextField(
                    controller: _schoolController,
                    decoration: const InputDecoration(
                      labelText: 'School Name *', // Marked as required
                      hintText: 'Enter your school name',
                      prefixIcon: Icon(Icons.school_rounded, color: Color(0xFF4ECDC4)), // Teal icon
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Inviter Number Field (Optional)
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF121833).withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFFFD700).withValues(alpha: 0.3), // Gold border for inviter field
                    ),
                  ),
                  child: TextField(
                    controller: _inviterController,
                    decoration: const InputDecoration(
                      labelText: 'Inviter Number (Optional)',
                      hintText: 'Enter your inviter\'s mobile number',
                      prefixIcon: Icon(Icons.group_add_rounded, color: Color(0xFFFFD700)), // Gold icon
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ),
                const SizedBox(height: 16),

                // Class Field (Fixed to Class 12)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF121833).withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF7C9CFF).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.school_rounded,
                        color: Color(0xFF7C9CFF),
                      ),
                      const SizedBox(width: 16),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Class',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9AA4BF),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Class 12',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7C9CFF).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Fixed',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF7C9CFF),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Class Section Dropdown
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF121833).withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF7C9CFF).withValues(alpha: 0.3),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedSection,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF7C9CFF)),
                      items: _sections.map((String section) {
                        return DropdownMenuItem<String>(
                          value: section,
                          child: Row(
                            children: [
                              const Icon(Icons.class_rounded, color: Color(0xFF7C9CFF), size: 20),
                              const SizedBox(width: 12),
                              Text('Section $section'),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedSection = newValue;
                          });
                        }
                      },
                      // Enable scrolling for long lists
                      menuMaxHeight: 300.0, // Explicitly set as double
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Board Dropdown
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF121833).withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF7C9CFF).withValues(alpha: 0.3),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedBoard,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF7C9CFF)),
                      items: _boards.map((String board) {
                        return DropdownMenuItem<String>(
                          value: board,
                          child: Row(
                            children: [
                              const Icon(Icons.school_rounded, color: Color(0xFF7C9CFF), size: 20),
                              const SizedBox(width: 12),
                              Text(board),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedBoard = newValue;
                          });
                        }
                      },
                      // Enable scrolling for long lists
                      menuMaxHeight: 300.0, // Explicitly set as double
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Terms and Conditions Checkbox
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF121833).withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF7C9CFF).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _termsAccepted,
                        onChanged: (bool? value) {
                          setState(() {
                            _termsAccepted = value ?? false;
                          });
                        },
                        activeColor: const Color(0xFF7C9CFF),
                        checkColor: Colors.white,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                            children: [
                              TextSpan(text: 'I accept the '),
                              TextSpan(
                                text: 'Terms & Conditions',
                                style: const TextStyle(
                                  color: Color(0xFF7C9CFF),
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()..onTap = () {
                                  // Show Terms & Conditions dialog
                                  _showTermsDialog(context);
                                },
                              ),
                              const TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: const TextStyle(
                                  color: Color(0xFF7C9CFF),
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()..onTap = () {
                                  // Show Privacy Policy dialog
                                  _showPrivacyDialog(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Continue Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _termsAccepted ? _saveProfile : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: _termsAccepted ? const Color(0xFF7C9CFF) : Colors.grey,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded),
                      ],
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

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}