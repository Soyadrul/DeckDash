/// multi_deck_config_screen.dart
/// Configuration screen for multi deck mode
/// Users can choose number of decks and shuffling method

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'memorization_screen.dart';  // Import the memorization screen
import '../widgets/custom_elevated_button.dart'; // NEW: Import custom button widget

class MultiDeckConfigScreen extends StatefulWidget {
  const MultiDeckConfigScreen({super.key});

  @override
  State<MultiDeckConfigScreen> createState() => _MultiDeckConfigScreenState();
}

class _MultiDeckConfigScreenState extends State<MultiDeckConfigScreen> {
  // Controller for the number of decks input field
  final TextEditingController _deckCountController = TextEditingController(text: '2');

  // Shuffling mode:
  // false = shuffle all cards together (as one big deck)
  // true = shuffle each deck separately, then combine them
  bool _shuffleSeparately = false;

  // Error message for invalid input
  String? _errorMessage;

  @override
  void dispose() {
    // Free up resources when widget is destroyed
    _deckCountController.dispose();
    super.dispose();
  }

  // Validates the number of decks input
  bool _validateInput() {
    final input = _deckCountController.text;
    final number = int.tryParse(input);

    // Check if input is not a number
    if (number == null) {
      setState(() {
        _errorMessage = 'Please enter a valid number';
      });
      return false;
    }

    // Minimum 2 decks required for multi-deck mode
    if (number < 2) {
      setState(() {
        _errorMessage = 'Number of decks must be at least 2';
      });
      return false;
    }

    // Reasonable maximum to avoid memory issues
    if (number > 10) {
      setState(() {
        _errorMessage = 'Maximum 10 decks per session';
      });
      return false;
    }

    // Input is valid
    setState(() {
      _errorMessage = null;
    });
    return true;
  }

  // Starts the training session with configured settings
  void _startSession() {
    if (_validateInput()) {
      final deckCount = int.parse(_deckCountController.text);
      final totalCards = deckCount * 52;  // Each deck has 52 cards

      // Navigate to memorization screen with multi-deck configuration
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MemorizationScreen(
            totalCards: totalCards,
            isMultiDeck: true,
            deckCount: deckCount,
            shuffleSeparately: _shuffleSeparately,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multi Deck Configuration'),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SECTION 1: Number of decks
              const Text(
                'Number of decks',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Input field for number of decks
              TextField(
                controller: _deckCountController,
                decoration: InputDecoration(
                  labelText: 'Number of decks',
                  helperText: 'Minimum 2, maximum 10',
                  errorText: _errorMessage,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.content_copy),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (value) {
                  // Clear error when user types
                  if (_errorMessage != null) {
                    setState(() {
                      _errorMessage = null;
                    });
                  }
                  // Force a rebuild to update the total cards display
                  setState(() {});
                },
              ),

              const SizedBox(height: 32),

              // SECTION 2: Shuffling mode
              const Text(
                'Shuffling mode',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // OPTION 1: Shuffle all cards together
              Card(
                child: RadioListTile<bool>(
                  title: const Text('Shuffle all cards together'),
                  subtitle: const Text('All cards are shuffled as one big deck'),
                  value: false,  // This option means NOT shuffling separately
                  groupValue: _shuffleSeparately,
                  onChanged: (value) {
                    setState(() {
                      _shuffleSeparately = value!;
                    });
                  },
                ),
              ),

              const SizedBox(height: 12),

              // OPTION 2: Shuffle each deck separately
              Card(
                child: RadioListTile<bool>(
                  title: const Text('Shuffle each deck separately'),
                  subtitle: const Text('Each deck is shuffled individually, then combined'),
                  value: true,  // This option means shuffling separately
                  groupValue: _shuffleSeparately,
                  onChanged: (value) {
                    setState(() {
                      _shuffleSeparately = value!;
                    });
                  },
                ),
              ),

              // Add spacing before bottom section
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),

              // Info box showing total number of cards
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        // Calculate and display total cards
                        'Total cards: ${(int.tryParse(_deckCountController.text) ?? 2) * 52}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Start button, centered horizontally
              Align(
                alignment: Alignment.center,
                child: CustomElevatedButton(
                  height: 56,
                  onPressed: _startSession,
                  child: const Text(
                    'Start Training',
                    style: TextStyle(fontSize: 18),
                  ),
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
}    // Closes the _MultiDeckConfigScreenState class
