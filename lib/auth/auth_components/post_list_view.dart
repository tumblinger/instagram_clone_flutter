import 'package:flutter/material.dart';
import 'package:instagram_clone/components/post_created_by_details.dart';
import 'package:instagram_clone/create_post/posts.dart';
import 'package:instagram_clone/create_post/posts_service.dart';

import '../../components/app_follow_button.dart';
import '../../home/home_components/home_media_slider.dart';
import '../../home/home_components/home_post_details_card.dart';
import '../../user_profile/user_page_screen.dart';

class PostListView extends StatelessWidget {
  final List<Posts> posts;
  final int currentScreenIndex;
  final int? currentMediaIndex;
  final PostsService postsService;

  const PostListView({ 
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
                      Container(
                        color: Colors.black12,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              PostCreatedByDetails(post: post, currentScreenIndex: currentScreenIndex),
                              Row(children: [
                                AppFollowButton(),
                                SizedBox(width: 12.0),
                                Icon(Icons.more_horiz, color: Colors.white)
                              ],)
                            ],),
                        ),
                      ),
                    ]),

                HomePostDetailsCard(post: post, postService: postsService)
              ],
            ),
          );

        });
  }
}
