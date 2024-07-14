import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sketch_app/data/model/usermodel.dart';
import 'package:sketch_app/util/exeption.dart';
import 'package:uuid/uuid.dart';


class FirebaseFirestoreService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> createUser({
    required String email,
    required String username,
    required String bio,
    required String profile,
  }) async {
    await _firebaseFirestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .set({
      'email': email,
      'username': username,
      'bio': bio,
      'profile': profile,
      'followers': [],
      'following': [],
    });
    return true;
  }

  Future<Usermodel> getUser({String? uidd}) async {
    try{
      final user = await _firebaseFirestore.collection('users').doc(uidd ?? _auth.currentUser!.uid).get();
      final snapuser = user.data()!;
      return Usermodel(snapuser['bio'], snapuser['email'], snapuser['followers'], snapuser['following'], snapuser['username'], snapuser['profile']);
    }on FirebaseException catch(e){
      throw exceptions(e.message.toString());
    }
  }

  Future<bool> createPost({
    required String postImage,
    required String caption,
  }) async {
    var uid = Uuid().v4();
    DateTime data = new DateTime.now();
    Usermodel user = await getUser();
    await _firebaseFirestore.collection('posts').doc(uid).set({
      'postImage' : postImage,
      'username' : user.username,
      'profileImage' : user.profile,
      'caption' : caption,
      'uid' : _auth.currentUser!.uid,
      'postId' : uid,
      'like' : [],
      'time' : data
    });
    return true;
  }

  Future<bool> createReels({
    required String video,
    required String caption,
  }) async {
    var uid = Uuid().v4();
    DateTime data = new DateTime.now();
    Usermodel user = await getUser();
    await _firebaseFirestore.collection('reels').doc(uid).set({
      'reelsvideo' : video,
      'username' : user.username,
      'profileImage' : user.profile,
      'caption' : caption,
      'uid' : _auth.currentUser!.uid,
      'postId' : uid,
      'like' : [],
      'time' : data
    });
    return true;
  }

  Future<bool> comments({
    required String comment,
    required String type,
    required String uidd,
  }) async {
    var uid = Uuid().v4();
    Usermodel user = await getUser();
    await _firebaseFirestore.collection(type).doc(uidd).collection('comments').doc(uid).set({
      'comment' : comment,
      'username' : user.username,
      'profileImage' : user.profile,
      'commentUid' : uid

    });
    return true;
  }

  Future<bool> like({
    required List like,
    required String type,
    required String uid,
    required String postId,

  }) async {
    String res = 'some error';
    try {
      if (like.contains(uid)) {
        await _firebaseFirestore.collection(type).doc(postId).update({
          'like': FieldValue.arrayRemove([uid])
        });
      } else {
       await  _firebaseFirestore.collection(type).doc(postId).update({
          'like': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } on Exception catch (e) {
      res = e.toString();
    }
    return res == 'success';
  }

  Future<bool> follow({
    required String uid,
  }) async {
    String res = 'some error';
    DocumentSnapshot snap = await _firebaseFirestore.collection('users').doc(_auth.currentUser!.uid).get();
    List follow = (snap.data()! as dynamic)['following'];
    try {
      if (follow.contains(uid)) {
        await _firebaseFirestore.collection('users').doc(_auth.currentUser!.uid).update({
          'following': FieldValue.arrayRemove([uid])
        });
        await _firebaseFirestore.collection('users').doc(uid).update({
          'followers': FieldValue.arrayRemove([_auth.currentUser!.uid])
        });
      } else {
        await  _firebaseFirestore.collection('users').doc(_auth.currentUser!.uid).update({
          'following': FieldValue.arrayUnion([uid])
        });
        await  _firebaseFirestore.collection('users').doc(uid).update({
          'followers': FieldValue.arrayUnion([_auth.currentUser!.uid])
        });
      }
      res = 'success';
    } on Exception catch (e) {
      res = e.toString();
    }
    return res == 'success';
  }
}
