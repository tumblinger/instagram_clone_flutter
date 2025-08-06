import 'package:flutter/material.dart';
import 'package:instagram_clone/create_post/posts_service.dart';

import '../auth/auth_components/post_list_view.dart';
import '../components/app_bottom_navigation_bar.dart';
import '../create_post/posts.dart';

class UserPostsScreen extends StatelessWidget {
  final String userId;
  final int currentScreenIndex;
  final  int? currentMediaIndex;

  UserPostsScreen({super.key, required this.userId, required this.currentScreenIndex, this.currentMediaIndex});

  final PostsService postsService = PostsService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: StreamBuilder<List<Posts>>(
                stream: postsService.getPostsByUserId(userId),
                builder: (context, snapshot){
                  //waiting:
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const Scaffold(
                        body: Center(
                            child: CircularProgressIndicator()));
                  }
                  //error:
                  if(snapshot.hasError){
                    return const Center(child: Text('Error'));
                  }
                  // empty- no posts:
                  if(!snapshot.hasData || snapshot.data!.isEmpty){
                    return const Center(child: Text('No posts yet'));
                  }
                  List<Posts> posts = snapshot.data!;

                  return PostListView(
                      posts: posts,
                      currentScreenIndex: currentScreenIndex,
                      postsService: postsService,
                      currentMediaIndex: currentMediaIndex
                  );
                })
        ),
        bottomNavigationBar:  AppBottomNavigationBar(currentIndex: currentScreenIndex)

    );

  }
}
