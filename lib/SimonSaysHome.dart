import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(SimonSaysHome());
}

class SimonSaysHome extends StatefulWidget {
  @override
  _SimonSaysHomeState createState() => _SimonSaysHomeState();
}

class _SimonSaysHomeState extends State<SimonSaysHome> {
  List<Color> baseColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.cyan,
    Colors.teal,
  ];

  List<Color> colors = [];
  List<int> sequence = [];
  List<int> playerInput = [];
  int score = 0;
  bool isGameActive = false;
  int currentLevel = 1;
  int maxLevels = 5;
  int timeLeft = 60;
  Timer? levelTimer;
  AudioPlayer audioPlayer = AudioPlayer();
  List<bool> isHighlighted = List.filled(8, false);

  @override
  void initState() {
    super.initState();
    startGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6E7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F6E7),
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
              'Level: $currentLevel - Score: $score',
              style: TextStyle(fontSize: 16, color: Colors.black, fontFamily: 'Poppins'),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                'Time: $timeLeft',
                style: TextStyle(fontSize: 16, color: Colors.black, fontFamily: 'Poppins'),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildColorButtons(),
          SizedBox(height: 20),
          if (!isGameActive)
            Text(
              'Follow the sequence and tap the colors!',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Poppins',
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  Widget buildColorButtons() {
    return Column(
      children: [
        for (int i = 0; i < colors.length; i += 2)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildColorButton(i),
              if (i + 1 < colors.length) buildColorButton(i + 1),
            ],
          ),
      ],
    );
  }

  Widget buildColorButton(int index) {
    return GestureDetector(
      onTap: isGameActive ? () => playerTap(index) : null,
      child: Container(
        margin: EdgeInsets.all(10),
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: colors[index],
          borderRadius: BorderRadius.circular(15),
          border: isHighlighted[index] ? Border.all(color: Colors.white, width: 5) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              offset: Offset(2, 2),
              blurRadius: 5,
            ),
          ],
        ),
      ),
    );
  }

  void startGame() {
    score = 0;
    currentLevel = 1;
    startLevel();
  }

  void startLevel() {
    timeLeft = 60;
    score = 0;
    updateColorsForLevel();
    nextRound();
    startTimer();
  }

  void updateColorsForLevel() {
    colors = baseColors.sublist(0, 2 + (currentLevel - 1) * 2);
    isHighlighted = List.filled(colors.length, false);
  }

  void startTimer() {
    levelTimer?.cancel();
    levelTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          resetLevel();
        }
      });
    });
  }

  void nextRound() {
    playerInput.clear();
    sequence.add((colors.length * DateTime.now().millisecondsSinceEpoch) ~/ 1000 % colors.length);
    playSequence();
  }

  void playSequence() {
    isGameActive = false;
    isHighlighted = List.filled(colors.length, false);
    for (int i = 0; i < sequence.length; i++) {
      Timer(Duration(seconds: i), () {
        highlightButton(sequence[i]);
      });
    }
    Timer(Duration(seconds: sequence.length), () {
      isGameActive = true;
    });
  }

  void highlightButton(int index) {
    setState(() {
      isHighlighted[index] = true;
    });
    Timer(Duration(milliseconds: 500), () {
      setState(() {
        isHighlighted[index] = false;
      });
    });
  }

  void playerTap(int index) {
    playerInput.add(index);
    highlightButton(index);
    checkInput();
  }

  void checkInput() {
    for (int i = 0; i < playerInput.length; i++) {
      if (playerInput[i] != sequence[i]) {
        playerInput.clear();
        showEndDialog('Incorrect Sequence!', false);
        return;
      }
    }

    if (playerInput.length == sequence.length) {
      score += 10;

      if (score >= 50) {
        if (currentLevel < maxLevels) {
          showEndDialog('Level $currentLevel Complete!', true);
        } else {
          levelTimer?.cancel();
          setState(() {
            isGameActive = false;
          });
        }
      } else {
        Timer(Duration(seconds: 1), nextRound);
      }
    }
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
            if (isCorrect)
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
          if (!isCorrect)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                startLevel();
              },
              child: const Text('Retry Level', style: TextStyle(color: Color(0xFF1A9562))),
            ),
          if (isCorrect && currentLevel < maxLevels)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  currentLevel++;
                  startLevel();
                });
              },
              child: const Text('Next Level', style: TextStyle(color: Color(0xFF1A9562))),
            ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  void resetLevel() {
    setState(() {
      isGameActive = false;
      timeLeft = 60;
      sequence.clear();
      playerInput.clear();
    });
    startLevel();
  }

  void playCorrectSound() async {
    await audioPlayer.play(AssetSource('sounds/correct.mp3'));
  }

  void playIncorrectSound() async {
    await audioPlayer.play(AssetSource('sounds/incorrect.mp3'));
  }

  @override
  void dispose() {
    levelTimer?.cancel();
    audioPlayer.dispose();
    super.dispose();
  }
}
