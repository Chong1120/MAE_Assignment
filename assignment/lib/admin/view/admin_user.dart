import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../feature/admin_manage_f.dart';
import 'admin_user_specific.dart';

class AdminUserPage extends StatefulWidget {
  const AdminUserPage({super.key});

  @override
  _AdminUserPageState createState() => _AdminUserPageState();
}

class _AdminUserPageState extends State<AdminUserPage> {
  DateTime _currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
  late Future<Map<DateTime, int>> _activeUserCount;
  late Future<List<Map<String, dynamic>>> _userData;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _activeUserCount = userActiveLevel(_currentMonth);
      _userData = fetchAllUsers();
    });
  }

  void _changeMonth(int months) {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + months);
      _loadData();
    });
  }

  List<LineChartBarData> _createChartData(Map<DateTime, int> activeUserCount) {
    List<FlSpot> spots = [];
    int daysInMonth = DateUtils.getDaysInMonth(_currentMonth.year, _currentMonth.month); // Use _currentMonth here

    // Start from day 1 and go up to the number of days in the current month
    for (int day = 1; day <= daysInMonth; day++) {
      final dateKey = DateTime(_currentMonth.year, _currentMonth.month, day); // Use _currentMonth
      int postCount = activeUserCount[dateKey] ?? 0;
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

    void _showAddUserDialog() {
    showDialog(
      context: context,
      builder: (context) => const AdminUserSpecific(user: {}), // Pass an empty user map for a new user
    ).then((_) {
      _loadData(); // Reload data after adding a new user
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
              future: _activeUserCount,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                final activeUserCount = snapshot.data!;

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
                      lineBarsData: _createChartData(activeUserCount),
                      minX: 1, // Start from day 1
                      maxX: daysInMonth.toDouble(), // Dynamic based on the number of days in the month
                      minY: 0, // Start from 0 post count
                      maxY: (activeUserCount.values.reduce((a, b) => a > b ? a : b) * 1.2).toDouble(),
                    ),
                  ),
                );
              },
            ),
          ),

          // user List Title with '+' Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'User List',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _showAddUserDialog, // Show the dialog to add a new User
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // User List
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _userData,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final Users = snapshot.data!;
                return ListView.builder(
                  itemCount: Users.length,
                  itemBuilder: (context, index) {
                    final user = Users[index];
                    return ListTile(
                      title: Text(user['username']),
                      trailing: PopupMenuButton(
                        onSelected: (value) async {
                          if (value == 'edit') {
                            await showDialog(
                              context: context,
                              builder: (context) => AdminUserSpecific(user: user),
                            );
                            _loadData();
                          } else if (value == 'delete') {
                            await deleteUser(user['id']);
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
