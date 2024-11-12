import 'package:cognify_app/Bird.dart';
import 'package:cognify_app/MonthDaygame.dart';
import 'package:cognify_app/clocktime.dart';
import 'package:cognify_app/learning/MonthDaylearning.dart';
import 'package:cognify_app/Seacreatures.dart';
import 'package:cognify_app/animal.dart';
import 'package:cognify_app/learning/Birdlearning.dart';
import 'package:cognify_app/learning/letterlearning.dart';
import 'package:cognify_app/letterwordgame.dart';
import 'package:flutter/material.dart';
// Import other screens that are part of the Basic Skills category


void main() {
  runApp(BasicHomeScreenApp());
}

class BasicHomeScreenApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basic Skills Games',
      theme: ThemeData(
        fontFamily: 'Poppins', // Setting the default font family
      ),
      home: BasicHomeScreen(),
    );
  }
}

class BasicHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Basic Skills Games', style: TextStyle(color: Colors.black)),
        backgroundColor: Color(0xFFF8F6E7),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black), // Sets AppBar icon color to black
      ),
      backgroundColor: Color(0xFFF8F6E7), // Background color for the screen
      body: ListView(
        padding: EdgeInsets.all(12.0),
        children: [
          _buildGameTypeSection([
            _buildGameCard(context, 'Animal Guess Game', AnimalQuizScreen(), '🦁'),
            _buildGameCard(context, 'Bird Guess Game', BirdQuizScreen(), '🐦'),
            _buildGameCard(context, 'Sea Creatures Guess Game', SeacreatureQuizScreen(), '🐙'),
           // _buildGameCard(context, 'Learning letters', PhonicsGameScreen(), '🔠'),
            _buildGameCard(context, 'Word Match Game', LetterGame(), '✍️'),
            _buildGameCard(context, 'Tell Time Game', ClockGame(), '🕒'),




          //
            //  _buildGameCard(context, 'Month Day learning', MDHomePage(), '✍️'),
            _buildGameCard(context, ' Day Month Guess Game', DayMonthYearGame(), '📅️'),

            //PhonicsGameScreen() //LetterGame()



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

  Widget _buildGameCard(BuildContext context, String gameName, Widget nextScreen, String emoji) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextScreen),
        );
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
