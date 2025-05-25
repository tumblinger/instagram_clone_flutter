import 'package:flutter/material.dart';
import 'package:instagram_clone/create_post/posts.dart';

class HomePostDetailsCard extends StatelessWidget {
  final Posts post;
  const HomePostDetailsCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          Row(children: [
            const Icon(Icons.favorite_outline),
                Text('${post.likes}'),
          ],)
        ],)
      ],
    );
  }
}
