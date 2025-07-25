import 'package:flutter/material.dart';
import 'package:instagram_clone/home/media.dart';

class GalleryMediaThumbnail extends StatelessWidget {
  final Media media;
  const GalleryMediaThumbnail({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final mediaSize = screenWidth/3;
    
    return SizedBox(
      width: mediaSize,
      height: mediaSize,
      child: media.type == MediaTypes.image 
          ? Image.network(media.value, fit: BoxFit.cover) 
          : null,
    );
  }
}

