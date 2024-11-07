
import 'package:blott_mobile_assessment/providers/auth_provider.dart';
import 'package:blott_mobile_assessment/views/auth_screen.dart';
import 'package:blott_mobile_assessment/views/data_list_screen.dart';
import 'package:blott_mobile_assessment/views/notifications_allowing_screen.dart';
import 'package:blott_mobile_assessment/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'app/controllers/theme.dart';
import 'app/view/overlay_utility.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyApp());
}

class MyApp extends StatefulWidget {
   MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

   late ThemeServiceProvider _themeProvider;
   late AuthProvider _authProvider;

   @override
   void initState() {
     super.initState();

     // Initialize Providers and Services
     _themeProvider = ThemeServiceProvider();
     _authProvider = AuthProvider();

   }

   @override
   Widget build(BuildContext context) {
     return MultiProvider(
       providers: [
         ChangeNotifierProvider<ThemeServiceProvider>(create: (_) => _themeProvider),
         ChangeNotifierProvider<AuthProvider>(create: (_) => _authProvider),
       ],
       child: Builder(
         builder: (context) {
           return MaterialApp.router(
             title: 'Blott Assessment',
             debugShowCheckedModeBanner: false,
             theme: context.watch<ThemeServiceProvider>().lightTheme,
             darkTheme: context.watch<ThemeServiceProvider>().darkTheme,
             themeMode: context.watch<ThemeServiceProvider>().themeMode,
             routerConfig: _router,
             builder:(context, child) => OverlayUtility(child: child),
           );
         },
       ),
     );
   }


  final GoRouter _router = GoRouter(
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
