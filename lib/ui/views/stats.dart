import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key, required this.title});

  final String title;

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          Text("Stat"),
          // https://pub.dev/documentation/graphic/latest/graphic/graphic-library.html
          Chart(
            data: const [
              {'genre': 'Sports', 'sold': 275},
              {'genre': 'Strategy', 'sold': 115},
              {'genre': 'Action', 'sold': 120},
              {'genre': 'Shooter', 'sold': 350},
              {'genre': 'Other', 'sold': 150},
            ],
            variables: {
              'genre': Variable(
                accessor: (Map map) => map['genre'] as String,
              ),
              'sold': Variable(
                accessor: (Map map) => map['sold'] as num,
              ),
            },
            elements: [IntervalElement()],
            axes: [
              Defaults.horizontalAxis,
              Defaults.verticalAxis,
            ],
          )
        ],
      ),
      backgroundColor: Colors.grey[900],
    );
  }
}
