import 'package:flutter/material.dart';
import 'user_weight.dart'; // Import the WeightTab and ExerciseTab widgets
import 'user_exercise.dart'; 

class UserReport extends StatefulWidget {
  final String userId; 
  const UserReport({super.key, required this.userId});

  @override
  _UserReportState createState() => _UserReportState();
}

class _UserReportState extends State<UserReport> with SingleTickerProviderStateMixin {
  int _currentIndex = 2; 
  DateTime currentDate = DateTime.now(); 
  DateTime selectedWeekStart = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)); 

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // 2 tabs (Weight, Exercise)
  }

  void navigateToPage(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/user_home', arguments: {'userId': widget.userId});
        break;
      case 1:
        Navigator.pushNamed(context, '/user_community', arguments: {'userId': widget.userId});
        break;
      case 2:
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
        title: const Text('Report'),
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
      body: Column(
        children: [
          // TabBar placed under the AppBar
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Weight'),
              Tab(text: 'Exercise'),
            ],
          ),
          // TabBarView to show content of selected tab
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                UserWeightPage(userId: widget.userId),
                UserExercisePage(userId: widget.userId),
              ],
            ),
          ),
        ],
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
        selectedItemColor: const Color.fromARGB(255, 47, 8, 64), 
        unselectedItemColor: Colors.white, 
        type: BottomNavigationBarType.fixed, 
      ),
    );
  }
}
