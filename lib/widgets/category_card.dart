// category_card.dart

import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final Color color;
  final String label;
  final String image;
  final double cardHeight;
  final double cardWidth;
  final double imageHeight;
  final double imageWidth;

  const CategoryCard({
    Key? key,
    required this.color,
    required this.label,
    required this.image,
    required this.cardHeight,
    required this.cardWidth,
    required this.imageHeight,
    required this.imageWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Aligns text to the start
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              image,
              height: imageHeight,
              width: imageWidth,
              fit: BoxFit.contain,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 2.0, top: 8.0), // Adds padding to the left
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF9F5F2),
                ),
                textAlign: TextAlign.start, // Ensure text is left-aligned
              ),
            ),
          ),
        ],
      ),
    );
  }
}
