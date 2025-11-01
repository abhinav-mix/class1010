import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz_app/screens/home_screen.dart'; // Assuming HomeScreen is in quiz_app/screens
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:uuid/uuid.dart';

class QrPaymentScreen extends StatefulWidget {
  final Function(ThemeMode) themeChanger; // Restore original parameter
  final bool isDialog; // Add a flag to indicate if this is used as a dialog

  const QrPaymentScreen({super.key, required this.themeChanger, this.isDialog = false});

  @override
  State<QrPaymentScreen> createState() => _QrPaymentScreenState();
}

class _QrPaymentScreenState extends State<QrPaymentScreen> {
  String _transactionId = '';
  final Uuid _uuid = const Uuid();
  bool _paymentConfirmed = false;
  final TextEditingController _utrController = TextEditingController();
  String _utrStatus = '';
  bool _utrSubmitted = false;
  DateTime _screenOpenedTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _generateTransactionId();
  }

  @override
  void dispose() {
    _utrController.dispose();
    super.dispose();
  }

  void _generateTransactionId() {
    setState(() {
      _transactionId = _uuid.v4();
    });
  }

  Future<void> _submitUtr() async {
    final String utr = _utrController.text.trim();
    
    if (utr.isEmpty) {
      setState(() {
        _utrStatus = 'Please enter UTR';
      });
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
      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 2));
      
      // In a real app, you would verify the UTR with your backend
      // For now, we'll assume it's valid if entered within time
      
      // Store transactionId in SharedPreferences upon successful payment
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('transaction_id', _transactionId);
      
      setState(() {
        _utrStatus = 'Payment successful! Redirecting to app...';
      });
      
      // If this is a dialog, close it and let the home screen handle navigation
      if (widget.isDialog) {
        // Navigate to home screen after a brief delay
        await Future.delayed(const Duration(seconds: 1));
        
        if (mounted) {
          Navigator.of(context).pop(); // Close the dialog
        }
      } else {
        // Navigate to home screen after a brief delay
        await Future.delayed(const Duration(seconds: 1));
        
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomeScreen(themeChanger: widget.themeChanger),
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _utrStatus = 'Error processing payment: $e';
      });
      
      _showErrorDialog('Error processing payment: $e');
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isDialog ? null : AppBar( // No app bar in dialog mode
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
                  'Welcome! To access the app, please complete the payment:',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Step 1: Scan the QR code below to make payment',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                // Use a Container with a border to ensure the QR code is visible
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Image.asset(
                    'assets/qr.png',
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
                  'Step 2: After making the payment, enter the UTR/Bank Reference number below:',
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
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _utrSubmitted ? null : _submitUtr,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: _utrSubmitted
                      ? const CircularProgressIndicator()
                      : const Text('Submit Payment'),
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
                  'Note: You must enter the UTR within 2 minutes of QR display.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.orange),
                ),
                const SizedBox(height: 20),
                Text(
                  'Transaction ID: $_transactionId',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}