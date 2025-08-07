import 'package:flutter/material.dart';
import 'package:instagram_clone/home/media.dart';
import '../components/app_bottom_navigation_bar.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  List<Media> _mediaList = [];

  @override
  void initState() {
    if(_mediaList.isEmpty){
      //open camera
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('New post', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: const SafeArea(
          child: Center(child: Text("Create a post Screen"),)),
        bottomNavigationBar:  const AppBottomNavigationBar(currentIndex: 2)
    );
  }
}
