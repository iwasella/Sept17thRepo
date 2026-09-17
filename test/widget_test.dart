import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutterappformysept17/main.dart';

void main() {
  testWidgets('calculates a simple addition', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('7'));
    await tester.tap(find.text('+'));
    await tester.tap(find.text('3'));
    await tester.tap(find.text('='));
    await tester.pump();

    expect(find.byKey(const Key('calculator-display')), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
  });

  testWidgets('clear resets the display', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('9'));
    await tester.tap(find.text('C'));
    await tester.pump();

    expect(
      tester.widget<Text>(find.byKey(const Key('calculator-display'))).data,
      '0',
    );
  });
}
