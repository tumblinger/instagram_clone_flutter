import 'package:flutter/material.dart';
import 'package:instagram_clone/auth/auth_service.dart';
import 'package:instagram_clone/create_post/posts.dart';
import 'package:instagram_clone/create_post/posts_service.dart';
import 'package:instagram_clone/home/media.dart';
import 'package:instagram_clone/reels/reels_post_list_view.dart';
import 'package:instagram_clone/user_profile/user_profile_model.dart';
import 'package:instagram_clone/user_profile/user_profile_service.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  final PostsService postsService = PostsService();
  final AuthService authService = AuthService();
  final UserProfileService userProfileService = UserProfileService();
  UserProfileModel? _currentUserProfile;

  @override
  void initState(){
    getUserProfile();
    super.initState();
  }

  void getUserProfile() async{
    try{
       UserProfileModel? currentUserProfile = await userProfileService.getUserProfile(authService.currentFirebaseUser!.uid);
       if(currentUserProfile != null){
         setState(() {
           _currentUserProfile = currentUserProfile;
         });
       }
    } catch(e){
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: StreamBuilder<List<Posts>>(
              stream: postsService.getPosts(),
              builder: (context, snapshot){
               
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Scaffold(
                      body: Center(
                          child: CircularProgressIndicator()));
                }
            
                if(snapshot.hasError){
                  return const Center(child: Text('Error'));
                }
              
                if(!snapshot.hasData || snapshot.data!.isEmpty){
                  return const Center(child: Text('No posts yet'));
                }

                List<Posts> posts = snapshot.data!;
                List<PostVideo> postVideos = posts.map((post){ 
                  return PostVideo(
                      posts: post,
                      videoMedia: post.media.where((mediaItem) => mediaItem.type == MediaTypes.video).toList() 
                  );
                }).toList(); 

                return ReelsPostListView(
                    postVideos: postVideos.where((postVideos) => postVideos.videoMedia.isNotEmpty).toList(), currentScreenIndex: 3, currentUserId: _currentUserProfile!.uid, currentUserFollowing: _currentUserProfile!.followers);
              })
      ));
  }
}
