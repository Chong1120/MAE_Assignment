import 'package:flutter/material.dart';
import '../feature/user_home_video_f.dart'; // Import the feature file
import 'package:youtube_player_flutter/youtube_player_flutter.dart'; // Import YouTube player package
import 'package:intl/intl.dart'; // Import for date formatting

class UserHomeVideo extends StatefulWidget {
  final String userId;
  final String category; // Pass the selected category

  const UserHomeVideo(
      {super.key, required this.userId, required this.category});

  @override
  _UserHomeVideoState createState() => _UserHomeVideoState();
}

class _UserHomeVideoState extends State<UserHomeVideo> {
  int _currentIndex = 0;
  List<Map<String, dynamic>> _videos = []; // To hold video data

  @override
  void initState() {
    super.initState();
    _fetchVideos(); // Fetch videos based on category
  }

  Future<void> _fetchVideos() async {
    List<Map<String, dynamic>> videos =
        await fetchWorkoutVideos(widget.category);
    setState(() {
      _videos = videos;
    });
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

  void _markWorkoutAsDone() async {
    // Update user's activity in Firebase
    await updateUserActivity(widget.userId);
    // Show motivational message
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Congratulations!'),
        content: const Text(
            'You have successfully completed your workout! Keep it up!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pop(context); // Navigate back to the previous screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Videos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Back button icon
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
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
        child: _videos.isEmpty
            ? const Center(
                child: CircularProgressIndicator()) // Loading indicator
            : ListView.builder(
                itemCount: _videos.length,
                itemBuilder: (context, index) {
                  final video = _videos[index];
                  return Card(
                    child: Column(
                      children: [
                        YoutubePlayer(
                          controller: YoutubePlayerController(
                            initialVideoId: YoutubePlayer.convertUrlToId(
                                    video['videourl']) ??
                                '',
                            flags: const YoutubePlayerFlags(
                              autoPlay: false,
                              mute: false,
                            ),
                          ),
                          showVideoProgressIndicator: true,
                        ),
                        ListTile(
                          title: Text(video['videoname']),
                          subtitle: Text(video['videodescription']),
                        ),
                        ElevatedButton(
                          onPressed:
                              _markWorkoutAsDone, // Confirm button action
                          child: const Text('I\'m Done!'),
                        ),
                      ],
                    ),
                  );
                },
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
