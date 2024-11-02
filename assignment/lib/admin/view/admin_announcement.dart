import 'package:flutter/material.dart';
import '../feature/admin_announcement_f.dart'; // Import the functions file

class AdminAnnouncement extends StatefulWidget {
  const AdminAnnouncement({super.key});

  @override
  _AdminAnnouncementState createState() => _AdminAnnouncementState();
}

class _AdminAnnouncementState extends State<AdminAnnouncement> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  List announcements = [];

  @override
  void initState() {
    super.initState();
    fetchAnnouncements(); // Fetch existing announcements when the page loads
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
      saveAnnouncement('admin1', dateTime, title, content); // Function to save announcement to Firebase

      _titleController.clear();
      _contentController.clear();
      fetchAnnouncements(); // Refresh the announcement list after adding a new one
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
        // Current page, do nothing
        break;
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
              maxLines: 5, // Increased max lines for content input
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
                          const SizedBox(height: 4), // Spacing between date and content
                          Text(
                            announcement['content'],
                            maxLines: 5, // Adjust this to show more lines
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Activity'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.manage_accounts), label: 'Manage'),
          BottomNavigationBarItem(icon: Icon(Icons.feedback), label: 'Feedback'),
        ],
        onTap: navigateToPage,
      ),
    );
  }
}
