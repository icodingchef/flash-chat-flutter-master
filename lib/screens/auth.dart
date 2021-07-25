import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

final _auth = FirebaseAuth.instance;

Future<UserCredential> googleSighIn() async {

  final googleSignIn = GoogleSignIn();
  final googleAccount = await googleSignIn.signIn();
  if (googleAccount != null) {
    final googleAuth = await googleAccount.authentication;
    if (googleAuth.accessToken != null && googleAuth.idToken != null) {
      final authResult = await _auth.signInWithCredential(
        GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ),
      );
      return authResult;
    } else {
      throw PlatformException(
        code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
        message: 'Missing Google Auth Token',
      );
    }
  } else {
    throw PlatformException(
      code: 'ERROR_ABORTED_BY_USER',
      message: 'Sign in aborted by user',
    );
  }
}

Future<void> signOut() async {
  await _auth.signOut();
}