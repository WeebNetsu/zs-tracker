import 'package:flutter/material.dart';

class DashItem extends StatelessWidget {
  const DashItem({
    Key? key,
    required this.windowWidth,
    required this.title,
    required this.child,
  }) : super(key: key);

  final double windowWidth;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.secondary,
        ),
        height: 70,
        width: (windowWidth / 3.3),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
