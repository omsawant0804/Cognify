import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, "Home", 0),
          _buildNavItem(Icons.thumb_up, "Recommended", 1),
          _buildNavItem(Icons.bar_chart, "Evaluation", 2),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onItemSelected(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Use a fixed size for the container
          Container(
            width: 100, // Set a fixed width for consistency
            height: 60, // Set a fixed height for consistency
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: isSelected
                  ? Text(
                label,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              )
                  : Icon(icon, color: Colors.white, size: 30),
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
