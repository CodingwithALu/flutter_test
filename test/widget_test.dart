// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:test/data/in_memory_employee_repository.dart';
import 'package:test/main.dart';

void main() {
  testWidgets('Employee list renders', (WidgetTester tester) async {
    await tester.pumpWidget(
      MyApp(
        initializeFirebase: false,
        repository: InMemoryEmployeeRepository(),
      ),
    );

    expect(find.text('Danh sách nhân sự'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
