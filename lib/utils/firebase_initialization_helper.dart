import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../firebase_options.dart';

class FirebaseInitializationHelper {
  static const Duration initializationTimeout = Duration(seconds: 15);

  /// Initialize Firebase with error handling and timeout
  /// Returns true on success, false on failure
  static Future<bool> initializeFirebase() async {
    if (Firebase.apps.isNotEmpty) {
      return true;
    }

    try {
      // Try initializing with explicit platform options first
      try {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ).timeout(
          initializationTimeout,
          onTimeout: () {
            throw FirebaseInitializationTimeoutException(
              'Firebase initialization timed out after ${initializationTimeout.inSeconds} seconds',
              initializationTimeout,
            );
          },
        );
        return true;
      } catch (optionsError) {
        debugPrint('Firebase initializeApp with DefaultFirebaseOptions failed: $optionsError');
        // Fallback to default initializeApp (uses native google-services.json / GoogleService-Info.plist)
        if (Firebase.apps.isEmpty) {
          await Firebase.initializeApp().timeout(
            initializationTimeout,
            onTimeout: () {
              throw FirebaseInitializationTimeoutException(
                'Native Firebase initialization timed out after ${initializationTimeout.inSeconds} seconds',
                initializationTimeout,
              );
            },
          );
        }
        return true;
      }
    } on FirebaseInitializationTimeoutException catch (e) {
      debugPrint('Firebase initialization timeout: ${e.message}');
      return false;
    } on FirebaseException catch (e) {
      debugPrint('Firebase initialization error: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      debugPrint('Unexpected error during Firebase initialization: $e');
      return false;
    }
  }
}

class FirebaseInitializationTimeoutException implements Exception {
  final String message;
  final Duration timeout;

  FirebaseInitializationTimeoutException(this.message, this.timeout);

  @override
  String toString() => message;
}
