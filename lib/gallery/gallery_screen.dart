import 'dart:async';
import 'package:flutter/material.dart';
import 'package:instagram_clone/create_post/posts.dart';
import 'package:instagram_clone/home/media.dart';
import 'package:instagram_clone/user_profile/user_profile_model.dart';
import 'package:instagram_clone/user_profile/user_profile_service.dart';
import '../components/app_bottom_navigation_bar.dart';
import '../create_post/posts_service.dart';
import 'gallery.media-thumbnail.dart';

class GalleryScreen extends StatefulWidget {

  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final UserProfileService userProfileService = UserProfileService(); //service for queries to Firebase, for ex.: search users by name
  final PostsService postsService = PostsService(); // service for posts
  final TextEditingController _searchController = TextEditingController(); //get text & clean form

  List<UserProfileModel> _userProfiles = [];
  Timer? _debounceTimer;

  Future<void> _handleUserSearch(String searchText) async {
    if(searchText.isEmpty){
      setState(() {
        _userProfiles =[];
      });
      return;
    }
    try{
      //1 -get list of found users, 2-update screen according to found users:
      final userProfilesResult = await userProfileService.getUsersByUserNameSearch(searchText);

      setState(() {
        _userProfiles = userProfilesResult;
      });
    }
    catch(error){
      setState(() {
        _userProfiles =[];
      });
    }
  }

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

                      // Timer:
                      onChanged: (searchText) {
                        _debounceTimer?.cancel();
                        _debounceTimer = Timer(const Duration(milliseconds: 500), (){
                          _handleUserSearch(searchText);
                        });
                      },

                    ),
                  ),

                  if(_searchController.text.isNotEmpty && _userProfiles.isEmpty)
                    Text('User not found'),


                  if(_searchController.text.isNotEmpty)
                    Expanded(
                        child: ListView.builder( //builds list only while scrolling
                          itemCount: _userProfiles.length,
                          itemBuilder: (context, index){ //for each list's element
                            final userProfile = _userProfiles[index];
                            return Row(
                              children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(userProfile.avatar),
                              ),
                              Text(userProfile.userName)
                              ],
                        );
                        })),

                  if(_searchController.text.isEmpty)
                  Expanded(
                    child: StreamBuilder<List<Posts>>(
                      stream: postsService.getPosts(),
                      builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return Center(child: CircularProgressIndicator(),);
                        }
                        //get Posts list from the stream (result - Posts):
                        List<Posts> posts = snapshot.data ?? [];
                        //transform each Post into its media list (result - list of media lists):
                        List<List<Media>> allMediaList = posts.map((post) => post.media).toList();
                        // unpack nested lists into plain list of media-files:
                        List<Media>allMedia = allMediaList.expand((media) => media).toList();

                        return GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 2,
                              crossAxisSpacing: 2
                            ),
                            itemCount: allMedia.length,
                            itemBuilder: (context, index){
                              Media media = allMedia[index];
                              return GalleryMediaThumbnail(media: media,);
                            });
                      },
                    ),
                  )
                ],
              )),
        bottomNavigationBar:  const AppBottomNavigationBar(currentIndex: 1)
    );
  }
}
