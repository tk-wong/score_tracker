import 'package:flutter/material.dart';
import 'package:score_app/pages/set_reason_page.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
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
          // ListTile(
          //   title: Text('Option 2'),
          //   subtitle: Text('Description for option 2'),
          //   onTap: () {
          //     // Handle option 2 tap
          //   },
          // ),
          // Add more settings options here
        ],
      ),
    );
  }
}