import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:zs_tracker/models/sleep.dart';
import 'package:zs_tracker/ui/widgets/dash_row.dart';
import 'package:zs_tracker/utils/app.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key, required this.title});

  final String title;

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  List<SleepModel> _sleeps = [];
  bool _loadingData = true;

  Future<void> _loadData() async {
    final sleeps = await loadSleepData();

    // todo this filtering should be happending when the user
    // filters by day/month/year/all time etc.
    sleeps?.retainWhere(
      (sleep) => sleep.endTime.isAfter(
        DateTime.now().subtract(const Duration(days: 29)),
      ),
    );

    setState(() {
      _sleeps = sleeps ?? [];
      _loadingData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingData) _loadData();

    List<SleepModel> selectedSleeps = [];
    final DateTime currentDate = DateTime.now();
    for (var sleep in _sleeps) {
      if (sleep.endTime.month == currentDate.month) {
        selectedSleeps.add(sleep);
        print(sleep.endTime);
      }
    }

    var filteredSleeps = selectedSleeps
        .map(
          (sleep) => {
            "day": sleep.endTime.day,
            "hours": (sleep.duration / 60).round(),
          },
        )
        .toList();

    final sleepDays = filteredSleeps.map((s) => s["day"]).toList();
    for (var i = 1; i < 29; i++) {
      if (sleepDays.contains(i)) continue;

      filteredSleeps.add({
        "day": i,
        "hours": 0,
      });
    }

    filteredSleeps.sort(
      (a, b) => a["day"]! > b["day"]! ? 1 : 0,
    );

    // star: timesUsed
    List<Map<String, int>> sleepRatings = [
      {"stars": 1, "count": 4},
      {"stars": 2, "count": 2},
      {"stars": 3, "count": 9},
      {"stars": 4, "count": 3},
      {"stars": 5, "count": 1}
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _loadingData
          ? const CircularProgressIndicator()
          : /* BarChart(
              BarChartData(
                // read about it in the BarChartData section
                maxY: 24,
                minY: 0,
                barGroups: [
                  ...filteredSleeps
                      .map((fs) => BarChartGroupData(
                            x: 0,
                            barRods: [
                              BarChartRodData(
                                toY: 10,
                                width: 10,
                              )
                            ],
                          ))
                      .toList(),
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: 10,
                        width: 10,
                      )
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY: 5,
                        width: 10,
                      )
                    ],
                  ),
                  BarChartGroupData(
                    x: 2,
                    barRods: [
                      BarChartRodData(
                        toY: 0,
                        width: 10,
                      )
                    ],
                  ),
                  BarChartGroupData(
                    x: 3,
                    barRods: [
                      BarChartRodData(
                        toY: 15,
                        width: 10,
                      )
                    ],
                  ),
                ],
              ),
              swapAnimationDuration: Duration(milliseconds: 150), // Optional
              swapAnimationCurve: Curves.linear, // Optional
            ), */
          ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Center(
                    child: Text(
                      "Minidash for all time stats",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 8,
                    right: 8,
                  ),
                  child: DashRow(sleeps: _sleeps),
                ),
                // https://pub.dev/documentation/graphic/latest/graphic/graphic-library.html

                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Center(
                    child: Text(
                      "Sleep times for this month",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 300,
                  child: Chart(
                    data: filteredSleeps,
                    variables: {
                      'day': Variable(
                        accessor: (Map map) => map['day'] as int,
                      ),
                      'hours': Variable(
                        accessor: (Map map) => map['hours'] as int,
                      ),
                    },
                    elements: [LineElement(), PointElement()],
                    axes: [
                      Defaults.horizontalAxis,
                      Defaults.verticalAxis,
                    ],
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Center(
                    child: Text(
                      "Sleep Ratings (All Time)",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 300,
                  child: Chart(
                    data: sleepRatings,
                    variables: {
                      'stars': Variable(
                        accessor: (Map<String, int> rating) =>
                            rating["stars"] as int,
                      ),
                      'rating': Variable(
                        accessor: (Map<String, int> rating) =>
                            rating["count"] as int,
                      ),
                    },
                    elements: [IntervalElement()],
                    axes: [
                      Defaults.horizontalAxis,
                      Defaults.verticalAxis,
                    ],
                  ),
                ),
              ],
            ),
      backgroundColor: Colors.grey[900],
    );
  }
}
