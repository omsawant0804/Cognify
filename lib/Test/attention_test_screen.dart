import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class AttentionTestScreen extends StatefulWidget {
  final Function(String, int, int, int) onTestComplete;

  AttentionTestScreen({required this.onTestComplete});

  @override
  _AttentionTestScreenState createState() => _AttentionTestScreenState();
}

class _AttentionTestScreenState extends State<AttentionTestScreen> {
  Color questionColor = Colors.red;
  List<Color> options = [];
  int correctAnswers = 0;
  int totalAttempts = 0;
  int level = 1;
  int timerSeconds = 90;
  late Timer timer;
  bool testCompleted = false;

  @override
  void initState() {
    super.initState();
    generateQuestion();
    startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        if (timerSeconds > 0) {
          timerSeconds--;
        } else {
          timer.cancel();
          completeTest();
        }
      });
    });
  }

  void generateQuestion() {
    options.clear();
    Random random = Random();
    questionColor = getRandomColor(random);

    options.add(questionColor); // Ensure the correct color is in options

    while (options.length < (level + 2)) {
      Color optionColor = getRandomColor(random);
      if (!options.contains(optionColor)) {
        options.add(optionColor);
      }
    }

    options.shuffle();
  }

  Color getRandomColor(Random random) {
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    );
  }

  void onOptionSelected(Color selectedColor) {
    setState(() {
      totalAttempts++;
      if (selectedColor == questionColor) {
        correctAnswers++;
        if (correctAnswers % 5 == 0) {
          level++;
        }
        generateQuestion();
      }
    });
  }

  void completeTest() {
    testCompleted = true;
    widget.onTestComplete(
        'Attention Test', totalAttempts, correctAnswers, level);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double optionBoxSize = screenWidth * 0.15;
    int columns =
    (options.length <= 4) ? 2 : 3; // Adjust columns based on difficulty

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6E7),
      appBar: AppBar(
        title: Text("Attention Test"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  "Time Remaining: $timerSeconds s",
                  style: TextStyle(fontSize: 20),
                ),
                Spacer(),
                Text(
                  "Score: ${correctAnswers * 10}",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),

            SizedBox(height: screenHeight * 0.02),
            // Fixed size for the question box
            Container(
              width: 100, // Set a fixed width
              height: 100, // Set a fixed height
              color: questionColor,
            ),
            SizedBox(height: screenHeight * 0.03),
            Text(
              "Select the matching color",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: screenHeight * 0.02),
            Spacer(),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: options.length,
              itemBuilder: (context, index) {
                Color color = options[index];
                return GestureDetector(
                  onTap: () {
                    if (!testCompleted) {
                      onOptionSelected(color);
                    }
                  },
                  child: Container(
                    width: optionBoxSize,
                    height: optionBoxSize,
                    color: color,
                  ),
                );
              },
            ),
            Spacer(),
            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
  }
}
