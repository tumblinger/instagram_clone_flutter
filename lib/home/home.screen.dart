import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/home/media.dart';
import 'package:instagram_clone/home/posts.dart';
import 'package:instagram_clone/home/posts_service.dart';

import '../app_constants.dart';
import '../components/app_bottom_navigation_bar.dart';

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
          leadingWidth: 120.0,
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
                        // color: Colors.amberAccent,
                        child: Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(post.avatar),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: AppConstants.defaultAppPadding
                              ),
                              textColor: Colors.black,
                              title: Text(post.userName),
                              titleTextStyle: const TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold),
                              titleAlignment: ListTileTitleAlignment.center,
                              subtitle: const Text("Suggested for you"),
                              subtitleTextStyle: const TextStyle(fontSize: 10.0),
                              trailing: const Icon(Icons.more_vert),
                            ),

                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 300.0,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                  itemCount: post.media.length,
                                  itemBuilder: (context, index){
                                    MediaTypes mediaTypes = post.media[index].type;
                                    String mediaValue = post.media[index].value;

                                    return SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: mediaTypes == MediaTypes.image ? Image.network(mediaValue, fit: BoxFit.cover,) : const Text('Video'),
                                    );
                                  }),
                            )
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

