// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class AdminProfile extends StatefulWidget {
  final String userId; 
  const AdminProfile({super.key, required this.userId});

  @override
  _AdminProfileState createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Here is admin Profile"),
          ],
        ),
      ),
    );
  }
}