import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Future<GoogleSignInAccount?> signIn() async {
    try {
      await _googleSignIn.initialize(
        serverClientId:
            '613547408344-t38sc4d8i2kjo54bi2n7acauldip2ium.apps.googleusercontent.com',
      );

      try {
        await _googleSignIn.signOut();
      } catch (_) {}

      final GoogleSignInAccount account =
          await _googleSignIn.authenticate();

      return account; 
    } on GoogleSignInException catch (e) {
      debugPrint('GOOGLE SIGN IN ERROR CODE: ${e.code}');
      debugPrint('GOOGLE SIGN IN ERROR DESCRIPTION: ${e.description}');
      return null;
    } catch (e) {
      debugPrint('GOOGLE SIGN IN UNKNOWN ERROR: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
  }
}