import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:speffo/Authentication/authentication_bloc.dart';
import 'package:speffo/Helper/page_router.dart';
import 'package:speffo/Home/nav_home.dart';
import 'package:speffo/Login/View/login_main_view.dart';
import 'package:speffo/Themes/text_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:speffo/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");
  runApp(
    ScreenUtilInit(
      designSize: const Size(393, 852),
      child: MaterialApp(
        theme: globalTheme(),

        home: Scaffold(body: SpeffoApp()),
      ),
    ),
  );
}

class SpeffoApp extends StatefulWidget {
  const SpeffoApp({super.key});

  @override
  State<SpeffoApp> createState() => _SpeffoAppState();
}

class _SpeffoAppState extends State<SpeffoApp>
    with SingleTickerProviderStateMixin {
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
          AuthenticationBloc()
            ..add(CheckAuthenticationEvent()),
        ),

      ],
      child: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is Authenticated) {
            PageRouter.pushRemoveUntil(context, NavHome());
          } else {
            PageRouter.pushRemoveUntil(context, LoginMainView());
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/logo/logo.png', height: 75.h),

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
          ),
        ),
      ),
    );
  }
}
