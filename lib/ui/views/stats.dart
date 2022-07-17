import 'package:flutter/material.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key, required this.title});

  final String title;

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          Text("Stat"),
        ],
      ),
      backgroundColor: Colors.grey[900],
    );
  }
}
