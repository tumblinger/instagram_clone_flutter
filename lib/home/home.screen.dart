import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/auth/auth_components/post_list_view.dart';
import 'package:instagram_clone/create_post/posts.dart';
import 'package:instagram_clone/create_post/posts_service.dart';
import '../app_constants.dart';
import '../components/app_bottom_navigation_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PostsService postsService = PostsService();
    final int currentScreenIndex = 0;

    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 64.0,
          leading: Padding(
          padding: const EdgeInsets.only(left: AppConstants.defaultAppPadding),
          child: SvgPicture.asset("assets/app-logos/instagram-clone-logo-dark.svg", semanticsLabel: 'Text logo',),
        ),
          leadingWidth: 100.0,
          actions: [
          IconButton(
            padding: EdgeInsets.only(right: AppConstants.defaultAppPadding),
            icon: const Icon (CupertinoIcons.heart),
            onPressed: ()=> print('Heart'),
          ),
        ],
      ),
      body: SafeArea(
          child: StreamBuilder<List<Posts>>(
              stream: postsService.getPosts(),
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
                    postsService: postsService
                );
              })
      ),
        bottomNavigationBar:  AppBottomNavigationBar(currentIndex: currentScreenIndex)

    );
  }
}

