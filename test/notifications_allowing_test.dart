import 'package:blott_mobile_assessment/views/notifications_allowing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

// Mock GoRouter
class MockGoRouter extends Mock implements GoRouter {}

void main() {
  testWidgets('NotificationsAllowingScreen UI elements are displayed', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      const MaterialApp(
        home: NotificationsAllowingScreen(),
      ),
    );

    // Verify the image is displayed
    expect(find.byType(Image), findsOneWidget);

    // Verify the CustomText widgets are displayed
    expect(find.text('Get the most out of Blott ✅'), findsOneWidget);
    expect(find.text('Allow notifications to stay in the loop with your payments, requests and groups.'), findsOneWidget);

    // Verify the continue button is displayed
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('Continue button navigates to /home', (WidgetTester tester) async {
    // Create a mock GoRouter instance
    final mockRouter = MockGoRouter();

    // Build the widget with GoRouter context
    await tester.pumpWidget(
      const MaterialApp(
        home:  NotificationsAllowingScreen(),
      ),
    );

    // Tap the continue button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Verify that the GoRouter is triggered to navigate to '/home'
    verify(mockRouter.go('/home')).called(1);
  });
}
