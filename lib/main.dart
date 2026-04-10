import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:score_app/controller/score_reason_controller.dart';
import 'package:score_app/controller/score_user_controller.dart';
import 'package:score_app/models/object_box.dart';
import 'package:score_app/models/score_history_entry.dart';
import 'l10n/app_localizations.dart';
import 'pages/score_home_page.dart';

late ObjectBox objectBox;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectBox = await ObjectBox.create();
  Store store = objectBox.store; // Access the store if needed for setup
  ScoreReasonController reasonController = ScoreReasonController.create(store);
  reasonController.loadDefaultReasons(); // Load default reasons into the database
  ScoreUserController userController = ScoreUserController.create(store);
  userController.addDefaultUsers(); // Load default users into the database
  runApp(const ScoreApp());
}

class ScoreApp extends StatelessWidget {
  const ScoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Team Score Tracker',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const ScoreHomePage(),
    );
  }
}
