import 'dart:async';
import 'package:flutter/material.dart';
import 'package:instagram_clone/create_post/posts.dart';
import 'package:instagram_clone/home/media.dart';
import 'package:instagram_clone/user_profile/user_page_screen.dart';
import 'package:instagram_clone/user_profile/user_profile_model.dart';
import 'package:instagram_clone/user_profile/user_profile_service.dart';
import '../components/app_bottom_navigation_bar.dart';
import '../create_post/posts_service.dart';
import '../components/gallery.media-thumbnail.dart';

class GalleryScreen extends StatefulWidget {

  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final UserProfileService userProfileService = UserProfileService(); 
  final PostsService postsService = PostsService(); 
  final TextEditingController _searchController = TextEditingController(); 
  final int currentScreenIndex = 1;

  List<UserProfileModel> _userProfiles = [];
  Timer? _debounceTimer;
  bool _isLoading = false;

  Future<void> _handleUserSearch(String searchText) async {
    if(searchText.isEmpty){
      setState(() {
        _userProfiles =[];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try{
      final userProfilesResult = await userProfileService.getUsersByUserNameSearch(searchText);

      setState(() {
        _userProfiles = userProfilesResult;
        _isLoading = false;
      });
    }
    catch(error){
      setState(() {
        _userProfiles =[];
        _isLoading = false;
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

                  if(_isLoading)
                    CircularProgressIndicator(strokeWidth: 2),

                  if(!_isLoading && _searchController.text.isNotEmpty && _userProfiles.isEmpty)
                    Text('User not found'),


                  if(_searchController.text.isNotEmpty)
                    Expanded(
                        child: ListView.builder( //builds list only while scrolling
                          itemCount: _userProfiles.length,
                          itemBuilder: (context, index){
                            final userProfile = _userProfiles[index];

                            return InkWell(
                              onTap: () => Navigator.push(
                                  context, MaterialPageRoute(
                                  builder: (context) => UserPageScreen(
                                      currentScreenIndex: currentScreenIndex,
                                      userId: userProfile.uid,
                                      userName: userProfile.userName,
                                  )
                              )),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 32,
                                      height: 32,
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(userProfile.avatar),
                                      ),
                                    ),
                                  SizedBox(width: 8),
                                  Text(userProfile.userName, style: TextStyle(fontSize: 12))
                                  ],
                                ),
                              ),
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

                        List<UserPostMedia> allUserPostMedia = posts.asMap().entries.expand((postEntry) => postEntry.value.media.asMap().entries.map((mediaEntry) => UserPostMedia(
                            userId: posts[postEntry.key].userId,
                            media: mediaEntry.value, 
                            mediaIndex: mediaEntry.key)
                        )).toList();

                        return GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 2,
                              crossAxisSpacing: 2
                            ),
                            itemCount: allUserPostMedia.length,
                            itemBuilder: (context, index){
                              UserPostMedia userPostMedia = allUserPostMedia[index];
                              
                              return GalleryMediaThumbnail(currentScreenIndex:  currentScreenIndex, userPostMedia: userPostMedia);
                            });
                      },
                    ),
                  )
                ],
              )),
        bottomNavigationBar:  AppBottomNavigationBar(currentIndex: currentScreenIndex)
    );
  }
}
