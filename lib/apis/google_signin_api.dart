import 'package:google_sign_in/google_sign_in.dart';

class GoogleSigninApi {
  static final _googleApi = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  static Future<GoogleSignInAccount?> login() => _googleApi.signIn();

  static Future<GoogleSignInAccount?> logout() => _googleApi.signOut();
}