import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sketch_app/data/firebase_servise/storage.dart';

import '../data/firebase_servise/firestor.dart';
import 'package:easy_localization/easy_localization.dart';

class AddPostTextScreen extends StatefulWidget {
  File _file;
  AddPostTextScreen(this._file, {super.key});

  @override
  State<AddPostTextScreen> createState() => _AddPostTextScreenState();
}

class _AddPostTextScreenState extends State<AddPostTextScreen> {
  final caption = TextEditingController();
  bool islooding = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    islooding = true;
                  });
                  String post_url = await StorageMethod()
                      .uploadImageToStorage('post', widget._file);
                  await FirebaseFirestoreService()
                      .createPost(postImage: post_url, caption: caption.text);
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
        child: islooding
            ? Center(
                child: CircularProgressIndicator(color: Colors.black),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      child: Row(
                        children: [
                          Container(
                            width: 65,
                            height: 65,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                image: DecorationImage(
                                    image: FileImage(widget._file),
                                    fit: BoxFit.cover)),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          SizedBox(
                            width: 280,
                            height: 60,
                            child: TextField(
                              controller: caption,
                              maxLines: null,
                              decoration: InputDecoration(
                                hintText: 'Bir açıklama yaz ...'.tr(),
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
