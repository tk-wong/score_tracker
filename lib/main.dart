import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:score_app/controller/score_reason_controller.dart';
import 'package:score_app/controller/score_user_controller.dart';
import 'package:score_app/controller/theme_mode_controller.dart';
import 'package:score_app/models/object_box.dart';
import 'l10n/app_localizations.dart';
import 'pages/score_home_page.dart';

late ObjectBox objectBox;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectBox = await ObjectBox.create();
  Store store = objectBox.store; // Access the store if needed for setup
  ScoreReasonController reasonController = ScoreReasonController.create(store);
  reasonController
      .loadDefaultReasons(); // Load default reasons into the database
  ScoreUserController userController = ScoreUserController.create(store);
  userController.addDefaultUsers(); // Load default users into the database

  ThemeMode themeMode = await ThemeModeController.getThemeMode();
  runApp(ScoreApp(themeMode: themeMode));
}

class ScoreApp extends StatefulWidget {
  final ThemeMode themeMode;
  const ScoreApp({super.key, required this.themeMode});

  @override
  State<ScoreApp> createState() => ScoreAppState();

  static ScoreAppState of(BuildContext context) =>
      context.findAncestorStateOfType<ScoreAppState>()!;
}

class ScoreAppState extends State<ScoreApp> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.themeMode;
  }

  @override
  Widget build(BuildContext context) {
    // ensure changing theme mode works and not flicker
    // e.g. one second of the color in other theme
    const buttonStyle = ButtonStyle(animationDuration: Duration.zero);

    return MaterialApp(
      title: 'Team Score Tracker',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        
        filledButtonTheme: FilledButtonThemeData(style: buttonStyle),
        iconButtonTheme: IconButtonThemeData(style: buttonStyle),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,

        filledButtonTheme: FilledButtonThemeData(style: buttonStyle),
        iconButtonTheme: IconButtonThemeData(style: buttonStyle),
      ),
      themeMode: _themeMode,
      home: ScoreHomePage(key: ValueKey(_themeMode)),
    );
  }

  void changeTheme(ThemeMode newTheme) {
    setState(() {
      _themeMode = newTheme;
    });
    ThemeModeController.setThemeMode(newTheme);
  }

  ThemeMode get themeMode => _themeMode;
}
