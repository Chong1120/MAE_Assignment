// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import '../feature/forget_password_f.dart'; // Import the forget password function file

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _secretWordController = TextEditingController();
  bool _showError = false;

  void _handleReset() async {
    final username = _usernameController.text.trim();
    final secretWord = _secretWordController.text.trim();

    final result = await checkSecretWord(username, secretWord);

    if (result) {
      _showNewPasswordDialog();
    } else {
      setState(() {
        _showError = true;
      });
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _showError = false;
        });
      });
    }
  }

  void _showNewPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController _newPasswordController = TextEditingController();
        return AlertDialog(
          title: const Text('Enter New Password'),
          content: TextField(
            controller: _newPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'New Password',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final newPassword = _newPasswordController.text.trim();
                final username = _usernameController.text.trim();
                await updatePassword(username, newPassword);
                Navigator.pop(context); // Close the dialog
                Navigator.pushNamed(context, '/reset_success');
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Forgot Password',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),

              // Username TextField
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Secret Word TextField
              TextField(
                controller: _secretWordController,
                decoration: const InputDecoration(
                  labelText: 'Secret Word',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Reset Button
              ElevatedButton(
                onPressed: _handleReset,
                child: const Text('Reset Password'),
              ),
              const SizedBox(height: 20),

              // Error Message
              if (_showError)
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.red.withOpacity(0.7),
                  child: const Text(
                    'Invalid secret word',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
