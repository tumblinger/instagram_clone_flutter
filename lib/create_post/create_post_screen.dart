import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/create_post/post_constants.dart';
import 'package:instagram_clone/create_post/posts.dart';
import 'package:instagram_clone/create_post/posts_service.dart';
import 'package:instagram_clone/home/media.dart';
import 'package:mime/mime.dart';
import '../home/home_components/home_media_slider.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final PostsService _postsService = PostsService();
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

      if(mediaFiles.isEmpty){
        return;
      }

      List<NewPostMedia?> selectedPostMediaList = mediaFiles.map((xFile){
        String? mimeType = lookupMimeType(xFile.path);
        if(mimeType == null) {
          return null;
        }

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
            mediaTypes: fileMediaType);
      }).toList();

      List<NewPostMedia> notNullSelectedPostMediaList = selectedPostMediaList.whereType<NewPostMedia>().toList();

      setState(() {
        _newPostMediaList = notNullSelectedPostMediaList;
      });

    } catch (error){
      print(error);
    }
  }

  Future<void> _createNewPost(String userId) async {
    final caption = _captionTextEditingController.text; 
    
    if(caption == null) return;
    if(_newPostMediaList.isEmpty) return;
    
    DocumentReference? newPostDocRef = await _postsService.createPost(
        userId: userId, 
        caption: caption,
        newPostMediaList: _newPostMediaList
    );
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Center(
                    child: InkWell(
                      onTap: _openMediaPicker,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width *0.7,
                        child: _newPostMediaList.isEmpty
                            ?
                        Container(
                          color: Colors.black12,
                          height: MediaQuery.of(context).size.height *0.5,
                          child: Center(
                            child: Text('Add media'),
                          ),
                        )
                            :
                        HomeMediaSlider(
                          mediaList: _newPostMediaList.map((newPostMedia) => Media(
                              value: '$localFileIdentifier${newPostMedia.file.path}', 
                              type: newPostMedia.mediaTypes)
                          ).toList(),
                        )
                      ),
                    ),
                  ),
                ],
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
              ),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width ,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.black12))
                ),
                child: FilledButton(
                  onPressed: () => {},
                  child: Text('Share'),
                ),
              )
            ],
          ),
      ),
    );
  }
}
