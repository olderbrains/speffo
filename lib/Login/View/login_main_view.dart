import 'package:flutter/material.dart';

class LoginMainView extends StatefulWidget {
  const LoginMainView({super.key});

  @override
  State<LoginMainView> createState() => _LoginMainViewState();
}

class _LoginMainViewState extends State<LoginMainView> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Log in or sign up'),
      ),
    );
  }
}
