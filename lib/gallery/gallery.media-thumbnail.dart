import 'package:flutter/material.dart';
import 'package:instagram_clone/home/media.dart';
import 'package:instagram_clone/user_profile/user_posts_screen.dart';
import 'package:video_player/video_player.dart';
import '../user_profile/user_profile_model.dart';

class GalleryMediaThumbnail extends StatefulWidget {
  final UserPostMedia userPostMedia;
  final int currentScreenIndex;

  const GalleryMediaThumbnail({
    super.key,
    required this.currentScreenIndex,
    required this.userPostMedia,
  });

  @override
  State<GalleryMediaThumbnail> createState() => _GalleryMediaThumbnailState();
}

class _GalleryMediaThumbnailState extends State<GalleryMediaThumbnail> {
  VideoPlayerController? _videoController;
  @override
  void initState() {
    if(widget.userPostMedia.media.type == MediaTypes.video){
      _initializeVideo();
    };
    super.initState();
  }
  Future<void> _initializeVideo() async {
    _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.userPostMedia.media.value));
    await _videoController!.initialize();

    if(mounted) {
      setState(() {
        _videoController!.play();
        _videoController!.setVolume(0);
        _videoController!.setLooping(true);
      });
    }
  }
  
  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final mediaSize = screenWidth/3;

    return InkWell(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(
          builder: (context) => UserPostsScreen(
              userId: widget.userPostMedia.userId,
              currentScreenIndex: widget.currentScreenIndex, 
              currentMediaIndex: widget.userPostMedia.mediaIndex,
              )
      )),
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children:[
          SizedBox(
            width: mediaSize,
            height: mediaSize,
            child: widget.userPostMedia.media.type == MediaTypes.image
                ? Image.network(widget.userPostMedia.media.value, fit: BoxFit.cover)
                : VideoPlayer(_videoController!),
          ),
          Padding(padding: EdgeInsets.only(right: 8, top: 8),
          child: widget.userPostMedia.media.type == MediaTypes.image
              ? const Icon(Icons.image, color: Colors.white, size: 16)
              : const Icon(Icons.video_collection, color: Colors.white, size: 16),
          ),

        ]
      ),
    );
  }
}
