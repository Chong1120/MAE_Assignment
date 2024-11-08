import 'package:flutter/material.dart';
import '../feature/admin_activity_f.dart'; // Import the feature file

class AdminActivity extends StatefulWidget {
  final String userId;
  const AdminActivity({super.key, required this.userId});

  @override
  _AdminActivityState createState() => _AdminActivityState();
}

class _AdminActivityState extends State<AdminActivity> {
  int _currentIndex = 1;
  List<Map<String, dynamic>> _activities = []; // To hold activities

  @override
  void initState() {
    super.initState();
    _fetchActivities(); // Fetch activities on init
  }

  Future<void> _fetchActivities() async {
    List<Map<String, dynamic>> activities = await fetchActivities();
    setState(() {
      _activities = activities;
    });
  }

  void navigateToPage(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/admin_home',
            arguments: {'userId': widget.userId});
        break;
      case 1:
        break;
      case 2:
        Navigator.pushNamed(context, '/admin_announcement',
            arguments: {'userId': widget.userId});
        break;
      case 3:
        Navigator.pushNamed(context, '/admin_manage',
            arguments: {'userId': widget.userId});
        break;
      case 4:
        Navigator.pushNamed(context, '/admin_feedback',
            arguments: {'userId': widget.userId});
        break;
    }
  }

  void _addActivity() {
    Navigator.pushNamed(context, '/add_activity',
        arguments: {'userId': widget.userId}).then((_) {
      _fetchActivities(); // Refresh activities after returning
    });
  }

  void _editActivity(Map<String, dynamic> activity) {
    // Navigate to edit activity page
    Navigator.pushNamed(context, '/edit_activity',
        arguments: {'userId': widget.userId, 'activity': activity}).then((_) {
      _fetchActivities(); // Refresh activities after editing
    });
  }

  void _confirmDeleteActivity(String activityId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this activity?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              await _deleteActivity(activityId);
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteActivity(String activityId) async {
    await deleteActivity(activityId); // Call delete function from feature file
    _fetchActivities(); // Refresh activities after deleting
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Prevent back button from appearing
        title: const Text('Manage Activities'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, '/admin_notification',
                  arguments: {'userId': widget.userId});
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/admin_profile',
                  arguments: {'userId': widget.userId});
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _activities.isEmpty
            ? const Center(
                child: CircularProgressIndicator()) // Loading indicator
            : ListView.builder(
                itemCount: _activities.length,
                itemBuilder: (context, index) {
                  final activity = _activities[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            // Make text take available space
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  activity['category'],
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Video Name: ${activity['videoname']}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  activity['videodescription'],
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Video URL: ${activity['videourl']}',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.blue),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                              width: 16), // Space between text and buttons
                          Column(
                            // Column for edit and delete buttons
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () =>
                                    _editActivity(activity), // Edit activity
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _confirmDeleteActivity(
                                    activity['id']), // Confirm delete activity
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addActivity, // Add new activity
        child: const Icon(Icons.add),
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
          BottomNavigationBarItem(
              icon: Icon(Icons.manage_accounts), label: 'Manage'),
          BottomNavigationBarItem(
              icon: Icon(Icons.feedback), label: 'Feedback'),
        ],
        backgroundColor: Colors.blue,
        selectedItemColor: const Color.fromARGB(255, 47, 22, 113),
        unselectedItemColor: Colors.black,
      ),
    );
  }
}
