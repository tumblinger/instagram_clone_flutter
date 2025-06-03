import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/create_post/posts.dart';
import 'package:instagram_clone/create_post/posts_service.dart';
import 'package:instagram_clone/home/home_components/home_post_details_card.dart';

import '../app_constants.dart';
import '../components/app_bottom_navigation_bar.dart';
import 'home_components/home_media_slider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PostsService postsService = PostsService();

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
                                    Row(children: [
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
                                    Row(children: [
                                      InkWell(
                                        customBorder: RoundedRectangleBorder(side: BorderSide(color: Colors.black)),
                                          child: Text('Follow', style: TextStyle(color: Colors.white),)),
                                      SizedBox(width: 12.0),
                                      Icon(Icons.more_horiz, color: Colors.white,)
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
              })
      ),
        bottomNavigationBar:  AppBottomNavigationBar(currentIndex: 0)

    );
  }
}




