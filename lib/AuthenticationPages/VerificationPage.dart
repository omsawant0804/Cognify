import 'package:cognify_app/AuthenticationPages/AccCreated.dart';
import 'package:cognify_app/AuthenticationPages/InputPage.dart';
import 'package:cognify_app/AuthenticationPages/PhoneAuth.dart';
import 'package:cognify_app/MainPages/HomePage.dart';
import 'package:cognify_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import '../Test/TestHomePage.dart';
import '../widget/Button.dart';
import '../widget/OTPinputFiled.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Verificationpage extends StatefulWidget {
  final String verificationId;

  const Verificationpage({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<Verificationpage> createState() => _VerificationpageState();
}

class _VerificationpageState extends State<Verificationpage> {
  TextEditingController otpController = TextEditingController();

  // Function to verify OTP, check user existence, and navigate accordingly
  Future<void> verifyOtp() async {
    String otp = otpController.text.toString().trim();
    if (otp.length == 6) {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otp,
      );

      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        User? user = userCredential.user;

        if (user != null) {
          // Check if the user exists in the Firestore 'User' collection
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('User')
              .doc(user.uid)
              .get();

          if (userDoc.exists) {
            // Navigate to HomePage if the user exists in the User collection
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),//Homepage()),  // Replace with your HomePage
                  (Route<dynamic> route) => false,
            );
          } else {
            // Navigate to InputPage if the user does not exist in the User collection
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => InputPage()),
                  (Route<dynamic> route) => false,
            );
          }
        } else {
          throw Exception("User not found after verification.");
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Verified")),
        );

      } catch (e) {
        print("Error verifying OTP: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Invalid OTP. Please try again.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid 6-digit OTP.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6E7),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.70),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter OTP',
                    style: TextStyle(
                      fontFamily: "Poppins",
                      color: const Color(0xFF232426),
                      fontSize: screenWidth * 0.08,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  CustomOTPField(
                    otpController: otpController,
                    length: 6,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  CustomButton(
                    req: 1,
                    text: "Submit",
                    targetPage: const PhoneAuth(),
                    onTapAction: verifyOtp,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
