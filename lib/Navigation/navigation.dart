import 'package:flutter/material.dart';

class Navigation {
  static void navigateTo(BuildContext context, Widget screen, String direction, {Duration duration = const Duration(milliseconds: 300)}) {
    Navigator.of(context).push(_createRoute(screen, direction, duration));
  }

  static Route _createRoute(Widget screen, String direction, Duration duration) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        Offset begin;
        Offset end = Offset.zero; // End at the center
        const curve = Curves.easeInOut;

        // Set the begin offset based on the specified direction
        switch (direction.toLowerCase()) {
          case 'right':
            begin = Offset(1.0, 0.0); // Start from the right
            break;
          case 'left':
            begin = Offset(-1.0, 0.0); // Start from the left
            break;
          case 'top':
            begin = Offset(0.0, -1.0); // Start from the top
            break;
          case 'bottom':
            begin = Offset(0.0, 1.0); // Start from the bottom
            break;
          default:
            begin = Offset(0.0, 0.0); // Default case
            break;
        }

        // Create the tweens for the animations
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var animationCurved = animation.drive(tween);

        return SlideTransition(
          position: animationCurved,
          child: child,
        );
      },
      transitionDuration: duration, // Use the provided duration
      reverseTransitionDuration: duration, // Use the provided duration for reverse transition
    );
  }
}
