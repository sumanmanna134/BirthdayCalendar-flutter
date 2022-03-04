import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:birthday_calendar/service/StorageService.dart';
import 'package:birthday_calendar/service/service_locator.dart';

class SettingsScreen extends StatefulWidget {
  final Function onClearNotifications;
  final Function onThemeChanged;

  const SettingsScreen({required this.onClearNotifications, required this.onThemeChanged});

  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  bool _isDarkModeEnabled = false;
  String versionNumber = "";
  StorageService _storageService = getIt<StorageService>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
        setState(() {
          versionNumber = packageInfo.version;
        });
      });
    });
   _getStoredThemeSetting();
  }

  void _getStoredThemeSetting() async {
    bool savedThemeModeSetting = await _storageService.getThemeModeSetting();
    setState(() {
      _isDarkModeEnabled = savedThemeModeSetting;
    });

  }

  void _showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text("Are You Sure?"),
      content: Text("Do you want to remove all notifications?"),
      actions: [
        TextButton(
        onPressed: () {
          _storageService.clearAllBirthdays()
              .then((didClearAllNotifications) =>
          {
            if (didClearAllNotifications) {
              widget.onClearNotifications()
            }
          });
          Navigator.pop(context);
        },
        child: const Text("Yes"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("No"),
        ),
      ],
    );
    showDialog(context: context,
    builder: (BuildContext context) {
      return alert;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Settings"),
      ),
      body:
          new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SwitchListTile(
                title: const Text('Dark Mode'),
                value: _isDarkModeEnabled,
                secondary:
                new Icon(Icons.dark_mode,
                    color: Color(0xFF642ef3)
                ),
                onChanged: (bool value) {
                  setState(() {
                    _isDarkModeEnabled = value;
                    _storageService.saveThemeModeSetting(_isDarkModeEnabled);
                    ThemeMode mode = _isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light;
                    widget.onThemeChanged(mode);
                  });
                },
              ),
              ListTile(
                  title: const Text("Clear Notifications"),
                  leading: const Icon(
                      Icons.clear,
                      color: Colors.redAccent),
                  onTap: () {
                    _showAlertDialog(context);
                  }
              ),
              Spacer(),
              new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                          "v " + this.versionNumber
                      )
                  )
                ],
              )
            ],
          ),
    );
  }

}