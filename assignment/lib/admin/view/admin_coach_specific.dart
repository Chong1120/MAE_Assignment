import 'package:flutter/material.dart';
import '../feature/admin_manage_f.dart';

class AdminCoachSpecific extends StatefulWidget {
  final Map<String, dynamic> coach;
  const AdminCoachSpecific({Key? key, required this.coach}) : super(key: key);

  @override
  _AdminCoachSpecificState createState() => _AdminCoachSpecificState();
}

class _AdminCoachSpecificState extends State<AdminCoachSpecific> {
  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  late TextEditingController _secretPassController;
  late TextEditingController _passwordController;
  late bool _isMale;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.coach['username']);
    _bioController = TextEditingController(text: widget.coach['bio']);
    _secretPassController = TextEditingController(text: widget.coach['secretpas']);
    _passwordController = TextEditingController(text: widget.coach['password']);
    _isMale = widget.coach['gender'] == 'male';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Coach'),
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
          TextField(controller: _bioController, decoration: const InputDecoration(labelText: 'Bio')),
          TextField(controller: _secretPassController, decoration: const InputDecoration(labelText: 'Secret Pass')),
          TextField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Password')),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await updateCoach(widget.coach['id'],_usernameController.text,
              _isMale ? 'male' : 'female',
              _bioController.text,
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
