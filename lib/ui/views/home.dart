import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zs_tracker/models/sleep.dart';
import 'package:zs_tracker/ui/widgets/dash_item.dart';
import 'package:zs_tracker/ui/widgets/navigation_drawer.dart';
import 'package:zs_tracker/ui/widgets/sleep_time_container.dart';
import 'package:zs_tracker/utils/app.dart';
import 'package:zs_tracker/utils/data_calculations.dart';
import 'package:zs_tracker/utils/formatting.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<SleepModel> _sleeps = [];
  bool _loadingData = true;

  Future<void> _loadSleepData() async {
    final Directory? appDir = await getAppDir();

    if (appDir == null) return;

    final File saveFile = File("${appDir.path}/save.json");

    if (!saveFile.existsSync()) {
      setState(() {
        _loadingData = false;
      });
      return;
    }

    final saveData = await saveFile.readAsString();

    final sleepJson = jsonDecode("[$saveData]");
    final List<SleepModel> sleeps = [];
    for (var sleep in sleepJson) {
      sleeps.add(
        SleepModel.fromJSON(sleep),
      );
    }

    // sort eariliest date first
    sleeps.sort(
        (a, b) => a.startTime.difference(b.startTime).inMinutes < 0 ? 1 : 0);

    setState(() {
      _sleeps = sleeps;
      _loadingData = false;
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  // }

  void _reloadData() async {
    setState(() {
      _loadingData = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingData) _loadSleepData();
    final windowWidth = MediaQuery.of(context).size.width;
    final colorScheme = Theme.of(context).colorScheme;
    final timeSlept = calculateTimeSlept(_sleeps);
    // final windowHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      drawer: _loadingData ? null : NavigationDrawer(),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _loadingData
          ? const CircularProgressIndicator()
          : ListView(
              children: [
                Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 8, right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DashItem(
                            windowWidth: windowWidth,
                            title: "Time Slept",
                            child: Text(formatDuration(timeSlept)),
                          ),
                          DashItem(
                            windowWidth: windowWidth,
                            title: 'Average Rating',
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(calculateAvgSleptRating(_sleeps)
                                    .toString()),
                                Icon(
                                  Icons.star_border,
                                  color: Colors.yellow[200],
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                          DashItem(
                            windowWidth: windowWidth,
                            title: "Average Sleep",
                            child: Text(
                              timeSlept.inMinutes < 1
                                  ? formatDuration(const Duration(minutes: 0))
                                  : formatDuration(Duration(
                                      minutes:
                                          (timeSlept.inMinutes / _sleeps.length)
                                              .round(),
                                    )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ..._sleeps
                        .map((sleep) => SleepTimeContainer(sleep, _reloadData))
                        .toList()
                  ],
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
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
        tooltip: 'Increment',
        backgroundColor: colorScheme.primary,
        child: const Icon(Icons.nightlight_round_rounded),
      ),
      backgroundColor: Colors.grey[900],
    );
  }
}
