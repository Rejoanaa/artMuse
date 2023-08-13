// ignore_for_file: body_might_complete_normally_catch_error

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_1/models/model.post.dart';
import 'package:logger/logger.dart';

import '../const/keywords.dart';
import '../models/model.user.dart';

Logger logger = Logger();

class MyFirestoreService {
  static Future<bool> mStoreUserCredential(
      {required FirebaseFirestore firebaseFirestore,
      required UserData user}) async {
    try {
      await firebaseFirestore
          .collection(MyKeywords.USER)
          .doc(user.email)
          .set(user.toJson());
      return true;
    } catch (e) {
      logger.e("Error in storing user credential: $e");
      return false;
    }
  }

  static Future<String?> mUploadImageToStorage(
      {required String imgUri,
      required FirebaseStorage firebaseStorage}) async {
    // Reference  storageRef = firebaseStorage.ref().child("art_images");

    File imageFile = File(imgUri);
    String? downloadUrl;

    /*  var snapShot = await firebaseStorage
        .ref()
        .child("images/imageName")
        .putFile(imageFile);
    var downloadUrl = await snapShot.ref.getDownloadURL(); */

    await firebaseStorage
        .ref()
        .child("image/$imgUri")
        .putFile(imageFile)
        .then((TaskSnapshot snapshot) async {
      // downloadUrl = await snapshot.ref.getDownloadURL();
      await snapshot.ref.getDownloadURL().then((value) => downloadUrl = value);
    }).onError((error, stackTrace) {
      logger.e("Error. in image upload: $error");
    });

    return downloadUrl;
  }

  static Future<bool> mUploadPost(
      {required FirebaseFirestore firebaseFirestore,
      required Post post}) async {
    bool isSuccess = false;
    await firebaseFirestore
        .collection(MyKeywords.POST)
        .doc()
        .set(post.toJson())
        .then((value) => {isSuccess = true, logger.w("Done. Post Uploaded.")})
        .onError(
            (error, stackTrace) => {logger.e("Error. Post uploading: $error")});

    return isSuccess;
  }

  static Future<bool?> mStoreLikeData(
      {required FirebaseFirestore firebaseFirestore,
      required String email,
      required String postId}) async {
    bool? isLiked;
    bool isLikedAlready =
        await mCheckLikedAlready(firebaseFirestore, email, postId);
    if (isLikedAlready) {
      // m: Remove doc (email) from LIKER
      await firebaseFirestore
          .collection(MyKeywords.POST)
          .doc(postId)
          .collection(MyKeywords.LIKER)
          .doc(email)
          .delete()
          .then((value) async {
        logger.w("UnLiked by $email");
        // m: Update Num Of Like Of This Post
        await mUpdateNumOfLikes(firebaseFirestore, postId);
        return isLiked = false;
      }).catchError((error) {
        logger.e(error);
      });
    } else {
      // m: Add new doc (email) to LIKER
      await firebaseFirestore
          .collection(MyKeywords.POST)
          .doc(postId)
          .collection(MyKeywords.LIKER)
          .doc(email)
          .set({
        MyKeywords.email: email,
        MyKeywords.ts: DateTime.now().millisecondsSinceEpoch
      }).then((value) async {
        logger.w("Liked by $email");
        // m: Update Num Of Like Of This Post
        await mUpdateNumOfLikes(firebaseFirestore, postId);
        return isLiked = true;
      }).catchError((error, stackTrace) {
        logger.e(error);
      });
    }
    return isLiked;
  }

  static Future<bool> mStoreRatingData({
    required FirebaseFirestore firebaseFirestore,
    required String email,
    required String postId,
    required int ratingValue,
  }) async {
    bool isRated = false;
    // m: Add new doc (email) to RATER
    await firebaseFirestore
        .collection(MyKeywords.POST)
        .doc(postId)
        .collection(MyKeywords.RATER)
        .doc(email)
        .set({
      MyKeywords.email: email,
      MyKeywords.ratingValue: ratingValue,
      MyKeywords.ts: DateTime.now().millisecondsSinceEpoch
    }).then((value) async {
      logger.w("Rated by $email");
      // m: Update Num Of Like Of This Post
      await mUpdateRatings(firebaseFirestore, postId);
      return isRated = true;
    }).catchError((error, stackTrace) {
      logger.e(error);
    });
    return isRated;
  }

  static Future<bool> mStoreCommentData(
      {required FirebaseFirestore firebaseFirestore,
      required String postId,
      required Commenter commenter}) async {
    bool isSuccess = false;
    await firebaseFirestore
        .collection(MyKeywords.POST)
        .doc(postId)
        .collection(MyKeywords.COMMENTER)
        .doc()
        .set(commenter.toJson())
        .then((value) async {
      await mUpdateNumOfComments(firebaseFirestore, postId);
      logger.w("Commented");

      isSuccess = true;
    }).onError((error, stackTrace) {
      logger.e("Error in Commenting: $error");
    });
    return isSuccess;
  }

  static Future<List<Commenter>> mFetchAllComments({
    required FirebaseFirestore firebaseFirestore,
    required String postId,
  }) async {
    List<Commenter> listCommenters = [];

    await firebaseFirestore
        .collection(MyKeywords.POST)
        .doc(postId)
        .collection(MyKeywords.COMMENTER)
        .orderBy(MyKeywords.ts, descending: false)
        // .limit(8)
        .get()
        .then((value) async {
      if (value.size > 0) {
        logger.w("Comment Loaded, size is: ${value.size}");
        for (var element in value.docs) {
          await mFetchUserData(
            firebaseFirestore: firebaseFirestore,
            email: element.get(MyKeywords.email),
          ).then((user) {
            if (user != null) {
              Commenter commenter = Commenter.fromJson(element.data());
              // also invoke user data into commenter object
              commenter.user = user;

              listCommenters.add(commenter);
            }
            return null;
          });
        }
      }
    }).onError((error, stackTrace) {
      logger.e(error);
    });

    return listCommenters;
  }

  static Future<List<Post>> mFetchInitialPost(
      {required FirebaseFirestore firebaseFirestore,
      required String category,
      required UserData userData}) async {
    logger.d("Category to fetch: $category");
    CollectionReference collectionRef =
        firebaseFirestore.collection(MyKeywords.POST);
    int itemsPerpage = 3;
    List<Post> posts = [];

    if (category.contains("all category")) {
      // fetch allorderBy(MyKeywords.ts, descending: true).get()
      await collectionRef
          .orderBy(MyKeywords.ts, descending: true)
          .limit(itemsPerpage)
          .get()
          .then((querySnapshot) async {
        logger.w("Post Loaded");

        for (var element in querySnapshot.docs) {
          // m: Create post object for each postData (element)
          Post? post =
              await mCreateObject(firebaseFirestore, element, userData);
          if (post != null) {
            posts.add(post);
          }
        }
      }).onError((error, stackTrace) {
        logger.e(error);
      });
    } else {
      logger.d("Fetching post by category");
      // fetch by cat
      await collectionRef
          .orderBy(MyKeywords.ts, descending: true)
          .limit(itemsPerpage)
          .where(MyKeywords.category, isEqualTo: mFormatedCategory(category))
          .get()
          .then((querySnapshot) async {
        logger.w("Post Loaded");

        for (var element in querySnapshot.docs) {
          /* 
          await firebaseFirestore
              .collection(MyKeywords.USER)
              .doc(element.get(MyKeywords.email))
              .get()
              .then((value) {
            Users user = Users(username: value.get(MyKeywords.username));
            Post post = Post(
                postId: element.id,
                email: element.get(MyKeywords.email),
                caption: element.get(MyKeywords.caption),
                imgUri: element.get(MyKeywords.img_uri),
                numOfLikes: element.get(MyKeywords.num_of_likes),
                numOfDislikes: element.get(MyKeywords.num_of_dislikes),
                category: element.get(MyKeywords.category),
                ts: element.get(MyKeywords.ts),
                users: user);

            posts.add(post);
          }).onError((error, stackTrace) {
            logger.e(error);
          });
        */
          // m: Create post object for each postData (element)
          Post? post =
              await mCreateObject(firebaseFirestore, element, userData);
          if (post != null) {
            posts.add(post);
          }
        }

        // logger.d("Uploaded post length: ${posts.length}");
      }).onError((error, stackTrace) {
        logger.e(error);
      });
    }

    return posts;
  }

  static Future<List<Post>> mFetchMorePosts(
      {required FirebaseFirestore firebaseFirestore,
      required String category,
      required String lastVisibleDocumentId,
      required UserData userData}) async {
    CollectionReference collectionRef =
        firebaseFirestore.collection(MyKeywords.POST);
    int itemsPerpage = 3;
    List<Post> posts = [];

    DocumentSnapshot<Object?> laslastVisibleDoc =
        await collectionRef.doc(lastVisibleDocumentId).get();

    if (category.contains("All Category")) {
      // fetch All category's data
      logger.d("Last visi id: $lastVisibleDocumentId");
      await collectionRef
          .orderBy(MyKeywords.ts,
              descending:
                  true) // Order the documents by a field, such as timestamp
          .limit(itemsPerpage) // Set the limit to the number of items per page
          .startAfterDocument(laslastVisibleDoc
              // lastVisibleDocument
              ) // Pass the last visible document from the previous page
          .get()
          .then((querySnapshot) async {
        logger.w("Post Loaded");

        for (var element in querySnapshot.docs) {
          // posts.add(Post.fromJson(jsonDecode(element.data().toString())));

          // posts.add(Post.fromJson(jsonDecode(element.data().toString())));
          /* await firebaseFirestore
              .collection(MyKeywords.USER)
              .doc(element.get(MyKeywords.email))
              .get()
              .then((value) {
            Users user = Users(username: value.get(MyKeywords.username));
            Post post = Post(
                postId: element.id,
                email: element.get(MyKeywords.email),
                caption: element.get(MyKeywords.caption),
                imgUri: element.get(MyKeywords.img_uri),
                numOfLikes: element.get(MyKeywords.num_of_likes),
                numOfDislikes: element.get(MyKeywords.num_of_dislikes),
                category: element.get(MyKeywords.category),
                ts: element.get(MyKeywords.ts),
                users: user);

            // logger.d(post.ts);
            posts.add(post);
          }).onError((error, stackTrace) {
            logger.e(error);
          }); */

          // m: Create post object for each postData (element)
          Post? post =
              await mCreateObject(firebaseFirestore, element, userData);
          if (post != null) {
            posts.add(post);
          }
        }
      }).onError((error, stackTrace) {
        logger.e(error);
      });
    } else {
      // fetch specific category's data
      await collectionRef
          .orderBy(MyKeywords.ts, descending: true)
          .limit(itemsPerpage)
          .startAfterDocument(laslastVisibleDoc)
          .where(MyKeywords.category, isEqualTo: mFormatedCategory(category))
          .get()
          .then((querySnapshot) async {
        logger.w("Post Loaded");

        for (var element in querySnapshot.docs) {
          // m: Create post object for each postData (element)
          Post? post =
              await mCreateObject(firebaseFirestore, element, userData);
          if (post != null) {
            posts.add(post);
          }
        }
      }).onError((error, stackTrace) {
        logger.e(error);
      });
    }

    return posts;
  }

  static dynamic mFormatedCategory(String category) {
    switch (category) {
      case "Drawings":
        return MyKeywords.drawing;

      case "Engraving":
        return MyKeywords.engraving;

      case "Iconography":
        return MyKeywords.iconography;

      case "Painting":
        return MyKeywords.painting;

      case "Sculpture":
        return MyKeywords.sculpture;
    }
  }

  static mUpdateNumOfLikes(
      FirebaseFirestore firebaseFirestore, String postId) async {
    firebaseFirestore
        .collection(MyKeywords.POST)
        .doc(postId)
        .collection(MyKeywords.LIKER)
        .get()
        .then((value) async {
      logger.d("Total Likes: ${value.size}");
      firebaseFirestore.collection(MyKeywords.POST).doc(postId).update({
        MyKeywords.num_of_likes: value.size,
      });
    });
  }

  static mUpdateRatings(
      FirebaseFirestore firebaseFirestore, String postId) async {
    firebaseFirestore
        .collection(MyKeywords.POST)
        .doc(postId)
        .collection(MyKeywords.RATER)
        .get()
        .then((value) async {
      logger.d("Total Num of Ratings: ${value.size}");
      num totalRatingValue = 0;
      for (var element in value.docs) {
        totalRatingValue += element.get(MyKeywords.ratingValue);
      }
      num ratings = totalRatingValue / value.size;
      await firebaseFirestore.collection(MyKeywords.POST).doc(postId).update({
        MyKeywords.ratings: ratings,
      });
    });
  }

  static mUpdateNumOfComments(
      FirebaseFirestore firebaseFirestore, String postId) async {
    firebaseFirestore
        .collection(MyKeywords.POST)
        .doc(postId)
        .collection(MyKeywords.COMMENTER)
        .get()
        .then((value) async {
      logger.d("Total Comments: ${value.size}");
      firebaseFirestore.collection(MyKeywords.POST).doc(postId).update({
        MyKeywords.num_of_comments: value.size,
      });
    });
  }

  static Future<bool> mCheckLikedStatus(FirebaseFirestore firebaseFirestore,
      QueryDocumentSnapshot<Object?> element, UserData userData) async {
    bool isLiked = false;

    await firebaseFirestore
        .collection(MyKeywords.POST)
        .doc(element.id)
        .collection(MyKeywords.LIKER)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        if (doc.id.contains(userData.email!)) {
          return isLiked = true;
        }
      }
    }).onError((error, stackTrace) {
      logger.e(error);
      return null;
    });
    return isLiked;
  }

  static Future<bool> mCheckRatedStatus(FirebaseFirestore firebaseFirestore,
      QueryDocumentSnapshot<Object?> element, UserData userData) async {
    bool isRated = false;

    await firebaseFirestore
        .collection(MyKeywords.POST)
        .doc(element.id)
        .collection(MyKeywords.RATER)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        if (doc.id.contains(userData.email!)) {
          return isRated = true;
        }
      }
    }).onError((error, stackTrace) {
      logger.e(error);
      return null;
    });
    return isRated;
  }

  static Future<bool> mRemoveMyPost(
      {required FirebaseFirestore firebaseFirestore,
      required UserData user,
      required String postId}) async {
    bool isSuccess = false;
    CollectionReference collectionRef =
        firebaseFirestore.collection(MyKeywords.POST);

    await collectionRef.doc(postId).delete().then((value) {
      isSuccess = true;
      logger.w("Deleted");
    }).onError((error, stackTrace) {
      logger.e(error);
    });

    return isSuccess;
  }

  static Future<UserData?> mUpdateUserData(
      {required FirebaseFirestore firebaseFirestore,
      required UserData userData}) async {
    UserData? newUser;
    await firebaseFirestore
        .collection(MyKeywords.USER)
        .doc(userData.email)
        .update(userData.toJson())
        .then((value) async {
      await mFetchUserData(
              firebaseFirestore: firebaseFirestore, email: userData.email!)
          .then((value) {
        value != null ? {newUser = value} : null;
      });
    }).onError((error, stackTrace) {
      logger.e(error);
    });

    return newUser;
  }

  static Future<Post?> mCreateObject(FirebaseFirestore firebaseFirestore,
      QueryDocumentSnapshot<Object?> element, UserData userData) async {
    Post? post;

    // m: Check if current user liked this post (element) or not
    bool isLiked =
        await mCheckLikedStatus(firebaseFirestore, element, userData);
    bool isRated =
        await mCheckRatedStatus(firebaseFirestore, element, userData);
    int? ratingValue =
        await mGetRatingValue(firebaseFirestore, element, userData);
    await firebaseFirestore
        .collection(MyKeywords.USER)
        .doc(element.get(MyKeywords.email))
        .get()
        .then((value) async {
      UserData user = UserData(username: value.get(MyKeywords.username));

      logger.w("Ratings: ${element.get(MyKeywords.ratings)}");

      post = Post(
        postId: element.id,
        email: element.get(MyKeywords.email),
        caption: element.get(MyKeywords.caption),
        imgUri: element.get(MyKeywords.img_uri),
        numOfLikes: element.get(MyKeywords.num_of_likes),
        numOfDislikes: element.get(MyKeywords.num_of_dislikes),
        numOfComments: element.get(MyKeywords.num_of_comments),
        category: element.get(MyKeywords.category),
        ts: element.get(MyKeywords.ts),
        users: user,
        ratings: element.get(MyKeywords.ratings),
        ratingValue: ratingValue ?? 0,
        likedStatus: isLiked,
        ratingStatus: isRated,
      );

      // logger.d(post.ts);
    }).onError((error, stackTrace) {
      logger.e("$error , $stackTrace");
    });

    return post;
  }

  static Future<bool> mCheckLikedAlready(
      FirebaseFirestore firebaseFirestore, String email, String postId) async {
    bool isSuccess = false;

    await firebaseFirestore
        .collection(MyKeywords.POST)
        .doc(postId)
        .collection(MyKeywords.LIKER)
        .get()
        .then((values) {
      for (var element in values.docs) {
        if (element.id == email) {
          logger.w("Liker already exist");
          return isSuccess = true;
        }
      }
    });

    return isSuccess;
  }

  static Future<List<Post>> mFetchMyPosts(
      {required FirebaseFirestore firebaseFirestore,
      required String category,
      required UserData user}) async {
    CollectionReference collectionRef =
        firebaseFirestore.collection(MyKeywords.POST);
    int itemsPerpage = 5;
    List<Post> posts = [];

    if (category.contains("all category")) {
      // fetch allorderBy(MyKeywords.ts, descending: true).get()
      await collectionRef
          .orderBy(MyKeywords.ts, descending: true)
          .limit(itemsPerpage)
          .get()
          .then((querySnapshot) async {
        logger.w("Post Loaded");

        for (var element in querySnapshot.docs) {
          // m: Create post object for each postData (element)
          if (element.get(MyKeywords.email) == user.email) {
            logger.d(
                "Post's user email: ${element.get(MyKeywords.email)} \n My email: ${user.email}");
            Post? post = await mCreateObject(firebaseFirestore, element, user);
            if (post != null) {
              posts.add(post);
            }
          }
        }
      }).onError((error, stackTrace) {
        logger.e(error);
      });
    } else {
      logger.d("Fetching post by category");
      // fetch by cat
      await collectionRef
          .orderBy(MyKeywords.ts, descending: true)
          .limit(itemsPerpage)
          .where(MyKeywords.category, isEqualTo: mFormatedCategory(category))
          .get()
          .then((querySnapshot) async {
        logger.w("Post Loaded");

        for (var element in querySnapshot.docs) {
          // m: Create post object for each postData (element)
          Post? post = await mCreateObject(firebaseFirestore, element, user);
          if (post != null) {
            posts.add(post);
          }
        }

        // logger.d("Uploaded post length: ${posts.length}");
      }).onError((error, stackTrace) {
        logger.e(error);
      });
    }

    return posts;
  }

  static Future<UserData?> mFetchUserData({
    required FirebaseFirestore firebaseFirestore,
    required String email,
  }) async {
    UserData? user;

    await firebaseFirestore
        .collection(MyKeywords.USER)
        .doc(email)
        .get()
        .then((value) {
      if (value.exists) {
        user = UserData.fromJson(value.data()!);
      }
    }).onError((error, stackTrace) {
      logger.e(error);
    });

    return user;
  }

  static Future<int?> mGetRatingValue(FirebaseFirestore firebaseFirestore,
      QueryDocumentSnapshot<Object?> element, UserData userData) async {
    int? ratingValue;
    await firebaseFirestore
        .collection(MyKeywords.POST)
        .doc(element.id)
        .collection(MyKeywords.RATER)
        .doc(userData.email)
        .get()
        .then((value) {
      ratingValue = value.get(MyKeywords.ratingValue);
    }).onError((error, stackTrace) {
      return null;
    });

    return ratingValue;
  }

  //c: Valid For Single image selection
  /* static Future<List<ImageDetailsModel>> mFetchAllDiaryDatafromFirestore(
      {required String email}) async {
    final FirebaseFirestore _firebaseFirestoreRef = FirebaseFirestore.instance;
    List<ImageDetailsModel> _listImageDetailModel = [];

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firebaseFirestoreRef
            .collection('USERS')
            .doc(email)
            .collection('DIARY')
            .orderBy("timestamp", descending: true)
            .get();

    for (var element in querySnapshot.docs) {
      _listImageDetailModel.add(ImageDetailsModel.fromJson(element.data()));
      // Logger().d("address: ${element['imgUrl']}");
/*       _listImageDetailModel[i].strgImgUri =
          await FirebaseStorageProvider.mGetImgUrl(element['imgUrl']);
      i++; */

      // Logger().d('Json: ' + jsonDecode(element.data().toString()));
    }

    for (var i = 0; i < _listImageDetailModel.length; i++) {
      _listImageDetailModel[i].strgImgUri =
          await FirebaseStorageProvider.mGetImgUrl(
              _listImageDetailModel[i].imgUrl!);
    }

    Logger().d('out');

    return _listImageDetailModel;
  } */
}
