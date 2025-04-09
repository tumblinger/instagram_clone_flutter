import 'package:flutter/material.dart';
import 'package:instagram_clone/app_routes.dart';
import 'package:instagram_clone/components/text_input_field.dart';
import 'package:provider/provider.dart';
import 'package:instagram_clone/user_profile/user_profile_provider.dart';
import '../auth_components/signup_screen_wrapper.dart';

class SignupEmailScreen extends StatefulWidget {
  const SignupEmailScreen({super.key});

  @override
  State<SignupEmailScreen> createState() => _SignupEmailScreenState();
}

class _SignupEmailScreenState extends State<SignupEmailScreen> {
  final TextEditingController _signupEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Provider(
          create: (context) => MyAuthProvider(),
          child: SignupScreenWrapper(
            headerText: "What is your email?",
            description: "Enter the email where you can be contacted. No one will see this on your profile",
            textInputField: TextInputField(
                textInputType: TextInputType.emailAddress,
                textEditingController: _signupEmailController,
                label: "Email",
            ),
            inputLabel: "Email",
            onNextButtonPressed: (){
              final email = _signupEmailController.text.trim();
              if(email.isNotEmpty){
                context.read<MyAuthProvider>().setEmail(email);
                Navigator.pushNamed(context, AppRoutes.confirmationCode);
              }
              print("Go to password screen");
            },
            emailConfirmationStep: false,
            ifHaveAccount: true,
          ),
        ),),
    );
  }
}