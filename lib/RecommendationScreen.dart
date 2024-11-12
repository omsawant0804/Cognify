import 'package:flutter/material.dart';

class ChooseLessonScreen extends StatefulWidget {
  const ChooseLessonScreen({super.key});

  @override
  _ChooseLessonScreenState createState() => _ChooseLessonScreenState();
}

class _ChooseLessonScreenState extends State<ChooseLessonScreen> {
  int? selectedLesson;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6E7), // Background color from the image
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   surfaceTintColor: Color(0xFFF9F5F2),
      //   elevation: 0,
      //
      //   leading: Padding(
      //     padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
      //     child: Container(
      //       decoration: BoxDecoration(
      //         shape: BoxShape.circle,
      //         color: Colors.black,
      //       ),
      //       child: IconButton(
      //         icon: Icon(Icons.arrow_back, color: Colors.white),
      //         onPressed: () => Navigator.of(context).pop(),
      //       ),
      //     ),
      //   ),
      //   actions: [
      //     Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 0),
      //       child: SizedBox(
      //         width: 80,
      //         height: 80,
      //         child: Center(
      //           child: IconButton(
      //             icon: const Icon(Icons.more_horiz, color: Colors.black),
      //             iconSize: 60,
      //             onPressed: () {
      //               // Add functionality here if needed
      //             },
      //           ),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),

      body: Column(
        children: [
          SizedBox(height: 40),
          // Title and Image in Center
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/rhino.png', // Replace with your asset path
                height: 100,
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Choose',

                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'the lesson',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 40),
          // Scrollable Lesson Cards (only this part scrolls)
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                width: 350,

                child: Column(

                  children: [
                    SizedBox(height: 10,),
                    LessonCard(
                      color: selectedLesson == 0 ? Color(0xFFFF8F52) : Color(0xFFEFEFEF),
                      emoji: '🐝', // Emoji for Insects Species
                      title: 'Insects Species',
                      isSelected: selectedLesson == 0,
                      onTap: () => setState(() => selectedLesson = 0),
                    ),
                    SizedBox(height: 16),
                    LessonCard(
                      color: selectedLesson == 1 ? Color(0xFFFF8F52) : Color(0xFFEFEFEF),
                      emoji: '🦁', // Emoji for Wild Animals
                      title: 'Wild Animals',
                      isSelected: selectedLesson == 1,
                      onTap: () => setState(() => selectedLesson = 1),
                    ),
                    SizedBox(height: 16),
                    LessonCard(
                      color: selectedLesson == 2 ? Color(0xFFFF8F52) : Color(0xFFEFEFEF),
                      emoji: '🐬', // Emoji for Aquatic Life
                      title: 'Aquatic Life',
                      isSelected: selectedLesson == 2,
                      onTap: () => setState(() => selectedLesson = 2),
                    ),
                    SizedBox(height: 16),
                    LessonCard(
                      color: selectedLesson == 3 ? Color(0xFFFF8F52) : Color(0xFFEFEFEF),
                      emoji: '🐦', // Emoji for Birds
                      title: 'Bird Species',
                      isSelected: selectedLesson == 3,
                      onTap: () => setState(() => selectedLesson = 3),
                    ),
                    SizedBox(height: 16),
                    LessonCard(
                      color: selectedLesson == 4 ? Color(0xFFFF8F52) : Color(0xFFEFEFEF),
                      emoji: '🐮', // Emoji for Cows
                      title: 'Mammals',
                      isSelected: selectedLesson == 4,
                      onTap: () => setState(() => selectedLesson = 4),
                    ),

                    SizedBox(height: 120,),
                  ],

                ),
              ),

            ),

          ),
        ],
      ),
      floatingActionButton: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        color: Colors.black,
        child: InkWell(
          onTap: () {
            // Implement your action for the 'Choose' button here
          },
          child: Container(
            width: 200, // Adjust width as needed
            height: 60, // Adjust height as needed
            alignment: Alignment.center,
            child: Text(
              'Choose',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class LessonCard extends StatelessWidget {
  final Color color;
  final String emoji; // Changed from IconData to String for emoji
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const LessonCard({
    super.key,
    required this.color,
    required this.emoji,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 160, // Increased height for lesson cards
        width: 340,  // Increased width for lesson cards
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(40),
          // boxShadow: [
          //   if (!isSelected) // Add drop shadow effect when not selected
          //     BoxShadow(
          //       color: Colors.black.withOpacity(0.1),
          //       spreadRadius: 2,
          //       blurRadius: 12,
          //       offset: Offset(0, 4), // Shadow position
          //     ),
          // ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Emoji container (replacing icon with emoji)
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFF9F5F2),
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(12),
              child: Text(
                emoji,
                style: TextStyle(fontSize: 30, color: isSelected ? Colors.black : Colors.grey),
              ),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black, // Set text color based on selection
              ),
            ),
          ],
        ),
      ),
    );
  }
}