import 'package:flutter/material.dart';
import '../../../../components/text_input_field.dart';
import '../auth_constants.dart';
import 'auth_screen_padding.dart';

class SignupScreenWrapper extends StatelessWidget {
  final String headerText;
  final String description;
  final String inputLabel;
  final TextInputField textInputField;
  final bool ? emailConfirmationStep;
  final bool loading;
  final String ? errorMessage;
  final bool ? ifHaveAccount;
  final Function() ? onResendConfirmationCodeButtonPressed;
  final Function() onNextButtonPressed;

  const SignupScreenWrapper({
    required this.headerText,
    required this.description,
    required this.inputLabel,
    required this.textInputField,
    this.onResendConfirmationCodeButtonPressed,
    this.emailConfirmationStep = false,
    this.loading = false,
    this.errorMessage,
    this.ifHaveAccount = false,
    required this.onNextButtonPressed,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return AuthScreenPadding(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(headerText,
                    style: Theme.of(context).brightness ==
                        Brightness.dark
                        ? const TextStyle(color: Colors.white,fontWeight: FontWeight.bold)
                        : const TextStyle(color: Colors.black,fontWeight: FontWeight.bold)
                ),
                const SizedBox(height: authFormGapValue),
                Text(description,
                    style: (Theme.of(context).brightness ==
                        Brightness.dark
                        ? const TextStyle(color: Colors.white)
                        : const TextStyle(color: Colors.black))
                        .copyWith(fontSize: 12.0)),
                const SizedBox(height: authFormGapValue),
                textInputField,
                if(errorMessage != null)
                  Text(errorMessage!, style: TextStyle(color: Colors.red)),
                const SizedBox(height: authFormGapValue),
                loading ?
                Center(child: CircularProgressIndicator(strokeWidth: 4.0,)):
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                      onPressed: onNextButtonPressed,
                      child:const Text("Next")),
                ),
                if (emailConfirmationStep == true)
                  SizedBox( width: double.infinity,
                      child: OutlinedButton(
                        onPressed: onResendConfirmationCodeButtonPressed,
                        style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF0095F6))),
                        child: const Text("I didn't get the code"),
                      ))
              ]
          ),
          Column(
            children: [
              SizedBox( width: double.infinity,
                  child: TextButton(onPressed:() => Navigator.popAndPushNamed(context, '/login'),
                      child: const Text("Already have an account? Login")
                  )
              )
            ],
          )
        ],
      ),
    );
  }
}

