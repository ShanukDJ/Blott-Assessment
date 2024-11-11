import 'package:blott_mobile_assessment/views/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:blott_mobile_assessment/providers/auth_provider.dart';
import 'package:blott_mobile_assessment/services/auth_db_helper.dart';

// Mock classes
class MockDatabaseHelper extends Mock implements DatabaseHelper {}

class MockAuthProvider extends Mock implements AuthProvider {}

void main() {
  late MockDatabaseHelper mockDatabaseHelper;
  late MockAuthProvider mockAuthProvider;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    mockAuthProvider = MockAuthProvider();
  });

  testWidgets('AuthScreen should validate the form correctly', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<AuthProvider>.value(
          value: mockAuthProvider,
          child: const AuthScreen(),
        ),
      ),
    );

    // Initially the form should be invalid
    expect(find.byType(ElevatedButton), findsOneWidget);
    ElevatedButton button = tester.widget(find.byType(ElevatedButton));
    expect(button.onPressed, isNull);

    // Enter a valid first name and last name
    await tester.enterText(find.byType(TextField).first, 'John');
    await tester.enterText(find.byType(TextField).last, 'Doe');

    // Rebuild the widget after state change
    await tester.pump();

    // Now the form should be valid, so button should be enabled
    button = tester.widget(find.byType(ElevatedButton));
    expect(button.onPressed, isNotNull);
  });

  testWidgets('Submit button triggers database insertion', (WidgetTester tester) async {
    // Mock the database insertion method
    when(mockDatabaseHelper.insertUser(any.toString(), any.toString())).thenAnswer((_) async => 1);

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<AuthProvider>.value(
          value: mockAuthProvider,
          child: const AuthScreen(),
        ),
      ),
    );

    // Enter text
    await tester.enterText(find.byType(TextField).first, 'John');
    await tester.enterText(find.byType(TextField).last, 'Doe');
    await tester.pump();

    // Tap the submit button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Check if the insertUser method was called with the correct arguments
    verify(mockDatabaseHelper.insertUser('John', 'Doe')).called(1);
  });

  testWidgets('Submit triggers loading state', (WidgetTester tester) async {
    // Mock the database insertion method with a delay
    when(mockDatabaseHelper.insertUser(any.toString(), any.toString())).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 1));
    });

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<AuthProvider>.value(
          value: mockAuthProvider,
          child: const AuthScreen(),
        ),
      ),
    );

    // Enter text
    await tester.enterText(find.byType(TextField).first, 'John');
    await tester.enterText(find.byType(TextField).last, 'Doe');
    await tester.pump();

    // Tap the submit button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify loading animation is shown
    expect(find.byType(LoadingAnimationWidget), findsOneWidget);
  });
}
