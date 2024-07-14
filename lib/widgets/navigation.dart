import 'package:flutter/material.dart';
import 'package:sketch_app/screen/add_posts.dart';
import 'package:sketch_app/screen/explor.dart';
import 'package:sketch_app/screen/home.dart';
import 'package:sketch_app/screen/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sketch_app/screen/reelsScreen.dart';
import 'package:sketch_app/screen/add.dart';
import 'package:sketch_app/screen/reelsScreen.dart';

class NavigationsScreen extends StatefulWidget {
  const NavigationsScreen({super.key});

  @override
  State<NavigationsScreen> createState() => _NavigationsScreenState();
}

int _currentIndex = 0;

class _NavigationsScreenState extends State<NavigationsScreen> {
  late PageController pageController;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  onPageChanged(int page) {
    setState(() {
      _currentIndex = page;
    });
  }

  navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: Container(
        child: BottomNavigationBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).colorScheme.onPrimary,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,

          currentIndex: _currentIndex,
          onTap: navigationTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.video_collection_outlined),
              label: '',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline_rounded),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '',
            ),
          ],
        ),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: [
          HomeScreen(),
          ReelsScreen(),
          AddScreen(),
          ExplorScreen(),
          ProfileScreen(Uid: _auth.currentUser!.uid),
        ],
      ),
    );
  }
}
