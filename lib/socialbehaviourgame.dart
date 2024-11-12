import 'package:flutter/material.dart';


import 'dart:math';


class ComBehaviourGame extends StatefulWidget {
  @override
  _ComBehaviourGameState createState() => _ComBehaviourGameState();
}

class _ComBehaviourGameState extends State<ComBehaviourGame> {
  List<Question> shuffledQuestions = [];
  int questionIndex = 0;
  int score = 0;

  @override
  void initState() {
    super.initState();
    shuffledQuestions = getShuffledQuestions(); // Shuffle questions on start
  }

  void _checkAnswer(bool isCorrect) {
    setState(() {
      if (isCorrect) {
        score++;
      }
      questionIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (questionIndex >= shuffledQuestions.length) {
      return Scaffold(
        backgroundColor: AppColors.offWhite,
        appBar: AppBar(
          title: Text('Results'),
        ),
        body: Center(
          child: Text(
            "You've completed the test! Your score: $score",
            style: AppTextStyles.headline,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final question = shuffledQuestions[questionIndex];
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        title: Text('Question ${questionIndex + 1}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QuestionWidget(
              questionText: question.questionText,
              correctImage: question.correctImage,
              incorrectImage: question.incorrectImage,
              onAnswerSelected: (isCorrect) => _checkAnswer(isCorrect),
            ),
            SizedBox(height: 20),
            ScoreWidget(score: score),
          ],
        ),
      ),
    );
  }
}


class ComBehvHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Communication Test Game'),
        backgroundColor: AppColors.primary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Let's Take Your Test",
              style: AppTextStyles.headline,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ComBehaviourGame()), // Updated for new class name
                );
              },
              child: Text('Start Game'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}





class QuestionWidget extends StatelessWidget {
  final String questionText;
  final String correctImage;
  final String incorrectImage;
  final Function(bool) onAnswerSelected;

  QuestionWidget({
    required this.questionText,
    required this.correctImage,
    required this.incorrectImage,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
      Text(
      questionText,
      style: TextStyle(fontSize: 20 , color: Colors.black     ),
      textAlign: TextAlign.center,
    ),
    SizedBox(height: 20),
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    GestureDetector(
      onTap: () => onAnswerSelected(true),
      child: Image.asset(correctImage, width: 100),
    ),
      SizedBox(width: 20),
      GestureDetector(
        onTap: () => onAnswerSelected(false),
        child: Image.asset(incorrectImage, width: 100),
      ),
    ],
    ),
      ],
    );
  }
}


class ScoreWidget extends StatelessWidget {
  final int score;

  ScoreWidget({required this.score});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Score: $score',
      style: TextStyle(fontSize: 20),
    );
  }
}


class AppColors {
  static const Color primary = Color(0xFFFFCC80);  // Light orange color
  static const Color offWhite = Color(0xFFF5F5F5);  // Off-white color
}

class AppTextStyles {
  static const TextStyle headline = TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black);
  static const TextStyle body = TextStyle(fontSize: 18, color: Colors.black87);
}





class Question {
  final String questionText;
  final String correctImage;
  final String incorrectImage;

  Question({required this.questionText, required this.correctImage, required this.incorrectImage});
}

List<Question> questions = [
  Question(
    questionText: "What should you do when you greet a friend?",
    correctImage: "assets/combehaviour/greet_a_friend.png",
    incorrectImage: "assets/combehaviour/expressing_thanks.png",
  ),
  Question(
    questionText: "How do you ask for help politely?",
    correctImage: "assets/combehaviour/asking_for_help.png",
    incorrectImage: "assets/combehaviour/greet_a_friend.png",
  ),
  Question(
    questionText: "What you do when someone helps you?",
    correctImage: "assets/combehaviour/expressing_thanks.png",
    incorrectImage: "assets/combehaviour/meeting_new_people.png",
  ),
  Question(
    questionText: "How do you share toys with a friend?",
    correctImage: "assets/combehaviour/sharing_toys.png",
    incorrectImage: "assets/combehaviour/responding_to_instructions.png",
  ),
  Question(
    questionText: "What will you do when meeting new people?",
    correctImage: "assets/combehaviour/meeting_new_people.png",
    incorrectImage: "assets/combehaviour/asking_permission.png",
  ),
  Question(
    questionText: "How do you respond to instructions?",
    correctImage: "assets/combehaviour/responding_to_instructions.png",
    incorrectImage: "assets/combehaviour/listening_to_others.png",
  ),
  Question(
    questionText: "How do you ask for permission to do something?",
    correctImage: "assets/combehaviour/asking_permission.png",
    incorrectImage: "assets/combehaviour/expressing_thanks.png",
  ),
  Question(
    questionText: "What you do when making a request?",
    correctImage: "assets/combehaviour/making_a_request.png",
    incorrectImage: "assets/combehaviour/listening_to_others.png",
  ),
  Question(
    questionText: "How should you listen to others when they speak?",
    correctImage: "assets/combehaviour/listening_to_others.png",
    incorrectImage: "assets/combehaviour/asking_for_help.png",
  ),
  Question(
    questionText: "What should you do if someone is talking?",
    correctImage: "assets/combehaviour/listening_to_others.png",
    incorrectImage: "assetscombehaviour/making_a_request.png",
  ),
];

// Shuffle the questions
List<Question> getShuffledQuestions() {
  final shuffledQuestions = List<Question>.from(questions);
  shuffledQuestions.shuffle(Random());
  return shuffledQuestions;
}

