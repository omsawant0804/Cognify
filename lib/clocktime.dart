import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(TimeGameApp());
}

class TimeGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      home: ClockGame(),
    );
  }
}

class ClockPainter extends CustomPainter {
  final DateTime time;

  ClockPainter(this.time);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) - 20;

    final backgroundPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, radius + 10, backgroundPaint);

    canvas.drawCircle(center, radius, paint);

    final textStyle = TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'Poppins');
    for (int i = 1; i <= 12; i++) {
      final angle = (i * pi) / 6;
      final x = center.dx + radius * 0.85 * cos(angle - pi / 2);
      final y = center.dy + radius * 0.85 * sin(angle - pi / 2);
      final textSpan = TextSpan(text: i.toString(), style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
    }

    final hour = time.hour % 12;
    final minute = time.minute;

    final hourAngle = (hour + minute / 60) * (pi / 6);
    canvas.drawLine(center,
        Offset(center.dx + radius * 0.5 * cos(hourAngle - pi / 2), center.dy + radius * 0.5 * sin(hourAngle - pi / 2)),
        paint..strokeWidth = 6);

    final minuteAngle = (minute) * (pi / 30);
    canvas.drawLine(center,
        Offset(center.dx + radius * 0.7 * cos(minuteAngle - pi / 2), center.dy + radius * 0.7 * sin(minuteAngle - pi / 2)),
        paint..strokeWidth = 4);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ClockGame extends StatefulWidget {
  @override
  _ClockGameState createState() => _ClockGameState();
}

class _ClockGameState extends State<ClockGame> {
  List<String> options = [];
  late DateTime currentTime;
  late String correctAnswer;
  int score = 0;
  int timerDuration = 60;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    setRandomTime();
    startTimer();
  }

  void setRandomTime() {
    final randomHour = Random().nextInt(12);
    final randomMinute = Random().nextInt(60);
    currentTime = DateTime(0, 0, 0, randomHour, randomMinute);
    correctAnswer = '${randomHour % 12 == 0 ? 12 : randomHour % 12}:${randomMinute.toString().padLeft(2, '0')}';
    generateOptions(correctAnswer);
  }

  void generateOptions(String correct) {
    Set<String> optionSet = {correct};
    while (optionSet.length < 4) {
      String newOption = generateRandomTime();
      optionSet.add(newOption);
    }
    options = optionSet.toList()..shuffle();
  }

  String generateRandomTime() {
    final hour = Random().nextInt(12);
    final minute = Random().nextInt(60);
    return '${hour % 12 == 0 ? 12 : hour}:${minute.toString().padLeft(2, '0')}';
  }

  void checkAnswer(String option) {
    if (option == correctAnswer) {
      setState(() {
        score += 10;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Correct! Score: $score', style: TextStyle(fontFamily: 'Poppins'))));
        setRandomTime();
      });
    } else
    {
      showDialog
        (
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color(0xFFF8F6E7),
            title: Text('Incorrect!', style: TextStyle(fontFamily: 'Poppins', color: Colors.black)),
            content: Text('Try again! The correct answer was $correctAnswer.', style: TextStyle(fontFamily: 'Poppins', color: Colors.black)),
            actions: [
              TextButton(
                child: Text('OK', style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF1A9562))),
                onPressed: () {
                  Navigator.of(context).pop();
                  setRandomTime();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (timerDuration == 0) {
        timer.cancel();
        showEndDialog();
      } else {
        setState(() {
          timerDuration--;
        });
      }
    });
  }

  void resetGame() {
    setState(() {
      score = 0;
      timerDuration = 60;
      setRandomTime();
    });
    startTimer();
  }

  void showEndDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF8F6E7),
          contentPadding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          title: Text(
            timerDuration == 0 && score > 0 ? 'Well Done!' : 'Time Up!',
            style: const TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (timerDuration == 0 && score > 0)
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
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
              child: const Text('Restart', style: TextStyle(color: Color(0xFF1A9562))),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
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
              'Score: $score',
              style: TextStyle(fontSize: 16, color: Colors.black, fontFamily: 'Poppins'),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                'Time: $timerDuration',
                style: TextStyle(fontSize: 16, color: Colors.black, fontFamily: 'Poppins'),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 300,
              child: CustomPaint(
                painter: ClockPainter(currentTime),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'What is the time?',
              style: TextStyle(fontSize: 20, fontFamily: 'Poppins',   color: Colors.black),
            ),



            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // To distribute buttons evenly
              children: options.map((option) {
                return ElevatedButton(
                  onPressed: () => checkAnswer(option),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Color(0xFFD9D9D9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    minimumSize: Size(80, 30), // Adjust size of the button
                  ),
                  child: Text(
                    option,
                    style: TextStyle(fontSize: 18, fontFamily: 'Poppins'),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
