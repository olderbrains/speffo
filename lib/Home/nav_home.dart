import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speffo/Authentication/authentication_bloc.dart';
import 'package:speffo/Helper/utills.dart';

class NavHome extends StatefulWidget {
  const NavHome({super.key});

  @override
  State<NavHome> createState() => _NavHomeState();
}

class _NavHomeState extends State<NavHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if(state is UnAuthenticated){
            signOutCallAction(context: context);
          }
        },
        builder: (context, state) {
          return Center(child: ElevatedButton(onPressed: () {
            context.read<AuthenticationBloc>().add(SignOutRequested());
          }, child: Text('Sign Out')),);
        },
      ),
    );
  }
}
