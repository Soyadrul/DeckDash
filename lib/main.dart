// This is the entry point of the application
// When the app starts, Flutter calls the main() function

import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

// The main function: the first thing that runs when the app starts
void main() {
  // runApp() takes a Widget and makes it the root of the widget tree
  runApp(const SpeedCardApp());
}

// The root widget of the entire application
// StatelessWidget means this widget doesn't change over time (it's immutable)
class SpeedCardApp extends StatelessWidget {
  const SpeedCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp provides Material Design styling and navigation
    return MaterialApp(
      // The title shown in the app switcher on mobile devices
      title: 'DeckDash',

      // Light theme configuration using Material 3 design system
      theme: ThemeData(
        // Material 3 (Material Design 3) is the latest design system from Google
        useMaterial3: true,

        // ColorScheme.fromSeed generates a complete color palette from a single color
        // This ensures all UI elements have harmonious colors
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,  // Primary color for the app
          brightness: Brightness.light,  // Light mode
        ),
      ),

      // Dark theme configuration (automatically used when device is in dark mode)
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,  // Dark mode
        ),
      ),

      // The first screen the user sees when opening the app
      home: const HomeScreen(),

      // Removes the "Debug" banner shown in the top-right corner during development
      debugShowCheckedModeBanner: false,
    );
  }
}