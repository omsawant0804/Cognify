import 'package:cognify_app/SimonSaysHome.dart';
import 'package:flutter/material.dart';
import 'package:cognify_app/Bird.dart';
import 'package:cognify_app/Seacreatures.dart';
import 'package:cognify_app/animal.dart';
import 'package:cognify_app/catchwater.dart';
import 'package:cognify_app/clocktime.dart';
import 'package:cognify_app/countgame.dart';
import 'package:cognify_app/emotion1.dart';
import 'package:cognify_app/game_screen.dart';
import 'package:cognify_app/goodbehaviourgame.dart';
import 'package:cognify_app/lettergame.dart';
import 'package:cognify_app/mathgame.dart';
import 'package:cognify_app/memorymatch.dart';
import 'package:cognify_app/shapegame.dart';


void main() {
  runApp(MemoryHomeScreenApp());
}

class MemoryHomeScreenApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Games',
      theme: ThemeData(
        fontFamily: 'Poppins', // Setting the default font family
      ),
      home: MemoryHomeScreen(),
    );
  }
}

class MemoryHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memory Games', style: TextStyle(color: Colors.black)),
        backgroundColor: Color(0xFFF8F6E7),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black), // Sets AppBar icon color to black
      ),
      backgroundColor: Color(0xFFF8F6E7), // Background color for the screen
      body: ListView(
        padding: EdgeInsets.all(12.0),
        children: [
          _buildGameTypeSection([
            _buildGameCard(context, 'Memory Match Game', MemoryGame()),
            _buildGameCard(context, 'Simon says Game', SimonSaysHome()), // New game card
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

  Widget _buildGameCard(BuildContext context, String gameName, Widget? nextScreen) {
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
                '🧩', // Emoji for match pair
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
