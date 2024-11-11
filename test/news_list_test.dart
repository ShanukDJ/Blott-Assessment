import 'package:blott_mobile_assessment/utills/widgets/shimmer_loading.dart';
import 'package:blott_mobile_assessment/views/news_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:blott_mobile_assessment/providers/auth_provider.dart';
import 'package:blott_mobile_assessment/services/news_list_service.dart';
import 'package:blott_mobile_assessment/models/news_model.dart';

// Mocking NewsService and AuthProvider
class MockNewsService extends Mock implements NewsService {}
class MockAuthProvider extends Mock implements AuthProvider {}

void main() {
  testWidgets('HomeScreen displays loading state initially', (WidgetTester tester) async {
    // Arrange: Mock AuthProvider and NewsService
    final mockAuthProvider = MockAuthProvider();

    // Simulate an AuthProvider with a first name
    when(mockAuthProvider.firstName).thenReturn("John");

    // Build the HomeScreen widget
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<AuthProvider>.value(
          value: mockAuthProvider,
          child: const HomeScreen(),
        ),
      ),
    );

    // Act: Check if the loading state is displayed
    expect(find.byType(ShimmerLoadingList), findsOneWidget);
    expect(find.text('Hey John'), findsOneWidget);  // Check user greeting
  });

  testWidgets('HomeScreen displays error message when data fetch fails', (WidgetTester tester) async {
    // Arrange: Mock AuthProvider and NewsService to simulate an error
    final mockAuthProvider = MockAuthProvider();
    final mockNewsService = MockNewsService();

    when(mockAuthProvider.firstName).thenReturn("John");
    when(mockNewsService.fetchNews()).thenThrow(Exception("Failed to fetch news"));

    // Build the HomeScreen widget
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<AuthProvider>.value(
          value: mockAuthProvider,
          child: const HomeScreen(),
        ),
      ),
    );

    // Act: Wait for the screen to reflect the error state
    await tester.pumpAndSettle();

    // Assert: Check for error message and icon
    expect(find.text("Something went wrong. Please try again later."), findsOneWidget);
    expect(find.byIcon(Icons.error), findsOneWidget);
  });

  testWidgets('HomeScreen displays news items when data fetch is successful', (WidgetTester tester) async {
    // Arrange: Mock AuthProvider and NewsService to simulate successful data fetching
    final mockAuthProvider = MockAuthProvider();
    final mockNewsService = MockNewsService();

    when(mockAuthProvider.firstName).thenReturn("John");
    when(mockNewsService.fetchNews()).thenAnswer(
          (_) async => [
        NewsModel(
          source: "Source 1",
          headline: "News Headline 1",
          datetime: 1596588232,
          image: "https://example.com/image1.jpg",
        ),
        NewsModel(
          source: "Source 2",
          headline: "News Headline 2",
          datetime: 1596588232,
          image: "https://example.com/image2.jpg",
        ),
      ],
    );

    // Build the HomeScreen widget
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<AuthProvider>.value(
          value: mockAuthProvider,
          child: HomeScreen(),
        ),
      ),
    );

    // Act: Wait for the successful loading state
    await tester.pumpAndSettle();

    // Assert: Check if the news list is displayed
    expect(find.byType(ListView), findsOneWidget);
    expect(find.text("News Headline 1"), findsOneWidget);
    expect(find.text("News Headline 2"), findsOneWidget);
  });

  testWidgets('HomeScreen triggers data refresh when pull-to-refresh is triggered', (WidgetTester tester) async {
    // Arrange: Mock AuthProvider and NewsService to simulate successful data fetching
    final mockAuthProvider = MockAuthProvider();
    final mockNewsService = MockNewsService();

    when(mockAuthProvider.firstName).thenReturn("John");
    when(mockNewsService.fetchNews()).thenAnswer(
          (_) async => [
        NewsModel(
          source: "Source 1",
          headline: "News Headline 1",
          datetime: 1596588232,
          image: "https://example.com/image1.jpg",
        ),
      ],
    );

    // Build the HomeScreen widget
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<AuthProvider>.value(
          value: mockAuthProvider,
          child: const HomeScreen(),
        ),
      ),
    );

    // Act: Simulate pull-to-refresh
    await tester.fling(find.byType(RefreshIndicator), const Offset(0.0, 1000.0), 1000);
    await tester.pumpAndSettle();

    // Assert: Verify that the data was reloaded (check for news headline again)
    expect(find.text("News Headline 1"), findsOneWidget);
  });
}
