import 'package:cognify_app/widget/Button.dart';

import 'result_screen.dart';
import 'package:flutter/material.dart';
import 'memory_test_screen.dart';
import 'attention_test_screen.dart';
import 'behavior_test_screen.dart';

class TesthomepageScreen extends StatefulWidget {
  @override
  _TesthomepageScreenState createState() => _TesthomepageScreenState();
}

class _TesthomepageScreenState extends State<TesthomepageScreen> {
  bool memoryTestCompleted = false;
  bool attentionTestCompleted = false;
  bool behaviorTestCompleted = false;

  // Add variables to store the data of each test
  int totalAttemptsMemory = 0;
  int totalCorrectMemory = 0;
  int highestLevelMemory = 0;

  int totalAttemptsAttention = 0;
  int totalCorrectAttention = 0;
  int highestLevelAttention = 0;

  int totalAttemptsBehavior = 0;
  int totalCorrectBehavior = 0;
  int highestLevelBehavior = 0;
  // Callback function to save the data when a test is completed
  void onTestComplete(String testName, int totalAttempts, int correctAnswers,
      int highestLevel) {
    setState(() {
      if (testName == 'Memory Test') {
        memoryTestCompleted = true;
        totalAttemptsMemory = totalAttempts;
        totalCorrectMemory = correctAnswers;
        highestLevelMemory = highestLevel;
      } else if (testName == 'Attention Test') {
        attentionTestCompleted = true;
        totalAttemptsAttention = totalAttempts;
        totalCorrectAttention = correctAnswers;
        highestLevelAttention = highestLevel;
      } else if (testName == 'Behavior Test') {
        behaviorTestCompleted = true;
        totalAttemptsBehavior = totalAttempts;
        totalCorrectBehavior = correctAnswers;
        highestLevelBehavior = highestLevel;
      }
    });
  }

  // Start test based on the current progress
  void startTest() {
    if (!memoryTestCompleted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MemoryTestScreen(
            onTestComplete: onTestComplete, // Pass the callback function
          ),
        ),
      ).then((result) {
        setState(() {
          memoryTestCompleted = true;
        });
      });
    } else if (!attentionTestCompleted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AttentionTestScreen(
            onTestComplete: onTestComplete, // Pass the callback function
          ),
        ),
      ).then((result) {
        setState(() {
          attentionTestCompleted = true;
        });
      });
    } else if (!behaviorTestCompleted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BehaviorTestScreen(
            onTestCompleted: onTestComplete, // Pass the callback function
          ),
        ),
      ).then((result) {
        setState(() {
          behaviorTestCompleted = true;
        });
      });
    } else {
      // All tests completed, show results
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsScreen(
            totalAttemptsMemory: totalAttemptsMemory,
            totalCorrectMemory: totalCorrectMemory,
            highestLevelMemory: highestLevelMemory,
            totalAttemptsAttention: totalAttemptsAttention,
            totalCorrectAttention: totalCorrectAttention,
            highestLevelAttention: highestLevelAttention,
            totalAttemptsBehavior: totalAttemptsBehavior,
            totalCorrectBehavior: totalCorrectBehavior,
            highestLevelBehavior: highestLevelBehavior,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F6E7),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 80),
              Text(
                "Take your Fit Test",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                "We'll calculate the child's baseline in 3 cognitive games.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              // Cognitive test circles
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: memoryTestCompleted
                        ? Color(0xFF32CD32)
                        : Color(0xFFD9D9D9),
                    child: Text("🧠", style: TextStyle(fontSize: 24)),
                  ),
                  SizedBox(width: 20),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: attentionTestCompleted
                        ? Color(0xFF32CD32)
                        : Color(0xFFD9D9D9),
                    child: Text("👁", style: TextStyle(fontSize: 24)),
                  ),
                  SizedBox(width: 20),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: behaviorTestCompleted
                        ? Color(0xFF32CD32)
                        : Color(0xFFD9D9D9),
                    child: Text("🗣", style: TextStyle(fontSize: 24)),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Spacer(),
              // Start Test Button
              // CustomButton(
              //     req: 1,
              //     text: memoryTestCompleted &&
              //     attentionTestCompleted &&
              //     behaviorTestCompleted
              //     ? "See Results"
              //     : (memoryTestCompleted && attentionTestCompleted ||
              //     memoryTestCompleted)
              //     ? "Continue Test"
              //     : "Start Test",
              //     onTapAction: startTest,
              //
              // ),
              // ElevatedButton(
              //   onPressed: startTest,
              //   style: ElevatedButton.styleFrom(
              //     padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(30),
              //     ),
              //   ),
              //   child: Text(
              //     memoryTestCompleted &&
              //         attentionTestCompleted &&
              //         behaviorTestCompleted
              //         ? "See Results"
              //         : (memoryTestCompleted && attentionTestCompleted ||
              //         memoryTestCompleted)
              //         ? "Continue Test"
              //         : "Start Test",
              //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              //   ),
              // ),

          ElevatedButton(
            onPressed: startTest,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.black, // Text color
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              memoryTestCompleted && attentionTestCompleted && behaviorTestCompleted
                  ? "See Results"
                  : (memoryTestCompleted && attentionTestCompleted || memoryTestCompleted)
                  ? "Continue Test"
                  : "Start Test",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          ],
          ),
        ),
      ),
    );
  }
}
