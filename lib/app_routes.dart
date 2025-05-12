import 'package:flutter/material.dart';
import 'package:instagram_clone/auth/auth_screens/auth_screen_logic.dart';
import 'package:instagram_clone/auth/auth_screens/login_screen.dart';
import 'package:instagram_clone/auth/auth_screens/signup_email_screen.dart';
import 'package:instagram_clone/auth/auth_screens/signup_password_screen.dart';
import 'package:instagram_clone/home/home.screen.dart';
import 'package:instagram_clone/reels/reels_screen.dart';
import 'package:instagram_clone/search/search_screen.dart';
import 'package:instagram_clone/user_profile/user_profile_screen.dart';
import 'auth/auth_screens/signup_email_otp_screen.dart';
import 'create_post/create_post_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String confirmationCode = '/signup-email-confirmation';
  static const String createPassword = '/create-password';
  static const String home = '/home';
  static const String search = '/search';
  static const String createPost = '/createPost';
  static const String reels = '/reels';
  static const String userProfile = '/userProfile';



  static Widget entryScreen = AuthScreenLogic();

  static Map<String, WidgetBuilder> getRoutes(){
    return {
      signup: (context) => SignupEmailScreen(),
      createPassword: (context) => SignupPasswordScreen(),
      confirmationCode: (context) => SignupEmailOtpScreen(),
      login: (context) => LoginScreen(),
      home: (context) => const HomeScreen(),
      search: (context) => SearchScreen(),
      createPost: (context) => CreatePostScreen(),
      reels: (context) => ReelsScreen(),
      userProfile: (context) => UserProfileScreen(),
    };
  }
}



