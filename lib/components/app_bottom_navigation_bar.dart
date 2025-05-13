import 'package:flutter/material.dart';
import 'package:instagram_clone/app_routes.dart';

class AppBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  const AppBottomNavigationBar({super.key, required this.currentIndex});

  @override
  State<AppBottomNavigationBar> createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar> {

  late int _activeIndex;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _activeIndex = widget.currentIndex;
  }

  void _onNavItemTapped(int index) {
    if(index == _activeIndex){
      print('index $index');
      print('index $_activeIndex');
      return;
    }
    setState(() {
      _activeIndex = index;
    });
    switch(index) {
      case 0:
        Navigator.pushNamed(context, AppRoutes.home);
        break;
      case 1:
        Navigator.pushNamed(context, AppRoutes.search);
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.createPost);
        break;
      case 3:
        Navigator.pushNamed(context, AppRoutes.reels);
        break;
      case 4:
        Navigator.pushNamed(context, AppRoutes.userProfile);
        break;

      default:
        Navigator.pushNamed(context, AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _activeIndex,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              activeIcon: Icon(Icons.search),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined),
              activeIcon: Icon(Icons.add_box),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.video_collection_outlined),
              activeIcon: Icon(Icons.video_collection),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined),
              activeIcon: Icon(Icons.person_2),
              label: ''),
        ],
    onTap: _onNavItemTapped,);
  }
}

