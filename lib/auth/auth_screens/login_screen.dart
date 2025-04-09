import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/app_routes.dart';
import 'package:instagram_clone/components/text_input_field.dart';
import 'package:provider/provider.dart';

import '../../../auth/auth_constants.dart';
import '../auth_components/auth_screen_padding.dart';
import '../../user_profile/user_profile_provider.dart';

const gapValue = authFormGapValue;

class LoginScreen extends StatefulWidget {
    const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _loginEmailController = TextEditingController();

  final TextEditingController _loginPasswordController = TextEditingController();

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, //for keyboard
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Center(
                  child: SvgPicture.asset("assets/app-logos/instagram-clone-logo.svg")),
            ),
            Expanded(
                child: AuthScreenPadding(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            TextInputField(
                                textInputType: TextInputType.emailAddress,
                                textEditingController: _loginEmailController,
                                label: "username or email"),
                            const SizedBox(height: gapValue),
                             TextInputField(
                              textInputType: TextInputType.text,
                              obscureText: true,
                              textEditingController: _loginPasswordController,
                              label: "password",
                            ),
                            const SizedBox(height: gapValue),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                  onPressed: () async{
                                    final email = _loginEmailController.text;
                                    final password = _loginPasswordController.text;
                    
                                    if(email.isEmpty || password.isEmpty){
                                      return;
                                    }
                    
                                    setState((){
                                    _loading = true;
                                    });
                                    final authServiceResponse = await Provider.of<MyAuthProvider>(context, listen: false).loginWithEmailAndPassword(email, password);
                                    String? loginErrorMessage = authServiceResponse.errorMessage;
                    
                                    if(loginErrorMessage != null){
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          backgroundColor: Colors.red.shade400,
                                          content: Text(loginErrorMessage)));
                    
                                      print(loginErrorMessage);
                    
                                    } else{
                                      Navigator.pushNamed(context, AppRoutes.home);
                                    }
                    
                                    setState((){
                                      _loading = false;
                                    });
                                    },
                                  child: const Text("Login")),
                            ),
                            TextButton(
                              onPressed: () => print('password recap'),
                              child: const Text('Forgot password?'),)
                          ],
                        ),
                        Column(
                          children: [
                            OutlinedButton(
                                onPressed: () => Navigator.pushNamed(context, AppRoutes.signup),
                                style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Color(0xFF0095F6))
                                ),
                                child: const Text("Create new account")),
                            TextButton(onPressed:() => print('Vala'),
                                child: Text("Valentina 2024-2025",
                                    style: Theme.of(context).brightness ==
                                        Brightness.dark
                                        ? const TextStyle(color: Colors.white54)
                                        : const TextStyle(color: Colors.black54))
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}


