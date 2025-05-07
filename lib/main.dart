import 'package:firebase_core/firebase_core.dart';
import 'package:flashy_flushbar/flashy_flushbar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lottie/lottie.dart';

import 'package:speffo/Authentication/authentication_bloc.dart';
import 'package:speffo/Helper/page_router.dart';
import 'package:speffo/Home/nav_home.dart';
import 'package:speffo/Login/Controller/PhoneAuthentication/login_bloc.dart';
import 'package:speffo/Login/View/login_main_view.dart';
import 'package:speffo/Themes/text_theme.dart';
import 'package:speffo/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthenticationBloc()),
          BlocProvider(create: (context) => LoginBloc()),
        ],
        child: MaterialApp(
          builder: FlashyFlushbarProvider.init(),
          theme: globalTheme(),
          home: const SplashScreen(),
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      context.read<AuthenticationBloc>().add(CheckUserState());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, authState) {
          if (authState is Authenticated) {
            PageRouter.pushRemoveUntil(context, const NavHome());
          }
          if (authState is UnAuthenticated) {
            PageRouter.pushRemoveUntil(context, const LoginMainView());
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo/logo.png', height: 75.h),
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Text(
                  "Home, Wherever You Go",
                  style: TextStyle(
                    color: Colors.blueGrey,

                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(
                width: 150.w,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(seconds: 2),
                    builder:
                        (context, value, child) => LinearProgressIndicator(
                          value: value,
                          minHeight: 4.h,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.blueGrey,
                          ),
                        ),
                    onEnd: () {
                      // Navigate to next screen or complete splash
                    },
                  ),
                ),
              ),
              Lottie.asset(
                'assets/lottie/splashLottie.json',
                height: 350.h,
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
