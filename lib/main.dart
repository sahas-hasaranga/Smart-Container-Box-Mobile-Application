import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'app.dart';

void main() async {
  // Ensure that Flutter widget binding is initialized before any async operations
  // This is critical: must be called before Firebase initialization and any platform channels
  WidgetsFlutterBinding.ensureInitialized();

  // Configure error handling for uncaught exceptions and async errors
  FlutterError.onError = (FlutterErrorDetails details) {
    debugPrint('Flutter Error: ${details.exception}');
    debugPrint('Stack trace: ${details.stack}');
  };

  // Handle async exceptions that occur outside the Flutter framework
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Platform Error: $error');
    debugPrint('Stack trace: $stack');
    return true;
  };

  // Run the app with the Smart Container App widget
  // Firebase initialization is now handled internally by the app widget
  // This prevents blocking the UI during the initialization process
  runApp(const SmartContainerApp());
}
