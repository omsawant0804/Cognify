import 'package:cognify_app/screens/home_screen.dart';
import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  final int totalAttemptsMemory;
  final int totalCorrectMemory;
  final int highestLevelMemory;
  final int totalAttemptsAttention;
  final int totalCorrectAttention;
  final int highestLevelAttention;
  final int totalAttemptsBehavior;
  final int totalCorrectBehavior;
  final int highestLevelBehavior;

  ResultsScreen({
    required this.totalAttemptsMemory,
    required this.totalCorrectMemory,
    required this.highestLevelMemory,
    required this.totalAttemptsAttention,
    required this.totalCorrectAttention,
    required this.highestLevelAttention,
    required this.totalAttemptsBehavior,
    required this.totalCorrectBehavior,
    required this.highestLevelBehavior,
  });

  double calculatePercentage(int correct, int attempts) {
    return attempts > 0 ? (correct / attempts) * 100 : 0;
  }

  double calculateOverallPercentage() {
    int totalAttempts =
        totalAttemptsMemory + totalAttemptsAttention + totalAttemptsBehavior;
    int totalCorrect =
        totalCorrectMemory + totalCorrectAttention + totalCorrectBehavior;
    return totalAttempts > 0 ? (totalCorrect / totalAttempts) * 100 : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F6E7),
      appBar: AppBar(title: Text('Results')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildResultSection(
              "Memory Test",
              totalCorrectMemory,
              totalAttemptsMemory,
              highestLevelMemory,
            ),
            SizedBox(height: 20),
            buildResultSection(
              "Attention Test",
              totalCorrectAttention,
              totalAttemptsAttention,
              highestLevelAttention,
            ),
            SizedBox(height: 20),
            buildResultSection(
              "Behavior Test",
              totalCorrectBehavior,
              totalAttemptsBehavior,
              highestLevelBehavior,
            ),
            SizedBox(height: 40),
            Spacer(),
            Center(
              child: Text(
                "Overall Result: ${calculateOverallPercentage().toStringAsFixed(1)}%",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Spacer(),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  Colors.black, // Set button background to black
                  foregroundColor:
                  Colors.white, // Set button text color to white
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                onPressed: () {
                  // Add functionality for the button
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                        (Route<dynamic> route) => false,
                  );
                },
                child: Text("Start Learning"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildResultSection(
      String testName, int correct, int attempts, int level) {
    double percentage = calculatePercentage(correct, attempts);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$testName: ${percentage.toStringAsFixed(1)}%",
          style: TextStyle(fontSize: 18),
        ),
        LinearProgressIndicator(
          value: percentage / 100,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        ),
        SizedBox(height: 5),
        Text('Score: $correct/$attempts, Level: $level'),
      ],
    );
  }
}