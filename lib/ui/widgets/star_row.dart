import 'dart:math';

import 'package:flutter/material.dart';

class StarRow extends StatelessWidget {
  const StarRow({
    Key? key,
    required int rating,
    double size = 23,
  })  : _rating = rating,
        _size = size,
        super(key: key);

  final int _rating;
  final double _size;

  @override
  Widget build(BuildContext context) {
    final int fill = min(_rating, 5);
    final int empty = 5 - fill;
    List<Widget> row = [];

    for (var i = 0; i < fill; i++) {
      row.add(Icon(
        Icons.star,
        color: Colors.yellow[200],
        size: _size,
      ));
    }

    for (var i = 0; i < empty; i++) {
      row.add(Icon(
        Icons.star_border,
        color: Colors.yellow[200],
        size: _size,
      ));
    }
    // ListTile is just a row
    return Row(
      children: row,
    );
  }
}
