import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sketch_app/widgets/post_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
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
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: SizedBox(
              width: 105,
              height: 28,
              child: Image.asset('images/logo.png'),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 20),
                child: SizedBox(
                  child:Image.asset('images/send.png'),
                width: 30,
                height: 30,),
              ),
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          StreamBuilder(
            stream: _firebaseFirestore.collection('posts').orderBy('time', descending: true).snapshots(),
            builder: (context, snapshot) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (!snapshot.hasData){
                      return Center(child: CircularProgressIndicator());
                    }
                    return PostWidget(snapshot.data!.docs[index].data());
                  },
                  childCount: snapshot.data == null ? 0 : snapshot.data!.docs.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}