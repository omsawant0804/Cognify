import 'dart:async';
import 'package:flutter/material.dart';

class MemoryTestScreen extends StatefulWidget {
  final Function(String, int, int, int) onTestComplete;

  MemoryTestScreen({required this.onTestComplete});

  @override
  _MemoryTestScreenState createState() => _MemoryTestScreenState();
}

class _MemoryTestScreenState extends State<MemoryTestScreen> {
  int level = 1;
  int score = 0;
  int totalAttempts = 0;
  int correctAnswers = 0;
  List<String> tileEmojis = [];
  List<int> selectedIndices = []; // Store indices instead of emojis
  List<int> matchedIndices = [];
  int timerSeconds = 90;
  late Timer timer;

  // Emoji set for the tile matching game
  final List<String> emojiSet = [
    "😀",
    "😎",
    "😴",
    "☹",
    "🥶",
    "😹",
    "👻",
    "👽",
    "🐵",
    "🐯",
    "🦊",
    "🐰",
    "🐭",
    "🐮",
    "🐸",
    "🐠",
    "🐬",
    "🐢",
    "🦚",
    "🦩",
    "🦋",
    "🐞",
    "🎈",
    "🎃",
    "🧸",
    "🎵",
    "🍧",
    "🍩",
    "🧁",
    "🍇",
    "🍉",
    "🍊",
    "🍍",
    "🍌",
    "🥭",
    "🍎",
    "🍓",
    "🍒",
    "🍏",
    "🌽",
    "🥦",
    "🥕",
    "🌼",
    "🌻",
    "🌴",
    "🍁",
    "🚗",
    "🛴",
    "🛵",
    "✈",
    "🚢",
    "🪑",
    "🌈",
    "☂",
    "❄",
    "🔥"
  ];

  @override
  void initState() {
    super.initState();
    startNewLevel();
    startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  // Start timer for 90 seconds
  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        if (timerSeconds > 0) {
          timerSeconds--;
        } else {
          timer.cancel();
          endTest();
        }
      });
    });
  }

  // Start a new level with increased grid size
  void startNewLevel() {
    int gridSize = (level + 1); // 2x2 for level 1, 3x3 for level 2, etc.
    int numTiles = gridSize * gridSize ~/ 2; // Pairs count
    List<String> levelEmojis = emojiSet.toList()..shuffle();

    tileEmojis = (levelEmojis.take(numTiles).toList() +
        levelEmojis.take(numTiles).toList());
    tileEmojis.shuffle();
    selectedIndices = [];
    matchedIndices = [];
  }

  // Handle tile selection logic
  void onTileSelected(int index) {
    if (selectedIndices.length < 2 &&
        !matchedIndices.contains(index) &&
        !selectedIndices.contains(index)) {
      setState(() {
        selectedIndices.add(index);
        totalAttempts++;

        // When two tiles are selected, check for a match
        if (selectedIndices.length == 2) {
          if (tileEmojis[selectedIndices[0]] ==
              tileEmojis[selectedIndices[1]]) {
            // Match found
            correctAnswers++;
            matchedIndices.addAll([selectedIndices[0], selectedIndices[1]]);
            score += 10;
            selectedIndices.clear();

            // If all pairs are matched, complete the level
            if (matchedIndices.length == tileEmojis.length) {
              showLevelCompleteDialog();
            }
          } else {
            // No match, clear selection after a brief delay
            Future.delayed(Duration(milliseconds: 500), () {
              setState(() {
                selectedIndices.clear();
              });
            });
          }
        }
      });
    }
  }

  // Show dialog for successful level completion
  void showLevelCompleteDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Level Complete!"),
        content: Text("Great job! Proceeding to the next level."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                level++;
                startNewLevel();
              });
            },
            child: Text("Next Level"),
          ),
        ],
      ),
    );
  }

  // End test and return to PreAssessmentScreen
  void endTest() {
    widget.onTestComplete(
        'Memory Test', totalAttempts ~/ 2, correctAnswers, level);
    Navigator.pop(context);
  }

  // Render each tile
  Widget buildTile(int index) {
    bool isMatched = matchedIndices.contains(index);
    bool isSelected = selectedIndices.contains(index);

    return GestureDetector(
      onTap: () => onTileSelected(index),
      child: Container(
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isMatched || isSelected ? Colors.white : Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(2),
          boxShadow: [
            BoxShadow(
                color: Colors.black26, blurRadius: 2, offset: Offset(2, 2)),
          ],
        ),
        child: Center(
          child: Text(
            isMatched || isSelected ? tileEmojis[index] : '',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int gridSize = (level + 1);
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6E7),
      appBar: AppBar(title: Text("Memory Test - Level $level")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text("Score: $score", style: TextStyle(fontSize: 20)),
                    Spacer(),
                    Text("Time Remaining: $timerSeconds s",
                        style: TextStyle(fontSize: 20)),
                  ],
                ),
                SizedBox(height: 10),
                Text("Match the pairs!",
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridSize,
              ),
              itemCount: tileEmojis.length,
              itemBuilder: (context, index) => buildTile(index),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: endTest,
            child: Text("End Test"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}