
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/my_services.dart';
import 'package:flutter_application_1/models/model.user.dart';
import 'package:flutter_application_1/screens/edit%20profile/scr.edit_profile.dart';
import 'package:flutter_application_1/screens/my%20posts/scr.my_posts.dart';
import 'package:flutter_application_1/utils/my_screensize.dart';
import 'package:getwidget/getwidget.dart';
import 'package:logger/logger.dart';

import '../../const/keywords.dart';
import '../../controller/firestore_service.dart';
import '../../models/model.post.dart';
import '../../utils/my_colors.dart';
import '../../utils/my_date_format.dart';
import '../../widgets/my_widget.dart';
import '../landing/pages/comments.dart';

class ProfilePage extends StatefulWidget {
  final UserData userData;
  const ProfilePage({super.key, required this.userData});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var _isUserDataExpanded = true;
  Logger logger = Logger();

  List<Post>? posts;
  late FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    logger.w("Call Profile");


/*     mLoadData(); // c: Load latest 10 posts from firebase firestore

    mControlListViewSrolling(); // c: Post listView scroll listener for control pagination

    mAddCollectionReferencePOSTListener();
    mAddCollectionReferenceLIKERListener(); */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: MyColors.thirdColor.withOpacity(0.5),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Container(height: MyScreenSize.mGetHeight(context, 100), width: MyScreenSize.mGetWidth(context, 100), color: Colors.blue,),

          CustomPaint(
            painter: HeaderCurvedContainerForProfile(),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                vProfileImage(
                  MyScreenSize.mGetWidth(context, 32),
                  MyScreenSize.mGetHeight(context, 20),
                ),
                /*  SizedBox(
                  height: 2,
                ), */
                vUserNameAndEmail(),
                const SizedBox(
                  height: 18,
                ),
                vAddPostAndEditProfile(context),
                Visibility(
                    visible: _isUserDataExpanded, child: vUserOtherDetails()),
                const SizedBox(
                  height: 8,
                ),
                const Divider(
                  height: 1,
                  color: Colors.black26,
                ),
                const SizedBox(
                  height: 8,
                ),
                // vShowAllPosts(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget vProfileImage(double height, double width) {
    return Container(
      width: height,
      height: width,
      decoration: BoxDecoration(
        border: Border.all(color: MyColors.fourthColor, width: 5),
        shape: BoxShape.circle,
        color: MyColors.fourthColor,
        image: const DecorationImage(
            fit: BoxFit.contain,
            image: AssetImage('assets/images/profile_pic.jpeg'),
            // image: AssetImage("assets/images/user.png"),
/*             image: NetworkImage(
                "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEg6X-MjDqDlh3z14MA3U9RgogW64BBMHzpZijczfoZNbpxBDj_tqvvWAdzvrqX_KWvs92nF4r-AU-i4AXW0pch8AAbgnrawaLjMCTKgdkF1jhtnXsrQ-A5pNXKXPyGWR69YHm5Hr9CQxMdMvFnCyM4fNZyR9PZa3PuOBbSeFU-LApOxvOx1_J5Vn_rLuQ/w640-h640/images%20(5)%20(11).jpeg")),
 */      
      )));
  }

  vUserNameAndEmail() {
    return Container(
      padding: const EdgeInsets.only(left: 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.userData.username!,
            style: const TextStyle(
                color: MyColors.secondColor,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 6,
          ),
          Row(
            children: [
              /*  Icon(Icons.email_outlined, color: Colors.black45,),
              SizedBox(
                width: 8,
              ), */
              Text(
                widget.userData.email!,
                style: const TextStyle(
                  fontSize: 14,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  vAddPostAndEditProfile(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ElevatedButton(
              onPressed: () {
                // show post
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return MyPostScreen(userData: widget.userData);
                }));
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.secondColor,
                  fixedSize: Size(0, MyScreenSize.mGetHeight(context, 3.5))),
              child: const Row(
                children: [
                  Icon(
                    Icons.newspaper_outlined,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text("My Posts")
                ],
              )),
        ),
        const SizedBox(
          width: 14,
        ),
        Expanded(
          flex: 2,
          child: ElevatedButton(
              onPressed: () {
                // add post
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return EditProfilePage(userData: widget.userData);
                }));
              },
              style: ElevatedButton.styleFrom(
                  // backgroundColor: MyColors.firstColor,
                  backgroundColor: MyColors.secondColor,
                  fixedSize: Size(0, MyScreenSize.mGetHeight(context, 3.5))),
              child: const Row(
                children: [
                  Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text("Edit Profile")
                ],
              )),
        ),
        /*  PopupMenuButton(itemBuilder: (context) {
          return [];
        }) */
        Expanded(
            child: InkWell(
                onTap: () {
                  setState(() {
                    _isUserDataExpanded = !_isUserDataExpanded;
                  });
                },
                child: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black45,
                  size: 32,
                )))
      ],
    );
  }

  // Widget
  vUserOtherDetails() {
    return Row(
      children: [
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16,
            ),
            vUserDob(),
            const SizedBox(
              height: 8,
            ),
            vUserAddress(),
            const SizedBox(
              height: 8,
            ),
            vUserContact(),
          ],
        ))
      ],
    );
  }

  vUserDob() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.centerLeft,
            child: const Icon(
              Icons.calendar_month,
              color: Colors.black26,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
              alignment: Alignment.centerLeft, child: const Text("Date of birth")),
        ),
        Expanded(
            child:
                Container(alignment: Alignment.centerLeft, child: const Text(":"))),
        Expanded(
          flex: 6,
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.userData.dob ?? "29 January, 1998",
              style: const TextStyle(color: MyColors.secondColor),
            ),
          ),
        )
      ],
    );
  }

  vUserAddress() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.centerLeft,
            child: const Icon(
              Icons.location_pin,
              color: Colors.black26,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
              alignment: Alignment.centerLeft, child: const Text("Location")),
        ),
        Expanded(
            child:
                Container(alignment: Alignment.centerLeft, child: const Text(":"))),
        Expanded(
          flex: 6,
          child: Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              "Bohoddarhat, Chittagong",
              style: TextStyle(color: MyColors.secondColor),
            ),
          ),
        )
      ],
    );
  }

  vUserContact() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.centerLeft,
            child: const Icon(
              Icons.phone,
              color: Colors.black26,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
              alignment: Alignment.centerLeft, child: const Text("Contact No")),
        ),
        Expanded(
            child:
                Container(alignment: Alignment.centerLeft, child: const Text(":"))),
        Expanded(
          flex: 6,
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "+88${widget.userData.phone!}",
              style: const TextStyle(color: MyColors.secondColor),
            ),
          ),
        )
      ],
    );
  }

/*   vShowAllPosts() {


    return _isDataLoading
        ? vPostShimmering()
        : posts == null || posts!.isEmpty
            ? vNoResultFound()
            : vPostList();
  
    
    
    
   
  }
  Widget vNoResultFound() {
    return SizedBox(
      height: MyScreenSize.mGetHeight(context, 100),
      child: Center(
        child: Text(
          "No result found.",
          style: TextStyle(
              color: Colors.black45, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
    vPostShimmering() {
   return Padding(
        padding: EdgeInsets.only(top: MyScreenSize.mGetHeight(context, 11)),
        child: MyWidget.vPostShimmering(context: context));
  }
  vPostList(){
    return  ListView.builder(
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
              : MyWidget.vPostPaginationShimmering(context: context);
        }));
  }

  Widget vItem(int index) {
    Post post = posts![index];
    return GFCard(
      // color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      elevation: 5,
      boxFit: BoxFit.cover,
      titlePosition: GFPosition.start,
      image: Image.network(
        post.imgUri!,
        fit: BoxFit.cover,
      ),

      showImage: true,
      title: GFListTile(
        margin: EdgeInsets.only(bottom: 6),
        shadow: BoxShadow(color: Colors.white),
        color: Colors.white,
        avatar: GFAvatar(
          size: 24,
          backgroundImage: AssetImage('assets/images/user.png'),
        ),
        titleText: post.users!.username,
        subTitleText: mFormatDateTime(post),
      ),
      content: vCatAndCap(post),
      buttonBar: GFButtonBar(
        padding: EdgeInsets.all(6),
        spacing: 16,
        children: <Widget>[
          vLikeButton(post),
          vCommentButton(post),
        ],
      ),
    );
  }
  Future<void> mOnClickLikeButton(Post post) async {
    await MyFirestoreService.mStoreLikeData(
            firebaseFirestore: firebaseFirestore,
            email: post.email!,
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
          SizedBox(
            height: 4,
          ),
          Text(
            "Likes",
            style: TextStyle(color: Colors.black54),
          ),
          SizedBox(
            height: 4,
          ),
          post.numOfLikes == null
              ? Text(
                  "0",
                  style: TextStyle(color: Colors.black54),
                )
              : Text(
                  "${post.numOfLikes}",
                  style: TextStyle(color: Colors.black54),
                )
        ],
      ),
    );
  }

  void mOnClickCommentButton(Post post) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CommentsPage(
        post: post,
      );
    }));
  }

  Widget vCommentButton(Post post) {
    return InkWell(
      onTap: () {
        mOnClickCommentButton(post);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GFAvatar(
            size: GFSize.SMALL,
            backgroundColor: Colors.black12,
            child: Icon(
              Icons.comment,
              color: MyColors.secondColor,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            "Comments",
            style: TextStyle(color: Colors.black54),
          ),
          SizedBox(
            height: 4,
          ),
          post.numOfComments == null
              ? Text(
                  "0",
                  style: TextStyle(color: Colors.black54),
                )
              : Text(
                  "${post.numOfComments}",
                  style: TextStyle(color: Colors.black54),
                )
        ],
      ),
    );
  }

  Widget vCatAndCap(Post post) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              // height: MyScreenSize.mGetHeight(context, 1),
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: MyColors.thirdColor),
              child: Text(
                post.category!,
                style: TextStyle(color: MyColors.secondColor),
              ),
            ),
          ],
        ),
        SizedBox(
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
 */
}
