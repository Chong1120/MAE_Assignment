// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class CoachProfile extends StatefulWidget {
  final String userId; 
  const CoachProfile({super.key, required this.userId});

  @override
  _CoachProfileState createState() => _CoachProfileState();
}

class _CoachProfileState extends State<CoachProfile> {
  int _currentIndex = 4; 


  void navigateToPage(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/coach_home', arguments: {'userId': widget.userId});
        break;
      case 1:
        Navigator.pushNamed(context, '/coach_search', arguments: {'userId': widget.userId});
        break;
      case 2:
        Navigator.pushNamed(context, '/coach_add', arguments: {'userId': widget.userId});
        break;
      case 3:
        Navigator.pushNamed(context, '/coach_report', arguments: {'userId': widget.userId});
        break;
      case 4:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, '/coach_notification', arguments: {'userId': widget.userId});
            },
          ),
          IconButton(
            icon: const Icon(Icons.feedback),
            onPressed: () {
              Navigator.pushNamed(context, '/coach_feedback', arguments: {'userId': widget.userId});
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Here is coach Profilepage"),
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
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_graph), label: 'Report'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        backgroundColor: Colors.blue, 
        selectedItemColor: const Color.fromARGB(255, 47, 22, 113),
        unselectedItemColor: Colors.black,
      ),
    );
  }
}
