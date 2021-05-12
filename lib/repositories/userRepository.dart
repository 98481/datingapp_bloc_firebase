import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  User user;
  final FirebaseFirestore _firestore;

  UserRepository({FirebaseAuth firebaseAuth, FirebaseFirestore firestore})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> signInWithEmail(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }
  Future<bool> isFirstTime(String userId) async {
    bool exist;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((user) {
      exist = user.exists;
    });

    return exist;
  }



  Future<void> signUpWithEmail(String email, String password) async {
    print(_firebaseAuth);
    return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  Future<bool> isSignedIn() async {
    //final currentUser = FirebaseAuth.instance.currentUser;
    return (await FirebaseAuth.instance.currentUser?.uid != null);
  }

  Future<String> getUser() async {

    String uid=await FirebaseAuth.instance.currentUser.uid.toString();
    return uid;
  }

  //profile setup
  Future<void> profileSetup(
      File photo,
      String userId,
      String name,
      String gender,
      String interestedIn,
      DateTime age,
      GeoPoint location) async {

    CollectionReference imgRef;

    //StorageReference storageUploadTask;
    //firebase_storage.TaskSnapshot  ref =await firebase_storage.FirebaseStorage.instance
     //   .ref()
      //  .child('userPhotos')
     //   .child(userId)
     //   .child(userId)
      //  .putFile(photo);
    firebase_storage.Reference  ref=await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('userPhotos')
        .child(userId)
        .child(userId);


    return await ref.putFile(photo).whenComplete(() async {
      await ref.getDownloadURL().then((url) async {
        await _firestore.collection('users').doc(userId).set({
          'uid': userId,
          'photoUrl': url,
          'name': name,
          "location": location,
          'gender': gender,
          'interestedIn': interestedIn,
          'age': age
        });

      });
    });
    //return await ref.putFile(photo).whenComplete(() async {
      //await ref.getDownloadURL().then((url) async {
        //await _firestore.collection('users').doc(userId).set({
          ////'uid': userId,
         // 'photoUrl': url,
         ///// 'name': name,
         /// "location": location,
          ///'gender': gender,
         /// 'interestedIn': interestedIn,
         /// 'age': age
       /// });
     /// });
    //});
  }
}