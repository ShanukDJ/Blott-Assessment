import 'package:blott_mobile_assessment/providers/auth_provider.dart';
import 'package:blott_mobile_assessment/views/auth_screen.dart';
import 'package:blott_mobile_assessment/views/news_list_screen.dart';
import 'package:blott_mobile_assessment/views/notifications_allowing_screen.dart';
import 'package:blott_mobile_assessment/views/splash_screen.dart';
import 'package:go_router/go_router.dart';


class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsAllowingScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}
