import 'package:flutter/material.dart';
import '../feature/signup_f.dart';

class SignUp extends StatefulWidget{
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp>{
//gender, height, password, secretpas, username
//username, gender, height, password, secretpas

  late TextEditingController _usernameController;
  late bool _isMale;
  late TextEditingController _userheightController;
  late TextEditingController _userpasswordController;
  late TextEditingController _usersecretpasController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: "");
    _userheightController = TextEditingController(text: "");
    _userpasswordController = TextEditingController(text: "");
    _usersecretpasController = TextEditingController(text: "");
    _isMale = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: _usernameController, decoration: const InputDecoration(labelText: 'Username', 
            border: OutlineInputBorder(),
            ),
            ),
            const SizedBox(height: 20,width: 20),
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.male, color: _isMale? Colors.blue : Colors.grey),
              onPressed: () => setState(() => _isMale = true)
            ),
            IconButton(
              icon: Icon(Icons.female, color: !_isMale? Colors.pink : Colors.grey),
              onPressed: () => setState(() => _isMale = false)
            ),
          ],
          ),
          TextField(controller: _userheightController, decoration: const InputDecoration(labelText: 'Height',
            border: OutlineInputBorder(),
            ),
            ),
            const SizedBox(height: 20,width: 20),
          TextField(controller: _userpasswordController, decoration: const InputDecoration(labelText: 'Password',
          border: OutlineInputBorder(),
          ),
          ),
          const SizedBox(height: 20,width: 20),
          TextField(controller: _usersecretpasController, decoration: const InputDecoration(labelText: 'Secret Word',
          border: OutlineInputBorder(),
          ),
          ),
          const SizedBox(height: 20,width: 20),
          ElevatedButton(
            onPressed: () async {
              await saveNewUser(
                null, _usernameController.text, 
                _isMale ? 'male' : 'female', _userheightController.text,
                _userpasswordController.text, _usersecretpasController.text
              );
              Navigator.pop(context);
            },
            child: const Text('Sign Up',),
          ),
        ],
        ),
      ),
      ),
    );
  }
  
}