import 'package:firebase_core/firebase_core.dart';
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
          debugShowCheckedModeBanner: false,
          theme: globalTheme(),
          builder: (context, child) {
            return BlocListener<AuthenticationBloc, AuthenticationState>(
              listenWhen:
                  (previous, current) =>
                      previous is Authenticated && current is UnAuthenticated,
              listener: (context, state) {
                if (state is UnAuthenticated) {
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).popUntil((route) => route.isFirst);
                  PageRouter.pushRemoveUntil(context, const LoginMainView());
                }
              },
              child: child!,
            );
          },
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

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      final authState = context.read<AuthenticationBloc>().state;

      if (authState is Authenticated) {
        PageRouter.pushRemoveUntil(context, const NavHome());
      } else {
        PageRouter.pushRemoveUntil(context, const LoginMainView());
      }
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo/logo.png', height: 75.h),
            SizedBox(height: 20.h),
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
    );
  }
}
