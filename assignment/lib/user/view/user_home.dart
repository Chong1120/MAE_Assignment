import 'package:flutter/material.dart';
import '../feature/user_home_f.dart'; // Import the feature file

class UserHome extends StatefulWidget {
  final String userId;

  const UserHome({super.key, required this.userId});

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  int _currentIndex = 0;
  String? _selectedCategory;
  List<String> _categories = []; // To hold the workout categories

  @override
  void initState() {
    super.initState();
    _fetchCategories(); // Fetch categories on init
  }

  Future<void> _fetchCategories() async {
    List<String> categories =
        await fetchWorkoutCategories(); // Fetch from Firebase
    setState(() {
      _categories = categories;
    });
  }

  void navigateToPage(int index) {
    switch (index) {
      case 0:
        break; // Keep current page for Home
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

  void _onConfirm() {
    if (_selectedCategory != null) {
      // Navigate to the workout videos page based on the selected category
      Navigator.pushNamed(context, '/workout_videos', arguments: {
        'category': _selectedCategory,
        'userId': widget.userId,
      });
    } else {
      // Show a message if no category is selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a workout category!')),
      );
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
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, '/user_search',
                  arguments: {'userId': widget.userId});
            },
          ),
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "What kind of workout would you like to do?",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              DropdownButton<String>(
                hint: const Text('Select Workout Category'),
                value: _selectedCategory,
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _onConfirm, // Confirm button action
                child: const Text('Enter'),
              ),
            ],
          ),
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
