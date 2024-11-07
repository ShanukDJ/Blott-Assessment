import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';



class ThemeServiceProvider with ChangeNotifier {
  ThemeData get theme => _lightThemeData();

  final bool _isDark = false;
  bool get isDark => _isDark;

  ThemeData get lightTheme => _lightThemeData();
  ThemeData get darkTheme => _darkThemeData();
  ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;


  final Color _primaryColor = const Color(0xFF523AE4);
  final Color _secondaryColor =  Colors.white;
  final Color _lightSurfaceColor =   Colors.white;
  final Color _darkSurfaceColor = const Color(0xFF023047);
  final Color _lightBackgroundColor = const Color(0xFF9381FF);
  final Color _darkBackgroundColor = const Color(0xFF1B1B1B);
  final Color _lightShadowColor = const Color(0xFFE2E8F0);
  final Color _darkShadowColor = const Color(0xFF0D1117);

  ThemeData _lightThemeData() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        primary: _primaryColor,
        onPrimary: Colors.white,
        secondary: _secondaryColor,
        onSecondary: Colors.white,
        surface: _lightSurfaceColor,
        onSurface: _darkSurfaceColor,
        shadow: _lightShadowColor,
        outline: const Color(0xFF8D99AE),
        error: const Color(0XFFEF233C),
      ),
      fontFamily: _fontFamily(),
      elevatedButtonTheme: _elevatedButtonThemeData(),
      outlinedButtonTheme: _outlinedButtonThemeData(),
      textButtonTheme: _textButtonThemeData(),
      inputDecorationTheme: _inputDecorationTheme(),
      appBarTheme: _appBarTheme(),
      iconTheme: _iconThemeData(),
      bottomNavigationBarTheme: _bottomNavigationBarThemeData(),
    );
  }

  ThemeData _darkThemeData() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        primary: _primaryColor,
        onPrimary: Colors.white,
        secondary: _secondaryColor,
        onSecondary: Colors.white,
        surface: _darkSurfaceColor,
        onSurface: _lightSurfaceColor,
        shadow: _darkShadowColor,
        outline: const Color(0xFF8D99AE),
        error: const Color(0XFFEF233C),
      ),
      fontFamily: _fontFamily(),
      elevatedButtonTheme: _elevatedButtonThemeData(),
      outlinedButtonTheme: _outlinedButtonThemeData(),
      textButtonTheme: _textButtonThemeData(),
      inputDecorationTheme: _inputDecorationTheme(),
      appBarTheme: _appBarTheme(),
      iconTheme: _iconThemeData(),
      bottomNavigationBarTheme: _bottomNavigationBarThemeData(),
    );
  }

  String? _fontFamily() {
    return GoogleFonts.roboto().fontFamily;
  }


  ElevatedButtonThemeData _elevatedButtonThemeData() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: _primaryColor,
        elevation: 0,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 24,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minimumSize: const Size(double.infinity, 48),
      ),
    );
  }

  OutlinedButtonThemeData _outlinedButtonThemeData() {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _isDark ? Colors.white : Colors.white,
        backgroundColor: _isDark ? _darkSurfaceColor : _lightSurfaceColor,
        elevation: 0,
        textStyle: const TextStyle(
          fontSize: 16,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 24,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minimumSize: const Size(double.infinity, 48),
      ),
    );
  }

  TextButtonThemeData _textButtonThemeData() {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _secondaryColor,
        elevation: 0,
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        maximumSize: const Size(double.infinity, 48),
      ),
    );
  }

  InputDecorationTheme _inputDecorationTheme() {
    return   const InputDecorationTheme(
    hintStyle: TextStyle(color: Colors.grey),
    enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.grey),
    ),
    border: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.grey),
    ),
    );
  }

  AppBarTheme _appBarTheme() {
    return AppBarTheme(
      foregroundColor: _isDark ? _lightBackgroundColor : _darkBackgroundColor,
      backgroundColor: _isDark ? _darkSurfaceColor : _lightSurfaceColor,
      elevation: 0,
      iconTheme: IconThemeData(
        color: _isDark ? _lightBackgroundColor : _darkBackgroundColor,
      ),
      titleTextStyle: TextStyle(
        color: _isDark ? _lightBackgroundColor : _darkBackgroundColor,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  IconThemeData _iconThemeData() {
    return IconThemeData(
      color: _isDark ? _lightBackgroundColor : _darkBackgroundColor,
    );
  }

  BottomNavigationBarThemeData _bottomNavigationBarThemeData() {
    return BottomNavigationBarThemeData(
      backgroundColor: _isDark ? _darkSurfaceColor : _lightSurfaceColor,
      type: BottomNavigationBarType.fixed,
      elevation: 16,
      selectedItemColor: _secondaryColor,
      unselectedItemColor: _isDark ? _lightBackgroundColor : _darkBackgroundColor,
      showUnselectedLabels: true,
      selectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 12,
      ),
    );
  }

  static void setSystemUIOverlayStyle({bool isDark = false}) {
    if (isDark) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.black,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      );
    }
  }
}
