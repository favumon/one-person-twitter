import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:one_person_twitter/features/auth/auth_page.dart';
import 'package:one_person_twitter/features/tweet/tweet_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Twitter app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
          FirebaseAuth.instance.currentUser == null ? AuthPage() : TweetPage(),
    );
  }
}
