import 'package:flutter/material.dart';
import 'package:swipeable_tile/swipeable_tile.dart';
import 'package:zs_tracker/models/sleep.dart';
import 'package:zs_tracker/ui/views/view_time.dart';
import 'package:zs_tracker/ui/widgets/star_row.dart';

class SleepTimeContainer extends StatelessWidget {
  final SleepModel? _data;

  const SleepTimeContainer(this._data, {super.key});

  @override
  Widget build(BuildContext context) {
    // final colorScheme = Theme.of(context).colorScheme;
    // final windowWidth = MediaQuery.of(context).size.width;
    // final previewWidth = windowWidth / 2 - 12;

    // if loading data
    if (_data == null) return const CircularProgressIndicator();

    return Padding(
      padding: const EdgeInsets.fromLTRB(7, 7, 7, 0),
      child: MaterialButton(
        padding: const EdgeInsets.all(0),
        onPressed: () {
          Navigator.pushNamed(
            context,
            "/view",
            arguments: ViewTimeArguments(_data!),
          );
        },
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          child: SwipeableTile(
            direction: SwipeDirection.horizontal,
            color: Colors.transparent,
            swipeThreshold: 0.7,
            onSwiped: (direction) => {},
            backgroundBuilder: (context, direction, progress) {
              // if (direction == SwipeDirection.endToStart) {
              // return your widget
              // } else if (direction == SwipeDirection.startToEnd) {
              return Container(
                color: Colors.red,
                alignment: direction == SwipeDirection.startToEnd
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.delete_forever,
                    color: Colors.grey[400],
                  ),
                ),
              );
              // }
            },
            key: UniqueKey(),
            child: Container(
              decoration: BoxDecoration(color: Colors.blue[800]),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sleep Time: ${_data!.getStartTimeStr()} - ${_data!.getEndTimeStr()}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[300],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Slept For: ${_data!.getDurationHHMM()}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[300],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(flex: 1),
                    Column(
                      children: [
                        Text(
                          _data!.getStartDateStr(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[300],
                          ),
                        ),
                        const SizedBox(height: 10),
                        StarRow(rating: _data!.getRating()),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
