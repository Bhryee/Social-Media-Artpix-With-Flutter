import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sketch_app/screen/add_reels.dart';
import 'package:sketch_app/screen/add_posts.dart';
import 'package:easy_localization/easy_localization.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

int _currentIndex = 0;

class _AddScreenState extends State<AddScreen> {
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

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView(
              controller: pageController,
              onPageChanged: onPageChanged,
              children: [AddPostScreen(), AddReelsScreen()],
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              bottom: 10,
              right: _currentIndex == 0 ? 120 : 170,
              child: Container(
                width: 160,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        navigationTapped(0);
                      },
                      child: Text(
                        'Fotoğraf'.tr(),
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: _currentIndex == 0 ? Colors.white : Colors.grey),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        navigationTapped(1);
                      },
                      child: Text(
                        'Video',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: _currentIndex == 1 ? Colors.white : Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
