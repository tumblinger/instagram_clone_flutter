import 'package:flutter/material.dart';
import 'package:instagram_clone/create_post/posts.dart';
import 'package:instagram_clone/create_post/posts_service.dart';
import 'package:instagram_clone/home/home_components/home_post_details_card.dart';
import 'package:instagram_clone/reels/reels.util.dart';
import 'package:instagram_clone/reels/reels_media_slider.dart';
import '../components/post_created_by_details.dart';

class ReelsPostListView extends StatelessWidget {
  final List<PostVideo> postVideos;
  final int currentScreenIndex;
  ReelsPostListView({super.key, required this.postVideos, required this.currentScreenIndex});
  final PostsService _postService = PostsService();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: postVideos.length,
      itemBuilder: (context, index){
      PostVideo postVideo = postVideos[index];
      Posts post = postVideo.posts;

      return Stack(
        children: [
          ReelsMediaSlider(videoMediaList: postVideo.videoMedia),
          SizedBox(
            height: videoDisplayHeight(context),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PostCreatedByDetails(post: postVideo.posts, currentScreenIndex: currentScreenIndex),
                  HomePostDetailsCard(post: post, postService: _postService, colorStyle: ColorStyle.light)
                ],
              ),
            ),
          )
        ],
      );
    });
  }
}
