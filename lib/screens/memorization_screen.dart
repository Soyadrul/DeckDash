// Memorization screen: displays cards one by one for the user to memorize
// After viewing all cards, user proceeds to the recall phase
// NOW WITH TIMER: Tracks how long user takes to memorize all cards

import 'package:flutter/material.dart';
import 'dart:math';  // For Random() function
import '../models/card_model.dart';
import '../widgets/memorization_timer.dart';  // ADDED: Import the timer widget
import 'recall_screen.dart';

class MemorizationScreen extends StatefulWidget {
  // Total number of cards to memorize
  final int totalCards;

  // Whether this is multi-deck mode
  final bool isMultiDeck;

  // Number of decks (only used in multi-deck mode)
  final int? deckCount;

  // Whether to shuffle decks separately (only used in multi-deck mode)
  final bool? shuffleSeparately;

  const MemorizationScreen({
    super.key,
    required this.totalCards,
    required this.isMultiDeck,
    this.deckCount,
    this.shuffleSeparately,
  });

  @override
  State<MemorizationScreen> createState() => _MemorizationScreenState();
}

class _MemorizationScreenState extends State<MemorizationScreen> {
  // The shuffled list of cards the user needs to memorize
  late List<PlayingCard> _shuffledCards;

  // Index of the currently displayed card (0-based)
  int _currentIndex = 0;

  // Whether the user has viewed all cards
  bool _isCompleted = false;

  // ADDED: GlobalKey to control the timer from this widget
  // This allows us to stop the timer when user moves to recall phase
  final GlobalKey<MemorizationTimerState> _timerKey = GlobalKey();
  
  // ADDED: Variable to store the memorization time when timer stops
  Duration? _memorizationTime;

  @override
  void initState() {
    super.initState();
    // Prepare and shuffle cards when screen loads
    _prepareCards();
  }

  // Prepares and shuffles cards based on configuration
  void _prepareCards() {
    if (widget.isMultiDeck) {
      // Multi-deck mode: create multiple decks with specified shuffling method
      _shuffledCards = _createMultiDeck(
        widget.deckCount!,
        widget.shuffleSeparately!,
      );
    } else {
      // Single deck mode: create one deck and shuffle it
      List<PlayingCard> deck = PlayingCard.createDeck();
      deck.shuffle(Random());  // Randomly shuffle the deck

      // Take only the requested number of cards
      _shuffledCards = deck.take(widget.totalCards).toList();
    }
  }

  // Creates multiple decks and shuffles them according to the chosen method
  List<PlayingCard> _createMultiDeck(int deckCount, bool shuffleSeparately) {
    List<PlayingCard> result = [];

    if (shuffleSeparately) {
      // Each deck is shuffled independently, then they're combined in order
      for (int i = 0; i < deckCount; i++) {
        List<PlayingCard> deck = PlayingCard.createDeck();
        deck.shuffle(Random());
        result.addAll(deck);  // Add this shuffled deck to the result
      }
    } else {
      // All cards from all decks are combined first, then shuffled together
      for (int i = 0; i < deckCount; i++) {
        result.addAll(PlayingCard.createDeck());
      }
      result.shuffle(Random());  // Shuffle all cards together
    }

    return result;
  }

  // Advances to the next card
  void _nextCard() {
    if (_currentIndex < _shuffledCards.length - 1) {
      // Not at the last card yet, move to next
      setState(() {
        _currentIndex++;
      });
    } else {
      // Just viewed the last card, mark as completed
      // ADDED: Stop the timer when all cards have been viewed
      _timerKey.currentState?.stopTimer();
      
      setState(() {
        _isCompleted = true;
      });
    }
  }

  // Goes back to the previous card
  void _previousCard() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  // MODIFIED: Transitions to the recall phase
  // Now stops the timer and passes memorization time to recall screen
  void _startRecall() {
    // NOTE: Timer is already stopped in _nextCard() when last card is viewed
    // This is just a safety check in case timer is somehow still running
    _timerKey.currentState?.stopTimer();
    
    // Use pushReplacement so user can't go back to memorization
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => RecallScreen(
          correctCards: _shuffledCards,
          memorizationTime: _memorizationTime,  // ADDED: Pass the memorization time
          isMultiDeck: widget.isMultiDeck,      // ADDED: Pass deck type
          deckCount: widget.deckCount ?? 1,      // ADDED: Pass deck count
        ),
      ),
    );
  }

  // ADDED: Formats the final memorization time for display
  // Shows format: MM:SS.CS (same as timer widget)
  String _formatFinalTime(Duration? duration) {
    if (duration == null) return '00:00.00';
    
    int totalSeconds = duration.inSeconds;
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    int centiseconds = (duration.inMilliseconds % 1000) ~/ 10;
    
    return '${minutes.toString().padLeft(2, '0')}:'
           '${seconds.toString().padLeft(2, '0')}.'
           '${centiseconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final currentCard = _shuffledCards[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        // MODIFIED: Show "Card X of X" only when not completed
        // When completed, show just the app name or empty title
        title: _isCompleted 
            ? const Text('Memorization Complete')  // Shows completion message in AppBar
            : Text('Card ${_currentIndex + 1} of ${_shuffledCards.length}'),
      ),
      // SafeArea prevents content from being hidden by system UI
      body: SafeArea(
        // ADDED: Use Stack to overlay the timer on top of existing content
        // This allows the timer to float in the top-right corner
        child: Stack(
          children: [
            // EXISTING CONTENT: All your original content stays the same
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                // ConstrainedBox ensures content fills screen height
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom -
                        kToolbarHeight - // AppBar height
                        48, // Padding
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // MODIFIED: Progress bar only shown when not completed
                      // This prevents the progress bar from appearing after all cards viewed
                      if (!_isCompleted)
                        LinearProgressIndicator(
                          value: (_currentIndex + 1) / _shuffledCards.length,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                        ),

                      // MODIFIED: Only add spacing after progress bar if it's showing
                      if (!_isCompleted) const SizedBox(height: 48),

                      // Display the current card ONLY if not completed
                      // Once all cards are viewed, hide the card display
                      if (!_isCompleted) _buildCardDisplay(currentCard),
                      
                      // MODIFIED: Show completion content when all cards viewed
                      // Removed the green check mark icon that was here before
                      if (_isCompleted) ...[
                        //const SizedBox(height: 144),
                        
                        // Show final memorization time in a card-like display
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 24,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.blue.withValues(alpha: 0.3),
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.timer,
                                    color: Colors.blue.shade700,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Memorization Time',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue.shade700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Display the final time in large, readable format
                              Text(
                                _formatFinalTime(_memorizationTime),
                                style: TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade900,
                                  fontFeatures: const [
                                    FontFeature.tabularFigures(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 48),

                      // Navigation controls or completion message
                      if (!_isCompleted) ...[
                        // Show previous/next buttons while viewing cards
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Previous button (disabled on first card)
                            ElevatedButton.icon(
                              onPressed: _currentIndex > 0 ? _previousCard : null,
                              icon: const Icon(Icons.arrow_back),
                              label: const Text('Previous'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                              ),
                            ),

                            // Next button (always enabled)
                            ElevatedButton.icon(
                              onPressed: _nextCard,
                              icon: const Icon(Icons.arrow_forward),
                              label: const Text('Next'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        // Show completion message and recall button
                        const Text(
                          'You\'ve seen all the cards!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Ready for the recall phase?',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _startRecall,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Start Recall',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            
            // ADDED: Timer positioned in top-right corner
            // This floats above all other content and doesn't interfere with layout
            Positioned(
              top: 16,   // 16px from the top
              right: 16, // 16px from the right edge
              child: MemorizationTimer(
                key: _timerKey,
                // Callback that saves the time when timer stops
                onTimerStop: (elapsed) {
                  setState(() {
                    _memorizationTime = elapsed;
                  });
                  // Optional: Print to console for debugging
                  print('Memorization completed in: ${elapsed.inSeconds}.${(elapsed.inMilliseconds % 1000) ~/ 10} seconds');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Builds the card display widget
  Widget _buildCardDisplay(PlayingCard card) {
    return Container(
      width: 200,
      height: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display card rank and suit as text
          // TODO: Replace with SVG image once assets are available
          // Use: SvgPicture.asset('assets/images/${card.imageName}')
          Text(
            card.displayName,
            style: TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.bold,
              // Hearts and diamonds are red, clubs and spades are black
              color: (card.suit == '♥' || card.suit == '♦')
                  ? Colors.red
                  : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          // Show the expected SVG filename
          Text(
            'Image: ${card.imageName}',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
