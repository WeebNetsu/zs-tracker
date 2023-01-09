import 'package:flutter/material.dart';
import 'package:zs_tracker/routes.dart';
import 'package:zs_tracker/services/local_notification.dart';

void main() {
  // below will ensure that the notification service is initialized
  // for the entire app, so we don't have to initialize it per page
  WidgetsFlutterBinding.ensureInitialized();
  LocalNotificationService().init();

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
          primary: Colors.blue[800],
          secondary: const Color.fromRGBO(227, 92, 6, 1),
        ),
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.grey[300],
              displayColor: Colors.grey[300],
            ),
      ),
      routes: routes,
    );
  }
}
