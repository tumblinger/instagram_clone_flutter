import 'package:flutter/material.dart';
import 'package:instagram_clone/components/app_bottom_navigation_bar.dart';
import 'package:instagram_clone/components/app_follow_button.dart';
import 'package:instagram_clone/create_post/posts_service.dart';
import 'package:instagram_clone/user_profile/user_profile_enums.dart';
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
  UserProfileModel? _userProfile;   UserPostMediaTab activeTab = UserPostMediaTab.all;
  List<UserPostMedia> tabUserPostMediaList = [];

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
                         TabButton(
                             icon: Icons.grid_on_outlined,
                             active: activeTab == UserPostMediaTab.all,
                             onTap: (){
                               setState(() {
                                activeTab = UserPostMediaTab.all; 
                           });
                         }),
                         SizedBox(width: 100),
                         TabButton(
                             icon: Icons.video_collection_outlined,
                             active: activeTab == UserPostMediaTab.video,
                             onTap: (){
                               setState(() {
                                 activeTab = UserPostMediaTab.video;
                               });
                             }),
                         SizedBox(width: 100),
                         TabButton(
                             icon: Icons.image_outlined,
                             active: activeTab == UserPostMediaTab.image,
                             onTap: (){
                               setState(() {
                                 activeTab = UserPostMediaTab.image;
                               });
                             }),
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

                       List<UserPostMedia> allUserPostMedia = posts.asMap().entries.expand((postEntry) => postEntry.value.media.asMap().entries.map((mediaEntry) => UserPostMedia(
                           userId: posts[postEntry.key].userId,
                           media: mediaEntry.value)
                       )).toList();
                       // final allMedia = posts.expand((post) => post.media).toList(); 

                       // if(allMedia.isEmpty){
                       //   return Center(
                       //     child: Text('No media found')
                       //   );
                       // }

                       if(activeTab == UserPostMediaTab.all) {
                         tabUserPostMediaList = allUserPostMedia;
                       }
                       if(activeTab == UserPostMediaTab.video) {
                         tabUserPostMediaList = allUserPostMedia.where((userPostMedia) => userPostMedia.media.type == MediaTypes.video).toList();
                       }
                       if(activeTab == UserPostMediaTab.image) {
                         tabUserPostMediaList = allUserPostMedia.where((userPostMedia) => userPostMedia.media.type == MediaTypes.image).toList();
                       }

                       return GridView.builder( 
                           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                               crossAxisCount: 3,
                               mainAxisSpacing: 2,
                               crossAxisSpacing: 2
                           ),
                           itemCount: tabUserPostMediaList.length, 
                           itemBuilder: (context, index){ 
                             UserPostMedia userPostMedia = tabUserPostMediaList[index];
                             return GalleryMediaThumbnail( currentScreenIndex:  widget.currentScreenIndex, userPostMedia: userPostMedia,);
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

class TabButton extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback onTap; 

  const TabButton({
    super.key,
    required this.icon,
    required this.onTap, 
    required this.active
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Icon(icon, color: active ? Colors.black : Colors.black26),
    );
  }
}

