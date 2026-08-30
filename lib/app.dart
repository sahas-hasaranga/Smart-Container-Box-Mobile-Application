import 'package:flutter/material.dart';
import 'widgets/splash_screen.dart';
import 'widgets/initialization_error_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'utils/firebase_initialization_helper.dart';

class SmartContainerApp extends StatefulWidget {
  const SmartContainerApp({super.key});

  @override
  State<SmartContainerApp> createState() => _SmartContainerAppState();
}

class _SmartContainerAppState extends State<SmartContainerApp> {
  late Future<bool> _initializationFuture;
  bool _bypassedToDashboard = false;

  @override
  void initState() {
    super.initState();
    _initializationFuture = FirebaseInitializationHelper.initializeFirebase();
  }

  void _retryInitialization() {
    setState(() {
      _bypassedToDashboard = false;
      _initializationFuture = FirebaseInitializationHelper.initializeFirebase();
    });
  }

  void _proceedToDashboard() {
    setState(() {
      _bypassedToDashboard = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Container Box',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF4F6FB),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF223A9E),
          secondary: Color(0xFF00A896),
          surface: Colors.white,
          error: Color(0xFF991B1B),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF06B6D4),
          secondary: Color(0xFF3B82F6),
          surface: Color(0xFF1E293B),
          error: Color(0xFFEF4444),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: _bypassedToDashboard
          ? const HomeScreen()
          : FutureBuilder<bool>(
              future: _initializationFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SplashScreen();
                } else if (snapshot.hasError || snapshot.data == false) {
                  return InitializationErrorScreen(
                    errorMessage: snapshot.hasError
                        ? 'Failed to initialize the application.\n${snapshot.error}'
                        : 'Failed to connect to Firebase.\nPlease check your internet connection and try again.',
                    onRetry: _retryInitialization,
                    onProceedToDashboard: _proceedToDashboard,
                  );
                } else if (snapshot.hasData && snapshot.data == true) {
                  return const LoginScreen();
                } else {
                  return InitializationErrorScreen(
                    errorMessage: 'Unexpected initialization state. Please restart the app.',
                    onRetry: _retryInitialization,
                    onProceedToDashboard: _proceedToDashboard,
                  );
                }
              },
            ),
    );
  }
}
