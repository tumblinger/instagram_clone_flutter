import 'package:flutter/material.dart';
import 'package:instagram_clone/create_post/posts.dart';
import 'package:intl/intl.dart';

import '../../util/numbers.dart';

class HomePostDetailsCard extends StatelessWidget {
  final Posts post;
  const HomePostDetailsCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Row(
               children: [
                 HomePostDetailsStatistic(icon: Icons.favorite_outline, statValue: post.likes),
                 const SizedBox(width: 12.0),
                 HomePostDetailsStatistic(icon: Icons.chat_bubble_outline, statValue: post.comments),
                 const SizedBox(width: 12.0),
                 HomePostDetailsStatistic(icon: Icons.send_outlined, statValue: post.shares),
               ],
             ),
             Icon(Icons.bookmark_border_outlined)
           ],
         ),

          SizedBox(height: 12.0),

          Text.rich(
              style: TextStyle(fontSize: 12.0),
              TextSpan(children: [
                TextSpan(
                  text: '${post.userName} ',
                  style: TextStyle(fontWeight: FontWeight.bold)
            ),
                TextSpan(text: post.caption)
          ])
          ),

          Text(
              DateFormat('MMM dd yyyy').format(post.createdAt),
              style: TextStyle(fontSize: 10.0, color: Colors.grey)
          )
        ],
      ),
    );
  }
}

class HomePostDetailsStatistic extends StatelessWidget {
  final IconData icon;
  final int statValue;
  final VoidCallback? onTap;

  const HomePostDetailsStatistic({super.key, required this.icon, required this.statValue, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(children: [
          Icon(icon),
          Text(shortNumber(statValue), style: TextStyle(fontSize: 10.0),),
      ],),
    );
  }
}
