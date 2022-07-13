import 'package:flutter/material.dart';
import 'package:zs_tracker/models/sleep.dart';
import 'package:zs_tracker/ui/widgets/sleep_time_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<SleepModel> sleeps = [
    SleepModel(DateTime.now(), 100, 3),
    SleepModel(DateTime.now().add(const Duration(days: 1, hours: 2)), 200, 4),
    SleepModel(DateTime.now().add(const Duration(days: 1, hours: 9)), 15, 2)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: sleeps.map((sleep) => SleepTimeContainer(sleep)).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        tooltip: 'Increment',
        child: const Icon(Icons.nightlight_round_rounded),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      backgroundColor: Colors.grey[900],
    );
  }
}
