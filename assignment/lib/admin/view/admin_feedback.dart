// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'admin_pending.dart';
import 'admin_replied.dart';

class AdminFeedback extends StatefulWidget {
  final String userId; 
  const AdminFeedback({super.key, required this.userId});

  @override
  _AdminFeedbackState createState() => _AdminFeedbackState();
}

class _AdminFeedbackState extends State<AdminFeedback> with SingleTickerProviderStateMixin {
  int _currentIndex = 4; 
  late TabController _tabController;

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
        Navigator.pushNamed(context, '/admin_manage', arguments: {'userId': widget.userId});
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
        title: const Text('Feedback'),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TabBar(
              controller: _tabController,
              tabs: const[
                Tab(text: 'Pending'),
                Tab(text: 'Replied') ,
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  AdminPendingPage(),
                  AdminRepliedPage(),
                ],
              ),
            ),
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
