import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Match Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MemoryGame(),
    );
  }
}

class MemoryGame extends StatefulWidget {
  @override
  _MemoryGameState createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  List<String> baseIcons = ['🚗', '🌲', '✈️', '🚚', '🏠', '🚀', '🚤', '🚲'];
  List<String> icons = [];
  List<bool> revealed = [];
  List<int> selectedIndexes = [];
  int timeLeft = 60;
  int score = 0;
  int level = 1;
  Timer? timer;
  bool dialogShown = false;
  bool gameEnded = false;

  // Initialize the audio player
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    startLevel();
  }

  void startLevel() {
    setState(() {
      int numPairs = level + 3;
      icons = (baseIcons.take(numPairs).toList() + baseIcons.take(numPairs).toList())..shuffle();
      revealed = List.generate(icons.length, (index) => false);
      selectedIndexes.clear();
      timeLeft = 60; // Reset timer
      score = 0;     // Reset score for each level
      dialogShown = false;
      gameEnded = false;
    });
    startTimer();
  }

  void startTimer() {
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          timer.cancel();
          if (!dialogShown && !gameEnded) {
            gameEnded = true;
            dialogShown = true;
            showEndDialog('Time\'s Up!', false);
          }
        }
      });
    });
  }

  void playCorrectSound() async {
    await audioPlayer.play(AssetSource('sounds/correct.mp3'));
  }

  void playIncorrectSound() async {
    await audioPlayer.play(AssetSource('sounds/incorrect.mp3'));
  }

  void showEndDialog(String message, bool isCorrect) {
    if (isCorrect) {
      playCorrectSound();
    } else {
      playIncorrectSound();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFF8F6E7),
        contentPadding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        title: Text(
          message,
          style: const TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isCorrect) // Show image only for success
              Image.asset(
                'assets/images/winkid.png', // Path to wink image
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
          if (!isCorrect)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                startLevel();
              },
              child: const Text('Retry Level', style: TextStyle(color: Color(0xFF1A9562))),
            ),
          if (isCorrect && level < 5)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  level++;
                  startLevel();
                });
              },
              child: const Text('Next Level', style: TextStyle(color: Color(0xFF1A9562))),
            ),
          if (isCorrect && level == 5)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                restartGame();
              },
              child: const Text('Restart', style: TextStyle(color: Color(0xFF1A9562))),
            ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  void revealCard(int index) {
    if (revealed[index] || selectedIndexes.length == 2) return;

    setState(() {
      revealed[index] = true;
      selectedIndexes.add(index);

      if (selectedIndexes.length == 2) {
        if (icons[selectedIndexes[0]] == icons[selectedIndexes[1]]) {
          score += 10;
          selectedIndexes.clear();

          if (revealed.every((isRevealed) => isRevealed)) {
            timer?.cancel();
            if (!dialogShown && !gameEnded) {
              gameEnded = true;
              dialogShown = true;
              showEndDialog('Level Complete!', true);
            }
          }
        } else {
          Future.delayed(Duration(seconds: 1), () {
            setState(() {
              revealed[selectedIndexes[0]] = false;
              revealed[selectedIndexes[1]] = false;
              selectedIndexes.clear();
            });
          });
        }
      }
    });
  }

  void restartGame() {
    setState(() {
      score = 0;
      level = 1;
      startLevel();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    audioPlayer.dispose();
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
              'Level: $level - Score: $score',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                'Time: $timeLeft',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: icons.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => revealCard(index),
              child: Container(
                color: revealed[index] ? Colors.blueAccent : Colors.grey,
                child: Center(
                  child: Text(
                    revealed[index] ? icons[index] : '',
                    style: const TextStyle(fontSize: 32, color: Colors.white),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
