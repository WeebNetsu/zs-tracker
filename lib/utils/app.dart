import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqlite_wrapper/sqlite_wrapper.dart';
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
//   final newFile = await File("${appDir.path}/save.db").create();

  try {
    // if overwriting
    if (items != null) {
      final x = await SQLiteWrapper().openDB("${appDir.path}/save.db");
      print(x);
      SQLiteWrapper().closeDB();

      /* JSON method
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
      ); */
    } else {
      // if appending
      final x = await SQLiteWrapper().openDB("${appDir.path}/save.sqlite", onCreate: () async {
        await SQLiteWrapper().query("""
            CREATE TABLE sleeps (
                id string unique primary key,
                start int,
                end int,
                rating int,
                notes string
            );
            """);
      });

      await SQLiteWrapper().insert(item!.toJson(), "sleeps");

      SQLiteWrapper().closeDB();

      /* JSON method
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
      } */
    }

    return true;
  } catch (err) {
    print(err);
  }

  return false;
}

/// Load sleep data. If `filePath` is provided, read sleep data from the provided path file,
///
/// else read the data from our save.json in our app directory
Future<List<SleepModel>?> loadSleepData({
  String? filePath,
  bool sort = true,
}) async {
  final Directory? appDir = await getAppDir();

  if (appDir == null) return null;

  final File saveFile = File(filePath ?? "${appDir.path}/save.json");

  if (!saveFile.existsSync()) {
    return null;
  }

  final saveData = await saveFile.readAsString();

  final sleepJson = jsonDecode("[$saveData]");
  final List<SleepModel> sleeps = [];
  for (var sleep in sleepJson) {
    sleeps.add(
      SleepModel.fromJSON(sleep),
    );
  }

  if (sort) {
    // sort eariliest date first
    sleeps.sort(
      (a, b) => a.startTime.difference(b.startTime).inMinutes < 0 ? 1 : 0,
    );
  }

  return sleeps;
}
