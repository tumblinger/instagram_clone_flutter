import 'dart:convert';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:instagram_clone/app_routes.dart';
import 'package:instagram_clone/components/text_input_field.dart';
import 'package:provider/provider.dart';
import 'package:instagram_clone/user_profile/user_profile_provider.dart';
import '../auth_components/signup_screen_wrapper.dart';

class SignupEmailOtpScreen extends StatefulWidget {
  const SignupEmailOtpScreen({super.key});

  @override
  State<SignupEmailOtpScreen> createState() => _SignupEmailOtpScreenState();
}

class _SignupEmailOtpScreenState extends State<SignupEmailOtpScreen> {
  final TextEditingController _signupOtpController = TextEditingController();

  String? _errorMessage;
  late String _createdOtp;

  //G e n e r a t e   O T P:
  String createOtp(){
    Random random = Random();
    String otp ='';
    for(int i=0; i<6; i++){
      String randomNumber = random.nextInt(10).toString();
      otp = otp + randomNumber;
    }
    return otp;
  }

  Future<void> _sendEmailWithOtp(String email, String otp) async{
    try{
      final emailResponse = await http.post(
          Uri.parse("https://pwt3i3mzcm.us-east-1.awsapprunner.com/api/v1/email/test"),
          headers: {
          "Content-Type": "application/json",
          "apiKey": "G3WM69SDmhCYkEZw2Ty7sn"
          },
          body: jsonEncode({
            'fromName': 'Instagram Clone',
            'subject': 'Email verification OTP',
            'toEmail': email,
            'bodyText': 'Your OTP for verification is $otp',
          },
          ));
        if (emailResponse.statusCode !=200) {
          setState(() {
            _errorMessage = 'Failed to send OTP email';
          });
      }
    } catch(error) {
      setState(() {
        //_errorMessage = 'Failed to send OTP email. Error: ${error.toString()}';
        _errorMessage = 'A server error occurred';
      });
    }
  }

  @override
  void initState(){
    super.initState();
    _createdOtp = createOtp();
    final email = context.read<MyAuthProvider>().email;
    if (email == null){
      Navigator.pop(context);
    }
    if (email != null){
      _sendEmailWithOtp(email, _createdOtp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Provider(
          create: (context) => MyAuthProvider(),
          child: SignupScreenWrapper(
            headerText: "Please enter your one time password (OTP)",
            description: "An OTP has been sent to your email",
            textInputField: TextInputField(
              textInputType: TextInputType.number,
              textEditingController: _signupOtpController,
              label: "otp",
            ),
            inputLabel: "otp",
            errorMessage: _errorMessage,
            emailConfirmationStep: false,
            ifHaveAccount: true,
            onNextButtonPressed: (){
              final enteredOtp = _signupOtpController.text.trim();

              if(enteredOtp.isEmpty){
                setState(() {
                  _errorMessage = 'OTP is required';
                });
                return;
              }

              if(enteredOtp == _createdOtp){
                Navigator.pushNamed(context, AppRoutes.createPassword);
              } else {
                setState(() {
                  _errorMessage = 'Invalid OTP';
                });
              }
            }
          ),
        ),),
    );
  }
}