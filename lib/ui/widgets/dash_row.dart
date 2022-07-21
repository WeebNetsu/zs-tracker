import 'package:flutter/material.dart';
import 'package:zs_tracker/models/sleep.dart';
import 'package:zs_tracker/ui/widgets/dash_item.dart';
import 'package:zs_tracker/utils/data_calculations.dart';
import 'package:zs_tracker/utils/formatting.dart';

class DashRow extends StatelessWidget {
  const DashRow({
    Key? key,
    required this.sleeps,
  }) : super(key: key);

  final List<SleepModel> sleeps;

  @override
  Widget build(BuildContext context) {
    final windowWidth = MediaQuery.of(context).size.width;
    final timeSlept = calculateTimeSlept(sleeps);

    return Row(
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
              Text(
                calculateAvgSleptRating(sleeps).toStringAsFixed(2),
              ),
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
                : formatDuration(
                    Duration(
                      minutes: (timeSlept.inMinutes / sleeps.length).round(),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
