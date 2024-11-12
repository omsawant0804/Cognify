import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:flutter/scheduler.dart';

void main() => runApp(WaterCatchGameApp());

class WaterCatchGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: WaterCatchGameScreen(),
    );
  }
}

class WaterCatchGameScreen extends StatefulWidget {
  @override
  _WaterCatchGameScreenState createState() => _WaterCatchGameScreenState();
}

class _WaterCatchGameScreenState extends State<WaterCatchGameScreen>
    with SingleTickerProviderStateMixin {
  final double bucketWidth = 200; // Increased bucket width
  final double bucketHeight = 120; // Increased bucket height
  double bucketPosition = 2; // Start at 0 for full width movement
  double dropSize = 80; // Increased drop size
  double _dropSpeed = 2.0; // Starting drop speed
  Random random = Random();

  List<Drop> _drops = [];
  late Ticker _ticker;
  late Timer _dropTimer; // Timer for generating drops
  int _score = 0;
  int _remainingTime = 60; // Timer starts at 60 seconds
  int _currentLevel = 1;

  @override
  void initState() {
    super.initState();
    _startGame();

    // Ticker for updating the game loop smoothly
    _ticker = Ticker(_updateGame);
    _ticker.start();
  }

  void _startGame() {
    _score = 0;
    _remainingTime = 60; // Reset timer
    _drops.clear();
    _startLevel();
    _startTimer(); // Start countdown timer

    // Start generating drops every 800ms
    _dropTimer = Timer.periodic(
        Duration(milliseconds: 800 - (_currentLevel * 50)), (timer) {
      _generateDrop();
    });
  }

  void _startLevel() {
    _drops.clear();
    // Increase speed by doubling the previous speed at each level
    _dropSpeed = 2.0 * _currentLevel; // Start at 2.0, double for each level
  }

  // Generate a single drop
  void _generateDrop() {
    setState(() {
      _drops.add(Drop(
        x: random.nextDouble() * (MediaQuery.of(context).size.width - dropSize),
        y: 0, // Start from top
        isWater: random.nextBool(), // Randomly choose water or poison
      ));
    });
  }

  // Timer function for the countdown
  void _startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        timer.cancel();
        _dropTimer.cancel(); // Stop drops when time runs out
        _showScoreDialog(); // Show score dialog when time is up
      }
    });
  }

  // Show score dialog
  void _showScoreDialog() {
    bool isFinalLevel = _currentLevel == 5; // Check if it's the 5th level

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isFinalLevel ? 'Game Over!' : 'Level $_currentLevel Completed!'),
          content: Text('Your score: $_score'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (isFinalLevel) {
                  // Restart the game if it's the 5th level
                  _resetGame();
                } else {
                  _currentLevel++;
                  _startGame(); // Start the next level
                }
              },
              child: Text(isFinalLevel ? 'Restart' : 'Next Level'),
            ),
          ],
        );
      },
    );
  }

  // Reset game to initial state
  void _resetGame() {
    _currentLevel = 1;
    _startGame();
  }

  // Update game logic: Move drops and check for collision
  void _updateGame(Duration elapsed) {
    setState(() {
      for (int i = _drops.length - 1; i >= 0; i--) {
        Drop drop = _drops[i];
        drop.y += _dropSpeed;

        // Check if drop hits the bucket
        if (drop.y + dropSize >= MediaQuery.of(context).size.height - bucketHeight &&
            drop.x + dropSize >= bucketPosition &&
            drop.x <= bucketPosition + bucketWidth) {
          _score += drop.isWater ? 5 : -5;
          _drops.removeAt(i); // Remove the drop immediately after it hits the bucket
        } else if (drop.y > MediaQuery.of(context).size.height - dropSize) {
          // Let the drop fall off the screen if it doesn't hit the bucket
          _drops.removeAt(i); // Remove it once it falls off the screen
        }
      }
    });
  }

  // Dispose of the ticker and timer to stop game updates
  @override
  void dispose() {
    _ticker.dispose();
    _dropTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side with level and score
            Text(
              'Level: $_currentLevel - Score: $_score',
              style: TextStyle(fontSize: 16), // Same size as time text
            ),
            // Right side with time
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Time: $_remainingTime',
                style: TextStyle(fontSize: 16), // Same size for consistency
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png', // Your background image
              fit: BoxFit.cover,
            ),
          ),
          // Bucket controlled by horizontal drag
          Positioned(
            bottom: 0,
            left: bucketPosition,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  // Update the bucket's position
                  bucketPosition += details.delta.dx;

                  // Clamp the position to ensure the bucket stays within the screen
                  bucketPosition = bucketPosition.clamp(
                      0.0, MediaQuery.of(context).size.width - bucketWidth);
                });
              },
              child: Image.asset(
                'assets/images/bucket.png', // Your water bucket image
                width: bucketWidth,
                height: bucketHeight,
              ),
            ),
          ),
          // Drops falling
          ..._drops.map((drop) => Positioned(
            left: drop.x,
            top: drop.y,
            child: Image.asset(
              drop.isWater
                  ? 'assets/images/waterdrop.png' // Your water drop image
                  : 'assets/images/poisondrop.png', // Your poison drop image
              width: dropSize,
              height: dropSize,
            ),
          )).toList(),
        ],
      ),
    );
  }
}










class Drop {
  double x;
  double y;
  bool isWater;

  Drop({required this.x, required this.y, required this.isWater});
}
