import 'package:zs_tracker/ui/views/add_time.dart';
import 'package:zs_tracker/ui/views/home.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext)> routes = {
  "/": (context) => const HomePage(
        title: 'Z\'s Tracker',
      ),
  "/add": (context) => const AddTimePage(
        title: 'Add Time',
      ),
};
