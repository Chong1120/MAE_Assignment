import 'package:flutter/material.dart';
import '../feature/coach_specific_f.dart';

class CoachSpecific extends StatefulWidget {
  final String userId;
  final String suserId;
  const CoachSpecific({super.key, required this.userId, required this.suserId});

  @override
  _CoachSpecificState createState() => _CoachSpecificState();
}

class _CoachSpecificState extends State<CoachSpecific> {
  late Future<Map<String, dynamic>> userInfoFuture;
  late Future<List<Map<String, dynamic>>> userPostsFuture;

  @override
  void initState() {
    super.initState();
    userInfoFuture = searchUser(widget.suserId);
    userPostsFuture = fetchUserPosts(widget.suserId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coach Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Return to the search page with a signal to refresh it
            Navigator.pop(
                context, true); // Indicate that the search page should refresh
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FutureBuilder<Map<String, dynamic>>(
              future: userInfoFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final userInfo = snapshot.data!;
                  IconData genderIcon = userInfo['gender'] == 'male'
                      ? Icons.person_4
                      : Icons.person_3;

                  return Column(
                    children: [
                      Icon(genderIcon, size: 100),
                      Text(userInfo['username'],
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      Text(userInfo['bio'],
                          style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 20),
                    ],
                  );
                } else {
                  return const Text('Profile not available');
                }
              },
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: userPostsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final userPosts = snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: userPosts.length,
                      itemBuilder: (context, index) {
                        final post = userPosts[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 10.0),
                          child: ListTile(
                            title: Text(post['title']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Category: ${post['category']}'),
                                Text('Posted on: ${post['timestamp']}'),
                                Text(post['content']),
                                Text(
                                    'Likes: ${post['likes_count']} Comments: ${post['comments_count']}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Text('No posts available');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
