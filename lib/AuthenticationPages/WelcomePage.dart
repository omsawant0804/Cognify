import 'package:cognify_app/AuthenticationPages/InputPage.dart';
import 'package:cognify_app/AuthenticationPages/PhoneAuth.dart';
import 'package:cognify_app/Navigation/navigation.dart';
import 'package:flutter/material.dart';

import '../widget/Button.dart';

class Welcomepage extends StatefulWidget {
  const Welcomepage({super.key});

  @override
  State<Welcomepage> createState() => _WelcomepageState();
}

class _WelcomepageState extends State<Welcomepage> {
  @override
  Widget build(BuildContext context) {
    // Get the screen size
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        color: Color(0xFFF8F6E7),
        child: Column(
          children: [
            // Top Container with proportional height
            Container(
              height: screenSize.height * 0.5, // 50% of screen height
              color: Colors.transparent,
            ),
            // Use SizedBox for spacing
            SizedBox(height: 5),

            // Expanded Container for Background Image
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/Welc_bg.png'), // Replace with your image path
                    fit: BoxFit.cover,
                  ),
                ),
                // Center the text vertically within this container
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Center items vertically
                    children: [
                      SizedBox(height: screenSize.height * 0.01), // Small top margin
                      Text(
                        "Cognify",
                        style: TextStyle(
                          fontSize: screenSize.width * 0.12, // Proportional font size
                          fontWeight: FontWeight.bold,
                          fontFamily: "Poppins",
                          color: Color(0xFF232426), // Change text color if needed
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.05), // Space below title
                      Text(
                        "Unlock Potential,\nOne Skill at a Time!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenSize.width * 0.06, // Proportional font size
                          fontFamily: "Poppins",
                          color: Color(0xFF232426), // Change text color if needed
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.12), // Space before button
                      CustomButton(
                        text: "Let’s Go", // Set the text here
                        targetPage: PhoneAuth(), // Set the target page here
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
