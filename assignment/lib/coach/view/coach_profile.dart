// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../feature/coach_profile_f.dart';

class CoachProfile extends StatefulWidget {
  final String userId; 
  const CoachProfile({super.key, required this.userId});

  @override
  _CoachProfileState createState() => _CoachProfileState();
}

class _CoachProfileState extends State<CoachProfile> {
  String? _username;
  String? _usergender;
  String? _userbio;
  String? _userpassword;
  String? _usersecretpas;

  late TextEditingController _usernameController;
  late bool _isMale;
  late TextEditingController _userbioController;
  late TextEditingController _userpasswordController;
  late TextEditingController _usersecretpasController;

  @override
  void initState() {
    super.initState();
    _fetchUsername();
    _fetchUsergender();
    _fetchUserbio();
    _fetchUserpassword();
    _fetchUsersecretpas();
    _usernameController = TextEditingController(text: "");
    _userbioController = TextEditingController(text: "");
    _userpasswordController = TextEditingController(text: "");
    _usersecretpasController = TextEditingController(text: "");
    _isMale = true;
  }

  Future<void> _fetchUsername() async{
    final username = await searchUser(widget.userId, 'username');
    _usernameController = TextEditingController(text: username);
    setState(() {
      _username = username;
    });
  }

   Future<void> _fetchUsergender() async{
    final usergender = await searchUser(widget.userId, 'gender');
    if(usergender == 'male')
    { 
      _isMale = true;
    }
    else{
      _isMale = false;
    }
    setState(() {
      _usergender = usergender;
    });
  }

 Future<void> _fetchUserbio() async{
    final userbio = await searchUser(widget.userId, 'bio');
    _userbioController = TextEditingController(text: userbio);
    setState(() {
      _userbio = userbio;
    });
  }

 Future<void> _fetchUserpassword() async{
    final userpassword = await searchUser(widget.userId, 'password');
    _userpasswordController = TextEditingController(text: userpassword);
    setState(() {
      _userpassword = userpassword;
    });
  }

   Future<void> _fetchUsersecretpas() async{
    final usersecretpas = await searchUser(widget.userId, 'secretpas');
    _usersecretpasController = TextEditingController(text: usersecretpas);
    setState(() {
      _usersecretpas = usersecretpas;
    });
  }

  

  int _currentIndex = 4; 


  void navigateToPage(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/coach_home', arguments: {'userId': widget.userId});
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
        Navigator.pushNamed(context, '/');
        break;
    }
  }
    Future<void> _saveProfile() async {
    try {
      await saveNewUser(
        widget.userId, 
        _usernameController.text, 
        _isMale ? 'male' : 'female', 
        _userbioController.text,
        _userpasswordController.text, 
        _usersecretpasController.text
      );
      // Displaying a SnackBar upon successful update
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    } catch (error) {
      // Handle potential errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profile'),
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: _usernameController, decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder(),
            ),
            ),
            const SizedBox(height: 20, width: 20,),          
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.male, color: _isMale? Colors.blue : Colors.grey),
                  onPressed: () => setState(() => _isMale = true)
                ),
                IconButton(
                  icon: Icon(Icons.female, color: !_isMale? Colors.pink : Colors.grey),
                  onPressed: () => setState(() => _isMale = false)
                ),
              ],
            ),
            TextField(controller: _userbioController, decoration: const InputDecoration(labelText: 'Bio', border: OutlineInputBorder(),
            ),
            ),
            const SizedBox(height: 20, width: 20,), 
            TextField(controller: _userpasswordController, decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder(),
            ),
            ),
            const SizedBox(height: 20, width: 20,), 
            TextField(controller: _usersecretpasController, decoration: const InputDecoration(labelText: 'Secret Word', border: OutlineInputBorder(),
            ),
            ),
            const SizedBox(height: 20, width: 20,), 
            TextButton(
              onPressed: _saveProfile,  // Replace the direct saveNewUser call with _saveProfile
              child: const Text('Save'),
            )
          ],
        ),
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
          BottomNavigationBarItem(icon: Icon(Icons.auto_graph), label: 'Report'),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Log Out'),
        ],
        backgroundColor: Colors.blue, 
        selectedItemColor: const Color.fromARGB(255, 47, 22, 113),
        unselectedItemColor: Colors.black,
      ),
    );
  }
}
