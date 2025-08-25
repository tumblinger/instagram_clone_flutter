import 'package:flutter/material.dart';
import 'package:instagram_clone/components/post_created_by_details.dart';
import 'package:instagram_clone/create_post/posts.dart';
import 'package:instagram_clone/create_post/posts_service.dart';
import '../../home/home_components/home_media_slider.dart';
import '../../home/home_components/home_post_details_card.dart';

class PostListView extends StatelessWidget {
  final List<Posts> posts;
  final int currentScreenIndex;
  final int? currentMediaIndex;
  final PostsService postsService;

  const PostListView({ // Constructor
    super.key,
    required this.posts,
    required this.currentScreenIndex,
    required this.postsService,
    this.currentMediaIndex
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index){
          Posts post = posts[index];

          return Card(
            elevation: 0.0,
            color: Colors.transparent,
            child: Column(
              children: [
                Stack(
                    children: [
                      HomeMediaSlider(mediaList: post.media, currentMediaIndex: currentMediaIndex,),
                      PostCreatedByDetails(post: post, currentScreenIndex: currentScreenIndex)
                    ]),

                HomePostDetailsCard(post: post, postService: postsService)
              ],
            ),
          );

        });
  }
}
