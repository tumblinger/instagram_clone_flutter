import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/home/media.dart';
import 'package:instagram_clone/reels/reels.util.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ReelsMediaSlider extends StatefulWidget { 
  final List<Media> videoMediaList; 
  final int? currentMediaIndex;
  final double? height;

  const ReelsMediaSlider({super.key, required this.videoMediaList, this.currentMediaIndex, this.height, });

  @override
  State<ReelsMediaSlider> createState() => _ReelsMediaSliderState();
}

class _ReelsMediaSliderState extends State<ReelsMediaSlider> {
  int _currentIndex = 0;
  late List<VideoPlayerController?> _videoControllers;
  final Key _videoVisibilityKey = UniqueKey();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentMediaIndex ?? 0;
    _initializeVideoController();
    //_playCurrentVideo();
  }

  Future<void> _initializeVideoController() async {
    _videoControllers = widget.videoMediaList.map((videoMedia) {
      final c = VideoPlayerController.networkUrl(Uri.parse(videoMedia.value));
      c.setLooping(true);
      return c;
    }).toList();
   
    await Future.wait(_videoControllers.map((c) => c!.initialize()));
    if (!mounted) return;
    setState(() {
      _isInitialized = true;
    });
    _playCurrentVideo();
  }

  void _handleVideoVisibilityChange(VisibilityInfo info){
    if(info.visibleFraction > 0.9){
      _playCurrentVideo();
    } else {
      _pauseAllVideos();
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
    if (!_isInitialized || _videoControllers.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return VisibilityDetector(
      key: _videoVisibilityKey,
        onVisibilityChanged: _handleVideoVisibilityChange,

        child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
          children: [
            CarouselSlider(
                items: widget.videoMediaList.asMap().entries.map((entry) {
                  int index = entry.key;
                  Media media = entry.value;

                  return Builder(builder: (BuildContext context){
                    final controller = _videoControllers[index];
                    if(!controller!.value.isInitialized){
                      return const Center(child: CircularProgressIndicator());
                    }

                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: videoDisplayHeight(context),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: FittedBox(
                              fit: BoxFit.cover, // or BoxFit.contain
                              child: SizedBox(
                                width: controller.value.size.width,
                                height: controller.value.size.height,
                                child: VideoPlayer(controller),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 8,
                            right: 8,
                            bottom: 8,
                            child: VideoProgressIndicator(
                              controller,
                              allowScrubbing: true,
                              colors: VideoProgressColors(playedColor: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                    );

                  });
                }).toList(),
      
                options: CarouselOptions(
                    initialPage: _currentIndex,
                    height: videoDisplayHeight(context),
                    // aspectRatio: 1,
                    viewportFraction: 1.0,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, _) {
                      if (_currentIndex == index) return;
                      _pauseAllVideos();
                      setState(() { _currentIndex = index; });
                      _playCurrentVideo();
                    }
                )),
            if(widget.videoMediaList.length >1)
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                widget.videoMediaList.asMap().entries.map((entry){
                  return Container(
                    width: 6.0,
                    height: 6.0,
                    margin: EdgeInsets.symmetric(horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == entry.key ? Colors.blueAccent : Colors.blueGrey,
                    ),);
                }).toList(),
              ),
            )
          ]),
    );
  }
}
