import 'package:flutter/material.dart';
import 'package:instagram_clone/create_post/posts.dart';

class ReelsPostListView extends StatelessWidget {
  final List<PostVideo> postVideos;
  const ReelsPostListView({super.key, required this.postVideos});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: postVideos.length,
        itemBuilder: (context, index){
      PostVideo postVideo = postVideos[index];
      return Container();
    });
  }
}
