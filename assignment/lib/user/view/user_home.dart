import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart'; // Import for video playback

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
  String? _videoUrl;
  String? _videoDescription;
  String? _videoName;
  String? _difficulty;

  @override
  void initState() {
    super.initState();
    _fetchActivities(); // Fetch activities when the page loads
  }

  void _fetchActivities() async {
    final snapshot = await _dbRef.child('activity').get();
    if (snapshot.exists) {
      setState(() {
        _activities = snapshot.value as Map<String, dynamic>;
      });
    }
  }

  void _onActivitySelected(String activityId) {
    setState(() {
      _selectedActivityId = activityId;
      _videoUrl = _activities[activityId]['videourl'];
      _videoDescription = _activities[activityId]['videodescription'];
      _videoName = _activities[activityId]['videoname'];
      _difficulty = _activities[activityId]['difficulty'];
    });
  }

  void _resetSelection() {
    setState(() {
      _selectedActivityId = null;
      _videoUrl = null;
      _videoDescription = null;
      _videoName = null;
      _difficulty = null;
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
            // Dropdown for selecting body part
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
              onChanged: _onActivitySelected,
            ),
            const SizedBox(height: 20),
            // Display workout details if an activity is selected
            if (_selectedActivityId != null) ...[
              Text(
                _videoName ?? '',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text('Difficulty: $_difficulty'),
              const SizedBox(height: 10),
              Text(_videoDescription ?? ''),
              const SizedBox(height: 20),
              // Play the video
              VideoPlayerWidget(videoUrl: _videoUrl ?? ''),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _resetSelection(); // Reset the selection after done
                  _showCompletion(); // Show completion message
                },
                child: const Text('Done'),
              ),
            ],
            const SizedBox(height: 40),
            // User homepage content
            const Expanded(
              child: Center(
                child: Text("Here is user Homepage"),
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

  void _showCompletion() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Workout Completed'),
        content: const Icon(Icons.check_circle, size: 60, color: Colors.green),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// Widget for displaying YouTube videos
class VideoPlayerWidget extends StatelessWidget {
  final String videoUrl;

  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract the video ID from the URL
    String videoId = YoutubePlayer.convertUrlToId(videoUrl) ?? '';

    return YoutubePlayer(
      controller: YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      ),
      showVideoProgressIndicator: true,
    );
  }
}
