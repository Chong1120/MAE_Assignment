import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../feature/coach_report_f.dart';

class CoachReport extends StatefulWidget {
  final String userId; 
  const CoachReport({super.key, required this.userId});

  @override
  _CoachReportState createState() => _CoachReportState();
}

class _CoachReportState extends State<CoachReport> {
  late Future<Map<String, num>> totalLikesCommentsFuture;
  late Future<List<Map<String, dynamic>>> coachPostsFuture;
  String selectedSortOption = 'Overall';
  List<Map<String, dynamic>> coachPosts = [];
  int _currentIndex = 3; 

@override
  void initState() {
    super.initState();
    totalLikesCommentsFuture = calculateTotalLikesAndComments(widget.userId);
    coachPostsFuture = fetchCoachPosts(widget.userId);
  }

  void sortPosts(String option) {
    setState(() {
      selectedSortOption = option;

      if (option == 'Order by likes') {
        coachPosts = sortPostsByLikes(coachPosts);
      } else if (option == 'Order by comments') {
        coachPosts = sortPostsByComments(coachPosts);
      }
    });
  }

Widget buildChart() {
  return selectedSortOption == 'Overall'
      ? FutureBuilder<Map<String, num>>(
          future: totalLikesCommentsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final data = snapshot.data!;
              return BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: (data['totalLikes']! + data['totalComments']!).toDouble() + 10,
                  barGroups: [
                    BarChartGroupData(
                      x: 0, // Position for "Likes"
                      barRods: [
                        BarChartRodData(
                          toY: data['totalLikes']!.toDouble(),
                          color: Colors.blue,
                          width: 20,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1, // Position for "Comments", set further apart
                      barRods: [
                        BarChartRodData(
                          toY: data['totalComments']!.toDouble(),
                          color: Colors.red,
                          width: 20,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ],
                    ),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false), // Hide the left titles
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false), // Hide the right titles
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false), // Hide the top titles
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return const Text(
                                'Likes',
                                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                              );
                            case 1:
                              return const Text(
                                'Comments',
                                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                              );
                            default:
                              return const Text('');
                          }
                        },
                      ),
                    ),
                  ),
                  gridData: const FlGridData(show: true),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey),
                  ),
                ),
              );
            }
          },
        )
      : ListView.builder(
          itemCount: coachPosts.length,
          itemBuilder: (context, index) {
            final post = coachPosts[index];
            return ListTile(
              title: Text(post['title']),
              subtitle: Text(
                  'Likes: ${post['likes_count']} | Comments: ${post['comments_count']}'),
            );
          },
        );
}



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
        title: const Text('Report'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: selectedSortOption,
              items: const [
                DropdownMenuItem(value: 'Overall', child: Text('Overall')),
                DropdownMenuItem(value: 'Order by likes', child: Text('Order by likes')),
                DropdownMenuItem(value: 'Order by comments', child: Text('Order by comments')),
              ],
              onChanged: (value) {
                if (value != null) {
                  sortPosts(value);
                }
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: coachPostsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    coachPosts = snapshot.data!;
                    return buildChart();
                  } else {
                    return const Center(child: Text('No data available'));
                  }
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
