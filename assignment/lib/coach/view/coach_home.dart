import 'package:flutter/material.dart';
import '../feature/coach_home_f.dart';

class CoachHome extends StatefulWidget {
  final String userId; 
  const CoachHome({super.key, required this.userId});

  @override
  _CoachHomeState createState() => _CoachHomeState();
}

class _CoachHomeState extends State<CoachHome> {
  String? usergender;
  int _currentIndex = 0; 
  List post = [];

  @override
  void initState() {
    super.initState();
    fetchPost();
  }

  Future<String> fetchGender(String suserId) async {
    final fetchedGender = await gender(widget.userId);
    return fetchedGender;
  }

  void fetchPost() async {
    final fetchedPost = await getpost();
    setState(() {
      post = fetchedPost;
    });
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
        itemCount: post.length,
        itemBuilder: (context, index) {
          final posts = post[index];
          
          return Card(
            child: ListTile(
              title: Text(posts['name']),
              trailing: FutureBuilder<String>(
              future: fetchGender(posts['name']),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Icon(Icons.error);
                } else if (snapshot.hasData) {
                  final gender = snapshot.data!;
                  return IconButton(
                    icon: Icon(
                      gender == 'male'
                        ? Icons.person_4_rounded
                        : gender == 'female'
                          ? Icons.person_3_rounded
                          : Icons.person, // Default icon if gender is unknown
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/coach_specific', arguments: {'userId': widget.userId, 'suserId': posts['name']});
                    },
                  );
                } else {
                  return const Icon(Icons.help);
                }
              },
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
