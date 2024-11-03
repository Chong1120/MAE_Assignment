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
  bool _showError = false; // To control error message visibility

  void _handleLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    final result = await checkLogin(username, password);

    if (result == 'admin') {
      Navigator.pushNamed(context, '/admin_announcement');
    } else if (result == 'coach') {
      Navigator.pushNamed(context, '/coach_notification');
    } else if (result == 'user') {
      Navigator.pushNamed(context, '/user_notification');
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

  bool _isPasswordVisible = false; // Track password visibility

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

              // Forgot Password Button
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
