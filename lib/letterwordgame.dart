import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'dart:async';
import 'dart:math';

class WordFormation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Word Dragging Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFFF8F6E7),
      ),
      home: LetterGame(),
    );
  }
}

class LetterGame extends StatefulWidget {
  @override
  _LetterGameState createState() => _LetterGameState();
}

class _LetterGameState extends State<LetterGame> {
  List<String> selectedLetters = [];
  String currentWord = '';
  int score = 0;
  int timer = 60;
  Random random = Random();
  List<String> wordList = [];
  Timer? countdownTimer;
  bool isGameOver = false;

  @override
  void initState() {
    super.initState();
    generateWordList();
    currentWord = getRandomWord();
    startTimer();
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  void generateWordList() {
    wordList = nouns.take(50).map((word) => word.toLowerCase()).toList();
  }

  String getRandomWord() {
    return wordList[random.nextInt(wordList.length)].toUpperCase();
  }

  void startTimer() {
    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (this.timer > 0) {
          this.timer--;
        } else {
          if (!isGameOver) {
            showEndDialog();
          }
        }
      });
    });
  }

  void resetGame() {
    setState(() {
      this.timer = 60;  // Reset the timer
      score = 0;         // Reset the score
      currentWord = getRandomWord(); // Get a new random word
      selectedLetters.clear();  // Clear selected letters
      isGameOver = false;  // Reset game over state
    });
  }

  void checkWord() {
    String userWord = selectedLetters.join('');

    if (userWord.isEmpty) {
      return;
    }

    if (userWord == currentWord) {
      setState(() {
        score += 10;
        currentWord = getRandomWord(); // Get a new random word
        selectedLetters.clear();
      });

      if (score >= 50) {
        // You can add a congratulatory feature or audio later
      }
    } else {
      showIncorrectDialog(); // Show incorrect answer dialog
      setState(() {
        selectedLetters.clear(); // Clear selected letters for new attempt
        currentWord = getRandomWord(); // New random word after incorrect answer
      });
    }
  }




  void showIncorrectDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
        backgroundColor: const Color(0xFFF8F6E7),
          contentPadding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          title: Text(
            'Incorrect! Try Again!',
            style: TextStyle(fontFamily: 'Poppins', color: Colors.black)
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Text(
                'Score: $score',
  style: TextStyle(fontFamily: 'Poppins', color: Colors.black)
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK', style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF1A9562))),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        );
      },
    );
  }

  void showEndDialog() {
    setState(() {
      isGameOver = true;  // Set the game over state to true
    });

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF8F6E7),
          contentPadding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          title: Text(
            timer == 0 && score > 0 ? 'Well Done!' : 'Time Up!',
            style: const TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (timer == 0 && score > 0)
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

  @override
  Widget build(BuildContext context) {
    List<String> letters = List<String>.generate(26, (index) => String.fromCharCode(index + 65));

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
                'Time: $timer',
                style: TextStyle(fontSize: 16, color: Colors.black, fontFamily: 'Poppins'),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Form this word: $currentWord', style: TextStyle(fontSize: 20, fontFamily: 'Poppins', color: Colors.black)),
          ),
          Expanded(
            child: Center(
              child: DragTarget<String>(
                onAccept: (data) {
                  setState(() {
                    selectedLetters.add(data);
                  });
                },
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    height: 80,
                    width: 300,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      selectedLetters.join(''),
                      style: TextStyle(fontSize: 32, color: Colors.black),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: checkWord,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Color(0xFFD9D9D9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              minimumSize: Size(80, 30),
            ),
            child: Text(
              'Submit',
              style: TextStyle(fontSize: 18, fontFamily: 'Poppins'),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: GridView.count(
                crossAxisCount: 6,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: letters.map((letter) => buildLetter(letter)).toList(),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildLetter(String letter) {
    return Draggable<String>(
      data: letter,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(0xFFffffff),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          letter,
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            letter,
            style: TextStyle(fontSize: 24, color: Colors.black),
          ),
        ),
      ),
      childWhenDragging: Container(),
    );
  }
}
