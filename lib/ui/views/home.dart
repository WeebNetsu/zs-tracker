import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:zs_tracker/models/sleep.dart';
import 'package:zs_tracker/ui/widgets/dash_row.dart';
import 'package:zs_tracker/ui/widgets/navigation_drawer.dart';
import 'package:zs_tracker/ui/widgets/sleep_time_container.dart';
import 'package:zs_tracker/utils/app.dart';
import 'package:zs_tracker/utils/formatting.dart';
import 'package:zs_tracker/utils/views.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<SleepModel> _sleeps = [];
  bool _loadingData = true;

  void displayError(String text) => showError(context, text);

  Future<void> _loadData() async {
    final sleeps = await loadSleepData();

    if (sleeps == null) {
      setState(() {
        _loadingData = false;
      });
      return;
    }

    setState(() {
      _sleeps = sleeps;
      _loadingData = false;
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  // }

  Future<void> _reloadData() async {
    setState(() {
      _loadingData = true;
    });
  }

  void _deleteItem(String id) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
          content: const Text("Item Deleted"),
          action: SnackBarAction(
            label: "Undo",
            onPressed: _reloadData,
            textColor: Colors.blue[800],
          ),
          // behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red[500],
          elevation: 1,
        ))
        .closed
        .then(
      (value) async {
        // if undo is not clicked
        if (value != SnackBarClosedReason.action) {
          List<SleepModel> newSleeps = [];
          for (var sleep in _sleeps) {
            if (sleep.id != id) {
              newSleeps.add(sleep);
            }
          }

          bool saved = await saveSleepData(items: newSleeps);

          if (!saved) {
            displayError("Could not delete item");
            return;
          }

          setState(() {
            _loadingData = true;
          });
        }
      },
    );
  }

  Map<int, Map<String, List<SleepModel>>> _generateSleepMap(
    Map<int, Map<String, List<SleepModel>>> sleeps,
    SleepModel sleep,
    int month,
  ) {
    var newSleeps = sleeps;
    if (newSleeps[sleep.endTime.year] == null) {
      newSleeps[sleep.endTime.year] = {};
    }
    if (newSleeps[sleep.endTime.year]![convertMonthToString(month)] == null) {
      newSleeps[sleep.endTime.year]![convertMonthToString(month)] = [];
    }

    newSleeps[sleep.endTime.year]![convertMonthToString(month)]!.add(sleep);

    return newSleeps;
  }

  List<Column> _buildSleepItems() {
    Map<int, Map<String, List<SleepModel>>> sleeps = {};

    for (var sleep in _sleeps) {
      switch (sleep.startTime.month) {
        case DateTime.january:
          sleeps = _generateSleepMap(sleeps, sleep, DateTime.january);
          break;
        case DateTime.february:
          sleeps = _generateSleepMap(sleeps, sleep, DateTime.february);
          break;
        case DateTime.march:
          sleeps = _generateSleepMap(sleeps, sleep, DateTime.march);
          break;
        case DateTime.april:
          sleeps = _generateSleepMap(sleeps, sleep, DateTime.april);
          break;
        case DateTime.may:
          sleeps = _generateSleepMap(sleeps, sleep, DateTime.may);
          break;
        case DateTime.june:
          sleeps = _generateSleepMap(sleeps, sleep, DateTime.june);
          break;
        case DateTime.july:
          sleeps = _generateSleepMap(sleeps, sleep, DateTime.july);
          break;
        case DateTime.august:
          sleeps = _generateSleepMap(sleeps, sleep, DateTime.august);
          break;
        case DateTime.september:
          sleeps = _generateSleepMap(sleeps, sleep, DateTime.september);
          break;
        case DateTime.october:
          sleeps = _generateSleepMap(sleeps, sleep, DateTime.october);
          break;
        case DateTime.november:
          sleeps = _generateSleepMap(sleeps, sleep, DateTime.november);
          break;
        case DateTime.december:
          sleeps = _generateSleepMap(sleeps, sleep, DateTime.december);
          break;
      }
    }

    // no, the maps are not what is causing the sleeps to be in the wrong order
    return sleeps.entries
        .map(
          (entry) => Column(
            children: [
              // don't show current year!
              if (entry.key != DateTime.now().year)
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 12, right: 12, top: 12),
                      child: Divider(color: Colors.grey),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ...entry.key
                              .toString()
                              .split("")
                              .map(
                                (e) => Text(
                                  e,
                                  style: TextStyle(
                                    // get random color
                                    color: Colors.primaries[Random().nextInt(
                                      Colors.primaries.length,
                                    )],
                                    fontSize: 18,
                                  ),
                                ),
                              )
                              .toList(),
                        ],
                      ),
                    ),
                  ],
                ),

              // for each month in year
              ...entry.value.entries
                  .map(
                    (e) => Column(
                      children: [
                        if (e.key != convertMonthToString(DateTime.now().month))
                          Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Divider(color: Colors.grey),
                              ),
                              // capitalze first letter of month
                              Text(capitalizeWord(e.key)),
                            ],
                          ),

                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            left: 8,
                            right: 8,
                          ),
                          child: DashRow(sleeps: e.value),
                        ),

                        // for each item in month
                        ...e.value
                            .map(
                              (sleep) => SleepTimeContainer(
                                sleep,
                                reloadData: _reloadData,
                                deleteItem: _deleteItem,
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  )
                  .toList(),
            ],
          ),
          // entry.value.entries.map((e) => e.value);
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingData) _loadData();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      drawer: _loadingData ? null : NavigationDrawer(reloadData: _reloadData),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _loadingData
          ? const CircularProgressIndicator()
          : ListView(
              children: [
                Column(
                  children: [
                    ..._buildSleepItems(),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
      floatingActionButton: SpeedDial(
        overlayColor: const Color.fromRGBO(30, 30, 30, 1),
        spaceBetweenChildren: 7,
        spacing: 5,
        backgroundColor: colorScheme.secondary,
        tooltip: 'Add Sleep',
        children: [
          SpeedDialChild(
            child: const Icon(Icons.lock_clock),
            onTap: () async {
              // below will go to /add on button pressed
              // note, this will push a new screen ontop of our screen, so our screen
              // will still exist!
              // the appbar will then also have a <- arrow to pop the current screen and come back
              // to this screen
              // https://youtu.be/Xnp6ptZVs1g
              dynamic data = await Navigator.pushNamed(context, "/add");
              setState(() {
                if (data != null) _loadingData = data['reload'];
              });
            },
            onLongPress: () => showError(
              context,
              "Add your sleep time!",
              error: false,
            ),
          ),
          SpeedDialChild(
            child: const Icon(Icons.add_alarm_sharp),
            onLongPress: () => showError(
              context,
              "Start the sleep timer!",
              error: false,
            ),
          ),
        ],
        child: const Icon(Icons.nightlight_round_rounded),
      ),
      backgroundColor: Colors.grey[900],
    );
  }
}
