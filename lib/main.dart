import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speffo/Themes/text_theme.dart';

void main() {
  runApp(
    ScreenUtilInit(
      designSize: Size(390, 844),
      builder: (context, child) => SpeffoApp(),
    ),
  );
}

class SpeffoApp extends StatefulWidget {
  const SpeffoApp({super.key});

  @override
  State<SpeffoApp> createState() => _SpeffoAppState();
}

class _SpeffoAppState extends State<SpeffoApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: globalTheme(),
      home: Scaffold(body: Center(child: Image.asset('assets/logo/logo.png'))),
    );
  }
}
