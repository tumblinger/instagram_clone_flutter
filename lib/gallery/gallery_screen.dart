import 'package:flutter/material.dart';
import 'package:instagram_clone/create_post/posts.dart';
import 'package:instagram_clone/home/media.dart';
import '../components/app_bottom_navigation_bar.dart';
import '../create_post/posts_service.dart';

class GalleryScreen extends StatefulWidget {

  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final PostsService postsService = PostsService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    child: TextField(
                      controller: _searchController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide: BorderSide.none
                        ),
                        hintText: "Search by username...",
                        filled: true,
                        fillColor: Colors.black12
                      ),
                    ),
                  ),

                  StreamBuilder<List<Posts>>(
                    stream: postsService.getPosts(),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return Center(child: CircularProgressIndicator(),);
                      }
                      List<Posts> posts = snapshot.data ?? [];
                      List<List<Media>> allMediaList = posts.map((post) => post.media).toList();
                      List<Media>allMedia = allMediaList.expand((media) => media).toList();

                      return GridView.builder(
                          gridDelegate: gridDelegate,
                          itemBuilder: itemBuilder);
                    },
                  )
                ],
              )),
        bottomNavigationBar:  const AppBottomNavigationBar(currentIndex: 1)
    );
  }
}
