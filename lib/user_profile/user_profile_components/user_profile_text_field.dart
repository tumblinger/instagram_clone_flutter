import 'package:flutter/material.dart';

class UserProfileTextField extends StatelessWidget {
  const UserProfileTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('First Name'),
        Expanded(child: TextField())
      ],
    );
  }
}
