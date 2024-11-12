import 'package:flutter/material.dart';
import '../feature/signup_f.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _usernameController = TextEditingController();
  bool _isMale = true; // Default to male, update if needed.
  TextEditingController _userheightController = TextEditingController();
  TextEditingController _userpasswordController = TextEditingController();
  TextEditingController _usersecretpasController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(Icons.male, color: _isMale ? Colors.blue : Colors.grey),
                    onPressed: () => setState(() => _isMale = true)
                  ),
                  IconButton(
                    icon: Icon(Icons.female, color: !_isMale ? Colors.pink : Colors.grey),
                    onPressed: () => setState(() => _isMale = false)
                  ),
                ],
              ),
              TextField(
                controller: _userheightController,
                decoration: const InputDecoration(
                  labelText: 'Height',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _userpasswordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _usersecretpasController,
                decoration: const InputDecoration(
                  labelText: 'Secret Word',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  bool isSuccess = await saveNewUser(
                    null, _usernameController.text, 
                    _isMale ? 'male' : 'female', _userheightController.text,
                    _userpasswordController.text, _usersecretpasController.text
                  );
                  if (isSuccess) {
                    _showSuccessDialog();
                  }
                },
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showSuccessDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Congratulations!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('You have successfully signed up.'),
                Text('Welcome to FITSPHERE!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Navigate back to the previous screen
              },
            ),
          ],
        );
      },
    );
  }
}
