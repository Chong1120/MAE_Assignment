import 'package:flutter/material.dart';
import '../feature/user_search_f.dart'; // Feature for searching coaches

class UserSearch extends StatefulWidget {
  final String userId;
  const UserSearch({super.key, required this.userId});

  @override
  _UserSearchState createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearch> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false; // To track if the search is in progress

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchCoach() async {
    if (_searchController.text.isEmpty) return;

    setState(() {
      _isSearching = true;
    });

    try {
      List<Map<String, dynamic>> results =
          await searchCoaches(_searchController.text);

      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (error) {
      setState(() {
        _isSearching = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load coaches')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search for Coach"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _searchCoach,
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
            _isSearching
                ? const Center(child: CircularProgressIndicator())
                : _searchResults.isEmpty
                    ? const Center(
                        child: Text(
                            'No coaches found. Try again with a different name.',
                            style: TextStyle(fontSize: 16, color: Colors.red)),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final coach = _searchResults[index];
                            return ListTile(
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
                                  // Reset search results when coming back from CoachSpecific page
                                  setState(() {
                                    _searchResults = [];
                                    _searchController.clear();
                                  });
                                });
                              },
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
