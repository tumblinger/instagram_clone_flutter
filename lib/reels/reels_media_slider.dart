import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/home/media.dart';
import 'package:video_player/video_player.dart';

class ReelsMediaSlider extends StatefulWidget { 
  final List<Media> videoMediaList; 

  const ReelsMediaSlider({super.key, required this.videoMediaList, });

  @override 
  State<ReelsMediaSlider> createState() => _ReelsMediaSliderState();
}

class _ReelsMediaSliderState extends State<ReelsMediaSlider> {
  int _currentIndex = 0;
  late List<VideoPlayerController?> _videoControllers;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoController();
  }

  Future<void> _initializeVideoController() async {
    _videoControllers = [];

    for(var videoMedia in widget.videoMediaList){
      final controller = VideoPlayerController.networkUrl(Uri.parse(videoMedia.value)); 
      await controller.initialize();
      _videoControllers.add(controller);
    }

    if(mounted) {
      setState(() {
        _isInitialized = true;
      });
      _playCurrentVideo();
    }
  }

  void _playCurrentVideo(){
    final controller = _videoControllers[_currentIndex];
    if(controller != null && controller.value.isInitialized) {
      controller.play();
    }
  }

  void _pauseAllVideos(){
    for(var controller in _videoControllers){
      controller?.pause();
    }
  }

  @override
  void dispose() {
    for (final controller in _videoControllers) {
      controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(!_isInitialized || _videoControllers.length != widget.videoMediaList.length){
      return Center(child: CircularProgressIndicator());
    }
    return Column(
        children: [
          CarouselSlider(
              items: widget.videoMediaList.asMap().entries.map((entry) {
                int index = entry.key;
                final controller = _videoControllers[index];
                return AspectRatio(
                    aspectRatio: controller!.value.aspectRatio,
                    child: VideoPlayer(controller),
                );
              }).toList(),

              options: CarouselOptions(
                  initialPage: _currentIndex,
                  height: MediaQuery.of(context).size.height,
                  aspectRatio: 1,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, _){
                    setState(() {
                      _currentIndex = index;
                    });
                    _pauseAllVideos();
                    _playCurrentVideo();
                  }
              )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
              widget.videoMediaList.asMap().entries.map((entry){
                return Container(
                  width: 6.0,
                  height: 6.0,
                  margin: EdgeInsets.symmetric(horizontal: 3.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == entry.key ? Colors.blueAccent : Colors.grey,
                  ),);
              }).toList(),
            ),
          )
        ]);
  }
}
