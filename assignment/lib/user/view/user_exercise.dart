import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../feature/user_report_f.dart';  // The functions for fetching data

class UserExercisePage extends StatefulWidget {
  final String userId;
  const UserExercisePage({super.key, required this.userId});

  @override
  _UserExercisePageState createState() => _UserExercisePageState();
}

class _UserExercisePageState extends State<UserExercisePage> {
  late List<Map<String, dynamic>> _activityData;
  late DateTime _selectedDate;
  late DateTime _startOfWeek;
  late DateTime _endOfWeek;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _startOfWeek = _getStartOfWeek(_selectedDate);
    _endOfWeek = _startOfWeek.add(const Duration(days: 6));
    _activityData = [];
    _loadActivityData();
  }

  DateTime _getStartOfWeek(DateTime date) {
    int daysToSubtract = date.weekday - DateTime.monday;
    return date.subtract(Duration(days: daysToSubtract));
  }

  Future<void> _loadActivityData() async {
    List<Map<String, dynamic>> data = await fetchActivityData(widget.userId);
    Map<String, Map<String, dynamic>> weeklyEntries = {};

    for (var entry in data) {
      DateTime activityDate = DateTime.parse(entry['date']);
      if (activityDate.isAfter(_startOfWeek.subtract(const Duration(days: 1))) &&
          activityDate.isBefore(_endOfWeek.add(const Duration(days: 1)))) {
        String dateKey = DateFormat('yyyy-MM-dd').format(activityDate);
        // Only keep the latest entry for each date
        if (!weeklyEntries.containsKey(dateKey) || 
            activityDate.isAfter(DateTime.parse(weeklyEntries[dateKey]!['date']))) {
          weeklyEntries[dateKey] = entry;
        }
      }
    }
    
    setState(() {
      _activityData = weeklyEntries.values.toList();
    });
  }

  List<BarChartGroupData> _createChartData() {
    return _activityData.map((activity) {
      DateTime activityDate = DateTime.parse(activity['date']);
      int xValue = activityDate.difference(_startOfWeek).inDays;

      // Handle cases where 'num' might be null
      double toYValue = activity['num'] != null ? activity['num'].toDouble() : 0.0;

      return BarChartGroupData(
        x: xValue,
        barRods: [
          BarChartRodData(
            fromY: 0,  // Start from Y = 0
            toY: toYValue,  // Use the validated toY value
            rodStackItems: [],
            borderRadius: BorderRadius.zero,
            width: 15,
            color: Colors.green,
          ),
        ],
      );
    }).toList();
  }

  FlTitlesData _generateTitles() {
    return FlTitlesData(
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false), // Hide top titles
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (double value, TitleMeta meta) {
            DateTime date = _startOfWeek.add(Duration(days: value.toInt() + 1));
            String formattedDate = DateFormat('MM/dd').format(date);
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(formattedDate, style: const TextStyle(fontSize: 10)),
            );
          },
        ),
      ),
      leftTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: true),
      ),
    );
  }

  void _navigateToPreviousWeek() {
    setState(() {
      _startOfWeek = _startOfWeek.subtract(const Duration(days: 7));
      _endOfWeek = _endOfWeek.subtract(const Duration(days: 7));
      _loadActivityData();  // Reload data for the new week
    });
  }

  void _navigateToNextWeek() {
    if (_endOfWeek.isBefore(DateTime.now())) {
      setState(() {
        _startOfWeek = _startOfWeek.add(const Duration(days: 7));
        _endOfWeek = _endOfWeek.add(const Duration(days: 7));
        _loadActivityData();  // Reload data for the new week
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _navigateToPreviousWeek,
              ),
              Text(
                '${DateFormat('MM/dd').format(_startOfWeek)} - ${DateFormat('MM/dd').format(_endOfWeek)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  color: _startOfWeek.isBefore(DateTime.now().subtract(const Duration(days: 7))) ? Colors.black : Colors.grey,
                ),
                onPressed: _startOfWeek.isBefore(DateTime.now().subtract(const Duration(days: 7)))
                    ? _navigateToNextWeek
                    : null,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 300,
            width: double.infinity,
            child: BarChart(
              BarChartData(
                gridData: const FlGridData(show: true),
                titlesData: _generateTitles(),
                borderData: FlBorderData(show: true),
                barGroups: _createChartData(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
