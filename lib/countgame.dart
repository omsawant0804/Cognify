import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(CountingGame());
}

class CountingGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counting Game',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CountingScreen(),
    );
  }
}

class CountingScreen extends StatefulWidget {
  @override
  _CountingScreenState createState() => _CountingScreenState();
}

class _CountingScreenState extends State<CountingScreen> {
  int _targetCount = 0;
  String _currentObject = '';
  TextEditingController _controller = TextEditingController();
  bool _gameOver = false;
  String _message = '';
  Timer? _timer;
  int _timeLeft = 60;
  int _level = 1;
  int _score = 0;

  List<String> _objectImages = [
    'apple.png',
    'ball.png',
    'banana.png',
    'bicycle.png',
    'box.png',
    'car.png',
    'chair.png',
    'icecream.png',
    'mango.png',
    'pencil.png',
    'strawberry.png',
    'waterbottle.png',
  ];

  @override
  void initState() {
    super.initState();
    _startNewLevel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startNewLevel() {
    _controller.clear();
    _gameOver = false;
    _message = '';
    _targetCount = _level + 2 + (_level - 1);
    _currentObject = _objectImages[Random().nextInt(_objectImages.length)];
    _startTimer(_timeForLevel());
    _objectImages.shuffle(); // Shuffle the images to make them random
  }

  int _timeForLevel() {
    return max(20, 70 - _level * 10); // Dynamic time limit per level
  }

  void _startTimer(int seconds) {
    _timeLeft = seconds;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _gameOver = true;
          _showLevelCompleteDialog();
          _timer?.cancel();
        }
      });
    });
  }

  void _showLevelCompleteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Level Completed!'),
          content: Text('Your score: $_score'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _nextLevel();
              },
              child: Text('Next Level'),
            ),
          ],
        );
      },
    );
  }

  void _checkCount() {
    if (_gameOver) return;

    int userCount = int.tryParse(_controller.text) ?? 0;

    if (userCount == _targetCount) {
      _playCongratsSound();
      _score += _level * 10;
      _message = 'Congrats! You counted correctly!';
      _refreshImages(); // Refresh images after each correct attempt
    } else {
      setState(() {
        _message = 'Wrong! Try Again.';
      });
    }
  }

  // Refreshes the images and selects a new object for the next attempt
  void _refreshImages() {
    setState(() {
      _targetCount = Random().nextInt(10) + 3; // Set a new target count
      _currentObject = _objectImages[Random().nextInt(_objectImages.length)]; // Select a new object
      _controller.clear(); // Clear the input for the next attempt
      _message = ''; // Clear the message
    });
  }

  void _nextLevel() {
    setState(() {
      if (_level < 5) {
        _level++;
        _startNewLevel();
      } else {
        _gameOver = true;
        _message = 'Congratulations! You completed all levels!';
        _timer?.cancel();
      }
    });
  }

  void _playCongratsSound() {
    AudioPlayer player = AudioPlayer();
    player.play(AssetSource('sounds/congrats.mp3')); // Play a sound for correct answer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Level: $_level - Score: $_score',
              style: TextStyle(fontSize: 16),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Time: $_timeLeft',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Count the Objects:", style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Flexible(
              child: SingleChildScrollView(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(_targetCount, (index) {
                    return Image.asset(
                      'assets/images/$_currentObject', // Display the current object
                      width: 80,
                      height: 80,
                    );
                  }),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your count',
                ),
              ),
            ),
            SizedBox(height: 20),

            // Custom styled "Submit Count" button
            Padding(
              padding: const EdgeInsets.all(12),
              child: GestureDetector(
                onTap: _checkCount,
                child: Container(
                  height: 58,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                  ),
                  child: Center(
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),
            Text(_message, style: TextStyle(fontSize: 18, color: Colors.green)),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
