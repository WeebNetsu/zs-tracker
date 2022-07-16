import 'package:flutter/material.dart';
import 'package:zs_tracker/models/sleep.dart';
import 'package:zs_tracker/ui/widgets/star_row.dart';

class ViewTimeArguments {
  final SleepModel sleepData;

  ViewTimeArguments(this.sleepData);
}

class ViewTimePage extends StatefulWidget {
  const ViewTimePage({super.key, required this.title});

  final String title;

  @override
  State<ViewTimePage> createState() => _ViewTimePageState();
}

class _ViewTimePageState extends State<ViewTimePage> {
  @override
  Widget build(BuildContext context) {
    final windowWidth = MediaQuery.of(context).size.width;
    final colorScheme = Theme.of(context).colorScheme;

    final routeData =
        ModalRoute.of(context)?.settings.arguments as ViewTimeArguments?;
    if (routeData == null) Navigator.pop(context);

    final sleepData = routeData!.sleepData;

    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StarRow(
                  rating: sleepData.getRating(),
                  size: 40,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  sleepData.getDurationHHMM(),
                  style: const TextStyle(
                      fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text("Start:"),
                Text(
                  '${sleepData.getStartTimeStr()} - ${sleepData.getStartDateStr()}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
              child: Divider(color: Colors.grey),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text("End:"),
                Text(
                  '${sleepData.getEndTimeStr()} - ${sleepData.getEndDateStr()}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Notes:",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: Container(
                    height: 200,
                    color: Colors.grey[700],
                    width: windowWidth - 80,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        children: [
                          Text(
                            sleepData.getNotes(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MaterialButton(
                  onPressed: () {},
                  color: colorScheme.primary,
                  child: const Text("Edit"),
                ),
                MaterialButton(
                  onPressed: () => Navigator.pop(context),
                  color: colorScheme.primary,
                  child: const Text("Back"),
                ),
              ],
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      backgroundColor: Colors.grey[900],
    );
  }
}
