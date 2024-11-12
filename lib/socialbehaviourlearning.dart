import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kids Communication App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: SBHomeScreen(),
    );
  }
}

class SBHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kids Communication App')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(height: 20), // Space between image and text
              Text(
                'Learn to Communicate',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20), // Space before button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ScenariosScreen()),
                  );
                },
                child: Text('Start Learning'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScenarioCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  ScenarioCard({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(title, style: TextStyle(fontSize: 20)),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.deepOrange),
        onTap: onTap,
      ),
    );
  }
}

class ScenarioDetailScreen extends StatefulWidget {
  final String title;
  final String description;
  final String imagePath;

  ScenarioDetailScreen({required this.title, required this.description, required this.imagePath});

  @override
  _ScenarioDetailScreenState createState() => _ScenarioDetailScreenState();
}

class _ScenarioDetailScreenState extends State<ScenarioDetailScreen> {
  late FlutterTts flutterTts;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    _speak(widget.description); // Automatically speak the description when the screen is loaded
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text(widget.description, style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            Image.asset(widget.imagePath),
          ],
        ),
      ),
    );
  }
}

class ScenariosScreen extends StatelessWidget {
  final List<Map<String, String>> scenarios = [
    {
      'title': 'Greet a Friend',
      'description': 'Smile and say "Hello!"',
      'image': 'assets/combehaviour/greet_a_friend.png',
    },
    {
      'title': 'Ask for Help',
      'description': 'Find a grown-up and ask politely.',
      'image': 'assets/combehaviour/asking_for_help.png',
    },
    {
      'title': 'Expressing Thanks',
      'description': 'Always say "Thank you!" when someone helps you.',
      'image': 'assets/combehaviour/expressing_thanks.png',
    },
    {
      'title': 'Sharing Toys',
      'description': 'Share your toys with friends to have more fun.',
      'image': 'assets/combehaviour/sharing_toys.png',
    },
    {
      'title': 'Meeting New People',
      'description': 'Introduce yourself and shake hands.',
      'image': 'assets/combehaviour/meeting_new_people.png',
    },
    {
      'title': 'Responding to Instructions',
      'description': 'Listen carefully and follow the instructions.',
      'image': 'assets/combehaviour/responding_to_instructions.png',
    },
    {
      'title': 'Asking Permission',
      'description': 'Always ask for permission before using someone else\'s things.',
      'image': 'assets/combehaviour/asking_permission.png',
    },
    {
      'title': 'Making a Request',
      'description': 'Use polite words when you ask for something.',
      'image': 'assets/combehaviour/making_a_request.png',
    },
    {
      'title': 'Listening to Others',
      'description': 'Pay attention when someone is speaking to you.',
      'image': 'assets/combehaviour/listening_to_others.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Communication Scenarios')),
      body: ListView.builder(
        itemCount: scenarios.length,
        itemBuilder: (context, index) {
          final scenario = scenarios[index];
          return ScenarioCard(
            title: scenario['title']!,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScenarioDetailScreen(
                    title: scenario['title']!,
                    description: scenario['description']!,
                    imagePath: scenario['image']!,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
