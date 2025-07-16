import 'package:flutter/material.dart';
// external imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:instagram_clone/app_routes.dart';
import 'package:instagram_clone/firebase_options.dart';

// internal imports:
import 'package:instagram_clone/app_theme_data.dart';
import 'package:provider/provider.dart';
import 'package:instagram_clone/user_profile/user_profile_provider.dart';

import 'auth/auth_screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const InstagramClone());
}

class InstagramClone extends StatelessWidget{
  const InstagramClone({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyAuthProvider>(
      create: (_) => MyAuthProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram Clone',
        theme: AppThemeData().light(),
        darkTheme: AppThemeData().dark(),
        themeMode: ThemeMode.light,
        routes: AppRoutes.getRoutes(),
        home: Consumer<MyAuthProvider>(
          builder: (context, authProvider, _) {
            if (authProvider.userProfile != null) {
              return AppRoutes.entryScreen;
            } else {
              return LoginScreen();
            }
          },
        ),
        ),
    );
  }
}





