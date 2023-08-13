// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/firestore_service.dart';
import 'package:flutter_application_1/models/model.user.dart';
import 'package:flutter_application_1/screens/landing/scr.landing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../const/keywords.dart';
import '../../controller/my_authentication_service.dart';
import '../../utils/my_colors.dart';
import '../../utils/my_screensize.dart';
import '../signin/scr_signin.dart';

class LauncherScreen extends StatefulWidget {
  const LauncherScreen({super.key});

  @override
  State<LauncherScreen> createState() => _LauncherScreenState();
}

class _LauncherScreenState extends State<LauncherScreen> {
  late FirebaseAuth firebaseAuth;

  // 1st call 
  @override
  void initState() {
    super.initState();
    // SystemChrome.setSystemUIOverlayStyle(style)
    firebaseAuth = FirebaseAuth.instance;

    mCheckUserLoggedInStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: MyScreenSize.mGetHeight(context, 100),
            width: MyScreenSize.mGetWidth(context, 100),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.1, 0.4, 0.7, 0.9],
                colors: [
                  Colors.white.withOpacity(0.8),
                  Colors.white,
                  Colors.white,
                  Colors.white
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "ArtMuse",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: MyColors.secondColor),
                ),
                SizedBox(
                  height: 24,
                ),
                Image(image: AssetImage("assets/animations/launcher2.gif")),
              ],
            )
            ));
  }

  void mGoForward(User user, UserData userData) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return LandingScreen(
        userData: userData,
      );
    }));
  }

  void mGoSignIn() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return const LoginScreen();
    }));
  }

  void mCheckUserLoggedInStatus() async {
    // e: new
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(milliseconds: 3000))
        .then((value) async {
      if (sharedPreferences.getBool(MyKeywords.sessionStatus) != null &&
          sharedPreferences.getBool(MyKeywords.sessionStatus)!) {
        User? user = MyAuthenticationService.mCheckUserSignInStatus(
            firebaseAuth: firebaseAuth);

        if (user != null) {
          await MyFirestoreService.mFetchUserData(
                  firebaseFirestore: FirebaseFirestore.instance,
                  email: user.email!)
              .then((value) {
            if (value != null) {
              mGoForward(user, value);
            }
          });
        } else {
          mGoSignIn();
        }
      } else {
        mGoSignIn();
      }
    });
  }
}
