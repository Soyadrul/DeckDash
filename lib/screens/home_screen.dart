// Home screen: the first screen users see
// Allows users to choose between single deck or multi deck training mode

import 'package:flutter/material.dart';
import 'single_deck_config_screen.dart';
import 'multi_deck_config_screen.dart';
import 'settings_screen.dart'; // ADDED: Import settings screen
import '../widgets/custom_elevated_button.dart'; // NEW: Import custom button widget

// StatelessWidget because this screen doesn't have any changing state
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold provides the basic visual structure (app bar, body, etc.)
    return Scaffold(
      // AppBar: the bar at the top of the screen
      appBar: AppBar(
        title: const Text('Speed Card Trainer'),
        centerTitle: true, // Centers the title text
        // ADDED: Settings button in app bar
        actions: [
          // IconButton for settings
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings', // Shows tooltip on long press
            onPressed: () {
              // Navigate to settings screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),

      // Body: the main content area below the app bar
      // SafeArea ensures content doesn't overlap with system UI (notches, navigation bars)
      body: SafeArea(
        // Center the content both vertically and horizontally
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600), // Limit max width on large screens
            child: SingleChildScrollView(
              child: Padding(
                // Padding adds space around the content (24 pixels on all sides)
                padding: const EdgeInsets.all(24.0),

                // Column arranges widgets vertically (top to bottom)
                child: Column(
                  // Centers children vertically within the Column
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon at the top of the screen
                    const Icon(
                      Icons.style, // Playing card icon
                      size: 80,
                      color: Colors.blue,
                    ),

                    // SizedBox creates empty space (32 pixels tall)
                    const SizedBox(height: 32),

                    // Title text
                    const Text(
                      'Choose training mode',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 48),

                    // SINGLE DECK BUTTON
                    CustomElevatedButtonIcon(
                      // onPressed: function called when button is tapped
                      onPressed: () {
                        // Navigator.push navigates to a new screen
                        // MaterialPageRoute handles the transition animation
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SingleDeckConfigScreen(),
                          ),
                        );
                      },
                      // Icon shown on the left side of the button
                      icon: const Icon(Icons.filter_1, size: 28),
                      // Text shown on the button
                      label: const Text(
                        'Single Deck',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // MULTI DECK BUTTON
                    CustomElevatedButtonIcon(
                      onPressed: () {
                        // Navigate to multi deck configuration screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MultiDeckConfigScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.filter_9_plus, size: 28),
                      label: const Text(
                        'Multi Deck',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Informational text explaining the two modes
                    const Text(
                      'Single deck: train memory with 1-52 cards\n'
                          'Multi deck: increase difficulty with multiple decks',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
