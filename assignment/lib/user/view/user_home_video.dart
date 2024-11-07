import 'package:flutter/material.dart';
import '../feature/user_home_video_f.dart'; // Import the feature file
import 'package:youtube_player_flutter/youtube_player_flutter.dart'; // Import YouTube player package

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
  late YoutubePlayerController _controller; // Declare controller

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
    if (_videos.isNotEmpty) {
      // Initialize the YouTube controller with the first video's ID
      String initialVideoId =
          YoutubePlayer.convertUrlToId(_videos[0]['videourl']) ?? '';
      _controller = YoutubePlayerController(
        initialVideoId: initialVideoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Workout Videos'),
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
                  final videoId = YoutubePlayer.convertUrlToId(
                      video['videourl']); // Extract video ID

                  return Card(
                    child: Column(
                      children: [
                        YoutubePlayer(
                          controller: YoutubePlayerController(
                            initialVideoId: videoId ?? '',
                            flags: const YoutubePlayerFlags(
                              autoPlay: true, // Auto play the video
                              mute: false,
                            ),
                          ),
                          showVideoProgressIndicator: true,
                        ),
                        ListTile(
                          title: Text(video['videoname']),
                          subtitle: Text(video['videodescription']),
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