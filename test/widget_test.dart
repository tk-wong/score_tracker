import 'package:flutter_test/flutter_test.dart';

import 'package:score_app/main.dart';

void main() {
  testWidgets('Score tracker shows scoreboard and history tabs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ScoreApp());

    expect(find.text('Score Tracker'), findsOneWidget);
    expect(find.text('Scoreboard'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('Bob'), findsOneWidget);
  });
}
