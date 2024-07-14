import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sketch_app/data/firebase_servise/firestor.dart';
import 'package:sketch_app/screen/reshare.dart';
import 'package:sketch_app/util/comment.dart';
import 'package:sketch_app/util/image_cached.dart';
import 'package:sketch_app/widgets/like.dart';
import 'package:video_player/video_player.dart';

class PostWidget extends StatefulWidget {
  final snapshot;


  PostWidget(this.snapshot, {super.key});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool isAnimating = false;
  String user = '';
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  VideoPlayerController? _controller;


  @override
  void initState() {
    super.initState();
    user = _firebaseAuth.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface ,
      child: Column(
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
                  formatDate(
                      widget.snapshot['time'].toDate(), [dd, '-', mm, '-', yyyy]),
                  style: TextStyle(fontSize: 11),
                ),
                trailing: const Icon(Icons.more_horiz),
              ),
            ),
          ),
          SizedBox(height: 20),

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

          GestureDetector(
            onDoubleTap: () {
              FirebaseFirestoreService().like(
                  like: widget.snapshot['like'],
                  type: 'posts',
                  uid: user,
                  postId: widget.snapshot['postId']);
              setState(() {
                isAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 375,
                  height: 375,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: ImageCached(widget.snapshot['postImage'])),

                ),


                AnimatedOpacity(
                  duration: Duration(milliseconds: 200),
                  opacity: isAnimating ? 1 : 0,
                  child: LikeAnimation(
                      child: Icon(
                        Icons.favorite,
                        size: 100,
                        color: Colors.white,
                      ),
                      duration: Duration(milliseconds: 400),
                      iconlike: false,
                      isAnimating: isAnimating,
                      End: () {
                        setState(() {
                          isAnimating = false;
                        });
                      }),
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              children: [
                SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(width: 10),
                    LikeAnimation(
                      child: IconButton(
                        onPressed: () {
                          FirebaseFirestoreService().like(
                              like: widget.snapshot['like'],
                              type: 'posts',
                              uid: user,
                              postId: widget.snapshot['postId']);
                        },
                        icon: Icon(
                          widget.snapshot['like'].contains(user)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: widget.snapshot['like'].contains(user)
                              ? Colors.red
                              : Colors.black,
                          size: 25,
                        ),
                      ),
                      isAnimating: widget.snapshot['like'].contains(user),
                    ),
                    Text(
                      widget.snapshot['like'].length.toString(),
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
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
                                bottom: MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: DraggableScrollableSheet(
                                maxChildSize: 0.6,
                                initialChildSize: 0.6,
                                minChildSize: 0.2,
                                builder: (context, scrollController) {
                                  return CommentScreen(
                                      widget.snapshot['postId'], 'posts');
                                },
                              ),
                            );
                          },
                        );
                      },
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: Image.asset('images/comment.png'),
                      ),
                    ),
                    SizedBox(width: 15),
                    SizedBox(
                      width: 25,
                      height: 25,
                      child: Image.asset('images/send.png'),
                    ),
                    SizedBox(width: 17),
                    GestureDetector(
                      onTap:  () { Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ReshareScreen(),),);
                      },
                      child: SizedBox(
                        width: 19,
                        height: 19,
                        child: Image.asset('images/repeat.png'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

