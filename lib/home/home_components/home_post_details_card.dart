import 'package:flutter/material.dart';
import 'package:instagram_clone/create_post/posts.dart';

class HomePostDetailsCard extends StatelessWidget {
  final Posts post;
  const HomePostDetailsCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Column(
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
         )
        ],
      ),
    );
  }
}

class HomePostDetailsStatistic extends StatelessWidget {
  final IconData icon;
  final int statValue;
  const HomePostDetailsStatistic({super.key, required this.icon, required this.statValue});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon),
      Text('$statValue'),
    ],);
  }
}

