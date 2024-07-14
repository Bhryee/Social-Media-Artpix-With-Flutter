import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sketch_app/data/firebase_servise/firestor.dart';
import 'package:sketch_app/util/image_cached.dart';
import 'package:easy_localization/easy_localization.dart';

class CommentScreen extends StatefulWidget {
  String type;
  String uid;

  CommentScreen(this.type, this.uid, {super.key});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final comment = TextEditingController();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        height: 300,
        child: Stack(
          children: [
            Positioned(
              top: 10,
              left: 150,
              child: Container(
                width: 100,
                height: 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _firebaseFirestore
                  .collection(widget.type)
                  .doc(widget.uid)
                  .collection('comments')
                  .snapshots(),
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }
                      return comment_item(snapshot.data!.docs[index]);
                    },
                    itemCount:
                        snapshot.data == null ? 0 : snapshot.data!.docs.length,
                  ),
                );
              },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 60,
                width: double.infinity,
                color: Theme.of(context).colorScheme.surface,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 45,
                      width: 290,
                      child: TextField(
                        controller: comment,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Yorum ekle'.tr(),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          if (comment.text.isNotEmpty) {
                            FirebaseFirestoreService().comments(
                              comment: comment.text,
                              type: widget.type,
                              uidd: widget.uid,
                            );
                          }
                          setState(() {
                            comment.clear();
                          });
                        },
                        child: const Icon(Icons.send)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget comment_item(final snapshot) {
    return ListTile(
      leading: ClipOval(
        child: SizedBox(
          height: 35,
          width: 35,
          child: ImageCached(
            snapshot['profileImage'],
          ),
        ),
      ),
      title: Text(
        snapshot['username'],
        style: TextStyle(
            fontSize: 13, fontWeight: FontWeight.bold, /*color: Colors.black*/),
      ),
      subtitle: Text(
        snapshot['comment'],
        style: TextStyle(fontSize: 13, /*color: Colors.black*/),
      ),
    );
  }
}
