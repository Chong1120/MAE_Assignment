// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../feature/admin_announcement_f.dart'; // Import your functions

class AdminAnnouncement extends StatefulWidget {
  final String userId; // Store the userId passed from the login
  const AdminAnnouncement({super.key, required this.userId});

  @override
  _AdminAnnouncementState createState() => _AdminAnnouncementState();
}

class _AdminAnnouncementState extends State<AdminAnnouncement> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  List announcements = [];
  int _currentIndex = 2; // Set the initial index to 2 (Add) as it's the current page

  @override
  void initState() {
    super.initState();
    fetchAnnouncements(); // Fetch announcements when the page loads
  }

  void fetchAnnouncements() async {
    final fetchedAnnouncements = await getAnnouncements(); // Function to get announcements from Firebase
    setState(() {
      announcements = fetchedAnnouncements; // Update the announcements state
    });
  }

  void addAnnouncement() {
    final title = _titleController.text;
    final content = _contentController.text;

    if (title.isNotEmpty && content.isNotEmpty) {
      final dateTime = DateTime.now().toIso8601String();
      saveAnnouncement(widget.userId, dateTime, title, content); // Use widget.userId

      _titleController.clear();
      _contentController.clear();
      fetchAnnouncements(); // Refresh the announcement list after adding
    }
  }

  void navigateToPage(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/admin_home');
        break;
      case 1:
        Navigator.pushNamed(context, '/admin_activity');
        break;
      case 2:
        break; // Current page
      case 3:
        Navigator.pushNamed(context, '/admin_manage');
        break;
      case 4:
        Navigator.pushNamed(context, '/admin_feedback');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcements'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, '/admin_notification');
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/admin_profile');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First box: Add new announcement
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Announcement Title'),
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Announcement Content'),
              maxLines: 5,
            ),
            ElevatedButton(
              onPressed: addAnnouncement,
              child: const Text('Add Announcement'),
            ),
            const SizedBox(height: 20),
            // Second box: Display existing announcements
            Expanded(
              child: ListView.builder(
                itemCount: announcements.length,
                itemBuilder: (context, index) {
                  final announcement = announcements[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(announcement['title']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            announcement['date_time'],
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            announcement['content'],
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
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
        backgroundColor: Colors.blue, // Set a background color for visibility
        selectedItemColor: const Color.fromARGB(255, 47, 22, 113),
        unselectedItemColor: Colors.black,
      ),
    );
  }
}
