import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zs_tracker/models/settings.dart';
import 'package:zs_tracker/models/sleep.dart';
import 'package:zs_tracker/services/local_notification.dart';
import 'package:zs_tracker/ui/widgets/star_row.dart';
import 'package:zs_tracker/utils/app.dart';
import 'package:zs_tracker/utils/formatting.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.title});

  final String title;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _loading = false;
  final SettingsModel _settings = SettingsModel(5, "Dark", DateTime.now());
  bool _receiveNotifications = true;

  // todo cannot export data, having permission issues
  // for now we'll just share the backed up file
  // https://stackoverflow.com/questions/73012513/write-file-to-directory-with-allowed-access-on-android
  Future<void> _exportData() async {
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
  }

  Future<void> _importData() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result == null) return;

    // todo throw error
    if (result.files.length != 1) return;

    PlatformFile file = result.files[0];

    // todo throw error
    if (file.extension != "sav" || file.path == null) return;

    // we try to parse the data
    // todo do error handling
    List<SleepModel>? sleeps = await loadSleepData(filePath: file.path);

    // todo throw error
    if (sleeps == null) return;

    bool importSuccess = await saveSleepData(items: sleeps);

    // todo thow error
    if (!importSuccess) return;

    // todo show message if success
  }

  void _onNotficationListener(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      print("Payload from settings: $payload");
      Navigator.pushNamed(context, "/stats", arguments: {payload: payload});
    }
  }

  void _listenToNotifcation() {
    LocalNotificationService()
        .onNotificationClick
        .stream
        .listen(_onNotficationListener);
  }

  @override
  void initState() {
    super.initState();

    // for notification with payload
    _listenToNotifcation();
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Rating System"),
                    DropdownButton(
                      value: _settings.ratingSystem,
                      items: _settings.availableRatingSystems
                          .map(
                            (int rateSystem) => DropdownMenuItem(
                              value: rateSystem,
                              child: StarRow(
                                rating: rateSystem,
                                maxRating: rateSystem,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          if (value != null) _settings.ratingSystem = value;
                        });
                      },
                      style: const TextStyle(backgroundColor: Colors.black),
                      dropdownColor: Colors.grey[900],
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Themes"),
                      DropdownButton(
                        value: _settings.theme,
                        items: _settings.availableThemes
                            .map(
                              (String theme) => DropdownMenuItem(
                                value: theme,
                                child: Text(
                                  capitalizeWord(theme),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            if (value != null) _settings.theme = value;
                          });
                        },
                        style: const TextStyle(backgroundColor: Colors.black),
                        dropdownColor: Colors.grey[900],
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Receive Notifications?"),
                      Switch(
                        value: _receiveNotifications,
                        onChanged: ((bool value) {
                          setState(() {
                            _receiveNotifications = value;
                          });
                        }),
                      ),
                    ],
                  ),
                ),

                if (_receiveNotifications)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Send notification at"),
                        MaterialButton(
                          onPressed: () {},
                          color: colorScheme.primary,
                          child: const Text("Set Time"),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 40),
                const Text("Notifiction refers to reminder to add sleep times"),

                MaterialButton(
                  onPressed: () async {
                    await LocalNotificationService().showNotifcation(
                      title: "test",
                      body: "test 2",
                    );
                  },
                  child: const Text("Show Notification"),
                ),
                MaterialButton(
                  onPressed: () async {
                    await LocalNotificationService().showSheduledNotifcation(
                      title: "test",
                      body: "test that waited",
                      seconds: 5,
                    );
                  },
                  child: const Text("Show Scheduled Notification"),
                ),
                MaterialButton(
                  onPressed: () async {
                    await LocalNotificationService().showNotifcation(
                      title: "test",
                      body: "test that waited",
                      payload: "This is my data",
                    );
                  },
                  child: const Text("Show Payload Notification"),
                ),

                // Import/Export Data
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MaterialButton(
                      onPressed: () async {
                        setState(() {
                          _loading = true;
                        });

                        await _exportData();

                        setState(() {
                          _loading = false;
                        });
                      },
                      color: colorScheme.primary,
                      child: const Text("Export Data"),
                    ),
                    MaterialButton(
                      onPressed: () async {
                        // todo show warning that this will overwrite any already
                        // existing data

                        setState(() {
                          _loading = true;
                        });

                        await _importData();

                        setState(() {
                          _loading = false;
                        });
                      },
                      color: colorScheme.primary,
                      child: const Text("Import Data"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[900],
    );
  }
}
