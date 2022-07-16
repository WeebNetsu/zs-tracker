import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:zs_tracker/models/sleep.dart';

Future<Directory?> getAppDir() async {
  var dirs = await getExternalStorageDirectories();
  if (dirs == null || dirs.isEmpty) return null;

  return dirs[0];
}

/// Save sleep data to file, returns true if success
///
/// If `item` is provided, it will **APPEND** to file if `items` is provided, it will **OVERWRITE** the file
Future<bool> saveSleepData({SleepModel? item, List<SleepModel>? items}) async {
  Directory? appDir = await getAppDir();

  if (appDir == null) return false;

  if ((item == null && items == null) || (item != null && items != null)) {
    throw ArgumentError(
      "Either item or items should be provided, only one, not both.",
    );
  }

  // create will not overwrite existing data
  final newFile = await File("${appDir.path}/save.json").create();

  try {
    // if overwriting
    if (items != null) {
      String newSleeps = "";
      for (var sleep in items) {
        newSleeps += "${jsonEncode(sleep.toJson())},";
      }

      // remove last character from string, aka ","
      if (newSleeps.isNotEmpty) {
        newSleeps = newSleeps.substring(0, newSleeps.length - 1);
      }

      // if the file is empty, don't append , at the start of the json!
      await newFile.writeAsString(
        newSleeps,
        mode: FileMode.write,
      );
    } else {
      // if appending
      if (newFile.readAsLinesSync().isEmpty) {
        await newFile.writeAsString(
          jsonEncode(item!.toJson()),
          mode: FileMode.append,
        );
      } else {
        await newFile.writeAsString(
          ",${jsonEncode(item!.toJson())}",
          mode: FileMode.append,
        );
      }
    }

    return true;
  } catch (err) {
    print(err);
  }

  return false;
}
