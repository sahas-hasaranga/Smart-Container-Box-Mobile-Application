import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'camera_screen.dart';
import 'gps_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    CameraScreen(),
    GpsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0A0E17),
          border: Border(
            top: BorderSide(
              color: Colors.white.withAlpha(13),
              width: 1,
            ),
          ),
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: const Color(0xFF10B981).withAlpha(51), // Teal pill
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return const TextStyle(color: Color(0xFF10B981), fontSize: 12, fontWeight: FontWeight.w600);
              }
              return TextStyle(color: Colors.white.withAlpha(128), fontSize: 12, fontWeight: FontWeight.w500);
            }),
          ),
          child: NavigationBar(
            backgroundColor: const Color(0xFF0A0E17),
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined, color: Colors.white.withAlpha(128)),
                selectedIcon: const Icon(Icons.dashboard_rounded, color: Color(0xFF10B981)),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.videocam_outlined, color: Colors.white.withAlpha(128)),
                selectedIcon: const Icon(Icons.videocam_rounded, color: Color(0xFF10B981)),
                label: 'Camera',
              ),
              NavigationDestination(
                icon: Icon(Icons.near_me_outlined, color: Colors.white.withAlpha(128)),
                selectedIcon: const Icon(Icons.near_me_rounded, color: Color(0xFF10B981)),
                label: 'GPS',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline_rounded, color: Colors.white.withAlpha(128)),
                selectedIcon: const Icon(Icons.person_rounded, color: Color(0xFF10B981)),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
