import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/home/media.dart';
import 'package:video_player/video_player.dart';

class HomeMediaSlider extends StatefulWidget {
  final List<Media> mediaList;
  final int? currentMediaIndex;
  final int? currentPostIndex;

  const HomeMediaSlider({super.key, required this.mediaList, this.currentMediaIndex, this.currentPostIndex});

  @override
  State<HomeMediaSlider> createState() => _HomeMediaSliderState();
}

class _HomeMediaSliderState extends State<HomeMediaSlider> {
  int _currentIndex = 0;
  late List<VideoPlayerController?> _videoControllers;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentMediaIndex ?? 0;
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
    _videoControllers = widget.mediaList.map((media){
      if(media.type == MediaTypes.video){

        final controller = VideoPlayerController.networkUrl(Uri.parse(media.value))
            ..initialize().then((_){
              setState(() {});
            });
        return controller;
      }
      return null;
    }).toList();
  }

  void _playCurrentVideo(){
    if(widget.mediaList[_currentIndex].type == MediaTypes.video){
      _videoControllers[_currentIndex]?.play();
    }
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
            items: widget.mediaList.asMap().entries.map((entry) {
              int index = entry.key;
              Media media = entry.value;
              return Builder(
                  builder: (BuildContext context){
                    if(media.type == MediaTypes.image){
                      return Image.network(media.value, fit: BoxFit.cover,);
                    } else {
                      return VideoPlayer(_videoControllers[index]!);
                    }
                  }

              );
            }).toList(), 

            options: CarouselOptions(
              initialPage: _currentIndex,
              height: 520,
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
            widget.mediaList.asMap().entries.map((entry){
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
