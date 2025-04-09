import 'package:flutter/material.dart';
import 'package:instagram_clone/app_routes.dart';
import 'package:instagram_clone/components/text_input_field.dart';
import 'package:provider/provider.dart';
import '../auth_components/signup_screen_wrapper.dart';
import '../../user_profile/user_profile_provider.dart';

class SignupPasswordScreen extends StatefulWidget {
   const SignupPasswordScreen({super.key});

  @override
  State<SignupPasswordScreen> createState() => _SignupPasswordScreenState();
}

class _SignupPasswordScreenState extends State<SignupPasswordScreen> {
  final TextEditingController _signupPasswordController = TextEditingController();

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SignupScreenWrapper(
                textInputField: TextInputField(
                  textInputType: TextInputType.text,
                  obscureText: true,
                  textEditingController: _signupPasswordController,
                  label: "password",
                ),
                loading: _loading,
                headerText: "Create a password.",
                description: "Create a password with at least 7 letters or numbers. It should be something others cannot guess.",
                inputLabel: "Password",
                onNextButtonPressed: () async{
                  final password = _signupPasswordController.text;
                  if(password.isEmpty){
                    return;
                  }
                  setState((){
                    _loading = true;
                  }
                  );

                  final authServiceResponse = await Provider.of<MyAuthProvider>(context, listen: false).signupWithEmailAndPassword(password);
                  String? signupErrorMessage = authServiceResponse.errorMessage;

                  if(signupErrorMessage != null){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.red.shade200,
                        content: Text(signupErrorMessage)));
                  } else{
                    Navigator.pushNamed(context, AppRoutes.home);
                  }

                  setState(() {
                    _loading = false;
                  });
                },
                emailConfirmationStep: false)
        ));
  }
}