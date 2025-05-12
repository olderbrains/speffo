import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:speffo/Authentication/authentication_bloc.dart';
import 'package:speffo/Helper/utills.dart';

class NavHome extends StatefulWidget {
  const NavHome({super.key});

  @override
  State<NavHome> createState() => _NavHomeState();
}

class _NavHomeState extends State<NavHome> {
  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);

  final List<Widget> _pages = [
    Center(child: Text('Home')),
    Center(child: Text('Search')),
    Center(child: Text('Profile')),
    Center(child: Text('Profile')),
  ];

  @override
  void dispose() {
    _selectedIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is UnAuthenticated) {
            signOutCallAction(context: context);
          }
        },
        builder: (context, state) {
          return ValueListenableBuilder<int>(
            valueListenable: _selectedIndex,
            builder: (context, value, _) {
              return _pages[value];
            },
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: ValueListenableBuilder<int>(
            valueListenable: _selectedIndex,
            builder: (context, value, _) {
              return GNav(
                gap: 8.w,

                activeColor: Colors.green.shade600,
                color: Colors.grey[600],
                iconSize: 24.sp,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                haptic: false,
                duration: const Duration(milliseconds: 400),
                tabBackgroundColor: Colors.green.shade100,
                tabs: [
                  GButton(
                    icon: Icons.explore,
                    text: 'Stay',
                    textStyle: TextTheme.of(context).bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade600,
                    ),
                  ),  GButton(
                    icon: Icons.search,
                    text: 'Search',
                    textStyle: TextTheme.of(context).bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade600,
                    ),
                  ),  GButton(
                    icon: Icons.messenger,
                    text: 'Profile',
                    textStyle: TextTheme.of(context).bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade600,
                    ),
                  ),  GButton(
                    icon: Icons.account_circle_sharp,
                    text: 'Account',
                    textStyle: TextTheme.of(context).bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade600,
                    ),
                  ),

                ],
                selectedIndex: value,
                onTabChange: (index) => _selectedIndex.value = index,
              );
            },
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          context.read<AuthenticationBloc>().add(SignOutRequested());
        },
        child: const Text('Sign Out'),
      ),
    );
  }
}
