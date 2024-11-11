// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import '../feature/admin_home_f.dart';

class AdminHomeApproved extends StatefulWidget {
  final String userId;
  const AdminHomeApproved({super.key, required this.userId});

  @override
  _AdminHomeApprovedState createState() => _AdminHomeApprovedState();
}

class _AdminHomeApprovedState extends State<AdminHomeApproved> {
  List<Map<String, dynamic>> posts = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    final fetchedPosts = await getPosts('approved', false);
    setState(() {
      posts = fetchedPosts;
    });
  }

  void _showReportDialog(String postId, String action) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Post'),
          content: Text('Are you sure you want to $action this post?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                if (action == 'report')
                {
                  await updatePost(postId, true, 'disapproved');
                }
                else
                {
                  await updatePost(postId, false, action);
                }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
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
                        '/user_specific',
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
                        icon: const Icon(Icons.warning),
                        onPressed: () => _showReportDialog(post['id'], 'report'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.block),
                        onPressed: () => _showReportDialog(post['id'], 'disapproved'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
