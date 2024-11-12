import 'package:flutter/material.dart';

class EvaluationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6E7),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 40),
            Text(
              'Evaluation',
              style: TextStyle(
                fontFamily: "Poppins",
                color: Colors.black,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),
            EvaluationCard(title: 'Memory', score: 34),
            EvaluationCard(title: 'Attention', score: 34),
            EvaluationCard(title: 'Reasoning', score: 34),
            EvaluationCard(title: 'Emotional Intelligence', score: 32),
          ],
        ),
      ),
      //Add Bottom NavBar
    );
  }
}

class EvaluationCard extends StatefulWidget {
  final String title;
  final int score;

  EvaluationCard({required this.title, required this.score});

  @override
  _EvaluationCardState createState() => _EvaluationCardState();
}

class _EvaluationCardState extends State<EvaluationCard> {
  bool isExpanded = false;

  void toggleExpand() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: toggleExpand,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFFE0E0E0),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  Row(
                    children: [
                      Text(
                        '${widget.score}%',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      Icon(
                        isExpanded ? Icons.arrow_upward : Icons.arrow_downward,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ],
              ),
              if (isExpanded)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'The ability to store, update, and retrieve information over time',
                        style: TextStyle(color: Colors.black54),
                      ),
                      SizedBox(height: 16),
                      CustomPaint(
                        size: Size(50,
                            100), // Width of the bar and height of the chart
                        painter: VerticalBarChartPainter(widget.score),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class VerticalBarChartPainter extends CustomPainter {
  final int score;

  VerticalBarChartPainter(this.score);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;

    // Calculate the bar height based on the score
    final barHeight = size.height * (score / 100);

    // Draw the vertical bar from the bottom up
    canvas.drawRect(
      Rect.fromLTWH(0, size.height - barHeight, size.width, barHeight),
      paint,
    );

    // Draw the score text above the bar
    final textPainter = TextPainter(
      text: TextSpan(
        text: '$score%',
        style: TextStyle(color: Colors.black, fontSize: 12),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
        canvas, Offset(size.width / 4, size.height - barHeight - 20));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}