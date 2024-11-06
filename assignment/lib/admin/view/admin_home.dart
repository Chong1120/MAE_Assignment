// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../feature/admin_home_f.dart';

class AdminHome extends StatefulWidget {
  final String userId; 
  const AdminHome({super.key, required this.userId});

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  String? usergender;
  int _currentIndex = 0; 
  List post = [];

  @override
  void initState() {
    super.initState();
    fetchPost();
  }

  Future<String> fetchGender(String suserId) async {
    final fetchedGender = await gender(widget.userId);
    return fetchedGender;
  }

  void fetchPost() async {
    final fetchedPost = await getpost();
    setState(() {
      post = fetchedPost;
    });
  }

  void navigateToPage(int index) {
    switch (index) {
      case 0:
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
        Navigator.pushNamed(context, '/admin_feedback', arguments: {'userId': widget.userId});
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
      body: ListView.builder(
        itemCount: post.length,
        itemBuilder: (context, index) {
          final posts = post[index];
          
          return Card(
            child: ListTile(
              title: Text(posts['name']),
              trailing: FutureBuilder<String>(
              future: fetchGender(posts['name']),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Icon(Icons.error);
                } else if (snapshot.hasData) {
                  final gender = snapshot.data!;
                  return IconButton(
                    icon: Icon(
                      gender == 'male'
                        ? Icons.person_4_rounded
                        : gender == 'female'
                          ? Icons.person_3_rounded
                          : Icons.person, // Default icon if gender is unknown
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/admin_specific', arguments: {'userId': widget.userId, 'suserId': posts['name']});
                    },
                  );
                } else {
                  return const Icon(Icons.help);
                }
              },
            ),
            ),
          );
        },
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
