import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Good Choices Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins', // Set the global font family to Poppins
      ),
      home: BehaviorGameScreen(),
    );
  }
}

class BehaviorGameScreen extends StatefulWidget {
  @override
  _BehaviorGameScreenState createState() => _BehaviorGameScreenState();
}

class _BehaviorGameScreenState extends State<BehaviorGameScreen> {
  int currentQuestionIndex = 0;
  int score = 0;
  bool isAnswerChecked = false;

  final List<Map<String, dynamic>> questions = [
    {
      'questionImage': 'assets/behaviour/time mgt que.png',
      'statement': 'You have homework to do, but your favorite show is on TV. What should you choose to do?',
      'options': [
        {
          'image': 'assets/behaviour/time mgt correct.png',
          'text': 'Do the Homework',
          'isCorrect': true,
        },
        {
          'image': 'assets/behaviour/time mgt incorrect.png',
          'text': 'Watch show on TV',
          'isCorrect': false,
        },
      ]
    },
    {
      'questionImage': 'assets/behaviour/take toy que.png',
      'statement': 'Imagine you see a shiny toy in a store, You really want to take it. What would you do?',
      'options': [
        {
          'image': 'assets/behaviour/take toy correct.png',
          'text': 'Wait for parents',
          'isCorrect': true,
        },
        {
          'image': 'assets/behaviour/take toy incorrect.png',
          'text': 'Take toy',
          'isCorrect': false,
        },
      ]
    },


    {
      'questionImage': 'assets/behaviour/take toy que.png',
      'statement': 'Imagine you see a shiny toy in a store, You really want to take it. What would you do?',
      'options': [
        {
          'image': 'assets/behaviour/take toy correct.png',
          'text': 'Wait for parents',
          'isCorrect': true,
        },
        {
          'image': 'assets/behaviour/take toy incorrect.png',
          'text': 'Take toy',
          'isCorrect': false,
        },
      ]
    },
    {
      'questionImage': 'assets/behaviour/pick litter que.png',
      'statement': 'You see litter on the playground. What should you do?',
      'options': [
        {
          'image': 'assets/behaviour/pick litter correct.png',
          'text': 'Throw in trash',
          'isCorrect': true,
        },
        {
          'image': 'assets/behaviour/pick litter incorrect.png',
          'text': 'Ignore it',
          'isCorrect': false,
        },
      ]
    },
    {
      'questionImage': 'assets/behaviour/drop book que.png',
      'statement': 'A classmate drops their books and needs help. What is the right choice?',
      'options': [
        {
          'image': 'assets/behaviour/drop book help.png',
          'text': 'Help to pick book',
          'isCorrect': true,
        },
        {
          'image': 'assets/behaviour/drop book ignore.png',
          'text': 'Ignore it',
          'isCorrect': false,
        },
      ]
    },
    {
      'questionImage': 'assets/behaviour/safety que.png',
      'statement': 'You want to ride your bike to the park. Its getting dark outside. What should you do?',
      'options': [
        {
          'image': 'assets/behaviour/safety and correct.png',
          'text': 'Wait until morning',
          'isCorrect': true,
        },
        {
          'image': 'assets/behaviour/safety and incorrect.png',
          'text': 'Go to the park',
          'isCorrect': false,
        },
      ]
    },
    /*
    {
      'questionImage': 'assets/behaviour/sharing que.png',
      'statement': 'You have a game that everyone wants to play. What should you do?',
      'options': [
        {
          'image': 'assets/behaviour/sharing and correct.png',
          'text': 'Share the game',
          'isCorrect': true,
        },
        {
          'image': 'assets/behaviour/sharing and incorrect.png',
          'text': 'Keep game to yourself',
          'isCorrect': false,
        },
      ]
    },*/
    {
      'questionImage': 'assets/behaviour/emotion regulation que.png',
      'statement': ' You feel angry because a friend didn’t share their toy. What should you do?',
      'options': [
        {
          'image': 'assets/behaviour/emotion regulation correct answer.png',
          'text': 'Request friend to share',
          'isCorrect': true,
        },
        {
          'image': 'assets/behaviour/emotion registration incorrect answer.png',
          'text': 'Yell at your friend',
          'isCorrect': false,
        },
      ]
    },
    {
      'questionImage': 'assets/behaviour/friendship deliemma que.png',
      'statement': 'Your friend wants you to skip class and go play instead. What is the best choice?',
      'options': [
        {
          'image': 'assets/behaviour/friendshipcorrect.png',
          'text': 'Play after class.',
          'isCorrect': true,
        },
        {
          'image': 'assets/behaviour/friendshipincorrect.png',
          'text': 'Skip class to play.',
          'isCorrect': false,
        },
      ]
    },
    {
      'questionImage': 'assets/behaviour/peer pressure que.png',
      'statement': 'Your friends are teasing someone at school. What’s the right choice?',
      'options': [
        {
          'image': 'assets/behaviour/peer pressure and correct.png',
          'text': 'Stand up for person being teased',
          'isCorrect': true,
        },
        {
          'image': 'assets/behaviour/peer pressure and incorrect.png',
          'text': 'Join in wih teasing',
          'isCorrect': false,
        },
      ]
    },
    {
      'questionImage': 'assets/behaviour/personal que.png',
      'statement': 'You want to hug a friend, but they look uncomfortable. What should you do?',
      'options': [
        {
          'image': 'assets/behaviour/personal correct.png',
          'text': 'Ask your friend if they want hug',
          'isCorrect': true,
        },
        {
          'image': 'assets/behaviour/personal que inc.png',
          'text': 'Hug them without asking',
          'isCorrect': false,
        },
      ]
    },

    // More questions here...
  ];

  void _checkAnswer(bool isCorrect) {
    setState(() {
      isAnswerChecked = true;
    });
    if (isCorrect) {
      setState(() {
        score += 10;  // Adds 10 points for each correct answer
      });

      // Show SnackBar for correct answer
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Correct! You earned 10 points.'),
          backgroundColor: Color(0xFFD9D9D9),
        ),
      );
    } else {
      // Show incorrect answer dialog
      _showIncorrectDialog();
    }

    // Delay before moving to the next question
    Future.delayed(Duration(seconds: 1), _nextQuestion);
  }

  void _nextQuestion() {
    setState(() {
      isAnswerChecked = false;
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        _showWinkidDialog();
      }
    });
  }

  void _showIncorrectDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFFF8F6E7),
        title: Text(
          "Incorrect!",
          style: TextStyle(color: Colors.black),
        ),
        content: Text(
          'Try again! The correct answer was ${(questions[currentQuestionIndex]['options'] as List<Map<String, dynamic>>).firstWhere((option) => option['isCorrect'])['text']}.',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            child: Text('OK', style: TextStyle(color: Colors.black)),
            onPressed: () {
              Navigator.of(context).pop();
              _nextQuestion();
            },
          ),
        ],
      ),
    );
  }

  void _showWinkidDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFFF8F6E7),
        title: Text(
          "Well Done!",
          style: TextStyle(color: Colors.black),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/winkid.png', height: 200, fit: BoxFit.contain),
            SizedBox(height: 10),
            Text(
              'Your score : $score.',
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Restart', style: TextStyle(color: Colors.black)),
            onPressed: () {
              Navigator.of(context).pop();
              _restartGame();
            },
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  void _restartGame() {
    setState(() {
      currentQuestionIndex = 0;
      score = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      backgroundColor: Color(0xFFF8F6E7),
      appBar: AppBar(
        backgroundColor: Color(0xFFF8F6E7),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Score: $score',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(currentQuestion['questionImage'], height: 150),
            SizedBox(height: 30),
            Text(
              currentQuestion['statement'],
              style: TextStyle(fontSize: 20, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Column(
              children: currentQuestion['options'].map<Widget>((option) {
                return OptionWidget(
                  option: option,
                  onTap: isAnswerChecked ? null : () => _checkAnswer(option['isCorrect']),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class OptionWidget extends StatelessWidget {
  final Map<String, dynamic> option;
  final VoidCallback? onTap;

  const OptionWidget({Key? key, required this.option, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: double.infinity, // Full width of parent
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0.7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Image.asset(option['image'], height: 40),
                SizedBox(width: 10),
                Expanded( // Ensures that text doesn't overflow
                  child: Text(
                    option['text'],
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    softWrap: true, // Allow text to wrap
                    overflow: TextOverflow.ellipsis, // In case of long text, truncate
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
