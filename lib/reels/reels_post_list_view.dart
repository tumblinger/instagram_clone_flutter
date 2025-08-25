import 'package:flutter/material.dart';
import 'package:instagram_clone/create_post/posts.dart';
import 'package:instagram_clone/reels/reels_media_slider.dart';
import '../components/app_follow_button.dart';
import '../components/post_created_by_details.dart';

class ReelsPostListView extends StatelessWidget {
  final List<PostVideo> postVideos;
  final int currentScreenIndex;
  const ReelsPostListView({super.key, required this.postVideos, required this.currentScreenIndex});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: postVideos.length,
        itemBuilder: (context, index){
      PostVideo postVideo = postVideos[index];

      return Stack(
        children: [
          ReelsMediaSlider(videoMediaList: postVideo.videoMedia),
          Container(
            color: Colors.black12,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PostCreatedByDetails(post: postVideo.posts, currentScreenIndex: currentScreenIndex),
                  Row(children: [
                    AppFollowButton(),
                    SizedBox(width: 12.0),
                    Icon(Icons.more_horiz, color: Colors.white)
                  ],)
                ],),
            ),
          ),
        ],
      );

    });
  }
}

