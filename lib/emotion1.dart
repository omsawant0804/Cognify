import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(EmotionGameApp());
}

class EmotionGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: EmotionGameScreen(),
    );
  }
}

class EmotionGameScreen extends StatefulWidget {
  @override
  _EmotionGameScreenState createState() => _EmotionGameScreenState();
}

class _EmotionGameScreenState extends State<EmotionGameScreen> {
  final Map<String, String> _emotions = {
    "Happy": "assets/Emotions/happy.jpg",
    "Sad": "assets/Emotions/sad.jpg",
    "Angry": "assets/Emotions/angry.jpg",
    "Surprised": "assets/Emotions/surprised.jpg",
    "Annoyed": "assets/Emotions/annoyed.jpg",
    "Excited": "assets/Emotions/excited.png",
    "Awkward": "assets/Emotions/awkward.jpg",
    "Confident": "assets/Emotions/confident.jpg",
    "Crying": "assets/Emotions/crying.jpg",
    "Fear": "assets/Emotions/fear.jpg",
    "Laughing": "assets/Emotions/laughing.jpg",
    "Screaming": "assets/Emotions/screaming.png",
    "Disgusted": "assets/Emotions/disgusted.png",
    "Bored": "assets/Emotions/bored.png",
    "Embarrassment": "assets/Emotions/embarrassment.png",
    "Frustration": "assets/Emotions/frustration.png",
    "Curious": "assets/Emotions/curious.png",
    "Relaxed": "assets/Emotions/relaxed.png",
    "Confused": "assets/Emotions/confused.png",
  };

  late String _correctEmotion;
  late List<String> _choices;
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
        _showLevelCompleteDialog(false);
      }
    });
  }

  void playCorrectSound() async {
    await audioPlayer.play(AssetSource('sounds/correct.mp3'));
  }

  void playIncorrectSound() async {
    await audioPlayer.play(AssetSource('sounds/incorrect.mp3'));
  }

  void _generateNewRound() {
    final random = Random();
    List<String> keys = _emotions.keys.toList();
    _correctEmotion = keys[random.nextInt(keys.length)];

    int availableEmotionsCount = 2 + (_currentLevel - 1);
    availableEmotionsCount = min(availableEmotionsCount, keys.length);

    _choices = List.from(keys)..shuffle();
    _choices = _choices.sublist(0, availableEmotionsCount);

    if (!_choices.contains(_correctEmotion)) {
      _choices[random.nextInt(availableEmotionsCount)] = _correctEmotion;
    }

    _feedbackMessage = "";
  }

  void _checkAnswer(String selectedEmotion) {
    if (selectedEmotion == _correctEmotion) {
      setState(() {
        _score += 10;
        _feedbackMessage = "Correct!";
      });

      if (_score >= 50) {
        _showLevelCompleteDialog(true);
      } else {
        _generateNewRound();
      }
    } else {
      setState(() {
        _feedbackMessage = "Incorrect Guess!";
      });
      Future.delayed(Duration(milliseconds: 500), () {
        _generateNewRound();
      });
    }
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
              'Level: $_currentLevel - Score: $_score',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                'Time: $_remainingTime',
                style: TextStyle(fontSize: 16, color: Colors.black),
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
              child: Image.asset(
                _emotions[_correctEmotion]!,
                height: 150,
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
              'Select the matching emotion:',
              style: TextStyle(fontSize: 20, color: Colors.black, fontFamily: 'Poppins'),
            ),
            //SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: _choices.map((choice) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Color(0xFFD9D9D9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        minimumSize: Size(140, 50),
                      ),
                      onPressed: () => _checkAnswer(choice),
                      child: Text(
                        choice,
                        style: TextStyle(fontSize: 18, fontFamily: 'Poppins'),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
