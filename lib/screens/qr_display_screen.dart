import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz_app/screens/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart'; // Add this import
import 'dart:convert';
import 'dart:async';
import 'dart:io' show exit, File; // Add File import

class QrDisplayScreen extends StatefulWidget {
  final Function(ThemeMode) themeChanger;

  const QrDisplayScreen({super.key, required this.themeChanger});

  @override
  State<QrDisplayScreen> createState() => _QrDisplayScreenState();
}

class _QrDisplayScreenState extends State<QrDisplayScreen> {
  final TextEditingController _utrController = TextEditingController();
  final TextEditingController _couponController = TextEditingController(); // New coupon controller
  String _utrStatus = '';
  bool _utrSubmitted = false;
  DateTime _screenOpenedTime = DateTime.now();
  String _currentQrImage = 'assets/qr.png'; // Track current QR image
  File? _paymentProofImage; // Add this for image upload
  final ImagePicker _picker = ImagePicker(); // Add image picker

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _utrController.dispose();
    _couponController.dispose(); // Dispose coupon controller
    super.dispose();
  }

  // Method to pick image from gallery
  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _paymentProofImage = File(image.path);
      });
    }
  }

  // Method to capture image from camera
  Future<void> _captureImageFromCamera() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _paymentProofImage = File(image.path);
      });
    }
  }

  // Method to show image source selection dialog
  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Row(
                    children: [
                      Icon(Icons.photo_library, color: Colors.blue),
                      SizedBox(width: 10),
                      Text('Choose from Gallery'),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImageFromGallery();
                  },
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  child: const Row(
                    children: [
                      Icon(Icons.camera_alt, color: Colors.green),
                      SizedBox(width: 10),
                      Text('Take a Photo'),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    _captureImageFromCamera();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Method to apply coupon
  void _applyCoupon() {
    final String coupon = _couponController.text.trim();
    
    if (coupon == '100') {
      setState(() {
        _currentQrImage = 'assets/50.png'; // Use special QR code
        _utrStatus = 'Coupon applied! Special QR code activated.';
      });
    } else {
      setState(() {
        _utrStatus = 'Invalid coupon code. Please try again.';
      });
    }
  }

  Future<void> _submitUtr() async {
    final String utr = _utrController.text.trim();
    
    if (utr.isEmpty) {
      setState(() {
        _utrStatus = 'Please enter UTR';
      });
      return;
    }

    // Check if payment proof image is uploaded
    if (_paymentProofImage == null) {
      setState(() {
        _utrStatus = 'Please upload payment proof (screenshot/photo)';
      });
      _showErrorDialog('Please upload payment proof (screenshot/photo) before submitting payment.');
      return;
    }

    // Check if UTR was submitted within 2 minutes of screen opening
    final twoMinutesAgo = DateTime.now().subtract(const Duration(minutes: 2));
    if (_screenOpenedTime.isBefore(twoMinutesAgo)) {
      setState(() {
        _utrStatus = 'Time expired! Payment must be within 2 minutes of QR display.';
        _utrSubmitted = true;
      });
      
      // Show dialog and prevent proceeding
      _showErrorDialog('Payment time expired! You must enter UTR within 2 minutes. App access denied.');
      return;
    }

    // Show loading state
    setState(() {
      _utrStatus = 'Processing payment...';
      _utrSubmitted = true;
    });

    try {
      // Send UTR and payment proof to WhatsApp
      await _sendToWhatsApp(utr);
      
      // Store a flag in SharedPreferences to indicate payment completion
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('payment_completed', true);
      
      setState(() {
        _utrStatus = 'Payment successful! Redirecting to app...';
      });
      
      // Navigate to home screen after a brief delay (replace current screen)
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreen(themeChanger: widget.themeChanger),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _utrStatus = 'Error processing payment: $e';
        _utrSubmitted = false;
      });
      
      _showErrorDialog('Error processing payment: $e');
    }
  }

  // Method to send UTR and payment proof to WhatsApp
  Future<void> _sendToWhatsApp(String utr) async {
    try {
      // First, upload the payment proof to the backend
      if (_paymentProofImage != null) {
        await _uploadPaymentProof(utr);
      }
      
      // Create message with UTR and payment details
      final message = 
          'New Payment Registration:\n'
          'UTR/Reference Number: $utr\n'
          'Payment Date: ${DateTime.now().toString()}\n'
          'User Details:\n'
          '- Name: ${await _getUserDetail('profile_name')}\n'
          '- Mobile: ${await _getUserDetail('profile_mobile')}\n'
          '- Email: ${await _getUserDetail('profile_email')}\n'
          '- Class: Class 12\n'
          '- Section: ${await _getUserDetail('profile_section')}\n'
          '- Board: ${await _getUserDetail('profile_board')}\n'
          '- School: ${await _getUserDetail('profile_school')}';

      // Create WhatsApp URL with message
      final whatsappUrl = 'https://wa.me/7253076678?text=${Uri.encodeComponent(message)}';
      
      // Note: In a real implementation, you would use a backend service
      // to send the message and image to WhatsApp
      // For now, we'll just print the message for demonstration
      
      print('WhatsApp Message: $message');
      print('Payment proof image would be sent to WhatsApp along with this message');
      
    } catch (e) {
      print('Error sending to WhatsApp: $e');
      rethrow;
    }
  }

  // Method to upload payment proof to backend
  Future<void> _uploadPaymentProof(String utr) async {
    try {
      // Create multipart request
      // Using your actual Render.com deployment URL
      final url = Uri.parse('https://class1010.onrender.com/upload-payment-proof');
      final request = http.MultipartRequest('POST', url);
      
      // Add UTR field
      request.fields['utr'] = utr;
      
      // Add file
      final file = await http.MultipartFile.fromPath(
        'paymentProof',
        _paymentProofImage!.path,
      );
      request.files.add(file);
      
      // Send request
      final response = await request.send();
      
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(responseBody);
        print('Upload response: $jsonResponse');
      } else {
        throw Exception('Failed to upload payment proof: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading payment proof: $e');
      rethrow;
    }
  }

  // Helper method to get user details from SharedPreferences
  Future<String> _getUserDetail(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? 'Not provided';
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Payment Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    // Close the entire app when back button is pressed
    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Complete Payment'),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '🎉 Unlock Premium Features & Amazing Rewards! 🎉',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Complete this one-time payment to access PRO features and win exciting prizes!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '🎁 What You Get:',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '✅ Full access to all subjects & chapters\n✅ Unlimited practice quizzes\n✅ Detailed performance analytics\n✅ Ad-free experience\n✅ Exclusive PRO badges & rewards',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '🏆 Special Giveaway Prizes:',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '📱 Smartphones & Tablets\n💻 Laptops & Desktops\n🎧 Headphones & Earbuds\n🎮 Gaming Consoles\n📚 Educational Books & Courses\n🎁 And many more exciting gifts!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Step 1: Apply Coupon (Optional)',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _couponController,
                          decoration: const InputDecoration(
                            labelText: 'Enter Coupon Code',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _applyCoupon,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          textStyle: const TextStyle(fontSize: 16),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Apply'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Step 2: Scan the QR code below to make payment',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  // Use a Container with a border to ensure the QR code is visible
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _currentQrImage == 'assets/50.png' ? Colors.green : Colors.black, 
                        width: _currentQrImage == 'assets/50.png' ? 4 : 2,
                      ),
                    ),
                    child: Image.asset(
                      _currentQrImage, // Use dynamic QR image based on coupon
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        // If the image fails to load, show a placeholder with error message
                        return Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error, color: Colors.red, size: 50),
                                Text('QR Code not found', 
                                     textAlign: TextAlign.center,
                                     style: TextStyle(color: Colors.red)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Step 3: After making the payment, enter the UTR/Bank Reference number below:',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _utrController,
                    decoration: const InputDecoration(
                      labelText: 'Enter UTR/Reference Number',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Step 4: Upload Payment Proof (Screenshot/Photo) *Required:',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _showImageSourceDialog, // Changed to show dialog
                          icon: const Icon(Icons.upload_file),
                          label: const Text('Upload Payment Proof *'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            textStyle: const TextStyle(fontSize: 16),
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_paymentProofImage != null) ...[
                    const SizedBox(height: 10),
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Image.file(
                              _paymentProofImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _paymentProofImage = null;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _utrSubmitted ? null : _submitUtr,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                    child: _utrSubmitted
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Submit Payment & Claim Rewards'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _utrStatus,
                    style: TextStyle(
                      fontSize: 14,
                      color: _utrStatus.contains('successful') 
                        ? Colors.green 
                        : (_utrStatus.contains('expired') || _utrStatus.contains('Error') 
                           ? Colors.red 
                           : Colors.black54),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '⏰ Note: You must enter the UTR within 2 minutes of QR display to claim your rewards!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.orange),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '🔒 Secure Payment | 💯 Satisfaction Guaranteed',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}