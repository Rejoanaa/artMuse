/* // ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, sort_child_properties_last

import 'package:art_blog_app/animations/Fade_Animation.dart';
import 'package:art_blog_app/screens/phone_verification/freeze.scr.phone_verification.dart';
import 'package:art_blog_app/screens/signin/scr_signin.dart';
import 'package:art_blog_app/utils/my_colors.dart';
import 'package:art_blog_app/utils/my_screensize.dart';
import 'package:flutter/material.dart';

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

class SignupScreen1 extends StatefulWidget {
  const SignupScreen1({super.key});

  @override
  State<SignupScreen1> createState() => _SignupScreen1State();
}

class _SignupScreen1State extends State<SignupScreen1> {
  // Color enabled = const Color.fromARGB(255, 63, 56, 89);
  Color enabled = const Color.fromARGB(255, 63, 56, 89);
  Color enabledtxt = Colors.white;
  Color deaible = Colors.grey;
  Color backgroundColor = const Color(0xFF1F1A30);
  bool ispasswordev = true;

  FormData? selected;

  TextEditingController usernameController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.1, 0.4, 0.7, 0.9],
            colors: [
              MyColors.firstColor.withOpacity(0.8),
              MyColors.firstColor,
              MyColors.firstColor,
              MyColors.firstColor
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
                  color: MyColors.fifthColor,
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
                        /*  const SizedBox(
                          height: 20,
                        ),
                        _vDateOfBirth(),
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
    return FadeAnimation(
      delay: 1,
      child: Container(
        width: 300,
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: selected == FormData.ConfirmPassword
                ? enabled
                : backgroundColor),
        padding: const EdgeInsets.all(5.0),
        child: InkWell(
          onTap: () {},
          child: TextField(
            controller: confirmPasswordController,
            enabled: false,
            decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.calendar_today,
                  color: deaible,
                  size: 20,
                ),
                hintText: 'Date of Birth',
                hintStyle: TextStyle(color: deaible, fontSize: 12)),
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(
                color: deaible, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
      ),
    );
  }

  Widget _vSignupButton() {
    return FadeAnimation(
        delay: 1,
        child: TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return PhoneVerificationScreen();
              }));
            },
            child: Text(
              "Sign Up",
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 0.5,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: TextButton.styleFrom(
                backgroundColor: MyColors.firstColor,
                // backgroundColor: const Color(0xFF2697FF),
                padding:
                    const EdgeInsets.symmetric(vertical: 14.0, horizontal: 80),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)))));
  }

  Widget _vConfirmPass() {
    return FadeAnimation(
      delay: 1,
      child: Container(
        width: 300,
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: selected == FormData.ConfirmPassword
                ? enabled
                : backgroundColor),
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
                  color: selected == FormData.ConfirmPassword
                      ? enabledtxt
                      : deaible,
                  fontSize: 12)),
          obscureText: ispasswordev,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(
              color:
                  selected == FormData.ConfirmPassword ? enabledtxt : deaible,
              fontWeight: FontWeight.bold,
              fontSize: 12),
        ),
      ),
    );
  }

  Widget _vPass() {
    return FadeAnimation(
      delay: 1,
      child: Container(
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
                        color: selected == FormData.password
                            ? enabledtxt
                            : deaible,
                        size: 20,
                      )
                    : Icon(
                        Icons.visibility,
                        color: selected == FormData.password
                            ? enabledtxt
                            : deaible,
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
      ),
    );
  }

  Widget _vEmail() {
    return FadeAnimation(
      delay: 1,
      child: Container(
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
      ),
    );
  }

  Widget _vPhone() {
    return FadeAnimation(
      delay: 1,
      child: Container(
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
      ),
    );
  }

  Widget _vUserName() {
    return FadeAnimation(
      delay: 1,
      child: Container(
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
      ),
    );
  }

  Widget _vFullName() {
    return FadeAnimation(
      delay: 1,
      child: Container(
        width: 300,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: selected == FormData.Email ? enabled : backgroundColor,
        ),
        padding: const EdgeInsets.all(5.0),
        child: TextField(
          controller: fullnameController,
          onTap: () {
            setState(() {
              selected = FormData.FullName;
            });
          },
          decoration: InputDecoration(
            enabledBorder: InputBorder.none,
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.title,
              color: selected == FormData.FullName ? enabledtxt : deaible,
              size: 20,
            ),
            hintText: 'Full Name',
            hintStyle: TextStyle(
                color: selected == FormData.FullName ? enabledtxt : deaible,
                fontSize: 12),
          ),
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(
              color: selected == FormData.FullName ? enabledtxt : deaible,
              fontWeight: FontWeight.bold,
              fontSize: 12),
        ),
      ),
    );
  }

  Widget _vCreateAccountText() {
    return FadeAnimation(
      delay: 1,
      child: Container(
        child: Text(
          "Create your account",
          style: TextStyle(
              // color: Colors.white.withOpacity(0.9),
              // color: UtilsColor.secondColor,
              color: MyColors.secondColor,
              letterSpacing: 0.5),
        ),
      ),
    );
  }

  Widget _vPersonDummyImage() {
    return FadeAnimation(
      delay: 0.8,
      child: Image.asset(
        "assets/images/user.png",
        width: 50,
        height: 50,
      ),
    );
  }

  Widget _vGotoSignin() {
    return FadeAnimation(
      delay: 1,
      child: Row(
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
                return LoginScreen();
              }));
            },
            child: Text("Sing in",
                style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget _vAddressLocation() {
    return FadeAnimation(
      delay: 1,
      child: Container(
        width: 300,
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0), color: backgroundColor),
        padding: const EdgeInsets.all(5.0),
        child: InkWell(
          onTap: () {
            confirmPasswordController.text = "Set text";
            // context.read<SignupBloc>().add(CalenderDialogOpenEvent());
          },
          child: TextField(
            controller: addressController,
            enabled: false,
            decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.location_city,
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
      ),
    );
  }
}
 */