import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cognify_app/task.dart';
import 'package:cognify_app/task_card.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final List<Task> allTasks = [
    Task('Wake up', 'assets/images/wakeup.png'),
    Task('Brush Teeth', 'assets/images/brush_teeth.png'),
    Task('Take Shower', 'assets/images/take_shower.png'),
    Task('Get Dressed', 'assets/images/get_dressed.png'),
    Task('Have Breakfast', 'assets/images/have_breakfast.png'),
    Task('Pack Bag', 'assets/images/pack_bag.png'),
    Task('Put on Shoes', 'assets/images/put_on_shoes.png'),
    Task('Go to School', 'assets/images/gotoschool.png'),
  ];

  int currentLevel = 1;
  List<Task> tasks = [];
  List<Task> userOrder = [];
  int score = 0;
  int secondsRemaining = 60;
  Timer? timer;
  bool dialogShown = false;
  bool gameEnded = false;

  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    startLevel(currentLevel);
  }

  void startLevel(int level) {
    setState(() {
      dialogShown = false;
      gameEnded = false;
      tasks = getTasksForLevel(level);
      userOrder = List.from(tasks)..shuffle(Random());
      resetTimer();
      startTimer();
    });
  }

  void resetTimer() {
    secondsRemaining = 60; // Set timer to 60 seconds for each level
  }

  List<Task> getTasksForLevel(int level) {
    return allTasks.sublist(0, level + 2); // Dynamically select tasks based on level
  }

  void startTimer() {
    timer?.cancel(); // Ensure the previous timer is canceled before starting a new one
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        timer.cancel();
        if (!dialogShown && !gameEnded) {
          gameEnded = true;
          dialogShown = true;
          showEndDialog('Time\'s Up!', false);
        }
      }
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
      builder: (context) => AlertDialog(
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
                Navigator.pop(context);
                startLevel(currentLevel);
              },
              child: const Text('Try Again', style: TextStyle(color: Color(0xFF1A9562))),
            ),
          if (isCorrect && currentLevel < 5)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                nextLevel();
              },
              child: const Text('Next Level', style: TextStyle(color: Color(0xFF1A9562))),
            ),
          if (isCorrect && currentLevel == 5)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
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

  void nextLevel() {
    if (currentLevel < 5) {
      setState(() {
        currentLevel++;
        startLevel(currentLevel);
      });
    }
  }

  void restartGame() {
    setState(() {
      score = 0;
      currentLevel = 1;
      startLevel(currentLevel);
    });
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
    });

    String message = isCorrect ? 'Well Done!' : 'Try Again!';
    if (!dialogShown && !gameEnded) {
      gameEnded = true;
      dialogShown = true;
      showEndDialog(message, isCorrect);
    }
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
            Expanded(
              child: Container(
                color: Colors.transparent,
                child: ReorderableListView.builder(
                  itemCount: userOrder.length,
                  itemBuilder: (context, index) {
                    final task = userOrder[index];
                    return Padding(
                      key: ValueKey(task.name),
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TaskCard(taskName: task.name, imagePath: task.imagePath),
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
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                onPressed: submitOrder,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Color(0xFFD9D9D9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 12),
                  minimumSize: Size(80, 30),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    audioPlayer.dispose();
    super.dispose();
  }
}
