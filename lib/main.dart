import 'package:flutter/material.dart';
import 'package:zs_tracker/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Z's Tracker",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.blue,
        ),
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.grey[300],
              displayColor: Colors.grey[300],
            ),
      ),
      // home: const HomePage(title: 'Z\'s Tracker'),
      routes: routes,
    );
  }
}
