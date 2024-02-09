import 'dart:io';

enum AuthMode {signUp, signIn}

class AuthFormData {
  String name = '';
  String email = '';
  String password = '';
  File? image;
  AuthMode _mode = AuthMode.signIn;

  bool get isSignIn {
    return _mode == AuthMode.signIn;
  }

  bool get isSignUp {
    return _mode == AuthMode.signUp;
  }

  void toggleAuthMode() {
    _mode = isSignIn ? AuthMode.signUp : AuthMode.signIn;
  }
}