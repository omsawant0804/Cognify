import 'dart:math';

import 'package:cognify_app/Seacreatures.dart';
import 'package:flutter/material.dart';

class SeacreatureScreen extends StatefulWidget {
  @override
  _SeacreatureScreenState createState() => _SeacreatureScreenState();
}

class _SeacreatureScreenState extends State<SeacreatureScreen> {


  final List<Map<String, dynamic>> animals = [
    {'name': 'Clownfish', 'emoji': '🐠', 'image': 'assets/seacreaturesimg/clownfish.png'},
    {'name': 'Crab', 'emoji': '🦀', 'image': 'assets/seacreaturesimg/crab.png'},
    {'name': 'Dolphin', 'emoji': '🐬', 'image': 'assets/seacreaturesimg/dolphin.png'},
    {'name': 'Jellyfish', 'emoji': '🎐', 'image': 'assets/seacreaturesimg/jellyfish.png'},
    {'name': 'Moray Eel', 'emoji': '🦈', 'image': 'assets/seacreaturesimg/moray eel.png'},
    {'name': 'Octopus', 'emoji': '🐙', 'image': 'assets/seacreaturesimg/octopus.png'},
    {'name': 'Orca', 'emoji': '🐋', 'image': 'assets/seacreaturesimg/orca.png'},
    {'name': 'Otter', 'emoji': '🦦', 'image': 'assets/seacreaturesimg/otter.png'},
    {'name': 'Seahorse', 'emoji': '🐡', 'image': 'assets/seacreaturesimg/seahorse.png'},
    {'name': 'Shark', 'emoji': '🦈', 'image': 'assets/seacreaturesimg/shark.png'},
    {'name': 'Starfish', 'emoji': '⭐', 'image': 'assets/seacreaturesimg/starfish.png'},
    {'name': 'Sting Ray', 'emoji': '🛸', 'image': 'assets/seacreaturesimg/sting ray.png'},
    {'name': 'Turtle', 'emoji': '🐢', 'image': 'assets/seacreaturesimg/turtle.png'},
  ];

  int _selectedIndex = 0;

  void _onIconTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    final animal = animals[_selectedIndex]; // Get selected animal data
    return Scaffold(
      backgroundColor: Color(0xFFF8F5E9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),

      ),


      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(height: 40),
              Text(
                'Sea Creatures',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              SizedBox(height: 140),
              Image.asset(
                animal['image'],
                height: 200,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.image, size: 200),
              ),
            ],
          ),
          SizedBox(height: 140),

          SizedBox(
            height: 80, // Adjusted height for the icon row
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: animals.asMap().entries.map((entry) {
                  int idx = entry.key;
                  var animal = entry.value;
                  bool isSelected = idx == _selectedIndex; // Check if the icon is selected
                  return GestureDetector(
                    onTap: () => _onIconTapped(idx), // Handle tap
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.orange : Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(15),
                      child: Text(
                        animal['emoji'],
                        style: TextStyle(
                          fontSize: 24,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),


          SizedBox(height: 6), // Reduced spacing between slider and container
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12), // Adjusted padding for a tighter look
            decoration: BoxDecoration(
              color: Color(0xFFD9D9D9),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child: Center(
              child: Text(
                animal['name'],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
