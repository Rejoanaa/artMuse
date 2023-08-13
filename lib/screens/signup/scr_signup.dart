import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/my_date_format.dart';
import 'package:logger/logger.dart';

import '../../controller/my_authentication_service.dart';
import '../../controller/firestore_service.dart';
import '../../controller/my_services.dart';
import '../../models/model.user.dart';
import '../../utils/my_colors.dart';
import '../../utils/my_screensize.dart';
import '../../widgets/my_widget.dart';
import '../signin/scr_signin.dart';

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

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Color enabled = const Color.fromARGB(255, 63, 56, 89);
  Color enabled = MyColors.secondColor3;
  Color enabledtxt = Colors.white;
  Color deaible = Colors.grey;
  Color backgroundColor = MyColors.secondColor;
  bool ispasswordev = true;
  Logger logger = Logger();

  FormData? selected;

  TextEditingController usernameController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  late FirebaseFirestore firebaseFirestore;
  late FirebaseAuth firebaseAuth;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    firebaseFirestore = FirebaseFirestore.instance;
    firebaseAuth = FirebaseAuth.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.1, 0.4, 0.7, 0.9],
            colors: [
              MyColors.secondColor5.withOpacity(0.8),
              MyColors.secondColor5,
              MyColors.secondColor5,
              MyColors.secondColor5
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  elevation: 5,
                  // color: MyColors.fifthColor,
                  color: MyColors.secondColor4,
                  child: Container(
                    width: MyScreenSize.mGetWidth(context, 95),
                    padding: const EdgeInsets.all(35.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _vPersonDummyImage(),
                        const SizedBox(
                          height: 10,
                        ),
                        _vCreateAccountText(),
                        const SizedBox(
                          height: 20,
                        ),
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
                        _vEmail(),
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
                        ),
                        _vDateOfBirth(),
                        /*  
                        const SizedBox(
                          height: 20,
                        ),
                        _vAddressLocation(), */
                        const SizedBox(
                          height: 25,
                        ),
                        _vSignupButton(),
                      ],
                    ),
                  ),
                ),
                //End of Center Card

                //Start of outer card
                const SizedBox(
                  height: 20,
                ),
                _vGotoSignin(),
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

  Widget _vSignupButton() {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            isLoading = true;
            mSignUpOperation();
          });
        },
        style: ElevatedButton.styleFrom(
            /* fixedSize: Size(MyScreenSize.mGetWidth(context, 60),
                MyScreenSize.mGetHeight(context, 7)), */
            // backgroundColor: MyColors.firstColor,
            backgroundColor: MyColors.secondColor,
            // backgroundColor: const Color(0xFF2697FF),
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 24),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0))),
        child: !isLoading
            ? const Text(
                "Sign Up",
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 0.5,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              )
            : MyWidget.vButtonProgressLoader(labelText: "Signing up..."));
  }

  Widget _vConfirmPass() {
    return Container(
      width: 300,
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color:
              selected == FormData.ConfirmPassword ? enabled : backgroundColor),
      padding: const EdgeInsets.all(5.0),
      child: TextField(
        controller: confirmPasswordController,
        onTap: () {
          setState(() {
            selected = FormData.ConfirmPassword;
          });
        },
        decoration: InputDecoration(
            enabledBorder: InputBorder.none,
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.lock_open_outlined,
              color:
                  selected == FormData.ConfirmPassword ? enabledtxt : deaible,
              size: 20,
            ),
            suffixIcon: IconButton(
              icon: ispasswordev
                  ? Icon(
                      Icons.visibility_off,
                      color: selected == FormData.ConfirmPassword
                          ? enabledtxt
                          : deaible,
                      size: 20,
                    )
                  : Icon(
                      Icons.visibility,
                      color: selected == FormData.ConfirmPassword
                          ? enabledtxt
                          : deaible,
                      size: 20,
                    ),
              onPressed: () => setState(() => ispasswordev = !ispasswordev),
            ),
            hintText: 'Confirm Password',
            hintStyle: TextStyle(
                color:
                    selected == FormData.ConfirmPassword ? enabledtxt : deaible,
                fontSize: 12)),
        obscureText: ispasswordev,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
            color: selected == FormData.ConfirmPassword ? enabledtxt : deaible,
            fontWeight: FontWeight.bold,
            fontSize: 12),
      ),
    );
  }

  Widget _vPass() {
    return Container(
      width: 300,
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: selected == FormData.password ? enabled : backgroundColor),
      padding: const EdgeInsets.all(5.0),
      child: TextField(
        controller: passwordController,
        onTap: () {
          setState(() {
            selected = FormData.password;
          });
        },
        decoration: InputDecoration(
            enabledBorder: InputBorder.none,
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.lock_open_outlined,
              color: selected == FormData.password ? enabledtxt : deaible,
              size: 20,
            ),
            suffixIcon: IconButton(
              icon: ispasswordev
                  ? Icon(
                      Icons.visibility_off,
                      color:
                          selected == FormData.password ? enabledtxt : deaible,
                      size: 20,
                    )
                  : Icon(
                      Icons.visibility,
                      color:
                          selected == FormData.password ? enabledtxt : deaible,
                      size: 20,
                    ),
              onPressed: () => setState(() => ispasswordev = !ispasswordev),
            ),
            hintText: 'Password',
            hintStyle: TextStyle(
                color: selected == FormData.password ? enabledtxt : deaible,
                fontSize: 12)),
        obscureText: ispasswordev,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
            color: selected == FormData.password ? enabledtxt : deaible,
            fontWeight: FontWeight.bold,
            fontSize: 12),
      ),
    );
  }

  Widget _vEmail() {
    return Container(
      width: 300,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: selected == FormData.Email ? enabled : backgroundColor,
      ),
      padding: const EdgeInsets.all(5.0),
      child: TextField(
        controller: emailController,
        onTap: () {
          setState(() {
            selected = FormData.Email;
          });
        },
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.email_outlined,
            color: selected == FormData.Email ? enabledtxt : deaible,
            size: 20,
          ),
          hintText: 'Email',
          hintStyle: TextStyle(
              color: selected == FormData.Email ? enabledtxt : deaible,
              fontSize: 12),
        ),
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
            color: selected == FormData.Email ? enabledtxt : deaible,
            fontWeight: FontWeight.bold,
            fontSize: 12),
      ),
    );
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

  Widget _vCreateAccountText() {
    return const Text(
      "Create your account",
      style: TextStyle(
          // color: Colors.white.withOpacity(0.9),
          // color: UtilsColor.secondColor,
          color: MyColors.secondColor,
          letterSpacing: 0.5),
    );
  }

  Widget _vPersonDummyImage() {
    return Image.asset(
      "assets/images/user.png",
      width: 50,
      height: 50,
    );
  }

  Widget _vGotoSignin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("If you have an account ",
            style: TextStyle(
              color: MyColors.secondColor,
              letterSpacing: 0.5,
            )),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return const LoginScreen();
            }));
          },
          child: Text("Sing in",
              style: TextStyle(
                  // color: Colors.white.withOpacity(0.9),
                  color: MyColors.secondColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  fontSize: 14)),
        ),
      ],
    );
  }

  bool mCheckInputValidation() {
    if (usernameController.value.text.isNotEmpty &&
        phoneController.value.text.isNotEmpty &&
        emailController.value.text.isNotEmpty &&
        passwordController.value.text.isNotEmpty &&
        confirmPasswordController.value.text.isNotEmpty &&
        dobController.value.text.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  void mSignUpOperation() async {
    if (mCheckInputValidation()) {
      // c: Pass correctness
      if (passwordController.value.text.length >= 6) {
        if (passwordController.value.text ==
            confirmPasswordController.value.text) {
          // c: Unique username checking
          bool isUnique = await MyAuthenticationService.mCheckUniqueUserName(
              firebaseFirestore: firebaseFirestore,
              username: usernameController.value.text);
          if (isUnique) {
            // c: proceed to signup
            UserCredential? userCredential =
                await MyAuthenticationService.mSignUp(
                        firebaseAuth: firebaseAuth,
                        email: emailController.value.text,
                        password: passwordController.value.text)
                    .then((UserCredential? userCredential) async {
              if (userCredential != null) {
                User user = userCredential.user!;
                // c: create a users object
                UserData users = UserData(
                    uid: user.uid,
                    email: user.email,
                    username: usernameController.value.text,
                    phone: phoneController.value.text,
                    dob: dobController.value.text,
                    ts: DateTime.now().millisecondsSinceEpoch.toString());
                // c: store the users data in to Firestore
                await MyFirestoreService.mStoreUserCredential(
                    firebaseFirestore: firebaseFirestore, user: users);

                Future.delayed(const Duration(milliseconds: 1)).then((value) {
                  MyWidget.vShowWarnigDialog(
                          context: context,
                          message: "Email verification has been sent",
                          buttonText: "Check email")
                      .then((value) async => {
                            await MyServices.mLaunchGmailInbox(
                                email: user.email!),
                            MyServices.mExitApp()
                          });
                });
              } else {
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
                      child: const Text("Dismiss"),
                    )).show();
              }
            });
          } else {
            await Future.delayed((const Duration(milliseconds: 1)))
                .then((value) {
              MyWidget.vShowWarnigDialog(
                  context: context, message: "Username already exist");
            });
          }
        } else {
          MyWidget.vShowWarnigDialog(
              context: context, message: "Password incorrect");
        }
      } else {
        MyWidget.vShowWarnigDialog(
            context: context,
            message: "Password should be at least 6 characters");
      }
    } else {
      // m: show alert
      MyWidget.vShowWarnigDialog(context: context, message: "Input required*");
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
          dobController.text = MyDateForamt.mFormateDate2(value!);
        });
      }
    });
  }
}
