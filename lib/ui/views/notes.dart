import 'package:flutter/material.dart';
import 'package:zs_tracker/models/sleep.dart';
import 'package:zs_tracker/utils/app.dart';
import 'package:zs_tracker/utils/views.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key, required this.title});

  final String title;

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<SleepModel> _sleeps = [];

  void displayError(String text) => showError(context, text);

  Future<void> _loadData() async {
    final sleeps = await loadSleepData();

    if (sleeps == null) return;

    final List<SleepModel> importantSleeps = [];
    for (SleepModel sleep in sleeps) {
      if (sleep.notes.trim().isNotEmpty) {
        importantSleeps.add(sleep);
      }
    }

    setState(() {
      _sleeps = importantSleeps;
    });
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final windowWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          ..._sleeps
              .map(
                (sleep) => Column(
                  children: [
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(color: Colors.white),
                    ),
                    Text(
                      "${sleep.getStartDateStr()} ${sleep.getStartTimeStr()} "
                      "- ${sleep.getEndDateStr()} ${sleep.getEndTimeStr()}",
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      child: Container(
                        height: 150,
                        color: Colors.grey[700],
                        width: windowWidth - 50,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView(
                            children: [
                              Text(sleep.notes),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
          const SizedBox(height: 20),
        ],
      ),
      backgroundColor: Colors.grey[900],
    );
  }
}
