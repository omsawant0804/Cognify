
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(PhonicsGameApp());
}

class PhonicsGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      title: 'English Alphabets',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PhonicsGameScreen(),
    );
  }
}

class PhonicsGameScreen extends StatefulWidget {
  @override
  _PhonicsGameScreenState createState() => _PhonicsGameScreenState();
}

class _PhonicsGameScreenState extends State<PhonicsGameScreen> {
  final FlutterTts _flutterTts = FlutterTts();

  // Function to play sound and show popup
// Function to play sound and show popup
// Function to play sound and show popup
  Future<void> showPopup(BuildContext context, String letter, String word, String imagePath) async {
    await _flutterTts.setLanguage("en-IN"); // Set to Indian English
    await _flutterTts.setSpeechRate(0.3); // Set speech rate to slow enough to match the dialog timing

    String phrase = "$letter for $word";

    // Show the popup
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  imagePath,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover, // Image adjustment
                ),
                SizedBox(height: 10),
                Text(
                  '$letter for $word',
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );

    // Start speaking
    await _flutterTts.speak(phrase);

    // Calculate how long the speech will take to finish
    int speechDuration = (phrase.length * 100) ~/ 3; // Approximation: Adjust this multiplier as needed

    // Ensure the popup stays for as long as TTS is speaking (plus a little buffer)
    await Future.delayed(Duration(milliseconds: speechDuration + 1500));

    // Close the dialog after speaking is done
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }



  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> alphabetInfo = [
      {'letter': 'A', 'word': 'Apple', 'image': 'assets/letters/A.jpg'},
      {'letter': 'B', 'word': 'Ball', 'image': 'assets/letters/B.jpg'},
      {'letter': 'C', 'word': 'Cat', 'image': 'assets/letters/C.jpg'},
      {'letter': 'D', 'word': 'Dog', 'image': 'assets/letters/D.jpg'},
      {'letter': 'E', 'word': 'Elephant', 'image': 'assets/letters/E.jpg'},
      {'letter': 'F', 'word': 'Fish', 'image': 'assets/letters/F.jpg'},
      {'letter': 'G', 'word': 'Grapes', 'image': 'assets/letters/G.jpg'},
      {'letter': 'H', 'word': 'Horse', 'image': 'assets/letters/H.jpg'},
      {'letter': 'I', 'word': 'Ice-cream', 'image': 'assets/letters/I.jpg'},
      {'letter': 'J', 'word': 'Juice', 'image': 'assets/letters/J.jpg'},
      {'letter': 'K', 'word': 'Kite', 'image': 'assets/letters/K.jpg'},
      {'letter': 'L', 'word': 'Lion', 'image': 'assets/letters/L.jpg'},
      {'letter': 'M', 'word': 'Mango', 'image': 'assets/letters/M.jpg'},
      {'letter': 'N', 'word': 'Nest', 'image': 'assets/letters/N.jpg'},
      {'letter': 'O', 'word': 'Orange', 'image': 'assets/letters/O.jpg'},
      {'letter': 'P', 'word': 'Pineapple', 'image': 'assets/letters/P.jpg'},
      {'letter': 'Q', 'word': 'Queen', 'image': 'assets/letters/Q.jpg'},
      {'letter': 'R', 'word': 'Rose', 'image': 'assets/letters/R.jpg'},
      {'letter': 'S', 'word': 'Strawberry', 'image': 'assets/letters/S.jpg'},
      {'letter': 'T', 'word': 'Tiger', 'image': 'assets/letters/T.jpg'},
      {'letter': 'U', 'word': 'Umbrella', 'image': 'assets/letters/U.jpg'},
      {'letter': 'V', 'word': 'Van', 'image': 'assets/letters/V.jpg'},
      {'letter': 'W', 'word': 'Watch', 'image': 'assets/letters/W.jpg'},
      {'letter': 'X', 'word': 'Xylophone', 'image': 'assets/letters/X.jpg'},
      {'letter': 'Y', 'word': 'Yak', 'image': 'assets/letters/Y.jpg'},
      {'letter': 'Z', 'word': 'Zebra', 'image': 'assets/letters/Z.jpg'},
    ];

    return Scaffold(
      appBar: AppBar(title: Text('English Alphabets')),
      body: GridView.count(
        crossAxisCount: 3, // Display 3 letters per row to make them larger
        padding: EdgeInsets.zero, // Remove padding to let the boxes fill the screen
        children: alphabetInfo.map((data) {
          return GestureDetector(
            onTap: () {
              showPopup(context, data['letter']!, data['word']!, data['image']!);
            },
            child: Container(
              margin: EdgeInsets.all(4), // Small margin for spacing between boxes
              decoration: BoxDecoration(
                color: Colors.white, // Background color
                border: Border.all(color: Colors.black, width: 2), // Black border
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
              child: Center(
                child: Text(
                  data['letter']!,
                  style: TextStyle(
                    fontSize: 58, // Larger font size to make the letters more visible
                    color: Colors.black, // Text color
                    fontWeight: FontWeight.bold, // Make the letters bold
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );


  }
}
