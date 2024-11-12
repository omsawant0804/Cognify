import 'package:cognify_app/AuthenticationPages/AccCreated.dart';
import 'package:cognify_app/AuthenticationPages/PhoneAuth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widget/Button.dart';
import '../widget/TextField.dart';

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final List<String> ageGroups = ["2–4", "5–8", "9–12", "13-16", "16 +"];
  int selectedAgeIndex = 2; // Default index for "9-12"
  TextEditingController nicknameController = TextEditingController();
  late FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = FixedExtentScrollController(initialItem: selectedAgeIndex);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    nicknameController.dispose();
    super.dispose();
  }

  // Create or fetch the user document with userID as the document ID
  Future<void> _createUserIfNotExist() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle case if user is not logged in
      return;
    }
    final String userId = user.uid;
    final DocumentReference userDocRef = FirebaseFirestore.instance.collection('User').doc(userId);

    // Check if the user document exists
    final userDocSnapshot = await userDocRef.get();
    if (!userDocSnapshot.exists) {
      // If the document doesn't exist, create the user document
      await userDocRef.set({ 'nickname': nicknameController.text,
        'ageGroup': ageGroups[selectedAgeIndex],});

      // Create subcollections for the user
      await _createSubcollections(userDocRef);
    }

    // After ensuring the user document exists, save the nickname and ageGroup in Data subcollection
  }

  // Method to create subcollections for a new user
  Future<void> _createSubcollections(DocumentReference userDocRef) async {
    await userDocRef.collection('Assessment').doc('initialData').set({});
    await userDocRef.collection('gameData').doc('initialData').set({});
    await userDocRef.collection('Feedback').doc('initialData').set({});
  }

  // Method to save nickname and ageGroup inside the Data subcollection

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFFF8F6E7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.20),
                Center(
                  child: Text(
                    "Personalize your child’s\nlearning experience",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: size.width * 0.06,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF232426),
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.07),
                Text(
                  "Child's Age",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: size.width * 0.045,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                _buildAgePicker(size),
                SizedBox(height: size.height * 0.14),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                  child: CustomInputField(
                    placeholder: "Child’s NickName",
                    controller: nicknameController,
                    keyboardType: TextInputType.text,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                CustomButton(
                  text: "Next",
                  targetPage: Acccreated(),
                  onTapAction:()async{
                    if(nicknameController.text != ""){
                      await _createUserIfNotExist();
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Enter Child NickName")),
                      );
                    }
                  },
                ),
                SizedBox(height: size.height * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAgePicker(Size size) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: size.height * 0.18,
          child: ListWheelScrollView.useDelegate(
            controller: _scrollController,
            itemExtent: 40,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (index) {
              setState(() {
                selectedAgeIndex = index;
              });
            },
            perspective: 0.004,
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                final isSelected = selectedAgeIndex == index;
                return Center(
                  child: Text(
                    ageGroups[index],
                    style: TextStyle(
                      fontSize: size.width * 0.045,
                      fontWeight: FontWeight.normal,
                      color: isSelected ? Colors.black : Colors.grey,
                    ),
                  ),
                );
              },
              childCount: ageGroups.length,
            ),
          ),
        ),
        Positioned(
          top: (size.height * 0.20) / 2 - 40,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 200,
              child: Divider(
                color: Colors.black,
                thickness: 1.0,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: (size.height * 0.20) / 2 - 40,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 200,
              child: Divider(
                color: Colors.black,
                thickness: 1.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
