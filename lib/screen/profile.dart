import 'package:flutter/material.dart';
import 'package:sketch_app/data/firebase_servise/firestor.dart';
import 'package:sketch_app/data/model/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sketch_app/screen/posts_explore.dart';
import 'package:sketch_app/screen/settings.dart';
import 'package:sketch_app/util/image_cached.dart';
import 'package:sketch_app/widgets/post_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sketch_app/theme/theme.dart';

class ProfileScreen extends StatefulWidget {
  String Uid;

  ProfileScreen({super.key, required this.Uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int post_lenght = 0;
  bool yours = false;
  List following = [];
  bool follow = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    if (widget.Uid == _auth.currentUser!.uid) {
      setState(() {
        yours = true;
      });
    }
  }

  getdata() async {
    DocumentSnapshot snap = await _firebaseFirestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get();
    following = (snap.data()! as dynamic)['following'];
    if (following.contains(widget.Uid)) {
      setState(() {
        follow = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Color(0xFF171717)
      // Theme.of(context).colorScheme.onSecondary
      // Theme.of(context).scaffoldBackgroundColor
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xffFAFAFA),
            // AppBar arkaplan rengi burada tanımlanıyor
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 0), // yatay ve dikey kayma
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 0,
            title: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SettingScreen(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Icon(
                    Icons.settings,
                    size: 35,
                    color: Color(0xFF1C869E),
                  ),
                )),
            centerTitle: false,
          ),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: FutureBuilder(
                future: FirebaseFirestoreService().getUser(uidd: widget.Uid),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Profile(snapshot.data!);
                },
              ),
            ),
            StreamBuilder(
              stream: _firebaseFirestore
                  .collection('posts')
                  .where(
                    'uid',
                    isEqualTo: widget.Uid,
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SliverToBoxAdapter(
                      child: const Center(child: CircularProgressIndicator()));
                }
                var snapLength = snapshot.data!.docs.length;
                return SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      var snap = snapshot.data!.docs[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PostScreen(snap.data()),
                          ));
                        },
                        //key: ValueKey(snap.id),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: ImageCached(snap['postImage'])),
                      );
                    },
                    childCount: snapLength,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget Profile(Usermodel user) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50, bottom: 10),
            child: ClipOval(
              child: SizedBox(
                width: 120,
                height: 120,
                child: ImageCached(user.profile),
              ),
            ),
          ),
          Column(
            children: [
              Text(
                user.username,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                user.bio,
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        post_lenght.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(
                        'Gönderi'.tr(),
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        user.followers.length.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(
                        'Takipçi'.tr(),
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        user.following.length.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(
                        'Takip'.tr(),
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Visibility(
            visible: !follow,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: GestureDetector(
                onTap: () {
                  if (!yours) {
                    FirebaseFirestoreService().follow(uid: widget.Uid);
                    setState(() {
                      follow = true;
                    });
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: yours ? Color(0xFF6CC9D3) : Color(0xFF6CC9D3),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          color:
                              yours ? Color(0xFF6CC9D3) : Color(0xFF6CC9D3))),
                  height: 40,
                  width: 180,
                  child: yours
                      ? Text(
                          'Profili Düzenle'.tr(),
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        )
                      : Text(
                          'Takip Et'.tr(),
                          style: TextStyle(fontSize: 15),
                        ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: follow,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: GestureDetector(
                onTap: () {
                  if (!yours) {
                    FirebaseFirestoreService().follow(uid: widget.Uid);
                    setState(() {
                      follow = false;
                    });
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: yours ? Color(0xFF6CC9D3) : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          color:
                              yours ? Color(0xFF6CC9D3) : Color(0xFF6CC9D3))),
                  height: 40,
                  width: 180,
                  child: yours
                      ? Text(
                          'Profili Düzenle'.tr(),
                          style: TextStyle(fontSize: 15),
                        )
                      : Text(
                          'Takibi Bırak'.tr(),
                          style: TextStyle(fontSize: 15),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
