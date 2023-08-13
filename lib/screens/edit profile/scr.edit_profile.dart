
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/landing/scr.landing.dart';
import 'package:flutter_application_1/utils/my_date_format.dart';
import 'package:logger/logger.dart';

import '../../../controller/firestore_service.dart';
import '../../../controller/my_authentication_service.dart';
import '../../../models/model.user.dart';
import '../../../utils/my_colors.dart';
import '../../../utils/my_screensize.dart';
import '../../../widgets/my_widget.dart';

enum FormData {
  FullName,
  UserName,
  Phone,
  Email,
  Gender,
  password,
  ConfirmPassword,
  dob,
  address
}

class EditProfilePage extends StatefulWidget {
  final UserData userData;
  const EditProfilePage({super.key, required this.userData});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  // Color enabled = const Color.fromARGB(255, 63, 56, 89);
  Color enabled = MyColors.fourthColor;
  Color enabledtxt = Colors.white;
  Color deaible = MyColors.fourthColor;
  // Color backgroundColor = const Color(0xFF1F1A30);
  Color backgroundColor = MyColors.secondColor;
  bool ispasswordev = true;
  Logger logger = Logger();

  FormData? selected;

  late TextEditingController usernameController;
  late TextEditingController phoneController;

  late TextEditingController dobController;
  late TextEditingController addressController;

  late FirebaseFirestore firebaseFirestore;
  late FirebaseAuth firebaseAuth;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.userData.username);
    phoneController = TextEditingController(text: widget.userData.phone);
    dobController = TextEditingController(text: widget.userData.dob);
    addressController = TextEditingController(
        text: "Jobra, University of Chittagong, Hathazari");

    firebaseFirestore = FirebaseFirestore.instance;
    firebaseAuth = FirebaseAuth.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.secondColor4,
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: MyColors.secondColor,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.1, 0.4, 0.7, 0.9],
            colors: [
              MyColors.secondColor4.withOpacity(0.8),
              MyColors.secondColor4,
              MyColors.secondColor4,
              MyColors.secondColor4
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MyScreenSize.mGetWidth(context, 95),
                  padding: const EdgeInsets.all(35.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /*  _vPersonDummyImage(),
                      const SizedBox(
                        height: 10,
                      ), */
                      /* _vCreateAccountText(),
                      const SizedBox(
                        height: 20,
                      ), */
                      /*  _vFullName(),
                      const SizedBox(
                        height: 20,
                      ), */
                      _vUserName(),
                      const SizedBox(
                        height: 20,
                      ),
                      _vPhone(),
                      const SizedBox(
                        height: 20,
                      ),
                      /*  _vEmail(),
                      const SizedBox(
                        height: 20,
                      ),
                      _vPass(),
                      const SizedBox(
                        height: 20,
                      ),
                      _vConfirmPass(),
                      const SizedBox(
                        height: 20,
                      ), */
                      _vDateOfBirth(),
                      const SizedBox(
                        height: 20,
                      ),
                      _vAddressLocation(),
                      const SizedBox(
                        height: 25,
                      ),
                      _vUpdateButton(),
                    ],
                  ),
                ),
                //End of Center Card

                //Start of outer card
                const SizedBox(
                  height: 20,
                ),
                // _vGotoSignin(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _vDateOfBirth() {
    return Container(
      width: 300,
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: selected == FormData.dob ? enabled : backgroundColor),
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: () {
          mShowDatePicker();
        },
        child: TextField(
          controller: dobController,
          enabled: false,
          decoration: InputDecoration(
              enabledBorder: InputBorder.none,
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.calendar_today,
                color: deaible,
                size: 20,
              ),
              hintText: 'Pick Date of birth',
              hintStyle: TextStyle(color: deaible, fontSize: 12)),
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(
              color: deaible, fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
    );
  }

  Widget _vUpdateButton() {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            isLoading = true;
            mUpdateOperation();
          });
        },
        style: ElevatedButton.styleFrom(
            /* fixedSize: Size(MyScreenSize.mGetWidth(context, 60),
                MyScreenSize.mGetHeight(context, 7)), */
            backgroundColor: MyColors.secondColor,
            // backgroundColor: const Color(0xFF2697FF),
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 24),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0))),
        child: !isLoading
            ? const Text(
                "Update",
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 0.5,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              )
            : MyWidget.vButtonProgressLoader(labelText: "Updating..."));
  }

  Widget _vPhone() {
    return Container(
      width: 300,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: selected == FormData.Phone ? enabled : backgroundColor,
      ),
      padding: const EdgeInsets.all(5.0),
      child: TextField(
        controller: phoneController,
        onTap: () {
          setState(() {
            selected = FormData.Phone;
          });
        },
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.phone_android_rounded,
            color: selected == FormData.Phone ? enabledtxt : deaible,
            size: 20,
          ),
          hintText: 'Phone Number',
          hintStyle: TextStyle(
              color: selected == FormData.Phone ? enabledtxt : deaible,
              fontSize: 12),
        ),
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
            color: selected == FormData.Phone ? enabledtxt : deaible,
            fontWeight: FontWeight.bold,
            fontSize: 12),
      ),
    );
  }

  Widget _vUserName() {
    return Container(
      width: 300,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: selected == FormData.Email ? enabled : backgroundColor,
      ),
      padding: const EdgeInsets.all(5.0),
      child: TextField(
        controller: usernameController,
        onTap: () {
          setState(() {
            selected = FormData.UserName;
          });
        },
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.title,
            color: selected == FormData.UserName ? enabledtxt : deaible,
            size: 20,
          ),
          hintText: 'User Name',
          hintStyle: TextStyle(
              color: selected == FormData.UserName ? enabledtxt : deaible,
              fontSize: 12),
        ),
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
            color: selected == FormData.UserName ? enabledtxt : deaible,
            fontWeight: FontWeight.bold,
            fontSize: 12),
      ),
    );
  }

/*   Widget _vGotoSignin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("If you have an account ",
            style: TextStyle(
              color: MyColors.bluishBlackColor,
              letterSpacing: 0.5,
            )),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return LoginScreen();
            }));
          },
          child: Text("Sing in",
              style: TextStyle(
                  color: MyColors.darkYellowColor.withOpacity(0.9),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  fontSize: 14)),
        ),
      ],
    );
  } */

  Widget _vAddressLocation() {
    return Container(
      width: 300,
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0), color: backgroundColor),
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: () {},
        child: TextField(
          controller: addressController,
          enabled: false,
          decoration: InputDecoration(
              enabledBorder: InputBorder.none,
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.location_pin,
                color: deaible,
                size: 20,
              ),
              hintText: 'Address Location',
              hintStyle: TextStyle(color: deaible, fontSize: 12)),
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(
              color: deaible, fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
    );
  }

  bool mCheckInputValidation() {
    if (usernameController.value.text.isNotEmpty &&
        phoneController.value.text.isNotEmpty &&
        dobController.value.text.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  void mUpdateOperation() async {
    if (mCheckInputValidation()) {
      // c: Unique username checking
      bool isUnique;
      if (widget.userData.username != usernameController.value.text) {
        isUnique = await MyAuthenticationService.mCheckUniqueUserName(
            firebaseFirestore: firebaseFirestore,
            username: usernameController.value.text);
      } else {
        isUnique = true;
      }

      if (isUnique) {
        // c: create a users object
        UserData users = UserData(
            uid: widget.userData.uid,
            email: widget.userData.email,
            username: usernameController.value.text,
            phone: phoneController.value.text,
            dob: dobController.value.text,
            location: addressController.value.text,
            ts: DateTime.now().millisecondsSinceEpoch.toString());
        // c: store the users data in to Firestore
        await MyFirestoreService.mUpdateUserData(
                firebaseFirestore: firebaseFirestore, userData: users)
            .then((value) {
          AwesomeDialog(
              context: context,
              dialogType: DialogType.noHeader,
              title: value != null ? "Success" : "Error",
              desc: value != null
                  ? "Information has been updated"
                  : "Error in update",
              btnOk: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return LandingScreen(userData: value!);
                  }));
                },
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(400, MyScreenSize.mGetHeight(context, 1)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
                child: const Text("Go to Home"),
              )).show();
          
        }

                /*  else {
                AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    title: "Sign up error",
                    btnOk: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          fixedSize:
                              Size(400, MyScreenSize.mGetHeight(context, 1)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4)),
                      child: Text("Dismiss"),
                    )).show();
              } */
                );
      } else {
        await Future.delayed((const Duration(milliseconds: 1))).then((value) {
          MyWidget.vShowWarnigDialog(
              context: context, message: "Username already exist");
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  void mShowDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now().add(const Duration(days: -40000)),
            lastDate: DateTime.now())
        .then((value) {
      if (value != null) {
        setState(() {
          dobController.text = MyDateForamt.mFormateDate2(value);
        });
      }
    });
  }
}
