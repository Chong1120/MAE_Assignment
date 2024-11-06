import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
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

  @override
  void initState() {
    super.initState();
    _activityData = [];
    _loadActivityData();
  }

  Future<void> _loadActivityData() async {
    List<Map<String, dynamic>> data = await fetchActivityData(widget.userId);
    setState(() {
      _activityData = data;
    });
  }

  List<BarChartGroupData> _createChartData() {
    return _activityData.map((activity) {
      return BarChartGroupData(
        x: activity['date'],
        barRods: [
          BarChartRodData(
            fromY: 0,  // Start from Y = 0
            toY: activity['num'].toDouble(),  // End at the value of the activity
            rodStackItems: [],
            borderRadius: BorderRadius.zero,
            width: 15,
            color: Colors.green,  // Correct parameter name for the bar color
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Display the chart with activity data
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: BarChart(
            BarChartData(
              gridData: const FlGridData(show: true),
              titlesData: const FlTitlesData(show: true),
              borderData: FlBorderData(show: true),
              barGroups: _createChartData(),
            ),
          ),
        ),
      ],
    );
  }
}
