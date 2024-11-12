import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(AlphabetHuntGame());
}

class AlphabetHuntGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AlphabetHunt(),
    );
  }
}

class AlphabetHunt extends StatefulWidget {
  @override
  _AlphabetHuntState createState() => _AlphabetHuntState();
}

class _AlphabetHuntState extends State<AlphabetHunt> {
  List<String> allLetters = List.generate(26, (index) => String.fromCharCode(65 + index));
  String targetLetter = '';
  List<String> displayedLetters = [];
  int score = 0;
  bool isCorrect = false;
  bool hasTapped = false;
  Timer? timer;
  int timeLeft = 60;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _generateNewGame();
  }

  @override
  void dispose() {
    timer?.cancel(); // Cancel timer when widget is disposed
    super.dispose();
  }

  void _startTimer() {
    timeLeft = 60;
    timer?.cancel(); // Cancel any existing timer
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          timer.cancel();
          _showTimesUpDialog();
        }
      });
    });
  }

  void _showTimesUpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Time's Up!"),
        content: Text("Your score: $score"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startTimer();
              _generateNewGame();
              setState(() {
                score = 0;
              });
            },
            child: Text("Restart"),
          ),
        ],
      ),
    );
  }

  void _generateNewGame() {
    setState(() {
      displayedLetters = List.from(allLetters)..shuffle();
      displayedLetters = displayedLetters.sublist(0, Random().nextInt(5) + 6);
      targetLetter = displayedLetters[Random().nextInt(displayedLetters.length)];
      isCorrect = false;
      hasTapped = false;
      _startTimer();
    });
  }

  void _onLetterTapped(String letter) {
    setState(() {
      hasTapped = true;
      if (letter == targetLetter) {
        isCorrect = true;
        score++;
        Future.delayed(Duration(seconds: 1), () {
          _generateNewGame();
        });
      } else {
        isCorrect = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(







      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Score: $score',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Time: $timeLeft',
              style: TextStyle(
                fontSize: 18,
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),









        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.black87),
            onPressed: () {
              _generateNewGame();
            },
          )
        ],
      ),















      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                "Find the letter:",
                style: TextStyle(fontSize: 20, color: Colors.black54),
              ),
            ),
            Text(
              targetLetter,
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1.2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemCount: displayedLetters.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _onLetterTapped(displayedLetters[index]),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: displayedLetters[index] == targetLetter
                              ? Colors.green
                              : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          displayedLetters[index],
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            if (hasTapped)
              AnimatedOpacity(
                opacity: hasTapped ? 1.0 : 0.0,
                duration: Duration(milliseconds: 300),
                child: Text(
                  isCorrect ? "Correct!" : "Try Again!",
                  style: TextStyle(
                    color: isCorrect ? Colors.green : Colors.red,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
