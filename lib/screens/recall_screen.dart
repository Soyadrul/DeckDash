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

  // Calculates the width each card should have
  // This ensures all cards have the same width, even in incomplete rows
  double _getCardWidth(double screenWidth, int cardsPerRow) {
    // Total horizontal padding (16px on each side)
    const totalHorizontalPadding = 32.0;
    
    // Horizontal padding between cards (4px on each side = 8px total per card)
    const cardHorizontalPadding = 8.0;
    
    // Calculate available width for cards
    final availableWidth = screenWidth - totalHorizontalPadding;
    
    // Calculate total spacing between cards in a row
    final totalSpacing = cardHorizontalPadding * (cardsPerRow - 1);
    
    // Calculate width per card
    // Each card gets equal width, with spacing accounted for
    return (availableWidth - totalSpacing) / cardsPerRow;
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
    final screenWidth = MediaQuery.of(context).size.width;
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
        // CRITICAL FIX: Wrap the entire body in SingleChildScrollView
        // This makes the whole screen scrollable when content is too tall
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Instructions banner at the top
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: Text(
                  'Select the cards in the order you saw them',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // UPDATED: Card selectors grid - no longer wrapped in Expanded
              // Instead, we calculate the exact height needed
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: _buildAllCardRows(screenWidth, cardsPerRow),
                ),
              ),

              // Finish button at the bottom
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 0.0,
                  bottom: 16.0,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _confirmFinish,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
            ],
          ),
        ),
      ),
    );
  }

  // NEW METHOD: Builds all card rows at once instead of using ListView.builder
  // This allows the SingleChildScrollView to handle all scrolling
  List<Widget> _buildAllCardRows(double screenWidth, int cardsPerRow) {
    // Calculate total number of rows needed
    final totalRows = (widget.correctCards.length / cardsPerRow).ceil();
    
    // Build a list of all row widgets
    return List.generate(totalRows, (rowIndex) {
      return _buildCardRow(rowIndex, cardsPerRow, screenWidth);
    });
  }

  // Builds a single row of card selectors
  Widget _buildCardRow(int rowIndex, int cardsPerRow, double screenWidth) {
    // Calculate which cards belong in this row
    final startIndex = rowIndex * cardsPerRow;
    final endIndex = (startIndex + cardsPerRow).clamp(0, widget.correctCards.length);
    
    // Calculate the fixed width each card should have
    final cardWidth = _getCardWidth(screenWidth, cardsPerRow);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      // Changed from spaceEvenly to start alignment
      // This prevents the last row from stretching cards to fill space
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(
          endIndex - startIndex,  // Number of cards in this row
              (i) {
            final cardIndex = startIndex + i;
            
            // Replaced Expanded with fixed-width Container
            // This ensures all cards have the same width
            return Container(
              width: cardWidth,
              // Add spacing between cards, but not after the last card
              margin: EdgeInsets.only(
                right: i < (endIndex - startIndex - 1) ? 8.0 : 0,
              ),
              child: CardSelectorDropdown(
                index: cardIndex,
                selectedCard: _selectedCards[cardIndex],
                onCardSelected: _onCardSelected,
              ),
            );
          },
        ),
      ),
    );
  }
}
