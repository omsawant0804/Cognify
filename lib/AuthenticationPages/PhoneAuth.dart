import 'package:cognify_app/AuthenticationPages/VerificationPage.dart';  // Ensure correct import
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widget/Button.dart';
import '../widget/TextField.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({super.key});

  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  TextEditingController phnNumber = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationId2="";
  // Function to send OTP
  Future<void> sendOtp(String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: '+91$phoneNumber', // Add +91 before the phone number
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // If OTP is automatically verified
          await _auth.signInWithCredential(credential);
          // Navigate to verification page or handle success
        },
        verificationFailed: (FirebaseAuthException e) {
          // Handle error
          print("Verification failed: ${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) {
          // When the code is sent
          // Pass the verificationId to the VerificationPage
          this.verificationId2=verificationId;
          print(verificationId);
          print("id "+verificationId2);
          print("OTP send");
          Get.snackbar("OTP Send", "");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(
              "OTP Send"
            )),
          );// Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => Verificationpage(verificationId: verificationId),
          //   ),
          // );
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => Verificationpage(verificationId: verificationId),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(1.0, 0.0), // From the right
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
              transitionDuration: Duration(milliseconds: 500),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Timeout for OTP auto-retrieval
          print("Timeout occurred");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Timeout")),
          );
        },
      );
    } catch (e) {
      print("Error sending OTP: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6E7),
      resizeToAvoidBottomInset: true, // Allows screen to resize when keyboard appears
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height, // Maintain the full height of the screen
            child: Stack(
              children: [
                // Positioned girl image container
                Positioned(
                  top: size.height * 0.1,
                  left: size.width * 0.001,
                  child: Container(
                    width: size.width * 0.4,
                    height: size.width * 0.6, // Adjusted height to maintain aspect ratio
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image.asset(
                      'assets/images/girl.png', // Replace with your girl image path
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Positioned boy image container
                Positioned(
                  top: size.height * 0.25,
                  right: size.width * 0.001,
                  child: Container(
                    width: size.width * 0.4,
                    height: size.width * 0.6, // Adjusted height to maintain aspect ratio
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image.asset(
                      'assets/images/boy.png', // Replace with your boy image path
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Other elements below the images
                Positioned(
                  bottom: size.height * 0.07,
                  left: size.width * 0.05,
                  right: size.width * 0.05,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Sign Up',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: const Color(0xFF232426),
                          fontSize: size.width * 0.08, // Responsive font size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: size.height * 0.02), // Responsive spacing
                      // Container for the input field
                      CustomInputField(
                        placeholder: "Enter Mobile Number",
                        controller: phnNumber,
                        constantCode: "+91",
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: size.height * 0.02), // Responsive spacing
                      // Container for the button
                      CustomButton(
                        req: 1,
                        text: "Next",
                        targetPage: SizedBox(),
                        // targetPage: Verificationpage(verificationId: verificationId2,), // This can be kept as a placeholder
                        onTapAction: () async {
                          String phoneNumber = phnNumber.text.toString().trim();
                          if (phoneNumber.isNotEmpty && phoneNumber.length ==10) {
                            // Send OTP to the entered phone number
                            print(phoneNumber);
                            await sendOtp(phoneNumber);
                          } else {
                            // Show validation message if phone number is empty
                            print("Please enter a valid phone number.");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Please enter a valid phone number.")),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
