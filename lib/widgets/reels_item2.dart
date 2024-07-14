import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sketch_app/util/comment.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sketch_app/data/firebase_servise/firestor.dart';
import 'package:sketch_app/util/image_cached.dart';
import 'package:video_player/video_player.dart';
import 'package:easy_localization/easy_localization.dart';

import 'like.dart';

class ReelsItem2 extends StatefulWidget {
  final snapshot;

  ReelsItem2(this.snapshot, {super.key});

  @override
  State<ReelsItem2> createState() => _ReelsItem2State();
}

class _ReelsItem2State extends State<ReelsItem2> {
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
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 54,
            color: Theme.of(context).colorScheme.surface,
            child: Center(
              child: ListTile(
                leading: ClipOval(
                  child: SizedBox(
                    width: 35,
                    height: 35,
                    child: ImageCached(widget.snapshot['profileImage']),
                  ),
                ),
                title: Text(
                  widget.snapshot['username'],
                  style: TextStyle(fontSize: 13),
                ),
                subtitle: Text(
                  formatDate(widget.snapshot['time'].toDate(),
                      [dd, '-', mm, '-', yyyy]),
                  style: TextStyle(fontSize: 9),
                ),
                trailing: const Icon(Icons.more_horiz),
              ),
            ),
          ),
          SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Row(
              children: [
                Text(widget.snapshot['caption'],
                    style: TextStyle(fontSize: 13), textAlign: TextAlign.start),
              ],
            ),
          ),
          SizedBox(height: 10),
          Stack(
            alignment: Alignment.center,
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    color: Colors.grey,
                    width: 369,
                    height: 656,
                    child: VideoPlayer(controller),
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
                top: 585.h,
                left: 25,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    SizedBox(width: 0),
                    Text(
                      widget.snapshot['like'].length.toString(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {
                        showBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
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
                    SizedBox(width: 8),
                    Text(
                      '0',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                        height: 30,
                        width: 30,
                        child: Image.asset('images/send-white.png')),
                    SizedBox(width: 8),
                    Text(
                      '0',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 15,),
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Image.asset('images/repeat-white.png'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
