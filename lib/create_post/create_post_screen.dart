import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/create_post/posts.dart';
import 'package:instagram_clone/home/media.dart';
import 'package:mime/mime.dart';
import '../components/app_bottom_navigation_bar.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final ImagePicker picker = ImagePicker();
  final TextEditingController _captionTextEditingController = TextEditingController();

  List<NewPostMedia> _newPostMediaList = [];

  @override
  void initState() {
    if(_newPostMediaList.isEmpty){
      _openMediaPicker();
    }
    super.initState();
  }

  Future<void> _openMediaPicker() async{
    try{
      final List<XFile> mediaFiles = await picker.pickMultipleMedia();

      if(mediaFiles.isEmpty){ // user didn't give access
        return;
      }
      List<NewPostMedia?> _selectedPostMediaList = mediaFiles.map((xFile){
        String? mimeType = lookupMimeType(xFile.path);
        if(mimeType == null) { 
          return null;
        }
        print('Mime type: $mimeType');

        MediaTypes? fileMediaType;
        bool isVideo = mimeType.startsWith('video/');
        bool isImage = mimeType.startsWith('image/');

        if(isVideo){
          fileMediaType = MediaTypes.video;
        }
        if(isImage){
          fileMediaType = MediaTypes.image;
        }
        if(fileMediaType == null){
          return null;
        }

        return NewPostMedia(
            file: File(xFile.path),
            mediaTypes: MediaTypes.image);
      }).toList();

      print('MediaFiles: $mediaFiles');

    } catch (error){
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('New post', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
          child: Center(
              child: Column(
                children: [
                  Center(
                    child: InkWell(
                      onTap: _openMediaPicker,
                      child: Container(
                        width: MediaQuery.of(context).size.width *0.7,
                        height: MediaQuery.of(context).size.width*0.8,
                        color: Colors.black12,
                        child: Center(
                          child: Text('Add media'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _captionTextEditingController,
                    decoration: InputDecoration(
                      hintText: 'Add a caption',
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16
                      )
                    ),
                  )
                ],
              ))),
        bottomNavigationBar:  const AppBottomNavigationBar(currentIndex: 2)
    );
  }
}
