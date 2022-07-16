import 'package:flutter/material.dart';
import 'package:swipeable_tile/swipeable_tile.dart';
import 'package:zs_tracker/models/sleep.dart';
import 'package:zs_tracker/ui/views/add_time.dart';
import 'package:zs_tracker/ui/views/view_time.dart';
import 'package:zs_tracker/ui/widgets/star_row.dart';

class SleepTimeContainer extends StatefulWidget {
  final SleepModel? data;
  final Function reloadData;
  final Function deleteItem;

  const SleepTimeContainer(this.data,
      {super.key, required this.reloadData, required this.deleteItem});

  @override
  State<SleepTimeContainer> createState() => _SleepTimeContainer();
}

class _SleepTimeContainer extends State<SleepTimeContainer> {
  @override
  Widget build(BuildContext context) {
    // final colorScheme = Theme.of(context).colorScheme;
    // final windowWidth = MediaQuery.of(context).size.width;
    // final previewWidth = windowWidth / 2 - 12;

    // if loading data
    if (widget.data == null) return const CircularProgressIndicator();

    return Padding(
      padding: const EdgeInsets.fromLTRB(7, 7, 7, 0),
      child: MaterialButton(
        padding: const EdgeInsets.all(0),
        onPressed: () async {
          await Navigator.pushNamed(
            context,
            "/view",
            arguments: ViewTimePageArguments(widget.data!),
          );

          // this can be permance issue later on, but for right now, it makes life easy
          // todo: change once we have more experience in flutter later
          widget.reloadData();
        },
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          child: SwipeableTile(
            direction: SwipeDirection.horizontal,
            color: Colors.transparent,
            swipeThreshold: 0.7,
            onSwiped: (direction) async {
              // if delete
              if (direction == SwipeDirection.endToStart) {
                widget.deleteItem(widget.data!.id);
              } else {
                await Navigator.pushNamed(
                  context,
                  '/edit',
                  arguments: AddTimePageArguments(widget.data),
                );

                // we just need to refresh afterwards
                widget.reloadData();
              }
            },
            backgroundBuilder: (context, direction, progress) {
              if (direction == SwipeDirection.endToStart) {
                // return your widget
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
              } // else if (direction == SwipeDirection.startToEnd) {

              return Container(
                color: Colors.orange[800],
                alignment: direction == SwipeDirection.startToEnd
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.edit,
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
                          "Sleep Time: ${widget.data!.getStartTimeStr()} - ${widget.data!.getEndTimeStr()}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[300],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Slept For: ${widget.data!.getDurationHHMM()}",
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
                          widget.data!.getStartDateStr(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[300],
                          ),
                        ),
                        const SizedBox(height: 10),
                        StarRow(rating: widget.data!.rating),
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
