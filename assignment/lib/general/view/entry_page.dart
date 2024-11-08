// lib/entry_page.dart
import 'package:flutter/material.dart';
import 'dart:async'; // Import for Timer

class EntryPage extends StatefulWidget {
  const EntryPage({Key? key}) : super(key: key);

  @override
  _EntryPageState createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String _displayText = '';
  final String _fullText = 'Welcome to FITSPHERE';
  int _textIndex = 0;
  bool _showButtons = false;

  @override
  void initState() {
    super.initState();

    // Animation for the logo
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 100, end: 0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // Start the logo animation
    _controller.forward();

    // Start the typewriter effect
    _typeWriterAnimation();

    // Show buttons after the text is displayed
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _showButtons = true; // Show buttons after text animation
      });
    });
  }

  // Typewriter animation function
  void _typeWriterAnimation() {
    Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (_textIndex < _fullText.length) {
        setState(() {
          _displayText += _fullText[_textIndex];
          _textIndex++;
        });
      } else {
        timer.cancel(); // Stop the timer when done
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ascending animation for the logo
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1), // Start from below
                end: Offset.zero, // End at the center
              ).animate(CurvedAnimation(
                parent: _controller,
                curve: Curves.easeOut,
              )),
              child: Image.asset(
                'lib/assets/FITSPHERE.png',
                height: MediaQuery.of(context).size.height * 0.25,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            // Typewriter animation for the welcome text
            Text(
              _displayText,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            // Show buttons only after text animation is complete
            if (_showButtons) ...[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed('/login'); // Navigate to login page
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed('/sign_up'); // Navigate to sign-up page
                },
                child: const Text('Sign Up'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
