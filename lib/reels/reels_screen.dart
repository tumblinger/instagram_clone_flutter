import 'package:flutter/material.dart';
import 'package:instagram_clone/create_post/posts.dart';

class ReelsScreen extends StatelessWidget {
  final List<PostVideo> postVideos;
  const ReelsScreen({super.key, required this.postVideos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView.builder(
              itemCount: postVideos.length,
              itemBuilder: (context, index){
                PostVideo postVideo = postVideos[index];
               return Container();
              }
              )));
  }
}
