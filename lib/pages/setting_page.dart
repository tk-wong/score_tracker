import 'package:flutter/material.dart';
import 'package:score_app/pages/set_reason_page.dart';

enum ColorTheme { light, dark, system }

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: Text('Set default reasons'),
            // subtitle: Text('Description for option 1'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SetReasonPage()),
              );
              // Handle option 1 tap
            },
          ),
          ListTile(
            title: Text('Set color theme'),
            subtitle: Text('Description for option 2'),
            onTap: () async {
              return showDialog(
                context: context,
                builder: (BuildContext buildContext) {
                  return ColorThemeSelectionDialog();
                },
              );
              // Handle option 2 tap
            },
          ),
          // Add more settings options here
        ],
      ),
    );
  }
}

class ColorThemeSelectionDialog extends StatefulWidget {
  const ColorThemeSelectionDialog({super.key});

  @override
  State<ColorThemeSelectionDialog> createState() =>
      _ColorThemeSelectionDialogState();
}

class _ColorThemeSelectionDialogState extends State<ColorThemeSelectionDialog> {
  ThemeMode _selectedColorTheme = ThemeMode.light;
  final _colorThemeFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Set color theme"),
      content: Form(
        key: _colorThemeFormKey,
        child: RadioGroup(
          groupValue: _selectedColorTheme,
          onChanged: (ThemeMode? value) => {
            setState(() => _selectedColorTheme = value!),
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RadioListTile<ThemeMode>(
                title: const Text('Light'),
                value: ThemeMode.light,
              ),
              RadioListTile<ThemeMode>(
                title: const Text('Dark'),
                value: ThemeMode.dark,
              ),
              RadioListTile<ThemeMode>(
                title: const Text('System'),
                value: ThemeMode.system,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _onChangeTheme, //todo: add onPress function
          child: const Text('Confirm'),
        ),
      ],
    );
  }
  void _onChangeTheme() {
 // https://stackoverflow.com/a/67714404 
  }
}
