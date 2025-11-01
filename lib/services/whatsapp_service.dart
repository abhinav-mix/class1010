import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class WhatsappService {
  static const String whatsappNumber = '7253076678'; // Your WhatsApp number
  static const String whatsappUrl = 'https://whatsapp.com/channel/0029VbBizSE2P59kaQsBpC3C';
  static const String lastPromptKey = 'last_whatsapp_prompt';
  static const String firstTimeAppOpenKey = 'first_time_app_open';
  static const int promptIntervalDays = 7; // 1 week

  static final WhatsappService _instance = WhatsappService._internal();
  factory WhatsappService() => _instance;
  WhatsappService._internal();

  /// Checks if it's the first time the app is opened
  static Future<bool> isFirstTimeAppOpen() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool(firstTimeAppOpenKey) ?? true;
    return isFirstTime;
  }

  /// Marks that the app has been opened for the first time
  static Future<void> markFirstTimeAppOpen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(firstTimeAppOpenKey, false);
  }

  /// Checks if it's time to show the WhatsApp prompt
  static Future<bool> shouldShowPrompt() async {
    final prefs = await SharedPreferences.getInstance();
    final lastPrompt = prefs.getInt(lastPromptKey) ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    final daysSinceLastPrompt = (now - lastPrompt) ~/ (1000 * 60 * 60 * 24);
    
    return daysSinceLastPrompt >= promptIntervalDays;
  }

  /// Reset the prompt timer (call when user joins)
  static Future<void> resetPromptTimer() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(lastPromptKey, DateTime.now().millisecondsSinceEpoch);
  }

  /// Records that the prompt was shown
  static Future<void> recordPromptShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(lastPromptKey, DateTime.now().millisecondsSinceEpoch);
  }

  /// Sends user profile information to WhatsApp
  static Future<void> sendUserProfileToWhatsApp(String name, String mobile, String email, 
      String section, String board, String? imagePath, [String? inviterNumber, String? schoolName]) async {
    
    // Create message with user details
    final userDetails = 
        'New User Registration:\n'
        'Name: $name\n'
        'Mobile: $mobile\n'
        'Email: $email\n'
        'Class: Class 12\n' // Automatically add Class 12
        'Section: $section\n'
        'Board: $board\n'
        // Add school information if provided
        '${schoolName != null && schoolName.isNotEmpty ? 'School: $schoolName\n' : ''}'
        // Add inviter information if provided
        '${inviterNumber != null && inviterNumber.isNotEmpty ? 'Inviter: $inviterNumber\n' : ''}'
        'Registration Date: ${DateTime.now().toString()}';

    if (imagePath != null && imagePath.isNotEmpty) {
      // If we have an image, we'll send it separately
      // First send the text message
      final textMessageUrl = 'https://wa.me/$whatsappNumber?text=${Uri.encodeComponent(userDetails)}';
      
      if (await canLaunchUrl(Uri.parse(textMessageUrl))) {
        await launchUrl(Uri.parse(textMessageUrl));
      }
      
      // Then send the image (this would require a different approach)
      // For now, we'll just send the text message with a note about the image
      final messageWithImageNote = '$userDetails\n\nUser photo was captured during registration.';
      final finalUrl = 'https://wa.me/$whatsappNumber?text=${Uri.encodeComponent(messageWithImageNote)}';
      
      if (await canLaunchUrl(Uri.parse(finalUrl))) {
        await launchUrl(Uri.parse(finalUrl));
      }
    } else {
      // Send only text message
      final whatsappUrl = 'https://wa.me/$whatsappNumber?text=${Uri.encodeComponent(userDetails)}';
      
      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        await launchUrl(Uri.parse(whatsappUrl));
      }
    }
  }

  /// Opens the WhatsApp channel
  static Future<void> openWhatsappChannel() async {
    final Uri url = Uri.parse(whatsappUrl);
    print('Attempting to launch WhatsApp URL: $whatsappUrl');
    print('URL can be launched: ${await canLaunchUrl(url)}');
    
    if (await canLaunchUrl(url)) {
      print('Launching WhatsApp URL...');
      await launchUrl(url, mode: LaunchMode.externalApplication);
      print('WhatsApp URL launched successfully');
    } else {
      // Fallback: try opening in browser
      print('Trying fallback method...');
      final Uri fallbackUrl = Uri.parse(whatsappUrl);
      if (await canLaunchUrl(fallbackUrl)) {
        await launchUrl(fallbackUrl);
        print('Fallback URL launched successfully');
      } else {
        // Show error message
        print('Could not launch WhatsApp channel URL: $whatsappUrl');
        // Show a snackbar to inform the user
        // Note: This requires a BuildContext which we don't have here
      }
    }
  }
}