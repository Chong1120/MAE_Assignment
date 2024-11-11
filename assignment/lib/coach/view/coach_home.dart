// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import '../feature/coach_home_f.dart';

class CoachHome extends StatefulWidget {
  final String userId; 
  const CoachHome({super.key, required this.userId});

  @override
  _CoachHomeState createState() => _CoachHomeState();
}

class _CoachHomeState extends State<CoachHome> {
  int _currentIndex = 0; 
  List<Map<String, dynamic>> posts = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    final fetchedPosts = await getApprovedPosts();
    setState(() {
      posts = fetchedPosts;
    });
  }

  Future<void> _toggleLike(String postId, String userId, bool isLiked) async {
    await toggleLike(postId, userId, isLiked);
    fetchPosts();
  }

  Future<void> _addComment(String postId, String userId, String content) async {
    await addComment(postId, userId, content);
    fetchPosts();
  }

  void _showCommentDialog(String postId) {
    final TextEditingController commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Comment'),
          content: TextField(
            controller: commentController,
            decoration: const InputDecoration(hintText: 'Enter your comment'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await _addComment(postId, widget.userId, commentController.text);
                Navigator.pop(context);
              },
              child: const Text('Comment'),
            ),
          ],
        );
      },
    );
  }

  void _showReportDialog(String postId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Report Post'),
          content: const Text('Are you sure you want to report this post?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                await reportPost(postId);
                Navigator.pop(context);
                fetchPosts();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void navigateToPage(int index) {
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushNamed(context, '/coach_search', arguments: {'userId': widget.userId});
        break;
      case 2:
        Navigator.pushNamed(context, '/coach_add', arguments: {'userId': widget.userId});
        break;
      case 3:
        Navigator.pushNamed(context, '/coach_report', arguments: {'userId': widget.userId});
        break;
      case 4:
        Navigator.pushNamed(context, '/coach_profile', arguments: {'userId': widget.userId});
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
              Navigator.pushNamed(context, '/coach_notification', arguments: {'userId': widget.userId});
            },
          ),
          IconButton(
            icon: const Icon(Icons.feedback),
            onPressed: () {
              Navigator.pushNamed(context, '/coach_feedback', arguments: {'userId': widget.userId});
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          final isLiked;
          if (post['likes'] != 0)
          {
            isLiked = post['likes'].containsKey(widget.userId);
          }
          else
          {
            isLiked = false;
          }
          
          return Card(
            child: ListTile(
              title: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      post['gender'] == 'male'
                        ? Icons.person_4_rounded
                        : post['gender'] == 'female'
                          ? Icons.person_3_rounded
                          : Icons.person, // Default icon if gender is unknown
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/coach_specific',
                        arguments: {'userId': widget.userId, 'suserId': post['name']},
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(post['username']),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post['datetime']),
                  Text(post['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(post['content']),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined),
                        onPressed: () => _toggleLike(post['id'], widget.userId, isLiked),
                      ),
                      IconButton(
                        icon: const Icon(Icons.comment),
                        onPressed: () => _showCommentDialog(post['id']),
                      ),
                      IconButton(
                        icon: const Icon(Icons.warning),
                        onPressed: () => _showReportDialog(post['id']),
                      ),
                    ],
                  ),
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: fetchComments(post['id']),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const CircularProgressIndicator();
                      final comments = snapshot.data!;
                      return Column(
                        children: comments
                            .map((comment) => ListTile(
                                  title: Text(comment['name']),
                                  subtitle: Text(comment['content']),
                                ))
                            .toList(),
                      );
                    },
                  ),
                ],
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
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_graph), label: 'Report'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        backgroundColor: Colors.blue, 
        selectedItemColor: const Color.fromARGB(255, 47, 22, 113),
        unselectedItemColor: Colors.black,
      ),
    );
  }
}
