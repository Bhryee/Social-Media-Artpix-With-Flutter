import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sketch_app/screen/posts_explore.dart';
import 'package:sketch_app/screen/reelsScreen.dart';
import 'package:sketch_app/screen/profile.dart';
import 'package:sketch_app/screen/reels_explore.dart';
import 'package:sketch_app/util/image_cached.dart';
import 'package:video_player/video_player.dart';
import 'package:easy_localization/easy_localization.dart';

class ExplorScreen extends StatefulWidget {
  const ExplorScreen({super.key});

  @override
  State<ExplorScreen> createState() => _ExplorScreenState();
}

class _ExplorScreenState extends State<ExplorScreen> {
  final search = TextEditingController();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  bool show = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SearchBox(),
            if (!show)
              StreamBuilder(
                stream: _firebaseFirestore.collection('posts').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  List<QueryDocumentSnapshot> posts = snapshot.data!.docs;

                  return StreamBuilder(
                    stream: _firebaseFirestore.collection('reels').snapshots(),
                    builder: (context, reelSnapshot) {
                      if (!reelSnapshot.hasData) {
                        return SliverToBoxAdapter(
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      List<QueryDocumentSnapshot> reels =
                          reelSnapshot.data!.docs;

                      List<QueryDocumentSnapshot> combined = [
                        ...posts,
                        ...reels
                      ];

                      return SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            final snap = combined[index];
                            final data = snap.data() as Map<String, dynamic>;
                            bool isDataVideo = isVideo(data); // Video kontrolünü burada yapın

                            return GestureDetector(
                              onTap: () {
                                if (isDataVideo) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ReelExploreScreen(data),
                                    ),
                                  );
                                } else {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => PostScreen(data),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(color: Colors.grey),
                                child: _buildMediaContent(data),
                              ),
                            );
                          },
                          childCount: combined.length,
                        ),
                        gridDelegate: SliverQuiltedGridDelegate(
                          crossAxisCount: 3,
                          mainAxisSpacing: 3,
                          crossAxisSpacing: 3,
                          pattern: [
                            QuiltedGridTile(2, 1),
                            QuiltedGridTile(2, 2),
                            QuiltedGridTile(1, 1),
                            QuiltedGridTile(1, 1),
                            QuiltedGridTile(1, 1),
                          ],
                        ),
                      );

                    },
                  );
                },
              ),
            if (show)
              StreamBuilder(
                stream: _firebaseFirestore
                    .collection('users')
                    .where('username', isGreaterThanOrEqualTo: search.text)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return SliverPadding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final snap = snapshot.data!.docs[index];
                          return Column(
                            children: [
                              SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProfileScreen(Uid: snap.id),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundImage:
                                          NetworkImage(snap['profile'] ?? ''),
                                    ),
                                    SizedBox(width: 15),
                                    Text(snap['username'] ?? 'Unknown')
                                  ],
                                ),
                              )
                            ],
                          );
                        },
                        childCount: snapshot.data!.docs.length,
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  bool isVideo(Map<String, dynamic> data) {
    return data['videoUrl'] != null;
  }

  Widget _buildMediaContent(Map<String, dynamic> data) {
    if (data['postImage'] != null) {
      return ImageCached(data['postImage']);
    } else if (data['url'] != null) {
      return ImageCached(data['url']);
    } else if (data['videoUrl'] != null) {
      return VideoWidget(videoUrl: data['videoUrl']);
    } else {
      return Container(color: Colors.grey, child: Icon(Icons.error));
    }
  }

  SliverToBoxAdapter SearchBox() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSecondary,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.black45),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: search,
                    onChanged: (value) {
                      setState(() {
                        show = value.isNotEmpty;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Kullanıcı Ara'.tr(),
                      hintStyle: TextStyle(color: Colors.black45),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
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

class VideoWidget extends StatefulWidget {
  final String videoUrl;

  const VideoWidget({required this.videoUrl, Key? key}) : super(key: key);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        if (mounted) setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : Center(child: CircularProgressIndicator());
  }
}
