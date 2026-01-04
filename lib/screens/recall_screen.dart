// Recall screen: user must recall and select the cards in the correct order
// Displays a grid of blank card slots where user selects which card was in each position

import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../widgets/card_selector_dropdown.dart';
import 'results_screen.dart';

class RecallScreen extends StatefulWidget {
  // The actual cards in their correct order
  final List<PlayingCard> correctCards;

  const RecallScreen({
    super.key,
    required this.correctCards,
  });

  @override
  State<RecallScreen> createState() => _RecallScreenState();
}

class _RecallScreenState extends State<RecallScreen> {
  // User's selected cards (null = not yet selected)
  late List<PlayingCard?> _selectedCards;

  @override
  void initState() {
    super.initState();
    // Initialize with null values (no cards selected yet)
    _selectedCards = List.filled(widget.correctCards.length, null);
  }

  // Calculates how many cards to show per row based on screen width
  // Larger screens show more cards per row
  int _getCardsPerRow(double screenWidth) {
    if (screenWidth > 800) return 4;  // Wide screens: 4 cards per row
    if (screenWidth > 500) return 3;  // Medium screens: 3 cards per row
    return 2;  // Small screens: 2 cards per row
  }

  // Callback when user selects a card at a specific position
  void _onCardSelected(int index, PlayingCard? card) {
    setState(() {
      _selectedCards[index] = card;
    });
  }

  // Checks if user has selected a card for every position
  bool _areAllCardsSelected() {
    return !_selectedCards.contains(null);
  }

  // Counts how many cards the user selected
  int _countSelectedCards() {
    int selected = 0;
    for (int i = 0; i < _selectedCards.length; i++) {
      if (_selectedCards[i] != null) {
        selected++;
      }
    }
    return selected;
  }

  // Shows confirmation dialog before finishing recall
  void _confirmFinish() {
    if (!_areAllCardsSelected()) {
      // Warn if not all cards are selected
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Warning'),
          content: const Text(
              'You haven\'t selected all cards. '
                  'Do you still want to finish the recall?'
          ),
          actions: [
            // Cancel button
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Continue'),
            ),
            // Confirm button
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                _goToResults();
              },
              child: const Text('Finish'),
            ),
          ],
        ),
      );
    } else {
      // All cards selected, go directly to results
      _goToResults();
    }
  }

  // Navigates to the results screen
  void _goToResults() {
    // Use pushReplacement so user can't go back to recall
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsScreen(
          correctCards: widget.correctCards,
          selectedCards: _selectedCards,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final cardsPerRow = _getCardsPerRow(screenWidth);
    final selectedCount = _countSelectedCards();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recall Phase'),
        actions: [
          // Shows the number of selected cards in the app bar (selected/total)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                '$selectedCount/${widget.correctCards.length}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      // SafeArea prevents content from being hidden by system UI
      body: SafeArea(
        child: Column(
          children: [
            // Instructions banner at the top
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .colorScheme
                    .primaryContainer,
              ),
              child: Text(
                'Select the cards in the order you saw them',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme
                      .of(context)
                      .colorScheme
                      .onPrimaryContainer,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Scrollable grid of card selectors
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                // Calculate number of rows needed
                itemCount: (widget.correctCards.length / cardsPerRow).ceil(),
                itemBuilder: (context, rowIndex) {
                  return _buildCardRow(rowIndex, cardsPerRow);
                },
              ),
            ),

            // Finish button at the bottom
            // Wrapped in SingleChildScrollView to handle keyboard
            SingleChildScrollView(
              reverse: true, // Keeps button visible when keyboard appears
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 16.0,
                  // Add padding for keyboard
                  bottom: MediaQuery
                      .of(context)
                      .viewInsets
                      .bottom + 16.0,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _confirmFinish,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme
                          .of(context)
                          .colorScheme
                          .primary,
                      foregroundColor: Theme
                          .of(context)
                          .colorScheme
                          .onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Finish Recall',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Builds a single row of card selectors
  Widget _buildCardRow(int rowIndex, int cardsPerRow) {
    // Calculate which cards belong in this row
    final startIndex = rowIndex * cardsPerRow;
    final endIndex = (startIndex + cardsPerRow).clamp(0, widget.correctCards.length);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          endIndex - startIndex,  // Number of cards in this row
              (i) {
            final cardIndex = startIndex + i;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: CardSelectorDropdown(
                  index: cardIndex,
                  selectedCard: _selectedCards[cardIndex],
                  onCardSelected: _onCardSelected,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
