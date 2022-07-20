import 'package:flutter/cupertino.dart';

/// Gets a routes data, will pop off the route if data is null
Object? getRouteData(BuildContext context, {bool popRouteOnNull = true}) {
  final routeData = ModalRoute.of(context)?.settings.arguments;
  if (routeData == null && popRouteOnNull) Navigator.pop(context);

  return routeData;
}
