import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:one_person_twitter/features/tweet/tweet_page.dart';

class AuthPageController extends GetxController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  RxBool isBusy = false.obs;

  String password;

  String email;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
  }

  signinWithGoogle() async {
    isBusy.value = true;
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      isBusy.value = false;
      return;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final googleAuthCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    var userCredential =
        await _firebaseAuth.signInWithCredential(googleAuthCredential);
    isBusy.value = false;
    Get.put(userCredential);

    print(userCredential.user.email);

    _navigateToTweetPage();
  }

  emailSignIn() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      isBusy.value = true;
      try {
        await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        _navigateToTweetPage();
      } on FirebaseException catch (e) {
        if (e.code == 'user-not-found') {
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password);
          _navigateToTweetPage();
          isBusy.value = false;
          return;
        } else
          Get.snackbar('Auth failure', e.message);
      } on Exception catch (e) {
        Get.snackbar('Auth failure', e.toString());
      }
      isBusy.value = false;
    }
  }

  void _navigateToTweetPage() {
    Get.off(() => TweetPage());
  }
}
