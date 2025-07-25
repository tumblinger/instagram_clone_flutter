import 'package:flutter/material.dart';
import 'package:instagram_clone/home/media.dart';
import 'package:video_player/video_player.dart';

class GalleryMediaThumbnail extends StatefulWidget {
  final Media media;
  const GalleryMediaThumbnail({super.key, required this.media});

  @override
  State<GalleryMediaThumbnail> createState() => _GalleryMediaThumbnailState();
}

class _GalleryMediaThumbnailState extends State<GalleryMediaThumbnail> {
  VideoPlayerController? _videoController;
  @override
  void initState() {
    if(widget.media.type == MediaTypes.video){
      _initializeVideo();
    };
    super.initState();
  }
  Future<void> _initializeVideo() async {
    _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.media.value));
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

    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children:[
        SizedBox(
          width: mediaSize,
          height: mediaSize,
          child: widget.media.type == MediaTypes.image
              ? Image.network(widget.media.value, fit: BoxFit.cover)
              : VideoPlayer(_videoController!),
        ),
        Padding(padding: EdgeInsets.only(right: 8, top: 8),
        child: widget.media.type == MediaTypes.image
            ? const Icon(Icons.image)
            : const Icon(Icons.video_collection),
        ),
        
      ]
    );
  }
}
