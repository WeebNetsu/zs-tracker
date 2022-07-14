import 'package:flutter/material.dart';

class Input extends StatefulWidget {
  const Input({super.key, required this.title, this.maxLines});
  final String title;
  final int? maxLines; // if should be multi-line

  @override
  State<Input> createState() => _Input();
}

class _Input extends State<Input> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[700],
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: TextField(
            maxLines: widget.maxLines,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.title,
            ),
          ),
        ),
      ),
    );
  }
}
