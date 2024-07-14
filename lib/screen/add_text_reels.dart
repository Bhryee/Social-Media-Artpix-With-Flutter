import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sketch_app/data/firebase_servise/firestor.dart';
import 'package:sketch_app/data/firebase_servise/storage.dart';
import 'package:video_player/video_player.dart';
import 'package:easy_localization/easy_localization.dart';

class AddReelsTextScreen extends StatefulWidget {
  File videoFile;

  AddReelsTextScreen(this.videoFile, {super.key});

  @override
  State<AddReelsTextScreen> createState() => _AddReelsTextScreenState();
}

class _AddReelsTextScreenState extends State<AddReelsTextScreen> {
  final caption = TextEditingController();
  late VideoPlayerController controller;
  bool Loading = false;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {});
        controller.setLooping(true);
        controller.setVolume(1.0);
        controller.play();
      });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFF1C869E)),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: Text(
          'Yeni Gönderi'.tr(),
          //style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    Loading = true;
                  });
                  String reels_url = await StorageMethod()
                      .uploadImageToStorage('reels', widget.videoFile);
                  await FirebaseFirestoreService()
                      .createReels(video: reels_url, caption: caption.text);
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Paylaş'.tr(),
                  style: TextStyle(color: Color(0xFF1C869E), fontSize: 15),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Loading
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.black,
              ))
            : SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1),
                  child: Column(
                    children: [
                      SizedBox(height: 30.h),
                      SizedBox(
                        height: 65,
                        width: 280.w,
                        child: TextField(
                          controller: caption,
                          maxLines: 10,
                          decoration: InputDecoration(
                            hintText: 'Bir açıklama yaz ...'.tr(),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                              width: 315,
                              height: 560,
                              child: controller.value.isInitialized
                                  ? AspectRatio(
                                      aspectRatio: controller.value.aspectRatio,
                                      child: VideoPlayer(controller),
                                    )
                                  : const CircularProgressIndicator()),
                        ),
                      ),
                    ],
                  ),
                ),
            ),
      ),
    );
  }
}
