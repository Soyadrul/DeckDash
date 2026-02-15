// Results screen: shows how well the user performed
// Displays score, percentage, and a visual comparison of selected vs correct cards
// NOW WITH TIMING INFO: Shows memorization time and auto-submit notification

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/card_model.dart';
import '../models/app_settings.dart';
import '../utils/svg_font_size_util.dart';
import '../widgets/custom_elevated_button.dart'; // NEW: Import custom button widget
import '../main.dart'; // Import the t() function for localization

class ResultsScreen extends StatelessWidget {
  // The correct cards in their actual order
  final List<PlayingCard> correctCards;

  // The cards the user selected (may contain nulls if not all were selected)
  final List<PlayingCard?> selectedCards;
  
  // ADDED: The time it took to memorize the cards
  final Duration? memorizationTime;
  
  // ADDED: Whether the recall was auto-submitted due to time running out
  final bool wasAutoSubmitted;

  const ResultsScreen({
    super.key,
    required this.correctCards,
    required this.selectedCards,
    this.memorizationTime,
    required this.wasAutoSubmitted,
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

  // ADDED: Formats memorization time into readable format
  // Returns format: MM:SS.CS (minutes:seconds.centiseconds)
  String _formatMemorizationTime(Duration? duration) {
    if (duration == null) return 'N/A';
    
    int totalSeconds = duration.inSeconds;
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    int centiseconds = (duration.inMilliseconds % 1000) ~/ 10;
    
    // Return formatted string with leading zeros
    return '${minutes.toString().padLeft(2, '0')}:'
           '${seconds.toString().padLeft(2, '0')}.'
           '${centiseconds.toString().padLeft(2, '0')}';
  }

  // Calculates cards per row based on screen width
  int _getCardsPerRow(double screenWidth) {
    // Adjusted breakpoints to be more conservative
    // This prevents trying to fit too many cards on smaller screens
    if (screenWidth >= 2000) return 10; // Ultra-wide screens: 10 cards per row
    if (screenWidth >= 1800) return 9;  // Very wide screens: 9 cards per row
    if (screenWidth >= 1600) return 8;  // Very wide screens: 8 cards per row
    if (screenWidth >= 1400) return 7;  // Very wide screens: 7 cards per row
    if (screenWidth >= 1200) return 6;  // Very wide screens: 6 cards per row
    if (screenWidth >= 1000) return 5;  // Wide screens: 5 cards per row
    if (screenWidth >= 800) return 4;   // Medium-wide screens: 4 cards per row
    if (screenWidth >= 600) return 3;   // Tablet screens: 3 cards per row
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

  @override
  Widget build(BuildContext context) {
    final score = _calculateScore();
    final percentage = _calculatePercentage();
    final scoreColor = _getScoreColor(context, percentage);

    return Scaffold(
      appBar: AppBar(
        title: Text(t('results')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to home screen
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
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
                  // ADDED: Auto-submit warning banner (only shown if auto-submitted)
                  if (wasAutoSubmitted)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.2),
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.orange.withValues(alpha: 0.5),
                            width: 2,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.timer_off,
                            color: Colors.orange[700]!,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              t('time_ran_out_auto_submit'),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.orange[700]!,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  // Score panel at the top (made more compact)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    decoration: BoxDecoration(
                      color: scoreColor.withValues(alpha: 0.1),
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
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: scoreColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Percentage: "86.5% correct"
                        Text(
                          '${percentage.toStringAsFixed(1)}% ${t('correct')}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ADDED: Memorization time display
                  if (memorizationTime != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.blue.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.timer,
                            color: Colors.blue.shade700,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${t('memorization_time')}: ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue[700]!,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            _formatMemorizationTime(memorizationTime),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.blue[900]!,
                              fontWeight: FontWeight.bold,
                              fontFeatures: const [
                                FontFeature.tabularFigures(), // Monospace numbers
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Card comparison grid
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: _buildAllResultRows(context, availableWidth, cardsPerRow),
                    ),
                  ),

                  // Bottom button to return home
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 0.0,
                      bottom: 16.0,
                    ),
                    child: CustomOutlinedButton(
                      height: 56,
                      onPressed: () {
                        // Pop all screens until we reach the home screen
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      child: Text(
                        t('return_home'),
                        style: const TextStyle(fontSize: 16),
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

  // Builds all result rows at once instead of using ListView.builder
  // This allows the SingleChildScrollView to handle all scrolling
  List<Widget> _buildAllResultRows(BuildContext context, double availableWidth, int cardsPerRow) {
    // Calculate total number of rows needed
    final totalRows = (correctCards.length / cardsPerRow).ceil();
    
    // Build a list of all row widgets
    return List.generate(totalRows, (rowIndex) {
      return _buildResultRow(context, rowIndex, cardsPerRow, availableWidth);
    });
  }

  // Builds one row of results showing both user's choice and correct answer
  Widget _buildResultRow(BuildContext context, int rowIndex, int cardsPerRow, double availableWidth) {
    final startIndex = rowIndex * cardsPerRow;
    final endIndex = (startIndex + cardsPerRow).clamp(0, correctCards.length);
    
    // Calculate the fixed width each card should have
    // IMPORTANT: Subtract the padding (16px * 2 = 32px) from available width
    final cardWidth = _getCardWidth(availableWidth - 32, cardsPerRow);

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        children: [
          // Row 1: User's selected cards
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(
              endIndex - startIndex,
                  (i) {
                final cardIndex = startIndex + i;
                final selectedCard = selectedCards[cardIndex];
                final correctCard = correctCards[cardIndex];
                final isCorrect = selectedCard == correctCard;

                return Container(
                  width: cardWidth,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(
              endIndex - startIndex,
                  (i) {
                final cardIndex = startIndex + i;
                final correctCard = correctCards[cardIndex];

                return Container(
                  width: cardWidth,
                  margin: EdgeInsets.only(
                    right: i < (endIndex - startIndex - 1) ? 8.0 : 0,
                  ),
                  child: _buildCardResult(
                    correctCard,
                    true,
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
      PlayingCard? card,
      bool isCorrect,
      String label,
          {
        bool isCorrectAnswer = false,
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
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCorrect ? Colors.green : Colors.red,
          width: isCorrectAnswer ? 1 : 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (card != null) ...[
            // Display the card as SVG without white background
            AspectRatio(
              aspectRatio: 0.7, // Standard card aspect ratio (width/height)
              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SvgWithCustomFontSize(
                    assetPath: 'assets/images/${card.imageName}',
                    cornerFontSize: AppSettings().svgCornerFontSize,
                    centerFontSize: AppSettings().svgCenterFontSize,
                    fit: BoxFit.contain, // Changed to contain to ensure the full card is visible
                  ),
                ),
              ),
            ),
          ] else ...[
            // No card selected - show question mark
            // Using AspectRatio to maintain consistent height with card view
            AspectRatio(
              aspectRatio: 0.7, // Same aspect ratio as card
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.help_outline,
                      size: 24, // Reduced size from 32 to 24
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 2), // Reduced height from 4 to 2
          // Label text
          Text(
            label == 'Your choice' ? t('your_choice') : t('correct_card'),
            style: const TextStyle(
              fontSize: 8, // Reduced font size from 10 to 8
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
