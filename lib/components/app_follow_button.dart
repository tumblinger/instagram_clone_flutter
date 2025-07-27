import 'package:flutter/material.dart';

class AppFollowButton extends StatelessWidget {
  const AppFollowButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: (){},
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.white, width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          minimumSize: Size.zero
        ), 
        child: Text('Follow', 
          style: TextStyle(color: Colors.white, fontSize: 1)
        ));
  }
}
