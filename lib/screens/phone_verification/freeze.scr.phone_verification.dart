/* import 'package:art_blog_app/screens/landing/scr.landing.dart';
import 'package:art_blog_app/utils/my_screensize.dart';
import 'package:flutter/material.dart';

import '../../animations/Fade_Animation.dart';
import '../../utils/my_colors.dart';

class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen({super.key});

  @override
  State<PhoneVerificationScreen> createState() =>
      PhoneVerificationScreenState();
}

class PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
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
                  color:
                      // const Color.fromARGB(255, 171, 211, 250).withOpacity(0.4),
                      MyColors.fifthColor,
                  child: Container(
                    width: 400,
                    padding: const EdgeInsets.all(40.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        vVerificationText(),
                        vVerificationText2(),
                        vCodeInputTextField(),
                        vVerifyButton()
                      ],
                    ),
                  ),
                ),

                //End of Center Card
                //Start of outer card
                vDidnotReciveCodeText(),
                vResendCode(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget vVerificationText() {
    return 
      
     Container(
        padding: const EdgeInsets.all(8),
        child: const Text(
          "Verification",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
              color: MyColors.secondColor),
        ),
    );
  }

  Widget vVerificationText2() {
    return 
      
     Container(
        padding: const EdgeInsets.all(8),
        child: const Text(
          "Enter the code send to your phone number",
          style: TextStyle(color: Colors.black54),
        ),
    );
  }

  Widget vCodeInputTextField() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: 
              
             TextFormField(
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 18, color: MyColors.secondColor),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                )),
              ),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: 
              
             TextFormField(
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 18, color: MyColors.secondColor),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                )),
              ),
            ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: 
              
              TextFormField(
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 18, color: MyColors.secondColor),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                )),
              ),
            ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: 
              
              TextFormField(
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 18, color: MyColors.secondColor),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                )),
              ),
            ),
        ],
      ),
    );
  }

  Widget vVerifyButton() {
    return 
      
     Container(
        padding: const EdgeInsets.all(8),
        child: ElevatedButton(
          onPressed: () {
            // e: Verify Code here
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const LandingScreen();
            }));
          },
          style: ElevatedButton.styleFrom(
              fixedSize: Size(MyScreenSize.mGetWidth(context, 40), 0),
              backgroundColor: MyColors.firstColor,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8)),
          child: const Icon(
            Icons.arrow_forward_ios,
            color: MyColors.fifthColor,
          )
          /*  const Text(
              "Verify",
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18),
            ) */ /* Container(
            width: 20,
            height: 20,
            child: 
            const CircularProgressIndicator(color: UtilsColor.fifthColor, strokeWidth: 2,),
          ) */
          ,
        ),
    );
  }

  Widget vDidnotReciveCodeText() {
    return 
      
      Container(
        padding: const EdgeInsets.all(8),
        child: 
          
         Text("Didn't recieve any code?",
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                letterSpacing: 0.5,
              )),
    );
  }

  Widget vResendCode() {
    return InkWell(
      onTap: () {
        // e: Send verification code again here
      },
      child: 
        
   Container(
          padding: const EdgeInsets.all(8),
          child: const Text(
            "Resend code again",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
                color: Colors.blueAccent),
          ),
        ),
    );
  }
}
 */