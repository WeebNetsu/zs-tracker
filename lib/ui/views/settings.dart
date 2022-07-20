import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zs_tracker/utils/app.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.title});

  final String title;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _loading = false;

  // todo cannot export data, having permission issues
  // for now we'll just share the backed up file
  // https://stackoverflow.com/questions/73012513/write-file-to-directory-with-allowed-access-on-android
  Future<void> _exportData() async {
    setState(() {
      _loading = true;
    });
    // All available permissions for permission handler:
    // https://github.com/Baseflow/flutter-permission-handler/blob/master/permission_handler/example/android/app/src/main/AndroidManifest.xml
    // Either the permission was already granted before or the user just granted it.
    // only manage_external_storage can be used to write to custom directory, and unless it is a core
    // functionality of my app, Play Store will reject it, which we want to avoid, so we'll save to documents folder instead
    // todo: show error instead of just returning
    if (!(await Permission.storage.request().isGranted)) return;
    Directory? appDir = await getAppDir();

    // todo show error instead
    if (appDir == null) return;

    File exportFile = await File(
      "${appDir.path}/zs_tracker_data_${DateTime.now().toString().replaceAll(' ', '_')}.sav",
    ).create(recursive: true);

    final File saveFile = File("${appDir.path}/save.json");

    if (!saveFile.existsSync()) {
      // todo return error
      return;
    }

    await exportFile.writeAsString(
      saveFile.readAsStringSync(),
      mode: FileMode.write,
    );

    await Share.shareFiles(
      [exportFile.path],
      text:
          "My sleep data for ${DateFormat("dd MMMM yyyy").format(DateTime.now())}",
    );

    // if running into errors, https://github.com/miguelpruivo/flutter_file_picker/wiki/Setup#android
    // find out where the user wants to export to
    /* final String? exportPath = await FilePicker.platform.getDirectoryPath();

    // if no folder was chosen
    if (exportPath == null) return;

    File exportFile = await File(
      "$exportPath/zs_tracker_data_${DateTime.now().toString().replaceAll(' ', '_')}.sav",
    ).create(recursive: true);
    */
    // // if the file is empty, don't append , at the start of the json!
    // await exportFile.writeAsString(
    //   "Hello World",
    //   mode: FileMode.write,
    // );

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MaterialButton(
                onPressed: () async {
                  await _exportData();
                },
                color: colorScheme.primary,
                child: const Text("Export Data"),
              ),
              MaterialButton(
                onPressed: () {},
                color: colorScheme.primary,
                child: const Text("Import Data"),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.grey[900],
    );
  }
}
