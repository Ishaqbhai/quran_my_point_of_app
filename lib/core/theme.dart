import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_hadith_app/core/app_colors.dart';

final AppColors appColors = AppColors();
ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: appColors.backgroundColor,
  fontFamily: GoogleFonts.poppins().fontFamily,
  textTheme: TextTheme(
    bodyLarge: GoogleFonts.poppins(fontSize: 18),
    bodyMedium: GoogleFonts.amiri(fontSize: 18), // Arabic font
  ),
  // AppBar Theme
  appBarTheme: AppBarTheme(
    color: appColors.appBarColor, // AppBar background color
    elevation: 4,
    titleTextStyle: TextStyle(
      color: appColors.appTextColor,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: appColors.appWhiteColor,
    ), // AppBar icon color
  ),

  // TextField Theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: appColors.appWhiteColor,
    prefixIconColor:
        appColors.appGreyColor, // Background color of the text field
    labelStyle: TextStyle(
      color: appColors.appWhiteColor, // Label color
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide.none,
    ),
    floatingLabelStyle: TextStyle(
      backgroundColor: appColors.appWhiteColor,
      color: appColors.backgroundColor,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide.none,
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: appColors.appBarColor,
    foregroundColor: appColors.appWhiteColor,
  ),
);
