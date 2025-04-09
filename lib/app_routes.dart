import 'package:flutter/material.dart';
import 'package:instagram_clone/auth/auth_screens/auth_screen_logic.dart';
import 'package:instagram_clone/auth/auth_screens/login_screen.dart';
import 'package:instagram_clone/auth/auth_screens/signup_email_screen.dart';
import 'package:instagram_clone/auth/auth_screens/signup_password_screen.dart';
import 'package:instagram_clone/home/home.screen.dart';
import 'auth/auth_screens/signup_email_otp_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String confirmationCode = '/signup-email-confirmation';
  static const String createPassword = '/create-password';
  static const String home = '/home';
  static Widget entryScreen = AuthScreenLogic();

  static Map<String, WidgetBuilder> getRoutes(){
    return {
      signup: (context) => SignupEmailScreen(),
      createPassword: (context) => SignupPasswordScreen(),
      confirmationCode: (context) => SignupEmailOtpScreen(),
      login: (context) => LoginScreen(),
      home: (context) => const HomeScreen(),
    };
  }
}


