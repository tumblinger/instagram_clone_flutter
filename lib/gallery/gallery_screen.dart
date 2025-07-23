import 'package:flutter/material.dart';
import '../components/app_bottom_navigation_bar.dart';

class GalleryScreen extends StatefulWidget {

  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    child: TextField(
                      controller: _searchController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide: BorderSide.none
                        ),
                        hintText: "Search by username...",
                        filled: true,
                        fillColor: Colors.black12
                      ),
                    ),
                  )
                ],
              )),
        bottomNavigationBar:  const AppBottomNavigationBar(currentIndex: 1)
    );
  }
}
