
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_code/res/colors.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: Colors.white,
    progressIndicatorTheme:
        const ProgressIndicatorThemeData(color: Colors.blue),
    textTheme: TextTheme(
      headlineLarge: GoogleFonts.inter(
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 18.0,
        color: Colors.black,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 16.0,
        color: Colors.black,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 14.0,
        color: Colors.black,
      ),
      displayLarge: GoogleFonts.inter(
        fontSize: 12.0,
        color: Colors.black,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 10.0,
        color: Colors.black,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 8.0,
        color: Colors.black,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    progressIndicatorTheme:
        const ProgressIndicatorThemeData(color: Colors.grey),
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.white,
    textTheme: TextTheme(
      headlineLarge: GoogleFonts.inter(
          fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.white),
      headlineMedium: GoogleFonts.inter(
          fontSize: 25.0, fontWeight: FontWeight.bold, color: Colors.white),
      headlineSmall: GoogleFonts.inter(
          fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
      bodyLarge: GoogleFonts.inter(fontSize: 18.0, color: Colors.white70),
      bodyMedium: GoogleFonts.inter(fontSize: 16.0, color: Colors.white70),
      bodySmall: GoogleFonts.inter(fontSize: 14.0, color: Colors.white70),
      displayLarge: GoogleFonts.inter(fontSize: 12.0, color: Colors.white70),
      displayMedium: GoogleFonts.inter(fontSize: 10.0, color: Colors.white70),
      displaySmall: GoogleFonts.inter(fontSize: 8.0, color: Colors.white70),
    ),
  );
}
