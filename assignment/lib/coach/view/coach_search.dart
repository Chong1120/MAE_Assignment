// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../feature/coach_search_f.dart'; // Feature for searching coaches

class CoachSearch extends StatefulWidget {
  final String userId;
  const CoachSearch({super.key, required this.userId});

  @override
  _CoachSearchState createState() => _CoachSearchState();
}

class _CoachSearchState extends State<CoachSearch> {
  int _currentIndex = 1;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchCoach() async {
    if (_searchController.text.isEmpty) return;

    List<Map<String, dynamic>> results =
        await searchCoaches(_searchController.text);
    setState(() {
      _searchResults = results;
    });
  }

  void navigateToPage(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/coach_home',
            arguments: {'userId': widget.userId});
        break;
      case 1:
        break;
      case 2:
        Navigator.pushNamed(context, '/coach_add',
            arguments: {'userId': widget.userId});
        break;
      case 3:
        Navigator.pushNamed(context, '/coach_report',
            arguments: {'userId': widget.userId});
        break;
      case 4:
        Navigator.pushNamed(context, '/coach_profile',
            arguments: {'userId': widget.userId});
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Search Coach'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, '/coach_notification',
                  arguments: {'userId': widget.userId});
            },
          ),
          IconButton(
            icon: const Icon(Icons.feedback),
            onPressed: () {
              Navigator.pushNamed(context, '/coach_feedback',
                  arguments: {'userId': widget.userId});
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Enter Coach Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _searchCoach,
              child: const Text('Search'),
            ),
            const SizedBox(height: 20),
            _searchResults.isEmpty
                ? const Center(
                    child: Text('No coaches found, please try again.',
                        style: TextStyle(fontSize: 16, color: Colors.red)),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final coach = _searchResults[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(coach['username']),
                            subtitle: Text(coach['bio']),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/coach_specific',
                                arguments: {
                                  'userId': widget.userId,
                                  'suserId': coach['id'],
                                },
                              ).then((_) {
                                setState(() {
                                  _searchResults = [];
                                  _searchController.clear();
                                });
                              });
                            },
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
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
          BottomNavigationBarItem(
              icon: Icon(Icons.auto_graph), label: 'Report'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        backgroundColor: Colors.blue,
        selectedItemColor: const Color.fromARGB(255, 47, 22, 113),
        unselectedItemColor: Colors.black,
      ),
    );
  }
}
