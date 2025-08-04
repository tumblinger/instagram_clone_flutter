import 'package:flutter/material.dart';
import 'package:instagram_clone/create_post/posts.dart';
import 'package:instagram_clone/create_post/posts_service.dart';

import '../../components/app_follow_button.dart';
import '../../home/home_components/home_media_slider.dart';
import '../../home/home_components/home_post_details_card.dart';
import '../../user_profile/user_page_screen.dart';

class PostListView extends StatelessWidget {
  final List<Posts> posts;
  final int currentScreenIndex;
  final PostsService postsService;

  const PostListView({ // Constructor
    super.key,
    required this.posts,
    required this.currentScreenIndex,
    required this.postsService
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
                      HomeMediaSlider(mediaList: post.media),
                      Container(
                        color: Colors.black12,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () => Navigator.push(
                                    context, MaterialPageRoute(
                                    builder: (context) => UserPageScreen(
                                        currentScreenIndex: currentScreenIndex,
                                        userId: post.userId,
                                        userName: post.userName)
                                )),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 28.0,
                                      child: CircleAvatar(
                                          backgroundImage: NetworkImage(post.avatar)),
                                    ),

                                    SizedBox(width: 12.0),

                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(post.userName, style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.white)),
                                        const Text('Suggested for you', style: TextStyle(fontSize: 10.0, color: Colors.white))
                                      ],)
                                  ],),
                              ),
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
