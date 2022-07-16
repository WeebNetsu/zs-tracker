import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.title});

  final String title;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MaterialButton(
                onPressed: () {},
                color: colorScheme.primary,
                child: const Text("Export Data"),
              ),
              MaterialButton(
                onPressed: () {},
                color: colorScheme.primary,
                child: const Text("Import Data"),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.grey[900],
    );
  }
}
