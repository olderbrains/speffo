import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speffo/Authentication/authentication_bloc.dart';

class NavHome extends StatefulWidget {
  const NavHome({super.key});

  @override
  State<NavHome> createState() => _NavHomeState();
}

class _NavHomeState extends State<NavHome> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      body: Center(child: ElevatedButton(onPressed: () {
        context.read<AuthenticationBloc>().add(SignOutRequested());
      }, child: Text('Sign Out')),),
    );
  }
}
