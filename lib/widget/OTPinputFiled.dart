import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CustomOTPField extends StatefulWidget {
  final TextEditingController otpController;
  final int length;

  const CustomOTPField({
    Key? key,
    required this.otpController,
    this.length = 6,
  }) : super(key: key);

  @override
  _CustomOTPFieldState createState() => _CustomOTPFieldState();
}

class _CustomOTPFieldState extends State<CustomOTPField> {
  @override
  Widget build(BuildContext context) {
    // Get screen width and height for dynamic resizing
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Use screen width and height to dynamically set field size and other properties
    double fieldHeight = screenHeight * 0.06; // 8% of screen height
    double fieldWidth = screenWidth * 0.14;  // 12% of screen width

    double fontSize = screenWidth * 0.05; // Font size is 5% of screen width

    return PinCodeTextField(
      controller: widget.otpController,
      autoDisposeControllers: false,
      appContext: context,
      length: widget.length,
      textStyle: TextStyle(
        fontFamily: 'Poppins',
        color: const Color(0xFF232426),
        fontSize: fontSize, // Dynamic font size
      ),
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      enableActiveFill: false,
      autoFocus: true,
      enablePinAutofill: false,
      errorTextSpace: 16,
      showCursor: true,
      cursorColor: const Color(0xFF232426),
      obscureText: false,
      keyboardType: TextInputType.number,
      pinTheme: PinTheme(
        fieldHeight: fieldHeight, // Dynamic field height
        fieldWidth: fieldWidth,   // Dynamic field width
        borderWidth: 1,
        borderRadius: BorderRadius.circular(18),
        shape: PinCodeFieldShape.box,
        activeColor: const Color(0xFF232426),
        inactiveColor: const Color(0xFF232426),
        selectedColor: const Color(0xFF232426),
        selectedFillColor: const Color(0xFF232426),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
