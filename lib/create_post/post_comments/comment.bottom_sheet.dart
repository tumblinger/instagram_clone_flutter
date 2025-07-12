import 'package:flutter/material.dart';
class CommentBottomSheet extends StatelessWidget {
  const CommentBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*0.75,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          SizedBox(
            height: 8),
          Text('Comments', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8)
        ],
      ),
    );
  }
}
