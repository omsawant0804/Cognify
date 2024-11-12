import 'package:cognify_app/Test/TestHomePage.dart';
import 'package:cognify_app/widget/Button.dart';
import 'package:flutter/material.dart';
// Import your custom button file if needed
// import '../widget/CustomButton.dart';

class Acccreated extends StatefulWidget {
  const Acccreated({super.key});

  @override
  State<Acccreated> createState() => _AcccreatedState();
}

class _AcccreatedState extends State<Acccreated> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6E7), // Light background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: screenWidth * 0.4),
            Text(
              'Account created\nsuccessfully',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: screenWidth * 0.08,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF232426),
              ),
            ),
            SizedBox(height: screenWidth * 0.2), // Space between text and icon
            Container(
              width: screenWidth * 0.4,
              height: screenWidth * 0.4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green.withOpacity(0.2), // Light green background
              ),
              child: Icon(
                Icons.check_circle,
                color: Colors.green,
                size: screenWidth * 0.3, // Size of the check icon
              ),
            ),
            SizedBox(height: screenWidth * 0.6), // Space between icon and button
            CustomButton(
              text: "Next",
              targetPage: TesthomepageScreen(),
              // Customize your button style as needed
            ),
          ],
        ),
      ),
    );
  }
}
