import 'package:flutter/material.dart';

ThemeData globalTheme() {
  return ThemeData(
    useMaterial3: false,
    colorScheme: ColorScheme.light(primary: Color(0xff2fa85a)),
    fontFamily: 'Poppins',
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontWeight: FontWeight.w900,),
      displayMedium: TextStyle(fontWeight: FontWeight.w800),
      displaySmall: TextStyle(fontWeight: FontWeight.w700),
      headlineMedium: TextStyle(fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(fontWeight: FontWeight.w500),
      titleLarge: TextStyle(fontWeight: FontWeight.w400),
      titleMedium: TextStyle(fontWeight: FontWeight.w300),
      titleSmall: TextStyle(fontWeight: FontWeight.w200),
      bodyLarge: TextStyle(fontWeight: FontWeight.w100),
    ),
  );
}
