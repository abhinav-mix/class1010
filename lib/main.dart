import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'screens/profile_setup_screen.dart';
import 'screens/points_system_screen.dart';
import 'screens/invite_friends_screen.dart';
import 'services/whatsapp_service.dart';
import 'services/theme_service.dart'; // Added theme service import
import 'screens/qr_display_screen.dart'; // Import the new QR display screen
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const QuizApp());
}

class QuizApp extends StatefulWidget {
  const QuizApp({super.key});

  @override
  State<QuizApp> createState() => _QuizAppState();
}

class _QuizAppState extends State<QuizApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final themeMode = await ThemeService.getThemeMode();
    setState(() {
      _themeMode = themeMode;
    });
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
      ThemeService.saveThemeMode(themeMode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quick Quiz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF7C9CFF),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF7C9CFF),
          secondary: const Color(0xFF4ECDC4),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF7C9CFF),
        scaffoldBackgroundColor: const Color(0xFF0B1020),
        fontFamily: 'Roboto',
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF7C9CFF),
          secondary: Color(0xFF4ECDC4),
        ),
      ),
      themeMode: _themeMode,
      home: ConnectivityChecker(themeChanger: changeTheme), // Pass theme changer to connectivity checker
    );
  }
}

class ConnectivityChecker extends StatefulWidget {
  final Function(ThemeMode) themeChanger; // Added theme changer parameter

  const ConnectivityChecker({super.key, required this.themeChanger});

  @override
  State<ConnectivityChecker> createState() => _ConnectivityCheckerState();
}

class _ConnectivityCheckerState extends State<ConnectivityChecker> {
  bool _isConnected = false;
  bool _profileCompleted = false;
  bool _paymentCompleted = false;
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkEverything();

    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (mounted) {
        setState(() {
          _isConnected = result != ConnectivityResult.none;
        });
      }
    });
  }

  Future<void> _checkEverything() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getBool('profile_completed') ?? false;
    
    // Check for payment completion flag properly
    final paymentCompleted = prefs.getBool('payment_completed') ?? false;
    
    print('DEBUG: profileCompleted = $completed');
    print('DEBUG: paymentCompleted = $paymentCompleted');
    
    if (mounted) {
      setState(() {
        _isConnected = connectivityResult != ConnectivityResult.none;
        _profileCompleted = completed;
        _paymentCompleted = paymentCompleted; // Use the payment completion flag
        _isChecking = false;
      });
    }

    _handleFirstTimeAppOpen(prefs);
  }

  /// Handle first time app open - send user profile to WhatsApp
  Future<void> _handleFirstTimeAppOpen(SharedPreferences prefs) async {
    if (await WhatsappService.isFirstTimeAppOpen()) {
      // Get user profile data
      final name = prefs.getString('profile_name') ?? '';
      final mobile = prefs.getString('profile_mobile') ?? '';
      final email = prefs.getString('profile_email') ?? '';
      final section = prefs.getString('profile_section') ?? 'A';
      final board = prefs.getString('profile_board') ?? 'CBSE';
      final school = prefs.getString('profile_school') ?? ''; // Get school name
      final inviter = prefs.getString('profile_inviter') ?? ''; // Get inviter number
      final imagePath = prefs.getString('profile_image');

      // Only send if we have user data (meaning they've completed profile setup)
      if (name.isNotEmpty && mobile.isNotEmpty && email.isNotEmpty) {
        // Send user profile to WhatsApp (class is automatically added as "Class 12")
        await WhatsappService.sendUserProfileToWhatsApp(
          name, mobile, email, section, board, imagePath, inviter, school
        );

        // Mark that we've handled the first time app open
        await WhatsappService.markFirstTimeAppOpen();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) { // Use _isChecking here
      print('DEBUG: Showing loading screen');
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF7C9CFF),
          ),
        ),
      );
    }

    if (!_isConnected) { // Use _isConnected here
      print('DEBUG: Showing no internet screen');
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
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFEF4444).withOpacity(0.2), // Corrected withValues to withOpacity
                      border: Border.all(
                        color: const Color(0xFFEF4444).withOpacity(0.5), // Corrected withValues to withOpacity
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.wifi_off_rounded,
                      size: 80,
                      color: Color(0xFFEF4444),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'No Internet Connection',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'कृपया अपना मोबाइल डेटा या Wi-Fi चालू करें\nPlease turn on mobile data or Wi-Fi',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.6), // Corrected withValues to withOpacity
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _isChecking = true; // Use _isChecking here
                      });
                      _checkEverything();
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      backgroundColor: const Color(0xFF7C9CFF),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Check if profile is completed
    if (!_profileCompleted) { // Use _profileCompleted here
      print('DEBUG: Showing profile setup screen');
      return const ProfileSetupScreen();
    }

    // Check if payment is completed - if not, always show payment screen
    // This ensures the payment screen persists until payment is completed
    if (!_paymentCompleted) {
      print('DEBUG: Showing QR display screen');
      return QrDisplayScreen(themeChanger: widget.themeChanger);
    }

    // If both profile and payment are completed, show home screen
    print('DEBUG: Showing home screen');
    return HomeScreen(themeChanger: widget.themeChanger); // Pass theme changer to home screen
  }
}