import 'package:flutter/material.dart';

class UserProfileTextField extends StatelessWidget {

  final String label;
  final TextEditingController? controller;
  final bool? enabled;

  const UserProfileTextField({super.key, required this.label, this.controller, this.enabled = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 100,
            child: Text(label)),
        Expanded(child: TextField(controller: controller, enabled: enabled,))
      ],
    );
  }
}

