import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Days and Months',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MDHomePage(),
    );
  }
}

class MDHomePage extends StatelessWidget {
  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<String> daysOfWeek = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
  ];

  final List<String> monthsOfYear = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  void playSound(String dayOrMonth) async {
    print('Playing sound for: $dayOrMonth');
    try {
      await _audioPlayer.play(AssetSource('sounds/$dayOrMonth.mp3'));
      print('Playback started');
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Days and Months Game'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SectionTitle(title: "Days of the Week"),
                ...daysOfWeek.map((day) => DayOrMonthButton(
                    name: day, onPressed: () => playSound(day.toLowerCase()))),
                SizedBox(height: 30),
                SectionTitle(title: "Months of the Year"),
                ...monthsOfYear.map((month) => DayOrMonthButton(
                    name: month, onPressed: () => playSound(month.toLowerCase()))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    );
  }
}

class DayOrMonthButton extends StatelessWidget {
  final String name;
  final VoidCallback onPressed;

  DayOrMonthButton({required this.name, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.orangeAccent,
          elevation: 5,
        ),
        child: Text(
          name,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
