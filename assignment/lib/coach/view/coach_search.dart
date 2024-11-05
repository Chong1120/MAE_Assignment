// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class CoachSearch extends StatefulWidget {
  final String userId; 
  const CoachSearch({super.key, required this.userId});

  @override
  _CoachSearchState createState() => _CoachSearchState();
}

class _CoachSearchState extends State<CoachSearch> {
  int _currentIndex = 1; 


  void navigateToPage(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/coach_home', arguments: {'userId': widget.userId});
        break;
      case 1:
        break;
      case 2:
        Navigator.pushNamed(context, '/coach_add', arguments: {'userId': widget.userId});
        break;
      case 3:
        Navigator.pushNamed(context, '/coach_report', arguments: {'userId': widget.userId});
        break;
      case 4:
        Navigator.pushNamed(context, '/coach_profile', arguments: {'userId': widget.userId});
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Search'),
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
            Text("Here is coach Searchpage"),
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
