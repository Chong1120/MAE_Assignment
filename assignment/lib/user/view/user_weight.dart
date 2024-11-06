import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';
import '../feature/user_report_f.dart'; // The functions for fetching data

class UserWeightPage extends StatefulWidget {
  final String userId;
  const UserWeightPage({super.key, required this.userId});

  @override
  _UserWeightPageState createState() => _UserWeightPageState();
}

class _UserWeightPageState extends State<UserWeightPage> {
  late DateTime _selectedDate;
  late DateTime _startOfWeek; // Start of the current week (Monday)
  late DateTime _endOfWeek; // End of the current week (Sunday)
  late List<Map<String, dynamic>> _weightData;
  late List<Map<String, dynamic>> _filteredData;
  double _minWeight = 0;
  double _maxWeight = 0;

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _startOfWeek = _getStartOfWeek(_selectedDate);
    _endOfWeek = _startOfWeek.add(const Duration(days: 6));
    _dateController.text = DateFormat('MM/dd').format(_selectedDate);
    _weightData = [];
    _filteredData = [];
    _loadWeightData();
  }

  DateTime _getStartOfWeek(DateTime date) {
    int daysToSubtract = date.weekday - DateTime.monday;
    return date.subtract(Duration(days: daysToSubtract));
  }

  Future<void> _loadWeightData() async {
    List<Map<String, dynamic>> data = await fetchWeightData(widget.userId);
    // Filter to keep only the latest entry per date
    Map<String, Map<String, dynamic>> latestEntries = {};
    for (var entry in data) {
      String dateKey = DateFormat('yyyy-MM-dd').format(DateTime.parse(entry['date']));
      DateTime entryDate = DateTime.parse(entry['date']);
      if (!latestEntries.containsKey(dateKey) || entryDate.isAfter(DateTime.parse(latestEntries[dateKey]!['date']))) {
        latestEntries[dateKey] = entry;
      }
    }
    setState(() {
      // Filter out entries with weight values that don't make sense (like 1730)
      _weightData = latestEntries.values.where((entry) => entry['value'] < 300).toList();
      _filterDataByWeek();
      _calculateMinMaxWeight();
    });
  }

  void _filterDataByWeek() {
    _filteredData = _weightData.where((weight) {
      DateTime date = DateTime.parse(weight['date']);
      return date.isAtSameMomentAs(_startOfWeek) || 
        date.isAtSameMomentAs(_endOfWeek) ||
        (date.isAfter((_startOfWeek).subtract(const Duration(days: 1))) && date.isBefore(_endOfWeek));
    }).toList();

    // Sort by date in ascending order
    _filteredData.sort((a, b) => DateTime.parse(a['date']).compareTo(DateTime.parse(b['date'])));
  }


  void _calculateMinMaxWeight() {
    if (_filteredData.isNotEmpty) {
      _minWeight = _filteredData
          .map((weight) => weight['value'].toDouble())
          .reduce((a, b) => a < b ? a : b);
      _maxWeight = _filteredData
          .map((weight) => weight['value'].toDouble())
          .reduce((a, b) => a > b ? a : b);
    }
  }

  List<BarChartGroupData> _createChartData() {
    return _filteredData.map((weight) {
      DateTime date = DateTime.parse(weight['date']);
      return BarChartGroupData(
        x: date.millisecondsSinceEpoch,
        barRods: [
          BarChartRodData(
            toY: weight['value'].toDouble(),
            color: Colors.blue,
            width: 15,
            borderRadius: BorderRadius.zero,
          ),
        ],
      );
    }).toList();
  }

  void _navigateToPreviousWeek() {
    setState(() {
      _startOfWeek = _startOfWeek.subtract(const Duration(days: 7));
      _endOfWeek = _endOfWeek.subtract(const Duration(days: 7));
      _filterDataByWeek();
      _calculateMinMaxWeight();
    });
  }

  void _navigateToNextWeek() {
    if (_endOfWeek.isBefore(DateTime.now())) {
      setState(() {
        _startOfWeek = _startOfWeek.add(const Duration(days: 7));
        _endOfWeek = _endOfWeek.add(const Duration(days: 7));
        _filterDataByWeek();
        _calculateMinMaxWeight();
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
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false), // Hide top titles
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value == _minWeight.floorToDouble() || value == _maxWeight.ceilToDouble()) {
                          return Text(value.toStringAsFixed(0), // Display integer values only
                              style: const TextStyle(fontSize: 10));
                        }
                        return Container();
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                        for (var weight in _filteredData) {
                          DateTime weightDate = DateTime.parse(weight['date']);
                          if (weightDate.year == date.year && weightDate.month == date.month && weightDate.day == date.day) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text('${DateFormat('MM/dd').format(date)} (${weight['value']})',
                                  style: const TextStyle(fontSize: 10)),
                            );
                          }
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: true),
                barGroups: _createChartData(),
                minY: _minWeight - 5,
                maxY: _maxWeight + 5,
              ),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _dateController,
                decoration: const InputDecoration(labelText: 'Date (MM/DD)'),
                readOnly: true,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () async {
                final selected = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (selected != null && selected != _selectedDate) {
                  setState(() {
                    _selectedDate = selected;
                    _dateController.text = DateFormat('MM/dd').format(selected);
                  });
                }
              },
            ),
          ],
        ),
        TextField(
          controller: _weightController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'Weight (kg)'),
        ),
        ElevatedButton(
          onPressed: () {
            double weight = double.tryParse(_weightController.text) ?? 0;
            if (weight > 0) {
              _addWeightData(_selectedDate, weight);
            }
          },
          child: const Text('Add Weight'),
        ),
      ],
    );
  }

  Future<void> _addWeightData(DateTime date, double weight) async {
    await addWeightData(widget.userId, date, weight);
    _loadWeightData();
  }
}
