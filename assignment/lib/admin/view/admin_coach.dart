import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../feature/admin_manage_f.dart';
import 'admin_coach_specific.dart';

class AdminCoachPage extends StatefulWidget {
  const AdminCoachPage({super.key});

  @override
  _AdminCoachPageState createState() => _AdminCoachPageState();
}

class _AdminCoachPageState extends State<AdminCoachPage> {
  DateTime _currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
  late Future<Map<DateTime, int>> _postCountData;
  late Future<List<Map<String, dynamic>>> _coachData;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _postCountData = fetchPostCountsByMonth(_currentMonth);
      _coachData = fetchAllCoaches();
    });
  }

  void _changeMonth(int months) {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + months);
      _loadData();
    });
  }

  List<LineChartBarData> _createChartData(Map<DateTime, int> postCountData) {
    List<FlSpot> spots = [];
    int daysInMonth = DateUtils.getDaysInMonth(_currentMonth.year, _currentMonth.month); // Use _currentMonth here

    // Start from day 1 and go up to the number of days in the current month
    for (int day = 1; day <= daysInMonth; day++) {
      final dateKey = DateTime(_currentMonth.year, _currentMonth.month, day); // Use _currentMonth
      int postCount = postCountData[dateKey] ?? 0;
      spots.add(FlSpot(day.toDouble(), postCount.toDouble()));
    }

    return [
      LineChartBarData(
        spots: spots,
        isCurved: false, // Normal line, not smooth
        color: Colors.blue,
        barWidth: 3,
        belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
      ),
    ];
  }

    void _showAddCoachDialog() {
    showDialog(
      context: context,
      builder: (context) => const AdminCoachSpecific(coach: {}), // Pass an empty coach map for a new coach
    ).then((_) {
      _loadData(); // Reload data after adding a new coach
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Month Display and Navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => _changeMonth(-1),
              ),
              Text(
                DateFormat('MMMM yyyy').format(_currentMonth),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  color: _currentMonth.isBefore(DateTime(DateTime.now().year, DateTime.now().month))
                      ? Colors.black
                      : Colors.grey,
                ),
                onPressed: _currentMonth.isBefore(DateTime(DateTime.now().year, DateTime.now().month))
                    ? () => _changeMonth(1)
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Line Chart with FutureBuilder
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<Map<DateTime, int>>(
              future: _postCountData,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                final postCountData = snapshot.data!;

                int daysInMonth = DateUtils.getDaysInMonth(_currentMonth.year, _currentMonth.month); // Use _currentMonth here

                return SizedBox(
                  height: 300,
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: true),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              // Display day (1, 2, 3, etc.) as x-axis labels
                              return Text(value.toInt().toString(), style: const TextStyle(fontSize: 10));
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              // Display the Y-axis values with a proper label
                              return Text(value.toInt().toString(), style: const TextStyle(fontSize: 10));
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      lineBarsData: _createChartData(postCountData),
                      minX: 1, // Start from day 1
                      maxX: daysInMonth.toDouble(), // Dynamic based on the number of days in the month
                      minY: 0, // Start from 0 post count
                      maxY: (postCountData.values.reduce((a, b) => a > b ? a : b) * 1.2).toDouble(),
                    ),
                  ),
                );
              },
            ),
          ),

          // Coach List Title with '+' Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Coach List',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _showAddCoachDialog, // Show the dialog to add a new coach
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Coach List
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _coachData,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final coaches = snapshot.data!;
                return ListView.builder(
                  itemCount: coaches.length,
                  itemBuilder: (context, index) {
                    final coach = coaches[index];
                    return ListTile(
                      title: Text(coach['username']),
                      trailing: PopupMenuButton(
                        onSelected: (value) async {
                          if (value == 'edit') {
                            await showDialog(
                              context: context,
                              builder: (context) => AdminCoachSpecific(coach: coach),
                            );
                            _loadData();
                          } else if (value == 'delete') {
                            await deleteCoach(coach['id']);
                            _loadData();
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'edit', child: Text('Edit')),
                          const PopupMenuItem(value: 'delete', child: Text('Delete')),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
