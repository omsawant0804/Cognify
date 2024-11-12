import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(SimpleMathGame());
}

class SimpleMathGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: MathGame(),
    );
  }
}

class MathGame extends StatefulWidget {
  @override
  _MathGameState createState() => _MathGameState();
}

class _MathGameState extends State<MathGame> {
  int firstNumber = 0;
  int secondNumber = 0;
  String operator = '';
  int correctAnswer = 0;
  int score = 0;
  int currentLevel = 1;
  int levelScore = 0;
  String feedbackMessage = '';
  bool correct = false;
  TextEditingController answerController = TextEditingController();

  int timerDuration = 60; // 1 minute in seconds
  Timer? timer;
  Timer? feedbackTimer; // Timer for feedback icon

  @override
  void initState() {
    super.initState();
    _generateNewProblem();
    _startTimer();
  }

  // Start the countdown timer
  void _startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        if (timerDuration > 0) {
          timerDuration--;
        } else {
          timer?.cancel();
          feedbackMessage = "Time's up!";
          // Restart the same level if time runs out
          _restartLevel();
        }
      });
    });
  }

  // Generate a new problem based on level
  void _generateNewProblem() {
    setState(() {
      final random = Random();
      int maxNumber = currentLevel * 10; // Increase range based on level
      firstNumber = random.nextInt(maxNumber) + 1;
      secondNumber = random.nextInt(maxNumber) + 1;

      // Define operators based on the current level
      List<String> operators = ['+'];

      if (currentLevel >= 2) {
        operators.add('-'); // Add subtraction from level 2
      }
      if (currentLevel >= 3) {
        operators.add('*'); // Add multiplication from level 3
      }
      if (currentLevel >= 4) {
        operators.add('/'); // Add division from level 4
      }

      operator = operators[random.nextInt(operators.length)];

      // Determine the correct answer based on the operator
      if (operator == '+') {
        correctAnswer = firstNumber + secondNumber;
      } else if (operator == '-') {
        if (firstNumber < secondNumber) {
          int temp = firstNumber;
          firstNumber = secondNumber;
          secondNumber = temp;
        }
        correctAnswer = firstNumber - secondNumber;
      } else if (operator == '*') {
        correctAnswer = firstNumber * secondNumber;
      } else if (operator == '/') {
        // Ensure no division by zero and integer results
        secondNumber = random.nextInt(maxNumber - 1) + 1; // Prevent division by zero
        firstNumber = secondNumber * (random.nextInt(maxNumber) + 1); // Ensure divisibility
        correctAnswer = firstNumber ~/ secondNumber; // Use integer division
      }

      feedbackMessage = '';
      answerController.clear();
    });
  }

  // Check if the answer is correct
  void _checkAnswer() {
    int userAnswer = int.tryParse(answerController.text) ?? 0;

    setState(() {
      if (userAnswer == correctAnswer) {
        score++;
        levelScore++;
        correct = true;

        if (levelScore >= 5) {
          currentLevel++;
          levelScore = 0;

          if (currentLevel > 5) {
            currentLevel = 5; // Cap at level 5
            feedbackMessage = "You've reached the highest level!";
          }
        }
        _generateNewProblem();
      } else {
        correct = false;
        feedbackMessage = "Try again!";
      }

      // Show feedback for 2 seconds
      feedbackTimer?.cancel(); // Cancel previous timer if any
      feedbackTimer = Timer(Duration(seconds: 2), () {
        setState(() {
          feedbackMessage = ''; // Clear feedback message after 2 seconds
          correct = false; // Reset correct state for next question
        });
      });
    });
  }

  // Restart the same level when time runs out
  void _restartLevel() {
    setState(() {
      timerDuration = 60; // Reset timer
      levelScore = 0; // Reset level score
      feedbackMessage = 'Restarting level ${currentLevel}...';
      _generateNewProblem(); // Generate a new problem
      _startTimer(); // Restart timer
    });
  }

  // Widget to show tick or cross icon
  Widget _feedbackIcon() {
    if (correct) {
      return Icon(Icons.check_circle, color: Colors.green, size: 60);
    } else if (feedbackMessage == "Try again!") {
      return Icon(Icons.cancel, color: Colors.red, size: 60);
    } else {
      return SizedBox.shrink();
    }
  }

  @override
  void dispose() {
    timer?.cancel(); // Cancel timer on dispose
    feedbackTimer?.cancel(); // Cancel feedback timer on dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Level: $currentLevel - Score: $score',
              style: TextStyle(fontSize: 16),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Time: $timerDuration',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView( // Wrap with SingleChildScrollView
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              '$firstNumber $operator $secondNumber = ?',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 20),
            TextField(
              controller: answerController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter answer',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            SizedBox(height: 50),
            GestureDetector(
              onTap: _checkAnswer,
              child: Container(
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                ),
                child: Center(
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
            _feedbackIcon(),
            SizedBox(height: 20),
            Text(
              'Level Progress: $levelScore / 5',
              style: TextStyle(fontSize: 20, color: Colors.white70),
            ),
            SizedBox(height: 20),
            LinearProgressIndicator(
              value: levelScore / 5,
              backgroundColor: Colors.grey[700],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
            ),
          ],
        ),
      ),
    );
  }}
