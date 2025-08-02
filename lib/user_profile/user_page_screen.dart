import 'package:flutter/material.dart';
import 'package:instagram_clone/components/app_bottom_navigation_bar.dart';
import 'package:instagram_clone/components/app_follow_button.dart';
import 'package:instagram_clone/create_post/posts_service.dart';
import 'package:instagram_clone/user_profile/user_profile_model.dart';
import 'package:instagram_clone/user_profile/user_profile_service.dart';
import '../create_post/posts.dart';
import '../components/gallery.media-thumbnail.dart';
import '../home/media.dart';

class UserPageScreen extends StatefulWidget {
  final int currentScreenIndex;
  final String userId;
  final String userName;

  const UserPageScreen({
    super.key, 
    required this.currentScreenIndex, 
    required this.userId,
    required this.userName});

  @override
  State<UserPageScreen> createState() => _UserPageScreenState();
}

class _UserPageScreenState extends State<UserPageScreen> {
  final UserProfileService userProfileService = UserProfileService();
  final PostsService postsService = PostsService();
  bool _isLoadingUserProfile = true; 
  UserProfileModel? _userProfile; 

  @override
  void initState() { 
    _getUserProfile();
    super.initState();
  }

  Future<void> _getUserProfile() async{ 
    try{
      UserProfileModel? userProfile = await userProfileService.getUserProfile(widget.userId);
      if(userProfile != null){
        setState(() {
          _isLoadingUserProfile = false;
          _userProfile = userProfile;
        });
      }
    }
    catch(error){
      rethrow; 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: ()=> Navigator.pop(context),
          child: Icon(Icons.arrow_back),
        ),
        title: Text(widget.userName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        actions: [
          Padding(padding: EdgeInsets.only(right: 16),
             child: AppFollowButton(color: Colors.black)),

        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (_isLoadingUserProfile)
              CircularProgressIndicator(strokeWidth: 2),

            if(!_isLoadingUserProfile && _userProfile != null)
          Expanded(
            child: Column(
               children: [
                 // if(_userProfile != null)
                 UserPageHeader(userProfileModel: _userProfile!),
                 Container(
                   decoration: BoxDecoration(
                     border: Border(
                       top: BorderSide(color: Colors.black12),
                       bottom: BorderSide(color: Colors.black12)
                     )
                   ),
                   child: Padding(
                     padding: const EdgeInsets.symmetric(vertical: 8),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Icon(Icons.grid_on_outlined),
                         SizedBox(width: 100),
                         Icon(Icons.video_collection_outlined),
                         SizedBox(width: 100),
                         Icon(Icons.image_outlined)
                       ],
                     ),
                   ),
                 ),

                 Expanded(
                   child: StreamBuilder<List<Posts>>(
                     stream: postsService.getPostsByUserId(_userProfile!.uid),
                     builder: (context, snapshot) {
                       if(snapshot.connectionState == ConnectionState.waiting){
                         return Center(child: CircularProgressIndicator());
                       }
                       if(!snapshot.hasData || snapshot.data!.isEmpty){
                         return Center(
                           child: Text('No posts found'),
                         );
                       }
                       final posts = snapshot.data!;
                       print('Posts count: ${posts.length}');

                       final allMedia = posts.expand((post) => post.media).toList();
                       print("Total media count: ${allMedia.length}");
                       if(allMedia.isEmpty){
                         return Center(
                           child: Text('No media found')
                         );
                       }

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
                 ),
               ],
            ),
          )
          ])
      ),
      bottomNavigationBar: AppBottomNavigationBar(currentIndex: widget.currentScreenIndex),
    );
  }
}

class UserPageHeader extends StatelessWidget {
  final UserProfileModel userProfileModel;
  const UserPageHeader({super.key, required this.userProfileModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(userProfileModel.avatar),),
              ),
              SizedBox(width: 50),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    UserStatistics(value: userProfileModel.totalPosts ?? 0, label: 'Posts'),
                    UserStatistics(value: userProfileModel.totalFollowers ?? 0, label: 'Followers'),
                    UserStatistics(value: userProfileModel.totalFollowing ?? 0, label: 'Following'),
                  ],
                ),
              )

            ],),
          SizedBox(height: 16),
          Column(
            children: [
              Text(userProfileModel.userName, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),

              if(userProfileModel.bio != null && userProfileModel.bio!.isNotEmpty)
                Text(userProfileModel.bio!, style: TextStyle(fontSize: 12, color: Colors.black54)),
            ],
          )
        ],
      ),
    );
  }
}

class UserStatistics extends StatelessWidget {
  final int value;
  final String label;
  const UserStatistics({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
            '$value',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 10),)
      ],
    );
  }
}
