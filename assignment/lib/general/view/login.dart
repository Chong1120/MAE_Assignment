// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, use_super_parameters

import 'package:flutter/material.dart';
import '../feature/login_f.dart'; // Import the login function file

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showError = false;
  String? _userId; // Variable to hold the userId

  void _handleLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    final result = await checkLogin(username, password);

    if (result != null) {
      // Store userId and navigate based on category
      _userId = result['userId'];
      final category = result['category'];

      if (category == 'admin') {
        Navigator.pushNamed(context, '/admin_home', arguments: {'userId': _userId});
      } else if (category == 'coach') {
        Navigator.pushNamed(context, '/coach_home', arguments: {'userId': _userId});
      } else if (category == 'user') {
        Navigator.pushNamed(context, '/user_notification', arguments: _userId);
      }
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

  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('lib/assets/FITSPHERE.png', height: 150),
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

              // Password TextField with Eye Icon
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isPasswordVisible,
              ),
              const SizedBox(height: 10),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/forget_password');
                  },
                  child: const Text('Forgot Password?'),
                ),
              ),
              const SizedBox(height: 20),

              // Login Button
              ElevatedButton(
                onPressed: _handleLogin,
                child: const Text('Login'),
              ),
              const SizedBox(height: 20),

              // Error Message
              if (_showError)
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.red.withOpacity(0.7),
                  child: const Text(
                    'Invalid username and password, please try again!',
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
