import 'package:flutter/material.dart';

class AppFollowButton extends StatelessWidget {
  final Color color;
  const AppFollowButton({super.key, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: (){},
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color, width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          minimumSize: Size.zero
        ),
        child: Text('Follow',
          style: TextStyle(color: color, fontSize: 10)
        )
    );
  }
}
