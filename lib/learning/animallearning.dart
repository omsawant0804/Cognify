
import 'dart:math';

import 'package:cognify_app/animal.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimalScreen(),
    );
  }
}
class AnimalScreen extends StatefulWidget {
  @override
  _AnimalScreenState createState() => _AnimalScreenState();
}

class _AnimalScreenState extends State<AnimalScreen> {
  final List<Map<String, dynamic>> animals = [
    {'name': 'Bear', 'emoji': '🐻', 'image': 'assets/animalimg/bear.png'},
    {'name': 'Buffalo', 'emoji': '🐃', 'image': 'assets/animalimg/buffalo.png'},

    {'name': 'Cat', 'emoji': '🐱', 'image': 'assets/animalimg/cat.png'},
    {'name': 'Cheetah', 'emoji': '🐆', 'image': 'assets/animalimg/cheetah.png'},

    {'name': 'Cow', 'emoji': '🐄', 'image': 'assets/animalimg/cow.png'},
    {'name': 'Deer', 'emoji': '🦌', 'image': 'assets/animalimg/deer.png'},
    {'name': 'Dog', 'emoji': '🐶', 'image': 'assets/animalimg/dog.png'},
    {'name': 'Elephant', 'emoji': '🐘', 'image': 'assets/animalimg/elephant.png'},
    {'name': 'Giraffe', 'emoji': '🦒', 'image': 'assets/animalimg/giraffe.png'},
    {'name': 'Hamster', 'emoji': '🐹', 'image': 'assets/animalimg/hamster.png'},
    {'name': 'Horse', 'emoji': '🐴', 'image': 'assets/animalimg/horse.png'},
    {'name': 'Kangaroo', 'emoji': '🦘', 'image': 'assets/animalimg/Kangaroo.png'},
    {'name': 'Koala', 'emoji': '🐨', 'image': 'assets/animalimg/koala.png'},
    {'name': 'Lion', 'emoji': '🦁', 'image': 'assets/animalimg/lion.png'},
    {'name': 'Monkey', 'emoji': '🐒', 'image': 'assets/animalimg/monkey.png'},
    {'name': 'Mouse', 'emoji': '🐭', 'image': 'assets/animalimg/mouse.png'},
    {'name': 'Panda', 'emoji': '🐼', 'image': 'assets/animalimg/panda.png'},

    {'name': 'Polar Bear', 'emoji': '🐻‍❄️', 'image': 'assets/animalimg/polar bear.png'},
    {'name': 'Rabbit', 'emoji': '🐰', 'image': 'assets/animalimg/rabbit.png'},
    {'name': 'Raccoon', 'emoji': '🦝', 'image': 'assets/animalimg/raccoon.png'},

    {'name': 'Tiger', 'emoji': '🐯', 'image': 'assets/animalimg/tiger.png'},
    {'name': 'Tortoise', 'emoji': '🐢', 'image': 'assets/animalimg/tortoise.png'},
    {'name': 'Wolf', 'emoji': '🐺', 'image': 'assets/animalimg/wolf.png'},
    {'name': 'Zebra', 'emoji': '🦓', 'image': 'assets/animalimg/zebra.png'},
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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AnimalQuizScreen()),
              );

            },
            icon: Image.asset(
              'assets/images/test2.png', // Make sure this file path is correct
              width: 40,
              height: 40,
            ),
          ),
        ],
      ),


      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(height: 40),
              Text(
                'Animals',
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
