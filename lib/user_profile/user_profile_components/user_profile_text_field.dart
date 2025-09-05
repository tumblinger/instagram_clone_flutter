import 'package:flutter/material.dart';

class UserProfileTextField extends StatelessWidget {

  final String label;
  final TextEditingController? controller;
  final bool? enabled;
  final String? placeholder;
  final TextInputType? keyboardType;

  const UserProfileTextField({
    super.key,
    required this.label,
    this.controller,
    this.enabled = true,
    this.placeholder,
    this.keyboardType = TextInputType.text
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 100,
            child: Text(label, style: TextStyle(color: enabled! ? Colors.black : Colors.grey),)),
        Expanded(child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            enabled: enabled,
            decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: TextStyle(color: Colors.grey))))
      ],
    );
  }
}

