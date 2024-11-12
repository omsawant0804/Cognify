import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:cognify_app/task.dart';
import 'package:cognify_app/task_card.dart';

class BehaviorTestScreen extends StatefulWidget {
  final Function(String, int, int, int)
  onTestCompleted; // Callback to handle results
  BehaviorTestScreen({required this.onTestCompleted});

  @override
  _BehaviorTestScreenState createState() => _BehaviorTestScreenState();
}

class _BehaviorTestScreenState extends State<BehaviorTestScreen> {
  List<Task> allTasks = [
    Task('Wake up', 'assets/morningroutine/wakeup.png'),
    Task('Brush Teeth', 'assets/morningroutine/brush_teeth.png'),
    Task('Take Shower', 'assets/morningroutine/take_shower.png'),
    Task('Get Dressed', 'assets/morningroutine/get_dressed.png'),
    Task('Have Breakfast', 'assets/morningroutine/have_breakfast.png'),
    Task('Pack Bag', 'assets/morningroutine/pack_bag.png'),
    Task('Put on Shoes', 'assets/morningroutine/put_on_shoes.png'),
    Task('Go to school', 'assets/morningroutine/gotoschool.png'),
  ];

  int currentLevel = 1;
  late List<Task> tasks;
  List<Task> userOrder = [];
  int score = 0;
  int totalAttempts = 0; // Track total attempts
  int correctAnswers = 0; // Track correct answers
  int secondsRemaining = 90; // Fixed timer for 90 seconds
  late Timer timer;
  bool dialogShown = false;
  bool gameEnded = false;

  // Initialize audio player
  // AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    startLevel(currentLevel);
    startTimer(); // Start timer only once at the beginning
  }

  void startLevel(int level) {
    setState(() {
      dialogShown = false;
      gameEnded = false;
      tasks = getTasksForLevel(level);
      userOrder = List.from(tasks);
      userOrder.shuffle(Random());
    });
  }

  List<Task> getTasksForLevel(int level) {
    return allTasks.sublist(
        0, level + 2); // Dynamically select tasks based on level
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        timer.cancel();
        endBehaviorTest(); // Directly end the test when time is up
      }
    });
  }

  void endBehaviorTest() {
    widget.onTestCompleted(
        "Behavior Test", totalAttempts, correctAnswers, currentLevel);
    Future.delayed(Duration(milliseconds: 100), () {
      Navigator.pop(context); // Navigate back to pre-assessment screen
    }); // Navigate back to pre-assessment screen
  }

  // Play correct sound
  void playCorrectSound() async {
    // await audioPlayer.play(AssetSource('sounds/correct.mp3'));
  }

  // Play incorrect sound
  void playIncorrectSound() async {
    // await audioPlayer.play(AssetSource('sounds/incorrect.mp3'));
  }

  void submitOrder() {
    if (gameEnded) return;

    bool isCorrect = true;

    for (int i = 0; i < tasks.length; i++) {
      if (userOrder[i].name != tasks[i].name) {
        isCorrect = false;
        break;
      }
    }

    setState(() {
      score += isCorrect ? 10 : 0;
      totalAttempts++; // Increment total attempts
      if (isCorrect) {
        correctAnswers++; // Increment correct answers
        currentLevel++; // Advance to the next level on correct answer
      }
    });

    String message = isCorrect ? 'Well Done!' : 'Try Again!';
    if (!dialogShown && !gameEnded) {
      //gameEnded = true;
      dialogShown = true;
      showEndDialog(message, isCorrect);
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
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF8F6E7),
        contentPadding:
        const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
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
                'assets/morningroutine/winkid.png',
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
              Navigator.pop(context);
              if (isCorrect) {
                startLevel(currentLevel); // Start the next level if correct
              } else {
                startLevel(currentLevel); // Restart current level if incorrect
              }
            },
            child: Text(
              isCorrect ? 'Next Level' : 'Try Again',
              style: TextStyle(color: Color(0xFF1A9562)),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
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
              'Level: $currentLevel - Score: $score',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                'Time: $secondsRemaining',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: const Color(0xFFF8F6E7),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Task List
            Expanded(
              child: Container(
                color: Colors.transparent,
                child: ReorderableListView.builder(
                  itemCount: userOrder.length,
                  itemBuilder: (context, index) {
                    final task = userOrder[index];
                    return Padding(
                      key: ValueKey(task.name),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TaskCard(
                            taskName: task.name, imagePath: task.imagePath),
                      ),
                    );
                  },
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (newIndex > oldIndex) newIndex--;
                      final Task task = userOrder.removeAt(oldIndex);
                      userOrder.insert(newIndex, task);
                    });
                  },
                  buildDefaultDragHandles: true,
                ),
              ),
            ),
            // Submit Button with updated style
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                onPressed: submitOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1A9562),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                ),
                child: Text('Submit Order', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}