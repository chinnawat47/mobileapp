import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hello_app/ui/register_page.dart';
import 'package:hello_app/ui/result_page.dart';
import 'package:hello_app/models/register_data.dart';

void main() {
  testWidgets('Register page shows the required form fields and buttons', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterPage()));

    expect(find.text('Student ID'), findsOneWidget);
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Surname'), findsOneWidget);
    expect(find.text('Major'), findsOneWidget);
    expect(find.text('Phone'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Add'), findsOneWidget);
    expect(find.text('View All'), findsOneWidget);
  });

  testWidgets('Result page shows empty state when there are no registrations', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: ResultPage(registrations: const [])),
    );

    expect(find.text('No registration data'), findsOneWidget);
    expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
  });
}
