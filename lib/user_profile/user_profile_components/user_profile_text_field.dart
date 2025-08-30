import 'package:flutter/material.dart';

class UserProfileTextField extends StatelessWidget {

  final String label;

  const UserProfileTextField({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 100,
            child: Text(label)),
        Expanded(child: TextField())
      ],
    );
  }
}
