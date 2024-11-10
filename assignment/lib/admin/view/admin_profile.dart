// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../feature/admin_profile_f.dart';

class AdminProfile extends StatefulWidget {
  final String userId; 
  const AdminProfile({super.key, required this.userId});

  @override
  _AdminProfileState createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  String? _username;

  @override
  void initState() {
    super.initState();
    _fetchUsername();
  }
  
  Future<void> _fetchUsername() async {
    final username = await searchUser(widget.userId);
    setState(() {
      _username = username;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Username: $_username'),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}
