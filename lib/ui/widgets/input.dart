import 'package:flutter/material.dart';

class Input extends StatefulWidget {
  final String title;
  final int? maxLines; // if should be multi-line
  final TextEditingController? contollerItem;

  const Input({
    super.key,
    required this.title,
    this.maxLines,
    this.contollerItem,
  });

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
            controller: widget.contollerItem,
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
