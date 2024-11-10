// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../feature/user_profile_f.dart';

class UserProfile extends StatefulWidget {
  final String userId;
  const UserProfile({super.key, required this.userId});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String? _username;
  String? _usergender;
  String? _userheight;
  String? _userpassword;
  String? _usersecretpas;

  late TextEditingController _usernameController;
  late bool _isMale;
  late TextEditingController _userheightController;
  late TextEditingController _userpasswordController;
  late TextEditingController _usersecretpasController;

  @override
  void initState() {
    super.initState();
    _fetchUsername();
    _fetchUsergender();
    _fetchUserheight();
    _fetchUserpassword();
    _fetchUsersecretpas();
    _usernameController = TextEditingController(text: "");
    _userheightController = TextEditingController(text: "");
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

 Future<void> _fetchUserheight() async{
    final userheight = await searchUser(widget.userId, 'height');
    _userheightController = TextEditingController(text: userheight);
    setState(() {
      _userheight = userheight;
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
        Navigator.pushNamed(context, '/user_home',
            arguments: {'userId': widget.userId});
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
        Navigator.pushNamed(context, '/');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _usernameController = TextEditingController(text: _username);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, '/user_search',
                  arguments: {'userId': widget.userId});
            },
          ),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: _usernameController, decoration: const InputDecoration(labelText: 'Username')),
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
            TextField(controller: _userheightController, decoration: const InputDecoration(labelText: 'Height')),
            TextField(controller: _userpasswordController, decoration: const InputDecoration(labelText: 'Password')),
            TextField(controller: _usersecretpasController, decoration: const InputDecoration(labelText: 'Secret Word')),
            TextButton(
              onPressed: () async {
                await saveNewUser(
                  widget.userId, _usernameController.text, 
                  _isMale ? 'male' : 'female', _userheightController.text,
                  _userpasswordController.text, _usersecretpasController.text
                );
                Navigator.pop(context);
              },
              child: const Text('Save'),
            )
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
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Log Out'),
        ],
        backgroundColor: Colors.blue,
        selectedItemColor: const Color.fromARGB(255, 47, 22, 113),
        unselectedItemColor: Colors.black,
      ),
    );
  }
}
