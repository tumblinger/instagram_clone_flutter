import 'package:flutter/material.dart';
import 'package:instagram_clone/app_routes.dart';

import 'package:instagram_clone/user_profile/user_profile_model.dart';
import 'package:provider/provider.dart';

import '../../user_profile/user_profile_provider.dart';

// GO TO LOGIN PAGE: if user is registered;
// GO TO SIGNUP PAGE: if user is not registered yet;
// GO TO HOME PAGE: if user is logged in;

class AuthScreenLogic extends StatelessWidget {
  const AuthScreenLogic({super.key});

  @override
  Widget build(BuildContext context) {
    final myAuthProvider = Provider.of<MyAuthProvider>(context);
    return StreamBuilder(
        stream: myAuthProvider.userProfileStream,
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.active){
            final UserProfileModel? userAccount = snapshot.data;
            WidgetsBinding.instance.addPostFrameCallback((_) {
            if(userAccount != null) {
              Navigator.of(context).pushReplacementNamed(AppRoutes.home);
            } else {
              if(myAuthProvider.hasSignedUpBefore){
                Navigator.of(context).pushReplacementNamed(AppRoutes.login);
              } else{
                Navigator.of(context).pushReplacementNamed(AppRoutes.signup);
              }
            }
            });
          }
          return const Scaffold(body: Center(child: CircularProgressIndicator(),),);
        }
    );

    // return myAuthProvider.hasSignedUpBefore ? LoginScreen() : SignupEmailScreen();
  }
}
