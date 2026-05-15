import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:objectbox/objectbox.dart';
import 'package:score_app/controller/score_reason_controller.dart';
import 'package:score_app/controller/score_user_controller.dart';

import 'package:score_app/main.dart';
import 'package:score_app/models/object_box.dart';
import 'package:score_app/models/score_user.dart';

import 'package:score_app/widgets/scoreboard/scoreboard_tab.dart';

void main() {
  setUp(() async {
    // Initialize ObjectBox and load default data before running tests
    objectBox = await ObjectBox.create();
    Store store = objectBox.store;
    ScoreReasonController reasonController = ScoreReasonController.create(
      store,
    );
    reasonController.loadDefaultReasons();
    ScoreUserController userController = ScoreUserController.create(store);
    userController.addDefaultUsers();
  });

  tearDown(() {
    // Clean up ObjectBox after tests are done
    objectBox.store.close();
  });
  testWidgets('Score tracker shows scoreboard and history tabs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ScoreApp());

    expect(find.text('Score Tracker'), findsOneWidget);
    expect(find.text('Scoreboard'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
  });

  testWidgets("Empty Scoreboard Tab", (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ScoreboardTab(
          users: [],
          onAddUser: () => {},
          onResetScore: () => {},
          onAddScore: (ScoreUser user) => {},
          onSubtractScore: (ScoreUser user) => {},
          onDeleteUser: (ScoreUser user) => {},
        ),
      ),
    );
    final emoptyUserFinder = find.text('No users added yet.');
    expect(emoptyUserFinder, findsOneWidget);
    // Add test logic for empty scoreboard tab
  });
}
