import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flight_viewer/screens/search_form_screen.dart';

void main() {
  group('SearchFormScreen', () {
    testWidgets('displays origin and destination fields', (WidgetTester tester) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(
        MaterialApp(
          home: SearchFormScreen(),
        ),
      );

      // Verify that the origin and destination text fields are present
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('allows entering text in origin and destination fields', (WidgetTester tester) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchFormScreen(),
          ),
        ),
      );

      // Find the text fields
      final originField = find.byType(TextField).at(0);
      final destinationField = find.byType(TextField).at(1);
      
      // Enter text
      await tester.enterText(originField, 'JFK');
      await tester.enterText(destinationField, 'LAX');
      
      // Verify text was entered
      expect(find.text('JFK'), findsOneWidget);
      expect(find.text('LAX'), findsOneWidget);
    });
  });
}