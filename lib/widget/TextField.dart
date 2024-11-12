import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  final String placeholder;
  final String? constantCode; // Optional parameter for country code
  final TextEditingController controller;
  final TextInputType keyboardType;

  CustomInputField({
    required this.placeholder,
    this.constantCode, // Constant code to display at the start
    required this.controller,
    required this.keyboardType,
  });

  @override
  _CustomInputFieldState createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  FocusNode focusNode = FocusNode(); // Create a FocusNode

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        // Unfocus the text field when it loses focus
        focusNode.unfocus();
      }
    });
  }

  @override
  void dispose() {
    focusNode.dispose(); // Dispose the FocusNode when done
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (widget.constantCode != null)
          Padding(
            padding: const EdgeInsets.only(right: 8.0), // Space between code and text field
            child: Text(
              widget.constantCode!,
              style: TextStyle(fontSize: 18,color:  Color(0xFF232426),fontFamily: "Poppins",),
            ),
          ),
        Expanded(
          child: Container(
            height: 70, // Increased height for the text field
            child: TextField(
              controller: widget.controller,
              keyboardType: widget.keyboardType,
              focusNode: focusNode, // Use the FocusNode here
              decoration: InputDecoration(
                hintText: widget.placeholder,
                hintStyle: TextStyle(fontSize: 16, color: Colors.grey,fontFamily: "Poppins"), // Set hint text size and color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(26),
                  borderSide: BorderSide(color: Colors.black.withOpacity(0.3)),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 25), // Adjust vertical padding for centering
              ),
              style: TextStyle(fontSize: 18,fontFamily: "Poppins"), // Increased font size for better visibility
              autofocus: false, // Disable automatic highlighting
              showCursor: true,
            ),
          ),
        ),
      ],
    );
  }
}
