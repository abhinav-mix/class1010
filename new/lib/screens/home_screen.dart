import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SmartlinkService {
  static const String _SMARTLINK_URL = 'YOUR_ADSTERRA_SMARTLINK_URL_HERE';
  static const String _PREFERENCE_KEY = 'smartlink_first_click_done';

  static final SmartlinkService _instance = SmartlinkService._internal();
  factory SmartlinkService() => _instance;
  SmartlinkService._internal();

  /// Checks if this is the user's first click and triggers the smartlink if so
  static Future<void> handleFirstClick() async {
    final prefs = await SharedPreferences.getInstance();
    final bool hasClicked = prefs.getBool(_PREFERENCE_KEY) ?? false;

    // If this is the first click, open the smartlink and mark it as done
    if (!hasClicked) {
      await _openSmartlink();
      await prefs.setBool(_PREFERENCE_KEY, true);
    }
  }

  /// Opens the Adsterra Smartlink in the browser
  static Future<void> _openSmartlink() async {
    final Uri url = Uri.parse(_SMARTLINK_URL);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}