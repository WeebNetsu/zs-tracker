import 'package:flutter/material.dart';

/// Gets a routes data, will pop off the route if data is null
Object? getRouteData(BuildContext context, {bool popRouteOnNull = true}) {
  final routeData = ModalRoute.of(context)?.settings.arguments;
  if (routeData == null && popRouteOnNull) Navigator.pop(context);

  return routeData;
}

void showError(
  BuildContext context,
  String text, {
  int duration = 3,
  bool error = true,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      duration: Duration(seconds: duration),
      backgroundColor: error ? Colors.red : Colors.blue,
    ),
  );
}
