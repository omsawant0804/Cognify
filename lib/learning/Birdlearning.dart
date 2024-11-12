
import 'dart:math';

import 'package:flutter/material.dart';
class BirdScreen extends StatefulWidget {
  @override
  _BirdScreenState createState() => _BirdScreenState();
}

class _BirdScreenState extends State<BirdScreen> {


  final List<Map<String, dynamic>> birds = [
    {'name': 'Eagle', 'emoji': '🦅', 'image': 'assets/birdimg/eagle.png'},
    {'name': 'Parrot', 'emoji': '🦜', 'image': 'assets/birdimg/parrot.png'},
    {'name': 'Owl', 'emoji': '🦉', 'image': 'assets/birdimg/owl.png'},
    {'name': 'Penguin', 'emoji': '🐧', 'image': 'assets/birdimg/Penguin.png'},
    {'name': 'Swan', 'emoji': '🦢', 'image': 'assets/birdimg/swan.png'},
    {'name': 'Chicken', 'emoji': '🐔', 'image': 'assets/birdimg/Chicken.png'},
    {'name': 'Peacock', 'emoji': '🦚', 'image': 'assets/birdimg/peacock.png'},
    {'name': 'Duck', 'emoji': '🦆', 'image': 'assets/birdimg/duck.png'},
    {'name': 'Flamingo', 'emoji': '🦩', 'image': 'assets/birdimg/flamingo.png'},
    {'name': 'Hummingbird', 'emoji': '🐦', 'image': 'assets/birdimg/humming bird.png'},
    {'name': 'Pigeon', 'emoji': '🐦', 'image': 'assets/birdimg/pigeon.png'},
    {'name': 'Woodpecker', 'emoji': '🐦', 'image': 'assets/birdimg/woodpecker.png'},
    {'name': 'Sparrow', 'emoji': '🐦', 'image': 'assets/birdimg/sparrow.png'},
    {'name': 'Crow', 'emoji': '🐦', 'image': 'assets/birdimg/crow.png'},
    {'name': 'Kingfisher', 'emoji': '🐦', 'image': 'assets/birdimg/kingfisher.png'},
    {'name': 'Pelican', 'emoji': '🐦', 'image': 'assets/birdimg/pelican.png'},
    {'name': 'Ostrich', 'emoji': '🦤', 'image': 'assets/birdimg/Ostrich.png'},
    {'name': 'Toucan', 'emoji': '🦜', 'image': 'assets/birdimg/toucan.png'},



  ];


  int _selectedIndex = 0;

  void _onIconTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    final bird = birds[_selectedIndex]; // Get selected animal data
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
                'Birds',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              SizedBox(height: 140),
              Image.asset(
                bird['image'],
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
                children: birds.asMap().entries.map((entry) {
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
                bird['name'],
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

