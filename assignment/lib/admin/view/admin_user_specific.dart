import 'package:flutter/material.dart';
import '../feature/admin_manage_f.dart';

class AdminUserSpecific extends StatefulWidget {
  final Map<String, dynamic> user;
  const AdminUserSpecific({Key? key, required this.user}) : super(key: key);

  @override
  _AdminUserSpecificState createState() => _AdminUserSpecificState();
}

class _AdminUserSpecificState extends State<AdminUserSpecific> {
  late TextEditingController _usernameController;
  late TextEditingController _heightController;
  late TextEditingController _secretPassController;
  late TextEditingController _passwordController;
  late bool _isMale;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user['username']);
    _heightController = TextEditingController(text: widget.user['height']);
    _secretPassController = TextEditingController(text: widget.user['secretpas']);
    _passwordController = TextEditingController(text: widget.user['password']);
    _isMale = widget.user['gender'] == 'male';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit User'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: _usernameController, decoration: const InputDecoration(labelText: 'Username')),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.male, color: _isMale ? Colors.blue : Colors.grey),
                onPressed: () => setState(() => _isMale = true),
              ),
              IconButton(
                icon: Icon(Icons.female, color: !_isMale ? Colors.pink : Colors.grey),
                onPressed: () => setState(() => _isMale = false),
              ),
            ],
          ),
          TextField(controller: _heightController, decoration: const InputDecoration(labelText: 'Height')),
          TextField(controller: _secretPassController, decoration: const InputDecoration(labelText: 'Secret Pass')),
          TextField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Password')),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await updateUser(widget.user['id'],_usernameController.text,
              _isMale ? 'male' : 'female',
              _heightController.text,
              _passwordController.text,
              _secretPassController.text,
            );
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
