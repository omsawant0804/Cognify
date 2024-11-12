import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BirdQuizScreen(),
    );
  }
}

class BirdQuizScreen extends StatefulWidget {
  @override
  _BirdQuizScreenState createState() => _BirdQuizScreenState();
}

class _BirdQuizScreenState extends State<BirdQuizScreen> {
  final List<Map<String, dynamic>> animals = [
    {'name': 'Eagle', 'emoji': '🦅', 'image': 'assets/birdimg/eagle.png'},
    {'name': 'Parrot', 'emoji': '🦜', 'image': 'assets/birdimg/parrot.png'},
    {'name': 'Owl', 'emoji': '🦉', 'image': 'assets/birdimg/owl.png'},
    {'name': 'Penguin', 'emoji': '🐧', 'image': 'assets/birdimg/Penguin.png'},
    {'name': 'Swan', 'emoji': '🦢', 'image': 'assets/birdimg/swan.png'},
    {'name': 'Chicken', 'emoji': '🐔', 'image': 'assets/birdimg/Chicken.png'},
    {'name': 'Peacock', 'emoji': '🦚', 'image': 'assets/birdimg/peacock.png'},
    {'name': 'Duck', 'emoji': '🦆', 'image': 'assets/birdimg/duck.png'},
    {'name': 'Flamingo', 'emoji': '🦩', 'image': 'assets/birdimg/flamingo.png'},
    {'name': 'Hummingbird', 'emoji': '🐦', 'image': 'assets/birdimg/humming bird.png'},
    {'name': 'Pigeon', 'emoji': '🐦', 'image': 'assets/birdimg/pigeon.png'},
    {'name': 'Woodpecker', 'emoji': '🐦', 'image': 'assets/birdimg/woodpecker.png'},
    {'name': 'Sparrow', 'emoji': '🐦', 'image': 'assets/birdimg/sparrow.png'},
    {'name': 'Crow', 'emoji': '🐦', 'image': 'assets/birdimg/crow.png'},
    {'name': 'Kingfisher', 'emoji': '🐦', 'image': 'assets/birdimg/kingfisher.png'},
    {'name': 'Pelican', 'emoji': '🐦', 'image': 'assets/birdimg/pelican.png'},
    {'name': 'Ostrich', 'emoji': '🦤', 'image': 'assets/birdimg/Ostrich.png'},
    {'name': 'Toucan', 'emoji': '🦜', 'image': 'assets/birdimg/toucan.png'},

  ];

  int score = 0;
  Map<String, dynamic>? currentAnimal;
  List<String> options = [];
  int timeRemaining = 60;
  Timer? countdownTimer;

  @override
  void initState() {
    super.initState();
    generateQuestion();
    startTimer();
  }

  void generateQuestion() {
    final random = Random();
    currentAnimal = animals[random.nextInt(animals.length)];

    Set<String> optionNames = {currentAnimal!['name']};
    while (optionNames.length < 4) {
      optionNames.add(animals[random.nextInt(animals.length)]['name']);
    }
    options = optionNames.toList()..shuffle();

    setState(() {}); // Update the UI with the new question
  }

  void checkAnswer(String answer) {
    if (answer == currentAnimal!['name']) {
      setState(() {
        score += 10; // Increase score for correct answer
      });
      generateQuestion(); // Load a new question
    } else {
      showIncorrectAnswerDialog(); // Show incorrect dialog and change question after dialog
    }
  }

  void showIncorrectAnswerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF8F6E7),
          title: Text('Incorrect!', style: TextStyle(fontFamily: 'Poppins', color: Colors.black)),
          content: Text(
            'Try again! The correct answer was ${currentAnimal!['name']}',
            style: TextStyle(fontFamily: 'Poppins', color: Colors.black),
          ),
          actions: [
            TextButton(
              child: Text('OK', style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF1A9562))),
              onPressed: () {
                Navigator.of(context).pop();
                generateQuestion(); // Generate a new question after dialog closes
              },
            ),
          ],
        );
      },
    );
  }

  void startTimer() {
    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeRemaining > 0) {
        setState(() {
          timeRemaining--;
        });
      } else {
        countdownTimer?.cancel();
        showEndDialog();
      }
    });
  }

  void showEndDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF8F6E7),
          contentPadding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          title: Text(
            timeRemaining == 0 && score > 0 ? 'Well Done!' : 'Time Up!',
            style: const TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (timeRemaining == 0 && score > 0)
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

  void resetGame() {
    setState(() {
      score = 0;
      timeRemaining = 60;
      generateQuestion();
    });
    startTimer();
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
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
              style: TextStyle(fontFamily: 'Poppins', fontSize: 16, color: Colors.black),
            ),
            Text(
              'Time: $timeRemaining',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Which animal is this?',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 20, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Image.asset(
                currentAnimal!['image'],
                height: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              Column(
                children: options.map((option) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SizedBox(
                      width: 200, // Fixed width for all option buttons
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: const Color(0xFFD9D9D9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          option,
                          style: TextStyle(fontFamily: 'Poppins', color: Colors.black, fontSize: 18),
                        ),
                        onPressed: () => checkAnswer(option),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }}
