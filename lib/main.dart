import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
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

class _SpeffoAppState extends State<SpeffoApp>   with SingleTickerProviderStateMixin {
  late AnimationController _controller;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: globalTheme(),
      home: Scaffold(body: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/logo/logo.png',height: 75.h,),

          Lottie.asset(
            'assets/lottie/splashLottie.json',
            height: 100.h,
            controller: _controller,

            onLoaded: (composition) {
              _controller
                ..duration = composition.duration
                ..repeat();
            },
          ),
        ],
      ))),
    );
  }
}
