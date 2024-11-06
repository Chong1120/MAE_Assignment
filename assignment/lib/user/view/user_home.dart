// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class UserHome extends StatefulWidget {
  final String userId; 
  const UserHome({super.key, required this.userId});

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  int _currentIndex = 0; 


  void navigateToPage(int index) {
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushNamed(context, '/user_community', arguments: {'userId': widget.userId});
        break;
      case 2:
        Navigator.pushNamed(context, '/user_report', arguments: {'userId': widget.userId});
        break;
      case 3:
        Navigator.pushNamed(context, '/user_nutrition', arguments: {'userId': widget.userId});
        break;
      case 4:
        Navigator.pushNamed(context, '/user_profile', arguments: {'userId': widget.userId});
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, '/user_notification', arguments: {'userId': widget.userId});
            },
          ),
          IconButton(
            icon: const Icon(Icons.feedback),
            onPressed: () {
              Navigator.pushNamed(context, '/user_feedback', arguments: {'userId': widget.userId});
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Here is user Homepage"),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          navigateToPage(index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.apartment_rounded), label: 'Community'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_graph), label: 'Report'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'Nutrition'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        backgroundColor: Colors.blue, 
        selectedItemColor: const Color.fromARGB(255, 47, 22, 113),
        unselectedItemColor: Colors.black,
      ),
    );
  }
}