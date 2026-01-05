// Results screen: shows how well the user performed
// Displays score, percentage, and a visual comparison of selected vs correct cards

import 'package:flutter/material.dart';
import '../models/card_model.dart';

class ResultsScreen extends StatelessWidget {
  // The correct cards in their actual order
  final List<PlayingCard> correctCards;

  // The cards the user selected (may contain nulls if not all were selected)
  final List<PlayingCard?> selectedCards;

  const ResultsScreen({
    super.key,
    required this.correctCards,
    required this.selectedCards,
  });

  // Calculates how many cards were correctly recalled
  int _calculateScore() {
    int correct = 0;
    for (int i = 0; i < correctCards.length; i++) {
      // Check if this position was selected and if it matches the correct card
      if (i < selectedCards.length && selectedCards[i] == correctCards[i]) {
        correct++;
      }
    }
    return correct;
  }

  // Calculates the percentage of correct recalls
  double _calculatePercentage() {
    return (_calculateScore() / correctCards.length) * 100;
  }

  // Returns a color based on the percentage score
  // Green for good (90+), orange for okay (70+), red for poor (<70)
  Color _getScoreColor(BuildContext context, double percentage) {
    if (percentage >= 90) return Colors.green;
    if (percentage >= 70) return Colors.orange;
    return Colors.red;
  }

  // Calculates cards per row based on screen width
  int _getCardsPerRow(double screenWidth) {
    if (screenWidth > 800) return 4;
    if (screenWidth > 500) return 3;
    return 2;
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

  @override
  Widget build(BuildContext context) {
    final score = _calculateScore();
    final percentage = _calculatePercentage();
    final scoreColor = _getScoreColor(context, percentage);
    final screenWidth = MediaQuery.of(context).size.width;
    final cardsPerRow = _getCardsPerRow(screenWidth);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        // Prevent going back (user should start fresh session from home)
        automaticallyImplyLeading: false,
      ),
      // SafeArea prevents content from being hidden by system UI
      body: SafeArea(
        child: Column(
          children: [
            // Score panel at the top
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: scoreColor.withValues(alpha: 0.1),  // Light background
                border: Border(
                  bottom: BorderSide(
                    color: scoreColor.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
              ),
              child: Column(
                children: [
                  // Main score: "45 / 52"
                  Text(
                    '$score / ${correctCards.length}',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: scoreColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Percentage: "86.5% correct"
                  Text(
                    '${percentage.toStringAsFixed(1)}% correct',
                    style: TextStyle(
                      fontSize: 20,
                      color: scoreColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable grid showing all results
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: (correctCards.length / cardsPerRow).ceil(),
                itemBuilder: (context, rowIndex) {
                  return _buildResultRow(context, rowIndex, cardsPerRow, screenWidth);
                },
              ),
            ),

            // Bottom button to return home
            // Wrapped to handle potential keyboard (future-proof)
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 16.0,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Pop all screens until we reach the home screen
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Return to Home',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Builds one row of results showing both user's choice and correct answer
  // Now accepts screenWidth to calculate fixed card width
  Widget _buildResultRow(BuildContext context, int rowIndex, int cardsPerRow, double screenWidth) {
    final startIndex = rowIndex * cardsPerRow;
    final endIndex = (startIndex + cardsPerRow).clamp(0, correctCards.length);
    
    // Calculate the fixed width each card should have
    final cardWidth = _getCardWidth(screenWidth, cardsPerRow);

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        children: [
          // Row 1: User's selected cards
          // Changed from spaceEvenly to start alignment
          // This prevents the last row from stretching cards to fill space
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(
              endIndex - startIndex,
                  (i) {
                final cardIndex = startIndex + i;
                final selectedCard = selectedCards[cardIndex];
                final correctCard = correctCards[cardIndex];
                final isCorrect = selectedCard == correctCard;

                // Replaced Expanded with fixed-width Container
                // This ensures all cards have the same width
                return Container(
                  width: cardWidth,
                  // Add spacing between cards, but not after the last card
                  margin: EdgeInsets.only(
                    right: i < (endIndex - startIndex - 1) ? 8.0 : 0,
                  ),
                  child: _buildCardResult(
                    selectedCard,
                    isCorrect,
                    'Your choice',
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Row 2: Correct cards
          // Changed from spaceEvenly to start alignment
          // This prevents the last row from stretching cards to fill space
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(
              endIndex - startIndex,
                  (i) {
                final cardIndex = startIndex + i;
                final correctCard = correctCards[cardIndex];

                // Replaced Expanded with fixed-width Container
                return Container(
                  width: cardWidth,
                  // Add spacing between cards, but not after the last card
                  margin: EdgeInsets.only(
                    right: i < (endIndex - startIndex - 1) ? 8.0 : 0,
                  ),
                  child: _buildCardResult(
                    correctCard,
                    true,  // Always true for the correct answer row
                    'Correct card',
                    isCorrectAnswer: true,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Builds a single card result display
  Widget _buildCardResult(
      PlayingCard? card,  // The card to display (null if not selected)
      bool isCorrect,  // Whether this card is correct in this position
      String label,  // Label to show below the card
          {
        bool isCorrectAnswer = false,  // Whether this is the "correct answer" row
      }) {
    Color backgroundColor;

    if (isCorrectAnswer) {
      // Correct answer row: always neutral blue background
      backgroundColor = Colors.blue.withValues(alpha: 0.1);
    } else {
      // User's choice row: green if correct, red if wrong
      backgroundColor = isCorrect
          ? Colors.green.withValues(alpha: 0.2)
          : Colors.red.withValues(alpha: 0.2);
    }

    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          // Thinner border for correct answer row
          color: isCorrect ? Colors.green : Colors.red,
          width: isCorrectAnswer ? 1 : 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (card != null) ...[
            // Display the card
            // TODO: Replace with SVG when assets are available
            Text(
              card.displayName,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                // Hearts and diamonds are red, clubs and spades are black
                color: (card.suit == '♥' || card.suit == '♦')
                    ? Colors.red
                    : Colors.black,
              ),
            ),
          ] else ...[
            // No card selected - show question mark
            const Icon(
              Icons.help_outline,
              size: 32,
              color: Colors.grey,
            ),
          ],
          const SizedBox(height: 4),
          // Label text
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
