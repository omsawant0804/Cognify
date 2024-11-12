import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class ColorGameScreen extends StatefulWidget {
  @override
  _ColorGameScreenState createState() => _ColorGameScreenState();
}

class _ColorGameScreenState extends State<ColorGameScreen> {
  final List<Color> _customColors = [
    Colors.red[200]!,
    Colors.green[200]!,
    Colors.blue[200]!,
    Colors.yellow[200]!,
    Colors.purple[200]!,
    Colors.orange[200]!,
    Colors.pink[200]!,
    Colors.teal[200]!,
    Colors.brown[200]!,
    Colors.grey[200]!,
  ];

  late Color _correctColor;
  late List<Color> _choices;
  int _score = 0;
  int _currentLevel = 1;
  int _totalScore = 0;
  Timer? _timer;
  int _remainingTime = 60;
  final int _totalLevels = 5;
  String _feedbackMessage = "";

  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    _currentLevel = 1;
    _totalScore = 0;
    _score = 0;
    _generateNewRound();
    _startTimer();
  }

  void _startTimer() {
    _remainingTime = 60;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _remainingTime--;
      });
      if (_remainingTime == 0) {
        _timer?.cancel();
        _showLevelCompleteDialog(false);
      }
    });
  }

  void _generateNewRound() {
    final random = Random();
    _correctColor = _customColors[random.nextInt(_customColors.length)];
    int availableColorsCount = min(2 + (_currentLevel - 1) * 2, _customColors.length);
    _choices = List.from(_customColors)..shuffle();
    _choices = _choices.sublist(0, availableColorsCount);
    if (!_choices.contains(_correctColor)) {
      _choices[random.nextInt(availableColorsCount)] = _correctColor;
    }
    _feedbackMessage = "";
  }

  void _checkAnswer(Color selectedColor) {
    if (selectedColor == _correctColor) {
      setState(() {
        _score += 10; // Increment score by 10
        _feedbackMessage = "Correct!";
      });
      if (_score >= 50) { // Check if score reaches 50 to advance level
        _showLevelCompleteDialog(true);
      } else {
        _generateNewRound();
      }
    } else {
      setState(() {
        _feedbackMessage = "Incorrect Guess!";  // Show incorrect guess message
      });
      Future.delayed(Duration(seconds: 1), () {  // Delay before new question
        _generateNewRound();  // Generate new question
      });
    }
  }

  void playCorrectSound() async {
    await audioPlayer.play(AssetSource('sounds/correct.mp3'));
  }

  void playIncorrectSound() async {
    await audioPlayer.play(AssetSource('sounds/incorrect.mp3'));
  }

  void _showLevelCompleteDialog(bool correct) {
    _timer?.cancel();
    if (correct) {
      playCorrectSound();
      _totalScore += _score;
    } else {
      playIncorrectSound();
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFF8F6E7),
        contentPadding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        title: Text(
          correct ? 'Level Complete!' : 'Time\'s Up!',
          style: const TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (correct)
              Image.asset(
                'assets/images/winkid.png',
                height: 200,
                fit: BoxFit.contain,
              ),
            const SizedBox(height: 16),
            Text(
              'Your Score for Level $_currentLevel: $_score',
              style: const TextStyle(color: Colors.black, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (_currentLevel == _totalLevels) {
                _startGame();
              } else {
                _nextLevel();
              }
            },
            child: Text(
              _currentLevel == _totalLevels ? 'Restart' : 'Next Level',
              style: const TextStyle(color: Color(0xFF1A9562)),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  void _nextLevel() {
    if (_currentLevel < _totalLevels) {
      setState(() {
        _currentLevel++;
        _score = 0;
        _generateNewRound();
        _startTimer();
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    audioPlayer.dispose();
    super.dispose();
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
              'Level: $_currentLevel - Score: $_score',
              style: TextStyle(fontSize: 16, color: Colors.black, fontFamily: 'Poppins'),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                'Time: $_remainingTime',
                style: TextStyle(fontSize: 16, color: Colors.black, fontFamily: 'Poppins'),
              ),
            ),
          ],
        ),
      ),











      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 70),
            Center(
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: _correctColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              _feedbackMessage,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _feedbackMessage == "Correct!" ? Colors.greenAccent : Colors.redAccent,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Select the matching color:',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                itemCount: _currentLevel == _totalLevels ? 10 : _choices.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _currentLevel == _totalLevels ? 5 : 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _checkAnswer(_choices[index]),
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: _choices[index],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
