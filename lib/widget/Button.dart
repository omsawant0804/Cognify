import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Widget targetPage;
  final int? req;
  final Future<void> Function()? onTapAction;  // Change type to Future<void> Function()

  const CustomButton({
    Key? key,
    this.req,
    required this.text,
    required this.targetPage,
    this.onTapAction,  // Optional parameter for an action
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () async {
        // Perform the action if it's provided
        if (onTapAction != null) {
          await onTapAction!();  // Now you can await the action
        }

        // Navigate to the target page
        if(req==null){
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => targetPage,
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(1.0, 0.0), // From the right
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
              transitionDuration: Duration(milliseconds: 500),
            ),
          );
        }

      },
      child: Container(
        width: screenSize.width * 0.9,
        height: screenSize.height * 0.08,
        decoration: BoxDecoration(
          color: Color(0xFF000000),
          borderRadius: BorderRadius.circular(26),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.16),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(30, 0, 0, 0),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenSize.width * 0.06,
                    fontFamily: "Poppins",
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ),
            SizedBox(width: screenSize.width * 0.05),
            Image.asset(
              "assets/images/dots.png",
              width: 26,
              height: 26,
            ),
          ],
        ),
      ),
    );
  }
}
