import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(ShapeGameApp());
}

class ShapeGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: ShapeGameScreen(),
    );
  }
}

class ShapeGameScreen extends StatefulWidget {
  @override
  _ShapeGameScreenState createState() => _ShapeGameScreenState();
}

class _ShapeGameScreenState extends State<ShapeGameScreen> {
  final List<Widget> _shapes = [
    Icon(Icons.circle, size: 100, color: Colors.blueGrey),
    Icon(Icons.square, size: 100, color: Colors.blueGrey),
    Icon(Icons.star, size: 100, color: Colors.blueGrey),
    Icon(Icons.favorite, size: 100, color: Colors.blueGrey),
    Icon(Icons.arrow_forward, size: 100, color: Colors.blueGrey),
    Icon(Icons.arrow_back, size: 100, color: Colors.blueGrey),

    Icon(Icons.rectangle, size: 100, color: Colors.blueGrey), // New shape (rectangle)
    Icon(Icons.pentagon, size: 100, color: Colors.blueGrey), // New shape (pentagon)
    Icon(Icons.hexagon, size: 100, color: Colors.blueGrey), // New shape (hexagon)
    Icon(Icons.cloud, size: 100, color: Colors.blueGrey), //
  ];

  late Widget _correctShape;
  late List<Widget> _choices;
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
    _correctShape = _shapes[random.nextInt(_shapes.length)];
    int availableShapesCount = min(2 + (_currentLevel - 1) * 2, _shapes.length);
    _choices = List.from(_shapes)..shuffle();
    _choices = _choices.sublist(0, availableShapesCount);
    if (!_choices.contains(_correctShape)) {
      _choices[random.nextInt(availableShapesCount)] = _correctShape;
    }
    _feedbackMessage = "";
  }

  void _checkAnswer(Widget selectedShape) {
    if (selectedShape == _correctShape) {
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
                child: _correctShape,
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
              'Select the matching shape:',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                itemCount: _choices.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _checkAnswer(_choices[index]),
                    child: Container(
                      height: 80,
                      width: 80,
                      alignment: Alignment.center,
                      child: _choices[index],
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