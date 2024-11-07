import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class UserHome extends StatefulWidget {
  final String userId;
  const UserHome({super.key, required this.userId});

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  int _currentIndex = 0;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  Map<String, dynamic> _activities = {};
  String? _selectedActivityId;

  @override
  void initState() {
    super.initState();
    _fetchActivities(); // Fetch activities when the page loads
  }

  void _fetchActivities() async {
    try {
      final snapshot = await _dbRef.child('activity').get();
      if (snapshot.exists) {
        setState(() {
          _activities = snapshot.value as Map<String, dynamic>;
        });
      } else {
        // Handle the case when there are no activities
        print('No activities found.');
      }
    } catch (e) {
      // Print the error message
      print('Error fetching activities: $e');
    }
  }

  void navigateToPage(int index) {
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushNamed(context, '/user_community',
            arguments: {'userId': widget.userId});
        break;
      case 2:
        Navigator.pushNamed(context, '/user_report',
            arguments: {'userId': widget.userId});
        break;
      case 3:
        Navigator.pushNamed(context, '/user_nutrition',
            arguments: {'userId': widget.userId});
        break;
      case 4:
        Navigator.pushNamed(context, '/user_profile',
            arguments: {'userId': widget.userId});
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
              Navigator.pushNamed(context, '/user_notification',
                  arguments: {'userId': widget.userId});
            },
          ),
          IconButton(
            icon: const Icon(Icons.feedback),
            onPressed: () {
              Navigator.pushNamed(context, '/user_feedback',
                  arguments: {'userId': widget.userId});
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display prompt for selecting workout
            const Text(
              "What kind of workout would you like to do?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Dropdown for selecting workout category
            DropdownButton<String>(
              hint: const Text('Select Workout'),
              value: _selectedActivityId,
              items: _activities.keys.map((String key) {
                return DropdownMenuItem<String>(
                  value: key,
                  child: Text(
                      _activities[key]['category']), // Display the category
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedActivityId = value; // Update selected activity
                });
              },
            ),
            const SizedBox(height: 20),

            // You can add more UI elements or features here as needed
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
          BottomNavigationBarItem(
              icon: Icon(Icons.apartment_rounded), label: 'Community'),
          BottomNavigationBarItem(
              icon: Icon(Icons.auto_graph), label: 'Report'),
          BottomNavigationBarItem(
              icon: Icon(Icons.restaurant), label: 'Nutrition'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        backgroundColor: Colors.blue,
        selectedItemColor: const Color.fromARGB(255, 47, 22, 113),
        unselectedItemColor: Colors.black,
      ),
    );
  }
}
