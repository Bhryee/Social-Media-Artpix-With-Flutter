import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sketch_app/data/firebase_servise/firestor.dart';
import 'package:sketch_app/data/firebase_servise/storage.dart';
import 'package:sketch_app/util/exeption.dart';

class Authentication {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> Login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
    } on FirebaseException catch (e) {
      throw exceptions(e.message.toString());
    }
  }

  Future<void> Signup({
    required String email,
    required String password,
    required String passwordConfirme,
    required String username,
    required String bio,
    required File profile,
  }) async {
    String URL;
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          bio.isNotEmpty) {
        if (password == passwordConfirme) {
          // create user with email and password
          await _auth.createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );
          // upload profile image on storage

          if (profile != File('')) {
            URL =
                await StorageMethod().uploadImageToStorage('Profile', profile);
          } else {
            URL = '';
          }

          // get information with firestor

          await FirebaseFirestoreService().createUser(
            email: email,
            username: username,
            bio: bio,
            profile: URL == ''
                ? 'https://firebasestorage.googleapis.com/v0/b/instagram-8a227.appspot.com/o/person.png?alt=media&token=c6fcbe9d-f502-4aa1-8b4b-ec37339e78ab'
                : URL,
          );
        } else {
          throw exceptions('Şifre ve şifre tekrar aynı olmalıdır.');
        }
      } else {
        throw exceptions('Lütfen tüm alanları doldurun.');
      }
    } on FirebaseException catch (e) {
      throw exceptions(e.message.toString());
    }
  }
}
