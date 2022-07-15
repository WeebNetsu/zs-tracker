import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zs_tracker/models/sleep.dart';
import 'package:zs_tracker/ui/widgets/sleep_time_container.dart';
import 'package:zs_tracker/utils.dart';

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
      // print('0 ' + sleep.runtimeType.toString());
      // print('1 ' + sleep["id"].runtimeType.toString());
      // print('2 ' + sleep["start"].runtimeType.toString());
      // print('3 ' + sleep["end"].runtimeType.toString());
      // print('4 ' + sleep["rating"].runtimeType.toString());
      // print('5 ' + sleep["notes"].runtimeType.toString());
      print(sleep);
      sleeps.add(
        SleepModel.fromJSON(sleep),
      );
    }

    // sort eariliest date first
    sleeps.sort((a, b) =>
        a.getStartTime().difference(b.getStartTime()).inMinutes.compareTo(0));

    setState(() {
      _sleeps = sleeps;
      _loadingData = false;
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _loadSleepData();
  // }

  @override
  Widget build(BuildContext context) {
    if (_loadingData) _loadSleepData();
    // _loadSleepData();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _loadingData
          ? const CircularProgressIndicator()
          : Column(
              children:
                  _sleeps.map((sleep) => SleepTimeContainer(sleep)).toList(),
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
        child: const Icon(Icons.nightlight_round_rounded),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      backgroundColor: Colors.grey[900],
    );
  }
}
