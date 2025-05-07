import 'package:flutter/material.dart';
import 'package:instagram_clone/home/posts.dart';
import 'package:instagram_clone/home/posts_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PostsService postsService = PostsService();

    return Scaffold(
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
                  print('Error: ${snapshot.error}');
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

                      return Column(
                        children: [
                          Text(post.userName),
                          Text(post.caption),
                          Text(post.likes.toString()),
                        ],
                      );

                    });
              })
      ),
    );
  }
}
