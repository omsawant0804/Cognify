import 'package:cognify_app/clocktime.dart';
import 'package:flutter/material.dart';
// Import your specific reasoning game screens here, e.g.:
// import 'package:cognifydemo3/puzzle_game.dart';
// import 'package:cognifydemo3/sequence_game.dart';
// import 'package:cognifydemo3/pattern_game.dart';

void main() {
  runApp(ReasoningHomeScreenApp());
}

class ReasoningHomeScreenApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reasoning Games',
      theme: ThemeData(
        fontFamily: 'Poppins', // Setting the default font family
      ),
      home: ReasoningHomeScreen(),
    );
  }
}

class ReasoningHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reasoning Games', style: TextStyle(color: Colors.black)),
        backgroundColor: Color(0xFFF8F6E7),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black), // Sets AppBar icon color to black
      ),
      backgroundColor: Color(0xFFF8F6E7), // Background color for the screen
      body: ListView(
        padding: EdgeInsets.all(12.0),
        children: [
          _buildGameTypeSection([
           // _buildGameCard(context, 'Tell Time Game', ClockGame(), '🕒'), // Puzzle emoji
           // Magnifying glass for pattern finding
          ]),
        ],
      ),
    );
  }

  Widget _buildGameTypeSection(List<Widget> games) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        children: games.map((game) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: game,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGameCard(BuildContext context, String gameName, Widget? nextScreen, String emoji) {
    return GestureDetector(
      onTap: () {
        if (nextScreen != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => nextScreen),
          );
        }
      },
      child: Card(
        elevation: 4,
        color: Color(0xFFD9D9D9), // Card color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Optional: rounded corners
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0), // Increased height
          alignment: Alignment.center,
          child: Row(
            children: [
              Text(
                emoji, // Emoji representing the game
                style: TextStyle(fontSize: 24), // Adjust emoji size if necessary
              ),
              SizedBox(width: 12.0), // Space between emoji and game name
              Expanded(
                child: Text(
                  gameName,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
