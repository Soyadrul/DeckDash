/// single_deck_config_screen.dart
/// Configuration screen for single deck mode
/// Users can choose between a full deck (52 cards) or a custom number of cards

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';  // For input formatters
import 'memorization_screen.dart';  // Import the memorization screen
import '../widgets/custom_elevated_button.dart'; // NEW: Import custom button widget

// StatefulWidget because this screen has changing state (user selections)
class SingleDeckConfigScreen extends StatefulWidget {
  const SingleDeckConfigScreen({super.key});

  @override
  State<SingleDeckConfigScreen> createState() => _SingleDeckConfigScreenState();
}

// The State class holds the mutable data for the StatefulWidget
class _SingleDeckConfigScreenState extends State<SingleDeckConfigScreen> {
  // Tracks whether user wants full deck (true) or custom number (false)
  bool _useFullDeck = true;

  // Controller for the text input field
  // Allows us to read and manipulate the text field's content
  final TextEditingController _cardCountController = TextEditingController(text: '12');

  // Error message to display if input is invalid (null means no error)
  String? _errorMessage;

  @override
  void dispose() {
    // IMPORTANT: Always dispose controllers to free up resources
    // This prevents memory leaks
    _cardCountController.dispose();
    super.dispose();
  }

  // Validates the user's input
  // Returns true if input is valid, false otherwise
  bool _validateInput() {
    // If using full deck, always valid
    if (_useFullDeck) {
      return true;
    }

    // Try to parse the input as an integer
    final input = _cardCountController.text;
    final number = int.tryParse(input);  // Returns null if parsing fails

    // Check if input is not a valid number
    if (number == null) {
      setState(() {
        _errorMessage = 'Please enter a valid number';
      });
      return false;
    }

    // Check if number is outside valid range (1-51)
    if (number < 1 || number > 51) {
      setState(() {
        _errorMessage = 'Number must be between 1 and 51';
      });
      return false;
    }

    // Input is valid, clear any error message
    setState(() {
      _errorMessage = null;
    });
    return true;
  }

  // Starts the training session
  void _startSession() {
    // Only proceed if input is valid
    if (_validateInput()) {
      // Determine how many cards to use
      final cardCount = _useFullDeck ? 52 : int.parse(_cardCountController.text);

      // Navigate to the memorization screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MemorizationScreen(
            totalCards: cardCount,
            isMultiDeck: false,  // Single deck mode
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Single Deck Configuration'),
      ),
      // SafeArea prevents content from being hidden by system UI
      body: SafeArea(
        // SingleChildScrollView allows scrolling when keyboard appears
        child: Center(  // Center the content horizontally
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600), // Limit max width on large screens
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,  // Align children to the left
            children: [
              // Section title
              const Text(
                'Choose number of cards',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // OPTION 1: Full deck (52 cards)
              // Card widget provides a material design card with elevation
              Card(
                child: RadioListTile<bool>(
                  title: const Text('Full deck (52 cards)'),
                  subtitle: const Text('Train memory with all cards'),
                  value: true,  // Value this radio button represents
                  groupValue: _useFullDeck,  // Current selected value
                  // Called when this radio button is tapped
                  onChanged: (value) {
                    setState(() {
                      _useFullDeck = value!;
                      _errorMessage = null;  // Clear any error
                    });
                  },
                ),
              ),

              const SizedBox(height: 12),

              // OPTION 2: Custom number of cards
              Card(
                child: RadioListTile<bool>(
                  title: const Text('Custom number'),
                  subtitle: const Text('Choose how many cards to use (1-51)'),
                  value: false,
                  groupValue: _useFullDeck,
                  onChanged: (value) {
                    setState(() {
                      _useFullDeck = value!;
                      _errorMessage = null;
                    });
                  },
                ),
              ),

              // Show text field only when custom number is selected
              // The "..." syntax is called a spread operator
              if (!_useFullDeck) ...[
                const SizedBox(height: 24),

                // Text input field for entering custom number
                TextField(
                  controller: _cardCountController,
                  decoration: InputDecoration(
                    labelText: 'Number of cards',
                    helperText: 'Enter a number between 1 and 51',
                    errorText: _errorMessage,  // Shows error if not null
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.numbers),
                  ),
                  keyboardType: TextInputType.number,  // Shows numeric keyboard

                  // Input formatters restrict what can be typed
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,  // Only allow digits (0-9)
                  ],

                  // Called whenever the text changes
                  onChanged: (value) {
                    // Clear error message when user starts typing
                    if (_errorMessage != null) {
                      setState(() {
                        _errorMessage = null;
                      });
                    }
                  },
                ),
              ],

              // Add spacing before button
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),

              // Start button at the bottom
              CustomElevatedButton(
                height: 56,
                onPressed: _startSession,
                child: const Text(
                  'Start Training',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ), // Column
        ), // SingleChildScrollView
      ), // ConstrainedBox
    ), // Center
  ) // SafeArea
); // Scaffold
  }  // Closes the build() method
}    // Closes the _SingleDeckConfigScreenState class
