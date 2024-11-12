import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String taskName;
  final String imagePath;

  const TaskCard({
    Key? key,
    required this.taskName,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Added elevation for shadow effect
      color: const Color(0xFFD9D9D9), // Card color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0), // Padding inside the card
        child: Row(
          children: [
            // Task image
            Image.asset(
              imagePath,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 12), // Spacing between image and text
            // Task name
            Expanded(
              child: Text(
                taskName,
                style: const TextStyle(
                  color: Colors.black, // Text color
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
