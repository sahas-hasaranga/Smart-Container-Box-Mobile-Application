import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class GoogleAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Handles Google Sign-In with strict requirement to always show Account Chooser
  static Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      if (kIsWeb) {
        // For Web
        final googleProvider = GoogleAuthProvider();
        googleProvider.setCustomParameters({'prompt': 'select_account'});
        return await _auth.signInWithPopup(googleProvider);
      } else {
        // STRICT REQUIREMENT: Clear previous session to force Account Chooser every time
        await _googleSignIn.signOut();
        
        // Trigger the authentication flow
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        if (googleUser == null) {
          // The user canceled the sign-in
          return null;
        }

        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        // Create a new credential
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase with the Google [UserCredential]
        final UserCredential userCredential = await _auth.signInWithCredential(credential);

        if (context.mounted) {
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle_outline, color: Colors.white),
                  SizedBox(width: 10),
                  Text('Signed in with Google successfully!'),
                ],
              ),
              backgroundColor: Color(0xFF10B981),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 3),
            ),
          );
        }

        return userCredential;
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException during Google Sign-In: ${e.code} - ${e.message}');
      _showErrorSnackBar(context, e.message ?? 'Authentication failed. Please try again.');
      return null;
    } catch (e) {
      debugPrint('Google Sign-In error: $e');
      _showErrorSnackBar(context, 'An unexpected error occurred during Google Sign-In.');
      return null;
    }
  }

  /// Safely signs out from both Firebase and GoogleSignIn
  static Future<void> signOut(BuildContext context) async {
    try {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      await _auth.signOut();
      if (!kIsWeb) {
        await _googleSignIn.signOut();
      }
      
      if (context.mounted) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.white),
                SizedBox(width: 10),
                Text('Logged out successfully.'),
              ],
            ),
            backgroundColor: Color(0xFF3B82F6),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error signing out: $e');
      if (!context.mounted) return;
      _showErrorSnackBar(context, 'Failed to log out cleanly.');
    }
  }

  static void _showErrorSnackBar(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
