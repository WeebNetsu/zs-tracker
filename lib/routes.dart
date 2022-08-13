import 'package:zs_tracker/ui/views/add_time.dart';
import 'package:zs_tracker/ui/views/home.dart';
import 'package:flutter/material.dart';
import 'package:zs_tracker/ui/views/notes.dart';
import 'package:zs_tracker/ui/views/settings.dart';
import 'package:zs_tracker/ui/views/stats.dart';
import 'package:zs_tracker/ui/views/view_time.dart';

Map<String, Widget Function(BuildContext)> routes = {
  "/": (context) => const HomePage(title: 'Z\'s Tracker'),
  "/add": (context) => const AddTimePage(title: 'Add Time'),
  "/edit": (context) => const AddTimePage(title: 'Edit Time'),
  "/view": (context) => const ViewTimePage(title: 'View Time'),
  "/settings": (context) => const SettingsPage(title: 'Settings'),
  "/stats": (context) => const StatsPage(title: 'Your Stats'),
  "/notes": (context) => const NotesPage(title: 'Your Notes'),
};
