import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/const/keywords.dart';
import 'package:flutter_application_1/controller/my_authentication_service.dart';
import 'package:flutter_application_1/controller/firestore_service.dart';
import 'package:flutter_application_1/models/model.post.dart';
import 'package:flutter_application_1/models/model.user.dart';
import 'package:flutter_application_1/screens/art%20guide/scr.art_guide.dart';
import 'package:flutter_application_1/screens/landing/pages/comments.dart';
import 'package:flutter_application_1/screens/landing/widgets/dlg_rating.dart';
import 'package:flutter_application_1/screens/my_map/scr.map.dart';
import 'package:flutter_application_1/screens/profile/scr_profile.dart';
import 'package:flutter_application_1/screens/signin/scr_signin.dart';
import 'package:flutter_application_1/utils/my_date_format.dart';
import 'package:flutter_application_1/widgets/my_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/my_colors.dart';
import '../../utils/my_screensize.dart';
import 'widgets/bottom_nav.dart';
import 'widgets/my_bottom_sheet.dart';

class LandingScreen extends StatefulWidget {
  final UserData userData;
  const LandingScreen({super.key, required this.userData});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final String _userName = "user_0012001";
  final String _imgCategory = "all category";
  int _pageIndex = 0;
  final Logger logger = Logger();
  late FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  bool _isDataLoading = true;
  bool _isMoreDataLoading = true;
  bool _isNoDataExist = false;
  String _dropDownValue = "All Category";
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  List<Post>? posts;
  late final ScrollController _scrollController = ScrollController();
  late CollectionReference _collectionReferencePOST;
  late CollectionReference _collectionReferenceLIKER;

// >>
  @override
  void initState() {
    super.initState();
    logger.d("I am Init");
    _collectionReferencePOST = firebaseFirestore.collection(MyKeywords.POST);
    _collectionReferenceLIKER = firebaseFirestore
        .collection(MyKeywords.POST)
        .doc()
        .collection(MyKeywords.LIKER);

    mLoadData(); // c: Load latest 10 posts from firebase firestore

    mControlListViewSrolling(); // c: Post listView scroll listener for control pagination

    mAddCollectionReferencePOSTListener();
    mAddCollectionReferenceLIKERListener();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.v("Build: Landing Screen");
    return Scaffold(
        backgroundColor: MyColors.secondColor5,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: MyColors.secondColor,
          elevation: 0,
          actions: const [
            // vActionItems(),
          ],
        ),
        drawer: Drawer(
            width: MyScreenSize.mGetWidth(context, 70), child: vDrawerItems()),
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          // backgroundColor: MyColors.firstColor,
          backgroundColor: MyColors.secondColor,
          onPressed: () {
            mShowBottomSheet();
          },
          child: const Icon(
            Icons.upload,
            color: MyColors.fourthColor,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: HomeBottomNavBar(
          pageIndex: _pageIndex,
          fabLocation: FloatingActionButtonLocation.centerDocked,
          shape: const CircularNotchedRectangle(),
          callback: (int pageIndex) {
            setState(() {
              _pageIndex = pageIndex;
            });
          },
        ),
        body: _pageIndex == 0
            ? vHome()
            : _pageIndex == 1
                ? ProfilePage(
                    userData: widget.userData,
                  )
                : null);
  }

  Widget vActionItems() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _userName,
          style: const TextStyle(color: MyColors.secondColor),
        ),
        const SizedBox(
          width: 12,
        ),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: MyColors.secondColor,
                width: .8,
              )),
          child: const CircleAvatar(
            backgroundImage: AssetImage(
              "assets/images/user.png",
            ),
          ),
        ),
        const SizedBox(
          width: 24,
        )
      ],
    );
  }

  Widget vDrawerItems() {
    return Container(
      color: Colors.white,
      // width: MyScreenSize.mGetWidth(context, 60),
      child: ListView(
        children: [
          vDrawerHeader(),
          ListTile(
            title: const Text(
              "Art Guide Video",
            ),
            leading: const Icon(Icons.play_arrow_rounded),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const ArtGuideScreen();
              }));
            },
          ),
          ListTile(
            title: const Text(
              "Share",
            ),
            leading: const Icon(Icons.share),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text(
              "Map",
            ),
            leading: const Icon(Icons.location_pin),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const MapIFrameScreen();
              }));
            },
          ),
          ListTile(
            title: const Text(
              "Sign out",
            ),
            leading: const Icon(Icons.arrow_back),
            onTap: () {
              mOnClickSignOut();
            },
          ),
        ],
      ),
    );
  }

  Widget vDrawerHeader() {
    return UserAccountsDrawerHeader(
      decoration: const BoxDecoration(color: MyColors.secondColor),
      accountName: Text(
        widget.userData.username == null ? "User" : widget.userData.username!,
      ),
      accountEmail: Text(
        widget.userData.email!,
      ),
      currentAccountPicture: CircleAvatar(
        child: widget.userData.imgUri != null
            ? Image(image: NetworkImage(widget.userData.imgUri!))
            : const Image(image: AssetImage("assets/images/user.png")),
      ),
    );
  }

  mShowBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return MyBottomSheet(callback:
              (String imgUri, String imgCategory, String caption) async {
            Post post = Post(
                email: widget.userData.email,
                caption: caption,
                imgUri: imgUri,
                category: imgCategory,
                ts: DateTime.now().millisecondsSinceEpoch.toString());

            await MyFirestoreService.mUploadPost(
                    firebaseFirestore: firebaseFirestore, post: post)
                .then((value) async {
              if (value) {
                await Future.delayed(const Duration(milliseconds: 3000))
                    .then((value) {
                  // c: dismiss bottomSheet
                  Navigator.pop(context);
                });

                setState(() {
                  _isDataLoading = true;
                });
                await MyFirestoreService.mFetchInitialPost(
                        firebaseFirestore: firebaseFirestore,
                        category: "all category",
                        userData: widget.userData)
                    .then((value) {
                  posts!.clear;
                  setState(() {
                    posts = value;
                    _isDataLoading = false;
                  });
                });
              }
            });
          });
        });
  }

  Widget vPostList() {
    return ListView.builder(
        controller: _scrollController,
        itemCount: posts!.length + 1,
        itemBuilder: ((context, index) {
          return index < posts!.length
              ? index == 0
                  ? Padding(
                      padding: EdgeInsets.only(
                          top: MyScreenSize.mGetHeight(context, 11)),
                      child: vItem(index),
                    )
                  : vItem(index)
              /*   : posts!.length > 1
                  ? MyWidget.vPostPaginationShimmering(context: context)
                  : Container(); */
              : posts!.length > 1 && !_isNoDataExist
                  // ? MyWidget.vPostPaginationShimmering(context: context)
                  ? vLoadMoreButton()
                  : Container();
        }));
  }

  Widget vCategoryDropdown() {
    return Container(
      height: MyScreenSize.mGetHeight(context, 6),
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 8, left: 12, right: 12),
      child: DropdownButtonHideUnderline(
        child: GFDropdown(
          isExpanded: true,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          borderRadius: BorderRadius.circular(5),
          border: const BorderSide(color: Colors.black12, width: 1),
          dropdownButtonColor: Colors.white,
          value: _dropDownValue,
          onChanged: (newValue) async {
            _dropDownValue = newValue!;
            setState(() {
              _isDataLoading = true;
            });
            await MyFirestoreService.mFetchInitialPost(
                    firebaseFirestore: firebaseFirestore,
                    category: _dropDownValue,
                    userData: widget.userData)
                .then((value) {
              posts!.clear;
              setState(() {
                posts = value;
                _isDataLoading = false;
                logger.d("Clicked: $newValue");
              });
            });
          },
          items: [
            'All Category',
            'Drawings',
            'Engraving',
            'Iconography',
            'Painting',
            'Sculpture'
          ]
              .map((value) => DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget vCatAndCap(Post post) {
    return Column(
      children: [
        /* Row(
          children: [
            Container(
              // height: MyScreenSize.mGetHeight(context, 1),
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: MyColors.thirdColor),
              child: Text(
                post.category!,
                style: const TextStyle(color: MyColors.secondColor),
              ),
            ),
          ],
        ), */
        const SizedBox(
          height: 4,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(post.caption!),
          ],
        ),
      ],
    );
  }

  Widget vItem(int index) {
    Post post = posts![index];
    return GFCard(
      // color: MyColors.thirdColor.withOpacity(0.8),
      color: MyColors.secondColor4,
      margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
      elevation: 5,
      boxFit: BoxFit.cover,
      titlePosition: GFPosition.start,
      image: Image.network(
        post.imgUri!,
        fit: BoxFit.cover,
      ),

      showImage: true,
      title: GFListTile(
        margin: const EdgeInsets.only(bottom: 10),
        shadow: const BoxShadow(color: Colors.white),
        // color: Colors.white,
        color: MyColors.secondColor3,

        avatar: const GFAvatar(
          size: 24,
          backgroundImage: AssetImage('assets/images/user.png'),
        ),
        titleText: post.users!.username,
        listItemTextColor: Colors.white,
        // subTitleText: mFormatDateTime(post),
        subTitle: Text(mFormatDateTime(post), style:  TextStyle(color: Colors.white),),
        
      ),
      content: vCatAndCap(post),
      buttonBar: GFButtonBar(
        padding: const EdgeInsets.all(6),
        spacing: 16,
        children: <Widget>[
          vLikeButton(post),
          vCommentButton(post),
          vRatingButton(post),
        ],
      ),
    );
  }

  Widget vLikeButton(Post post) {
    return InkWell(
      onTap: () async {
        mOnClickLikeButton(post);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GFAvatar(
            backgroundColor: post.likeStatus!
                ? Colors.deepOrange
                : Colors.black12 /* GFColors.PRIMARY */,
            size: GFSize.SMALL,
            child: Icon(
              Icons.favorite_outline,
              color: post.likeStatus! ? Colors.white : MyColors.secondColor,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          const Text(
            "Likes",
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(
            height: 4,
          ),
          post.numOfLikes == null
              ? const Text(
                  "0",
                  style: TextStyle(color: Colors.black54),
                )
              : Text(
                  "${post.numOfLikes}",
                  style: const TextStyle(color: Colors.black54),
                )
        ],
      ),
    );
  }

  Widget vCommentButton(Post post) {
    return InkWell(
      onTap: () {
        mOnClickCommentButton(post);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const GFAvatar(
            size: GFSize.SMALL,
            backgroundColor: Colors.black12,
            child: Icon(
              Icons.comment,
              color: MyColors.secondColor,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          const Text(
            "Comments",
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(
            height: 4,
          ),
          post.numOfComments == null
              ? const Text(
                  "0",
                  style: TextStyle(color: Colors.black54),
                )
              : Text(
                  "${post.numOfComments}",
                  style: const TextStyle(color: Colors.black54),
                )
        ],
      ),
    );
  }

  void mOnClickCommentButton(Post post) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CommentsPage(
        post: post,
        userData: widget.userData,
      );
    }));
  }

  Widget vHome() {
    return Stack(children: [
      vHomeBody(),
      vCurvedHeader(),
      vCategoryDropdown(),
    ]);
  }

  void mOnClickSignOut() async {
    await MyAuthenticationService.mSignOut(firebaseAuth: _firebaseAuth)
        .then((value) {
      if (value) {
        logger.w("Sign Out");
        Navigator.pop(context);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return const LoginScreen();
        }));
      }
    });
  }

  void mLoadData() async {
    logger.d("Loading post...");
    MyFirestoreService.mFetchInitialPost(
            userData: widget.userData,
            firebaseFirestore: firebaseFirestore,
            category: _imgCategory)
        .then((value) {
      setState(() {
        posts = value;
        /*  int i = posts!
            .indexWhere((element) => element.postId == "C71CC8DQdedbivs0kbXD");
        logger.d("Index is: $i"); */
        _isDataLoading = false;
      });
    });
  }

  String mFormatDateTime(Post post) {
    int currentDate = DateTime.now().day;
    int uploadedDate =
        DateTime.fromMillisecondsSinceEpoch(int.parse(post.ts!)).day;
/*     MyDateForamt.mFormateDate2(
        DateTime.fromMillisecondsSinceEpoch(int.parse(post.ts!))); */
    const String today = "Today";
    const String yesterday = "Yesterday";

    if (currentDate == uploadedDate) {
      return today;
    } else if (uploadedDate == currentDate - 1) {
      return yesterday;
    } else {
      return MyDateForamt.mFormateDate2(
          DateTime.fromMillisecondsSinceEpoch(int.parse(post.ts!)));
    }
  }

  void mControlListViewSrolling() {
    // c: add a scroll listener to scrollController
    _scrollController.addListener(mScrollListener);
  }

  void mScrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // c: Reached the end of the ListView
      // c: Perform any actions or load more data
      // c: You can trigger pagination or fetch more items here

      logger.w("End of List");
      // mLoadMore();
      mCheckMoreDataAvailability();
    }
  }

  void mLoadMore() async {
    await MyFirestoreService.mFetchMorePosts(
            userData: widget.userData,
            firebaseFirestore: firebaseFirestore,
            category: _dropDownValue,
            lastVisibleDocumentId: posts!.last.postId!)
        .then((value) {
      logger.w(value.length);
      if (value.isNotEmpty) {
        /*     List<Post> tempPosts = posts!;
        posts!.clear(); */
        setState(() {
          posts!.addAll(value);
        });
      } else {
        logger.w("No Data exist");
        setState(() {
          _isNoDataExist = true;
        });
      }
      _isMoreDataLoading = false;
    });
  }

  Future<void> mOnClickLikeButton(Post post) async {
    await MyFirestoreService.mStoreLikeData(
            firebaseFirestore: firebaseFirestore,
            // email: post.email!,
            email: widget.userData.email!,
            postId: post.postId!)
        .then((like) {
      if (like != null) {
        if (like) {
          // c: like
          logger.w("Like");
          posts![posts!.indexOf(post)].likeStatus = true;
        } else {
          // c: unlike
          logger.w("UnLike");
          posts![posts!.indexOf(post)].likeStatus = false;
        }
        // c: refresh
        setState(() {});
      }
    });
  }

  void mAddCollectionReferencePOSTListener() {
    _collectionReferencePOST.snapshots().listen((snapshot) {
      for (var docChange in snapshot.docChanges) {
        //c: Handle each change type
        if (docChange.type == DocumentChangeType.added) {
          logger.w("ADDED new item id: ${docChange.doc.id}");
        } else if (docChange.type == DocumentChangeType.modified) {
          logger.w("MODIFIED Post at ${docChange.doc.id}");
          var modifiedDocId = docChange.doc.id;
          int i =
              posts!.indexWhere((element) => element.postId == modifiedDocId);
          mUpdatePostData(docChange.doc, i);
          setState(() {});
          // logger.d("Index is: $i");
        }
      }
    });
  }

  void mAddCollectionReferenceLIKERListener() {
    _collectionReferenceLIKER.snapshots().listen((snapshot) {
      for (var docChange in snapshot.docChanges) {
        //c: Handle each change type
        if (docChange.type == DocumentChangeType.added) {
          logger.w("ADDED one item ${docChange.newIndex}");
        } else if (docChange.type == DocumentChangeType.modified) {
          setState(() {
            logger
                .w("MODIFIED one item ${docChange.doc.get(MyKeywords.email)}");
          });
        } else if (docChange.type == DocumentChangeType.removed) {
          setState(() {
            logger
                .w("REMOVED one item: ${docChange.doc.get(MyKeywords.email)}");
          });
        }
      }
    });
  }

  void mUpdatePostData(DocumentSnapshot<Object?> doc, int i) {
    posts![i].numOfLikes = doc.get(MyKeywords.num_of_likes);
    posts![i].numOfComments = doc.get(MyKeywords.num_of_comments);
    posts![i].ratings = doc.get(MyKeywords.ratings);
  }

  Widget vNoResultFound() {
    return SizedBox(
      height: MyScreenSize.mGetHeight(context, 100),
      child: const Center(
        child: Text(
          "No result found.",
          style: TextStyle(
              color: Colors.black45, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  vCurvedHeader() {
    return SizedBox(
      height: MyScreenSize.mGetHeight(context, 10),
      child: CustomPaint(
        painter: HeaderCurvedContainerForHome(),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
      ),
    );
  }

  vHomeBody() {
    return _isDataLoading
        ? vPostShimmering()
        : posts == null || posts!.isEmpty
            ? vNoResultFound()
            : vPostList();
  }

  vPostShimmering() {
    return Padding(
        padding: EdgeInsets.only(top: MyScreenSize.mGetHeight(context, 11)),
        child: MyWidget.vPostShimmering(context: context));
  }

  vRatingButton(Post post) {
    return InkWell(
      onTap: () async {
        mShowRatingDialog(post);
        // mOnClickRatingButton(post);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GFAvatar(
            backgroundColor: post.ratingStatus!
                // backgroundColor: post.likeStatus!
                ? MyColors.thirdColor
                : Colors.black12 /* GFColors.PRIMARY */,
                // : MyColors.secondColor5 /* GFColors.PRIMARY */,
            size: GFSize.SMALL,
            child: Icon(
              Icons.star_border,
              color: post.ratingStatus! ? Colors.white : MyColors.secondColor,
              // color: post.likeStatus! ? Colors.white : MyColors.secondColor,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          const Text(
            "Ratings",
            style: TextStyle(color: Color(0x89000000)),
            // style: TextStyle(color: MyColors.secondColor5),
          ),
          const SizedBox(
            height: 4,
          ),
          post.ratings == null
              // post.numOfLikes == null
              ? const Text(
                  "0",
                  style: TextStyle(color: Colors.black54),
                )
              : Text(
                  "${post.ratings}",
                  // "${post.numOfLikes}",
                  style: const TextStyle(color: Colors.black54),
                )
        ],
      ),
    );
  }

  /*  Future<void> mOnClickRatingButton(Post post) async {
    await MyFirestoreService.mStoreRatingData(
            firebaseFirestore: firebaseFirestore,
            email: post.email!,
            postId: post.postId!
            ratingValue:  )
        .then((rate) {
      if (rate != null) {
        if (rate) {
          // c: like
          logger.w("Rate");
          posts![posts!.indexOf(post)].ratingStatus = true;
        } else {
          // c: unlike
          logger.w("unRate");
          posts![posts!.indexOf(post)].ratingStatus = false;
        }
        // c: refresh
        setState(() {});
      }
    });
  } */

  void mShowRatingDialog(Post post) {
    showDialog(
        context: context,
        builder: (context) {
          return RatingDialog(
            ratingValue: post.ratingValue ?? 0,
            callback: (int ratingValue) {
              logger.w("Rating value input: ${ratingValue.runtimeType}");
              if (ratingValue > 0) {
                // calculate rate and store
                mStoreandUpdateRating(post, ratingValue);
              }
            },
          );
        });

    /* 
    AwesomeDialog(
        context: context,
        dialogType: DialogType.noHeader,
        body: Column(
          children: [
            Text(
              "Do you want to rate this?",
              style: TextStyle(color: MyColors.secondColor, fontSize: 18),
            ),
            SizedBox(
              height: 24,
            ),
            Row(
              children: [
                Expanded(
                    child: InkWell(
                  onTap: () {
                    setState(() {
                      _currentRate = 1;
                    });
                  },
                  child: Icon(
                    Icons.star,
                    color:
                        _currentRate < 1 ? Colors.black26 : MyColors.thirdColor,
                  ),
                )),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    setState(() {
                      _currentRate = 2;
                    });
                  },
                  child: Icon(
                    Icons.star,
                    color:
                        _currentRate < 2 ? Colors.black26 : MyColors.thirdColor,
                  ),
                )),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    setState(() {
                      _currentRate = 3;
                    });
                  },
                  child: Icon(
                    Icons.star,
                    color:
                        _currentRate < 3 ? Colors.black26 : MyColors.thirdColor,
                  ),
                )),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    setState(() {
                      _currentRate = 4;
                    });
                  },
                  child: Icon(
                    Icons.star,
                    color:
                        _currentRate < 4 ? Colors.black26 : MyColors.thirdColor,
                  ),
                )),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    setState(() {
                      _currentRate = 5;
                    });
                  },
                  child: Icon(
                    Icons.star,
                    color:
                        _currentRate < 5 ? Colors.black26 : MyColors.thirdColor,
                  ),
                )),
              
              ],
            ),
            SizedBox(
              height: 16,
            ),
          ],
        ),
        btnOk: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
              fixedSize: Size(0, MyScreenSize.mGetHeight(context, 2))),
          child: Text("Ok"),
        )).show();
   */
  }

  void mStoreandUpdateRating(Post post, int ratingValue) async {
    await MyFirestoreService.mStoreRatingData(
            firebaseFirestore: firebaseFirestore,
            email: widget.userData.email!,
            postId: post.postId!,
            ratingValue: ratingValue)
        .then((rated) {
      if (rated) {
        // c: like
        logger.w("rated");
        posts![posts!.indexOf(post)].ratingStatus = true;
      }
      // c: refresh
      setState(() {});
    });
  }

  vLoadMoreButton() {
    return InkWell(
        splashColor: Colors.white,
        onTap: () {
          /* setState(() {
            _isMoreDataLoading = true;
          }); */
          /* ToastCard(
            Text("Loading..."),
            Duration(milliseconds: 100),
          ); */
          // Toast.show("Toast plugin app", duration: Toast.lengthShort, gravity:  Toast.bottom);
          Fluttertoast.showToast(
              msg: "Loading...",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black87,
              textColor: Colors.white,
              fontSize: 14.0);

          mLoadMore();
        },
        child: Padding(
            padding:
                const EdgeInsets.only(bottom: 20, top: 8, left: 8, right: 8),
            child: MyWidget.vLoadMoreButton()
            // child: MoreLoaderWidget(isMoreLoading: _isMoreDataLoading),
            ));
  }

  void mCheckMoreDataAvailability() async {
    await MyFirestoreService.mFetchMorePosts(
            userData: widget.userData,
            firebaseFirestore: firebaseFirestore,
            category: _dropDownValue,
            lastVisibleDocumentId: posts!.last.postId!)
        .then((value) {
      logger.w(value.length);
      if (value.isEmpty) {
        logger.w("No Data exist");
        /*  ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("No Data exist"))); */
        setState(() {
          _isNoDataExist = true;
        });
      }
    });
  }
}
