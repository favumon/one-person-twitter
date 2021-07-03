import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_person_twitter/features/auth/auth_page.dart';

class TweetPageController extends GetxController {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  // final User user = FirebaseAuth.instance.currentUser;

  String tweetText;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController tweetTextController = TextEditingController();

  get tweets {
    return _firebaseFirestore
        .collection('tweet')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('tweets')
        .orderBy('post_date', descending: true)
        .snapshots();
  }

  Rx<QueryDocumentSnapshot<Map<String, dynamic>>> editTweet = Rx(null);

  String get getDisplayName =>
      FirebaseAuth.instance.currentUser.displayName ??
      FirebaseAuth.instance.currentUser.email;

  void onCreateOrUpdateTweet() {
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    tweetTextController.clear();
    if (editTweet.value != null) {
      _firebaseFirestore
          .collection('tweet')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection('tweets')
          .doc(editTweet.value.id)
          .update({'tweet_content': tweetText, 'post_date': DateTime.now()});
      editTweet.value = null;
    } else
      _firebaseFirestore
          .collection('tweet')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection('tweets')
          .doc()
          .set({'tweet_content': tweetText, 'post_date': DateTime.now()});
  }

  onDeleteTweet(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    if (doc != null) {
      _firebaseFirestore
          .collection('tweet')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection('tweets')
          .doc(doc.id)
          .delete();
    }
  }

  onEditTweet(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    //editTweetId.value = doc;
    editTweet.value = doc;
    tweetTextController.text = doc.data()['tweet_content'];
  }

  void onCancelTweetUpdate() {
    tweetTextController.clear();
    editTweet.value = null;
  }

  void onSignout() {
    FirebaseAuth.instance.signOut();
    Get.off(() => AuthPage());
  }

  @override
  void onClose() {
    tweetTextController.dispose();
    super.onClose();
  }
}
