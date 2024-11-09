// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'admin_coach.dart';
import 'admin_user.dart';

class AdminManage extends StatefulWidget {
  final String userId; 
  const AdminManage({super.key, required this.userId});

  @override
  _AdminManageState createState() => _AdminManageState();
}

class _AdminManageState extends State<AdminManage> with SingleTickerProviderStateMixin {
  int _currentIndex = 3; 
  late TabController _tabController;
  DateTime currentDate = DateTime.now(); 
  DateTime selectedWeekStart = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)); 

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // 2 tabs (Weight, Exercise)
  }

  void navigateToPage(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/admin_home', arguments: {'userId': widget.userId});
        break;
      case 1:
        Navigator.pushNamed(context, '/admin_activity', arguments: {'userId': widget.userId});
        break;
      case 2:
        Navigator.pushNamed(context, '/admin_announcement', arguments: {'userId': widget.userId});
        break;
      case 3:
        break;
      case 4:
        Navigator.pushNamed(context, '/admin_feedback', arguments: {'userId': widget.userId});
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Manage'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, '/admin_notification', arguments: {'userId': widget.userId});
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/admin_profile', arguments: {'userId': widget.userId});
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
              Tab(text: 'Coach'),
              Tab(text: 'User'),
            ],
          ),
          // TabBarView to show content of selected tab
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                AdminCoachPage(),
                AdminUserPage(),
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
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Activity'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.manage_accounts), label: 'Manage'),
          BottomNavigationBarItem(icon: Icon(Icons.feedback), label: 'Feedback'),
        ],
        backgroundColor: Colors.blue, 
        selectedItemColor: const Color.fromARGB(255, 47, 22, 113),
        unselectedItemColor: Colors.black,
      ),
    );
  }
}
