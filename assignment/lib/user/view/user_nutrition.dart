import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart'; // Import the YouTube player package

class UserNutrition extends StatefulWidget {
  final String userId;
  const UserNutrition({super.key, required this.userId});

  @override
  _UserNutritionState createState() => _UserNutritionState();
}

class _UserNutritionState extends State<UserNutrition> {
  int _currentIndex = 3;

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
        title: const Text('Nutrition'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Nutrition Knowledge',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Understanding Nutrition',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Nutrition is essential for maintaining good health and well-being. '
              'It involves the processes by which our bodies use the food we consume to support growth, energy, and overall health.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Image.asset(
              'lib/assets/nutrition_image1.jpeg', // Your first nutrition image
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            const Text(
              'Macronutrients',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text.rich(
              TextSpan(
                text: '1. ',
                style: const TextStyle(fontSize: 16),
                children: <TextSpan>[
                  const TextSpan(
                      text: 'Proteins: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const TextSpan(
                      text:
                          'Crucial for building muscles and repairing tissues. Sources include meat, fish, eggs, and legumes.\n'),
                  const TextSpan(text: '2. ', style: TextStyle(fontSize: 16)),
                  const TextSpan(
                      text: 'Carbohydrates: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const TextSpan(
                      text:
                          'The main source of energy for our body. Found in grains, fruits, and vegetables.\n'),
                  const TextSpan(text: '3. ', style: TextStyle(fontSize: 16)),
                  const TextSpan(
                      text: 'Fats: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const TextSpan(
                      text:
                          'Essential for hormone production and nutrient absorption. Healthy sources include avocados, nuts, and olive oil.'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(
              'lib/assets/macronutrients.jpeg', // Your macronutrients image
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            const Text(
              'Healthy Eating Tips',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              '1. Eat a variety of foods to ensure you get a balanced diet.\n'
              '2. Limit the intake of sugars and salts to maintain a healthy weight.\n'
              '3. Stay hydrated by drinking plenty of water throughout the day.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            YoutubePlayer(
              controller: YoutubePlayerController(
                initialVideoId: 'zdjWnvbaUZo', // Replace with a valid video ID
                flags: const YoutubePlayerFlags(
                  autoPlay: false,
                  mute: false,
                ),
              ),
              showVideoProgressIndicator: true,
            ),
            const SizedBox(height: 20),
            const Text(
              'Sample Meal Plan',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text.rich(
              TextSpan(
                text: '',
                style: const TextStyle(fontSize: 16),
                children: <TextSpan>[
                  const TextSpan(
                      text: 'Breakfast: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const TextSpan(
                      text: 'Oatmeal topped with fresh fruits and nuts.\n'),
                  const TextSpan(
                      text: 'Lunch: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const TextSpan(
                      text:
                          'Grilled chicken salad with a variety of vegetables and olive oil dressing.\n'),
                  const TextSpan(
                      text: 'Dinner: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const TextSpan(
                      text:
                          'Baked salmon served with steamed broccoli and quinoa.'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(
              'lib/assets/meal_plan.jpeg', // Your meal plan image
              height: 200,
              fit: BoxFit.cover,
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
