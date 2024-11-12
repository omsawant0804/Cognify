import 'package:cognify_app/Bird.dart';
import 'package:cognify_app/ColorGuss.dart';
import 'package:cognify_app/Seacreatures.dart';
import 'package:cognify_app/animal.dart';
import 'package:cognify_app/catchwater.dart';
import 'package:cognify_app/clocktime.dart';
import 'package:cognify_app/countgame.dart';
import 'package:cognify_app/emotion1.dart';
import 'package:cognify_app/game_screen.dart';
import 'package:cognify_app/goodbehaviourgame.dart';
import 'package:cognify_app/lettergame.dart';
import 'package:cognify_app/main.dart';
import 'package:cognify_app/mathgame.dart';
import 'package:cognify_app/memorymatch.dart';
import 'package:cognify_app/screens/MemoryHomeScreen.dart';
import 'package:cognify_app/screens/home_screen.dart';
import 'package:cognify_app/shapegame.dart';



import 'package:flutter/material.dart';
// import 'package:flame/game.dart';

// Placeholder screens for demonstration purposes

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cognify App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark, // Set to dark theme
        primarySwatch: Colors.blue,
      ),
      home:HomeScreen(),//MemoryHomeScreen(),//CognifyPage(), ,//
      //
    );
  }
}

class CognifyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cognify'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _buildGameTypeSection('Reading , Writing and Communication ', [
                  _buildGameCard(context, 'Shape Guess Game', ShapeGameScreen()),
                  _buildGameCard(context, 'Math Game', MathGame()),
                  _buildGameCard(context, 'Count Game', CountingScreen()),
                  _buildGameCard(context, 'animal Game', AnimalQuizScreen()),
                  _buildGameCard(context, 'Bird Game', BirdQuizScreen()),

                  _buildGameCard(context, 'Sea Creatures Game', SeacreatureQuizScreen()),


                ]),

                _buildGameCard(context, 'Shape Guess Game', ShapeGameScreen()),
                _buildGameCard(context, 'Color Guess Game', ColorGameScreen()),

                // Speed Section
                _buildGameTypeSection('Attention and Speed', [
                  _buildGameCard(context, 'Color Guess Game', ColorGameScreen()),
                  _buildGameCard(context, 'Collect Water Game', WaterCatchGameScreen()),//
                  _buildGameCard(context, 'Match Pair Game', MemoryGame()),
                  _buildGameCard(context, 'Cloxk Game', ClockGame()),///



                ]),

                _buildGameTypeSection('Emotional Intelligence Theory', [
                  _buildGameCard(context, 'Emotion Identification Game', EmotionGameScreen()),
                ]),

                // New Behavioral Theory Section
                _buildGameTypeSection('Life Skill and Behavioral Theory', [
                  _buildGameCard(context, 'Morning Routine Challenge', GameScreen()), //
                  _buildGameCard(context, 'Good Behaviour Challenge', BehaviorGameScreen()),
                ]),

                // New Social Skill and Collaboration Section
                _buildGameTypeSection('Social Skill and Collaboration', [
                  // Replace with your new game
                  // Add more games related to social skills and collaboration if needed
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameTypeSection(String title, List<Widget> games) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          SizedBox(height: 8),
          Container(
            height: 120, // Set a fixed height for the card row
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: games.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: games[index],
                );
              },
            ),
          ),
        ],
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
        color: Colors.blueGrey[800], // Modern card color
        child: Container(
          width: 120, // Set the width for each card
          padding: EdgeInsets.all(16.0),
          alignment: Alignment.center,
          child: Text(
            gameName,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.white), // Text color for contrast
          ),
        ),
      ),
    );
  }
}

