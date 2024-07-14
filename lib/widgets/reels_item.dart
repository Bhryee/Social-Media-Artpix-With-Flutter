import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sketch_app/util/comment.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sketch_app/data/firebase_servise/firestor.dart';
import 'package:sketch_app/util/image_cached.dart';
import 'package:video_player/video_player.dart';
import 'package:easy_localization/easy_localization.dart';

import 'like.dart';

class ReelsItem extends StatefulWidget {
  final snapshot;

  ReelsItem(this.snapshot, {super.key});

  @override
  State<ReelsItem> createState() => _ReelsItemState();
}

class _ReelsItemState extends State<ReelsItem> {
  late VideoPlayerController controller;
  bool play = true;
  bool isAnimating = false;
  String user = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = _auth.currentUser!.uid;
    // ignore: deprecated_member_use
    controller = VideoPlayerController.network(widget.snapshot['reelsvideo'])
      ..initialize().then((value) {
        setState(() {
          controller.setLooping(true);
          controller.setVolume(1);
          controller.play();
        });
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        GestureDetector(
          onDoubleTap: () {
            FirebaseFirestoreService().like(
                like: widget.snapshot['like'],
                type: 'reels',
                uid: user,
                postId: widget.snapshot['postId']);
            setState(() {
              isAnimating = true;
            });
          },
          onTap: () {
            setState(() {
              play = !play;
            });
            if (play) {
              controller.play();
            } else {
              controller.pause();
            }
          },
          child: Container(
            color: Colors.grey, // BURAYA TEKRAR BAK ???
            width: double.infinity,
            height: 812.h,
            child: VideoPlayer(controller),
          ),
        ),
        if (!play)
          Center(
            child: CircleAvatar(
              backgroundColor: Colors.white30,
              radius: 35.r,
              child: Icon(
                Icons.play_arrow,
                size: 35.w,
                color: Colors.white,
              ),
            ),
          ),
        Center(
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 200),
            opacity: isAnimating ? 1 : 0,
            child: LikeAnimation(
              child: Icon(
                Icons.favorite,
                size: 100.w,
                color: Colors.red,
              ),
              isAnimating: isAnimating,
              duration: Duration(milliseconds: 400),
              iconlike: false,
              End: () {
                setState(() {
                  isAnimating = false;
                });
              },
            ),
          ),
        ),
        Positioned(
          top: 430.h,
          right: 15.w,
          child: Column(
            children: [
              LikeAnimation(
                child: IconButton(
                  onPressed: () {
                    FirebaseFirestoreService().like(
                        like: widget.snapshot['like'],
                        type: 'reels',
                        uid: user,
                        postId: widget.snapshot['postId']);
                  },
                  icon: Icon(
                    widget.snapshot['like'].contains(user)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: widget.snapshot['like'].contains(user)
                        ? Colors.red
                        : Colors.white,
                    size: 24.w,
                  ),
                ),
                isAnimating: widget.snapshot['like'].contains(user),
              ),
              SizedBox(height: 3.h),
              Text(
                widget.snapshot['like'].length.toString(),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 15.h),
              GestureDetector(
                onTap: () {
                  showBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: DraggableScrollableSheet(
                          maxChildSize: 0.6,
                          initialChildSize: 0.6,
                          minChildSize: 0.2,
                          builder: (context, scrollController) {
                            return CommentScreen(
                                'reels', widget.snapshot['postId']);
                          },
                        ),
                      );
                    },
                  );
                },
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: Image.asset(
                    'images/comment-white.png',
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                '0',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 15.h),
              SizedBox(
                  height: 30, width: 30, child: Image.asset('images/send-white.png')),
              SizedBox(height: 3.h),
              Text(
                '0',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 40.h,
          left: 10.w,
          right: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipOval(
                    child: SizedBox(
                      height: 35.h,
                      width: 35.w,
                      child: ImageCached(widget.snapshot['profileImage']),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    widget.snapshot['username'],
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Container(
                    alignment: Alignment.center,
                    width: 65.w,
                    height: 25.h,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Text(
                      'Takip Et'.tr(),
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                widget.snapshot['caption'],
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
