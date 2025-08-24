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

  @override
  void initState() {
    super.initState();
    _initializeVideoController();
    _playCurrentVideo();
  }

  @override
  void dispose() {
    for (final controller in _videoControllers) {
      controller?.dispose(); 
    }
    super.dispose();
  }

  void _initializeVideoController(){
    _videoControllers = widget.videoMediaList.map((videoMedia){
        final videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(videoMedia.value)); 
        final controller = videoPlayerController
          ..initialize().then((_){ 
            setState(() {}); 
          });
        return controller;
    }).toList();
  }

  void _playCurrentVideo(){
      _videoControllers[_currentIndex]?.play();
  }

  void _pauseAllVideos(){
    for(var controller in _videoControllers){
      controller?.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          CarouselSlider(
              items: widget.videoMediaList.asMap().entries.map((entry) {
                int index = entry.key;
                return Builder( 
                    builder: (BuildContext context){
                        return VideoPlayer(_videoControllers[index]!);
                      });
              }).toList(),

              options: CarouselOptions(
                  initialPage: _currentIndex,
                  height: MediaQuery.of(context).size.height * 0.6,
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
