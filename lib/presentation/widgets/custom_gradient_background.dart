import 'package:flutter/material.dart';

class CustomGradientBackground extends StatelessWidget {
  final Widget child;

  const CustomGradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Check the current theme brightness
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDarkMode
              ? [
                  Color.fromRGBO(0, 0, 0, 0.9), // Almost black with opacity
                  Color.fromRGBO(45, 45, 45, 0.7), // Dark grey
                  Color(0xFF121212), // Fully black
                ]
              : [
                  Color.fromRGBO(37, 99, 235, 0.2), // Blue with 20% opacity
                  Color.fromRGBO(255, 255, 255, 0.14), // White with 14% opacity
                  Color(0xFFFFFFFF), // Fully white
                ],
          stops: const [
            0.0, // Start of the gradient
            0.31, // Second stop at 31%
            1.0, // End of the gradient
          ],
        ),
      ),
      child: child, // Pass the content for the screen
    );
  }
}
