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
    // Adjusted breakpoints to be more conservative
    // This prevents trying to fit too many cards on smaller screens
    if (screenWidth >= 900) return 4;   // Very wide screens: 4 cards per row
    if (screenWidth >= 600) return 3;   // Medium/tablet screens: 3 cards per row
    return 2;                           // Phone screens: 2 cards per row
  }

  // Calculates the width each card should have
  // This ensures all cards have the same width, even in incomplete rows
  double _getCardWidth(double availableWidth, int cardsPerRow) {
    // CRITICAL: This method now receives the ACTUAL available width
    // from LayoutBuilder, which accounts for SafeArea and all padding
    
    // Calculate total spacing between cards in a row
    // For N cards, there are (N-1) gaps of 8px each
    final totalSpacing = 8.0 * (cardsPerRow - 1);
    
    // Calculate width per card
    // Divide remaining space equally among all cards
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
        // CRITICAL FIX: Use LayoutBuilder to get the ACTUAL available width
        // This accounts for SafeArea padding, system UI, and all constraints
        child: LayoutBuilder(
          builder: (context, constraints) {
            // constraints.maxWidth is the TRUE available width after SafeArea
            final availableWidth = constraints.maxWidth;
            final cardsPerRow = _getCardsPerRow(availableWidth);
            
            return SingleChildScrollView(
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

                  // Card selectors grid
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: _buildAllCardRows(availableWidth, cardsPerRow),
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
            );
          },
        ),
      ),
    );
  }

  // Builds all card rows at once instead of using ListView.builder
  // This allows the SingleChildScrollView to handle all scrolling
  List<Widget> _buildAllCardRows(double availableWidth, int cardsPerRow) {
    // Calculate total number of rows needed
    final totalRows = (widget.correctCards.length / cardsPerRow).ceil();
    
    // Build a list of all row widgets
    return List.generate(totalRows, (rowIndex) {
      return _buildCardRow(rowIndex, cardsPerRow, availableWidth);
    });
  }

  // Builds a single row of card selectors
  Widget _buildCardRow(int rowIndex, int cardsPerRow, double availableWidth) {
    // Calculate which cards belong in this row
    final startIndex = rowIndex * cardsPerRow;
    final endIndex = (startIndex + cardsPerRow).clamp(0, widget.correctCards.length);
    
    // Calculate the fixed width each card should have
    // IMPORTANT: Subtract the padding (16px * 2 = 32px) from available width
    final cardWidth = _getCardWidth(availableWidth - 32, cardsPerRow);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(
          endIndex - startIndex,
              (i) {
            final cardIndex = startIndex + i;
            
            return Container(
              width: cardWidth,
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
