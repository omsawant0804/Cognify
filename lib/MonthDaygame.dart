import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(DayMonthYearGameApp());
}

class DayMonthYearGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Day/Month/Year Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      home: DayMonthYearGame(),
    );
  }
}

class DayMonthYearGame extends StatefulWidget {
  @override
  _DayMonthYearGameState createState() => _DayMonthYearGameState();
}

class _DayMonthYearGameState extends State<DayMonthYearGame> {
  List<String> options = [];
  late String correctAnswer;
  int score = 0;
  int timerDuration = 60;
  late Timer timer;
  String question = ''; // This will hold the question text

  final List<String> days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  final List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

  @override
  void initState() {
    super.initState();
    setRandomQuestion();
    startTimer();
  }

  void setRandomQuestion() {
    final randomType = Random().nextInt(4); // Adjusted to 4 for variety of questions

    if (randomType == 0) {
      // Random "What comes after" day question
      final randomDayIndex = Random().nextInt(7);
      final currentDay = days[randomDayIndex];
      final nextDay = days[(randomDayIndex + 1) % 7];
      question = 'What comes after $currentDay?';
      correctAnswer = nextDay;
      generateOptions(correctAnswer, days);
    } else if (randomType == 1) {
      // Random "How many days in week" question
      question = 'How many days are there in a week?';
      correctAnswer = '7';
      generateOptions(correctAnswer, ['6', '7', '8', '5']);
    } else if (randomType == 2) {
      // Random "How many months in year" question
      question = 'How many months are there in a year?';
      correctAnswer = '12';
      generateOptions(correctAnswer, ['10', '12', '14', '11']);
    } else {
      // Random "Total days in a specific month" question
      final randomMonth = months[Random().nextInt(12)];
      int daysInMonth = getDaysInMonth(randomMonth);
      question = 'How many days are in $randomMonth?';
      correctAnswer = '$daysInMonth';
      generateOptions(correctAnswer, ['28', '30', '31', '29']);
    }

    setState(() {
      options.shuffle();  // Shuffle the options to randomize them
    });
  }

  void generateOptions(String correct, List<String> optionsList) {
    Set<String> optionSet = {correct};
    while (optionSet.length < 4) {
      String newOption = optionsList[Random().nextInt(optionsList.length)];
      optionSet.add(newOption);
    }
    options = optionSet.toList()..shuffle();
  }

  void checkAnswer(String option) {
    if (option == correctAnswer) {
      setState(() {
        score += 10;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Correct! Score: $score', style: TextStyle(fontFamily: 'Poppins'))));
        setRandomQuestion();
      });
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color(0xFFF8F6E7),
            title: Text('Incorrect!', style: TextStyle(fontFamily: 'Poppins', color: Colors.black)),
            content: Text('Try again! The correct answer was $correctAnswer.', style: TextStyle(fontFamily: 'Poppins', color: Colors.black)),
            actions: [
              TextButton(
                child: Text('OK', style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF1A9562))),
                onPressed: () {
                  Navigator.of(context).pop();
                  setRandomQuestion();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (timerDuration == 0) {
        timer.cancel();
        showEndDialog();
      } else {
        setState(() {
          timerDuration--;
        });
      }
    });
  }

  void resetGame() {
    setState(() {
      score = 0;
      timerDuration = 60;
      setRandomQuestion();
    });
    startTimer();
  }

  void showEndDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF8F6E7),
          contentPadding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          title: Text(
            timerDuration == 0 && score > 0 ? 'Well Done!' : 'Time Up!',
            style: const TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (timerDuration == 0 && score > 0)
                Image.asset(
                  'assets/images/winkid.png',
                  height: 200,
                  fit: BoxFit.contain,
                ),
              const SizedBox(height: 16),
              Text(
                'Your score: $score',
                style: const TextStyle(color: Colors.black, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
              child: const Text('Restart', style: TextStyle(color: Color(0xFF1A9562))),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        );
      },
    );
  }

  int getDaysInMonth(String month) {
    const monthDays = {
      'January': 31, 'February': 28, 'March': 31, 'April': 30, 'May': 31,
      'June': 30, 'July': 31, 'August': 31, 'September': 30, 'October': 31,
      'November': 30, 'December': 31
    };
    // For simplicity, we won't check for leap years
    return monthDays[month]!;
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6E7),
      appBar: AppBar(
        backgroundColor: Color(0xFFF8F6E7),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Score: $score',
              style: TextStyle(fontSize: 16, color: Colors.black, fontFamily: 'Poppins'),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                'Time: $timerDuration',
                style: TextStyle(fontSize: 16, color: Colors.black, fontFamily: 'Poppins'),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Text(
              question,  // Display the question here
              style: TextStyle(fontSize: 20, fontFamily: 'Poppins', color: Colors.black),
            ),
            const SizedBox(height: 20),
            // Use Wrap widget for better alignment
            Wrap(
              spacing: 20.0, // Horizontal spacing between buttons
              runSpacing: 20.0, // Vertical spacing between buttons
              alignment: WrapAlignment.center,
              children: List.generate(4, (index) {
                return ElevatedButton(
                  onPressed: () => checkAnswer(options[index]),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Color(0xFFD9D9D9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: Text(
                    options[index],
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
