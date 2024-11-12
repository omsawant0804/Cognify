import 'package:flutter/material.dart';

class CategoryIcon extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback onTap;

  const CategoryIcon({
    super.key,
    required this.iconPath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[200],
            radius: 30, // Adjust this for the circle size
            child: Image.asset(iconPath, height: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,

              color: Colors.black54,

            ),

          ),
          const SizedBox(width:90),
        ],
      ),
    );
  }
}
