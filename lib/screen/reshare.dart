import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ReshareScreen extends StatefulWidget {
  const ReshareScreen({super.key});

  @override
  State<ReshareScreen> createState() => _ReshareScreenState();
}



class _ReshareScreenState extends State<ReshareScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final caption = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Yeniden Yayınlama', style: TextStyle(color: Colors.black)),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              onTap: () async {
                /*String post_url = await StorageMethod()
                    .uploadImageToStorage('post', );
                await FirebaseFirestoreService()
                    .createPost(postImage: post_url, caption: caption.text);
                Navigator.of(context).pop();*/
              },
                child: Text(
              'Paylaş',
              style: TextStyle(fontSize: 15, color: Color(0xFF1C869E)),
            )),
          )
        ],
      ),
      /*
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Yeniden Yayınlama', style: TextStyle(color: Colors.black)),)
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    islooding = true;
                  });
                  String post_url = await StorageMethod()
                      .uploadImageToStorage('post', widget._file);
                  await FirebaseFirestoreService()
                      .createPost(postImage: post_url, caption: caption.text);
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Paylaş',
                  style: TextStyle(color: Color(0xFF1C869E), fontSize: 15),
                ),
              ),
            ),
          ),
        ],

      */
      body: Center(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 120,
                width: 375,
                child: TextField(
                  controller: caption,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Bir açıklama yaz',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none
                  ),
                ),
              ),
              Container(
                height: 375,
                width: 375,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
