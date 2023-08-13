// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../const/keywords.dart';
import '../utils/custom_text.dart';

Logger logger = Logger();

class MyAuthenticationService {
  static User? mCheckUserSignInStatus({required FirebaseAuth firebaseAuth}) {
    User? user = firebaseAuth.currentUser;

    if (user != null) {
      // User is already signed in
      // Perform any necessary actions for a signed-in user
      if (mCheckUserVerified(firebaseAuth: firebaseAuth, user: user)) {
        logger.i('User is signed in with the following details:');
        logger.i('User ID: ${user.uid}');
        logger.i('Email: ${user.email}');
        return user;
      } else {
        return null;
      }
    } else {
      // User is not signed in
      // Perform any necessary actions for a non-signed-in user
      logger.w('User is not signed in');
      return null;
    }
  }

  static bool mCheckUserVerified(
      {required FirebaseAuth firebaseAuth, required User user}) {
    // User? user = firebaseAuth.currentUser;
    if (user.emailVerified) {
      logger.i("Email is verified");
      return true;
    } else {
      logger.w("Email is not verified");
      return false;
    }
  }

  static Future<dynamic> mSignIn(
      {required FirebaseAuth firebaseAuth,
      required String email,
      required String password}) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User user = userCredential.user!;

      // Sign-in successful, perform any necessary actions
      logger.d('User ID: ${user.uid}');
      logger.d('Email: ${user.email}');
      return user;
    } catch (e) {
      // Sign-in failed, handle the error
      String error = e.toString();
      logger.e('Sign-in error: $error');
      return error;
    }
  }

  static Future<bool> mCheckUniqueUserName(
      {required FirebaseFirestore firebaseFirestore,
      required String username}) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await firebaseFirestore.collection(MyKeywords.USER).get();
    if (querySnapshot.size > 0) {
      for (var element in querySnapshot.docs) {
        if (element.get(MyKeywords.username) == username) {
          logger.w("User name already exist");
          return false;
        }
      }
      logger.w("User name is Uinque");
      return true;
    } else {
      logger.w("User name is Uinque");
      return true;
    }
  }

  static Future<UserCredential?> mSignUp(
      {required FirebaseAuth firebaseAuth,
      required String email,
      required String password}) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // c: send a verification email here if desired.
      userCredential.user?.sendEmailVerification();

      return userCredential;
    } catch (e) {
      logger.e('Error signing up with email and password: $e');

      return null;
    }
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    const String accountExisted = "account-exists-with-different-credential";
    const String crendentialInvalid = "invalid-credential";

    FirebaseAuth auth = FirebaseAuth.instance;

    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);
        user = userCredential.user;
        // print("Google Sign in: " + user.toString());

        /* Navigator.of(context).pushReplacement(PageTransition(
            child: TeamCheckScreen(),
            type: PageTransitionType.rightToLeft,
            duration: Duration(milliseconds: 800))); */
      } on FirebaseAuthException catch (e) {
        if (e.code == accountExisted) {
          //handle the error here
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: CustomText(
            text:
                "The account is already exists with a differrent crendential.",
          )));
        } else if (e.code == crendentialInvalid) {
          //handle the error here
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: CustomText(
            text: "Error occured while accesing credentials. Try again!",
          )));
        }
      } catch (e) {
        //handle the error here
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: CustomText(
                text: "Error occured using Google Sign-In. Try again!")));
      }
    }

    return user;
  }

  static Future<bool> mSignOut({required FirebaseAuth firebaseAuth}) async {
    bool isSignedOut = false;
    await firebaseAuth.signOut().then((value) => isSignedOut = true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();

    return isSignedOut;
  }

/*   static Future<User?> signInWithGoogle() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    User _user;
    GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
   UserCredential authResult =  await _auth.signInWithCredential(credential);
    _user = authResult.user!;
    assert(!_user.isAnonymous);
    assert(await _user.getIdToken() != null);
    User currentUser = _auth.currentUser!;
    assert(_user.uid == currentUser.uid);
    print("User Name: ${_user.displayName}");
    print("User Email ${_user.email}");
  } */
}
