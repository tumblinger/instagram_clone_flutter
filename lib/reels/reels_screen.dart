import 'package:flutter/material.dart';
import 'package:instagram_clone/create_post/posts.dart';
import 'package:instagram_clone/create_post/posts_service.dart';
import 'package:instagram_clone/home/media.dart';
import 'package:instagram_clone/reels/reels_post_list_view.dart';

class ReelsScreen extends StatelessWidget {

  ReelsScreen({super.key});
  final PostsService postsService = PostsService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: StreamBuilder<List<Posts>>(
              stream: postsService.getPosts(),
              builder: (context, snapshot){
               
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Scaffold(
                      body: Center(
                          child: CircularProgressIndicator()));
                }
           
                if(snapshot.hasError){
                  return const Center(child: Text('Error'));
                }
               
                if(!snapshot.hasData || snapshot.data!.isEmpty){
                  return const Center(child: Text('No posts yet'));
                }
                List<Posts> posts = snapshot.data!;
                List<PostVideo> postVideos = posts.map((post){
                  return PostVideo(
                      posts: post,
                      videoMedia: post.media.where((mediaItem) => mediaItem.type == MediaTypes.video).toList()
                  );
                }).toList();

                return ReelsPostListView(postVideos: postVideos);
              })
      ));
  }
}
