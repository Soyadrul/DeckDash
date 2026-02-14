// Memorization screen: displays cards one by one for the user to memorize
// After viewing all cards, user proceeds to the recall phase
// FIXED: Timer now works even when hidden
// FIXED: Card display shows correct count format
// FIXED: 3-card display now shows all 3 cards properly

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math';
import '../models/card_model.dart';
import '../models/app_settings.dart';
import '../widgets/memorization_timer.dart';
import '../widgets/custom_elevated_button.dart'; // NEW: Import custom button widget
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
  
  int _currentGroupIndex = 0;
  bool _isCompleted = false;
  
  // FIXED: Timer key is now always present, even when hidden
  final GlobalKey<MemorizationTimerState> _timerKey = GlobalKey();
  Duration? _memorizationTime;

  final AppSettings _settings = AppSettings();
  
  DateTime? _lastBackPress;
  bool _showBackBanner = false;

  @override
  void initState() {
    super.initState();
    _prepareCards();
  }

  void _prepareCards() {
    if (widget.isMultiDeck) {
      _shuffledCards = _createMultiDeck(
        widget.deckCount!,
        widget.shuffleSeparately!,
      );
    } else {
      List<PlayingCard> deck = PlayingCard.createDeck();
      deck.shuffle(Random());
      _shuffledCards = deck.take(widget.totalCards).toList();
    }
  }

  List<PlayingCard> _createMultiDeck(int deckCount, bool shuffleSeparately) {
    List<PlayingCard> result = [];
    if (shuffleSeparately) {
      for (int i = 0; i < deckCount; i++) {
        List<PlayingCard> deck = PlayingCard.createDeck();
        deck.shuffle(Random());
        result.addAll(deck);
      }
    } else {
      for (int i = 0; i < deckCount; i++) {
        result.addAll(PlayingCard.createDeck());
      }
      result.shuffle(Random());
    }
    return result;
  }

  int _getTotalGroups() {
    final cardsPerView = _settings.getCardsPerView();
    return (_shuffledCards.length / cardsPerView).ceil();
  }

  List<PlayingCard> _getCurrentGroupCards() {
    final cardsPerView = _settings.getCardsPerView();
    final startIndex = _currentGroupIndex * cardsPerView;
    final endIndex = (startIndex + cardsPerView).clamp(0, _shuffledCards.length);
    return _shuffledCards.sublist(startIndex, endIndex);
  }

  int _getFirstCardIndex() {
    return _currentGroupIndex * _settings.getCardsPerView();
  }

  int _getLastCardIndex() {
    final cardsPerView = _settings.getCardsPerView();
    final lastIndex = (_currentGroupIndex + 1) * cardsPerView;
    return lastIndex.clamp(0, _shuffledCards.length);
  }

  bool _isLastGroup() {
    return _currentGroupIndex >= _getTotalGroups() - 1;
  }

  void _nextGroup() {
    if (!_isLastGroup()) {
      setState(() {
        _currentGroupIndex++;
      });
    } else {
      // Stop timer when last card is viewed
      _timerKey.currentState?.stopTimer();
      setState(() {
        _isCompleted = true;
      });
    }
  }

  void _previousGroup() {
    if (_currentGroupIndex > 0) {
      setState(() {
        _currentGroupIndex--;
      });
    }
  }

  void _startRecall() {
    _timerKey.currentState?.stopTimer();
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => RecallScreen(
          correctCards: _shuffledCards,
          memorizationTime: _memorizationTime,
          isMultiDeck: widget.isMultiDeck,
          deckCount: widget.deckCount ?? 1,
        ),
      ),
    );
  }

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

  Future<bool> _onWillPop() async {
    if (!_settings.enableBackConfirmation) {
      return true;
    }

    final now = DateTime.now();
    
    if (_lastBackPress != null && 
        now.difference(_lastBackPress!) < const Duration(seconds: 5)) {
      return true;
    }

    setState(() {
      _lastBackPress = now;
      _showBackBanner = true;
    });

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showBackBanner = false;
          _lastBackPress = null;
        });
      }
    });

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final currentCards = _getCurrentGroupCards();
    final totalGroups = _getTotalGroups();
    final firstCardIndex = _getFirstCardIndex();
    final lastCardIndex = _getLastCardIndex();

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          // FIXED: Show proper card count format
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _isCompleted
                  ? const Text('Memorization Complete')
                  : Text(_buildCardCountText(firstCardIndex, lastCardIndex)),
              if (!_isCompleted)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: LinearProgressIndicator(
                    value: (_currentGroupIndex + 1) / totalGroups,
                    minHeight: 4,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
            ],
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Center(  // Center the content horizontally
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600), // Limit max width on large screens
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height -
                              MediaQuery.of(context).padding.top -
                              MediaQuery.of(context).padding.bottom -
                              kToolbarHeight -
                              48,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (!_isCompleted) const SizedBox(height: 48),

                        if (!_isCompleted) _buildCardsDisplay(currentCards),
                        
                        if (_isCompleted) ...[
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

                        if (!_isCompleted) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomElevatedButtonIcon(
                                height: 56,
                                onPressed: _currentGroupIndex > 0 ? _previousGroup : null,
                                icon: const Icon(Icons.arrow_back),
                                label: const Text('Previous'),
                              ),

                              CustomElevatedButtonIcon(
                                height: 56,
                                onPressed: _nextGroup,
                                icon: const Icon(Icons.arrow_forward),
                                label: const Text('Next'),
                              ),
                            ],
                          ),
                        ] else ...[
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
                          CustomElevatedButton(
                            height: 56,
                            onPressed: _startRecall,
                            child: const Text(
                              'Start Recall',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ],
                    ),       // Closes Column(...)
                  ),         // Closes inner ConstrainedBox (line 222)
                ),           // Closes Padding(...)
              ),             // Closes SingleChildScrollView(...)
            ),               // Closes outer ConstrainedBox (line 217)
          ),                 // Closes Center(...)
              
              // FIXED: Timer is now always in the widget tree, just hidden with Opacity
              // This ensures it keeps running even when not visible
              Positioned(
                top: 16,
                right: 16,
                child: Opacity(
                  // Use opacity 0.0 when hidden instead of removing from tree
                  opacity: _settings.showMemorizationTimer ? 1.0 : 0.0,
                  child: IgnorePointer(
                    // Prevent interaction when invisible
                    ignoring: !_settings.showMemorizationTimer,
                    child: MemorizationTimer(
                      key: _timerKey,
                      onTimerStop: (elapsed) {
                        setState(() {
                          _memorizationTime = elapsed;
                        });
                        print('Memorization completed in: ${elapsed.inSeconds}.${(elapsed.inMilliseconds % 1000) ~/ 10} seconds');
                      },
                    ),
                  ),
                ),
              ),
              
              if (_showBackBanner)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Material(
                    elevation: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.orange.shade400,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.orange.shade700,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Press back again within 5 seconds to exit',
                              style: TextStyle(
                                color: Colors.orange.shade900,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],              // End of Stack's children list
          ),                // Closes Stack(...)
        ),                  // Closes SafeArea(... body: SafeArea(...) ...)
      ),                    // Closes Scaffold(... child: Scaffold(...) ...)
    );                      // Closes WillPopScope and ends the return statement
  }

  /// FIXED: Builds proper card count text
  /// "Card 1 of 52" for single card
  /// "Card 1-3 of 52" for multiple cards
  String _buildCardCountText(int firstIndex, int lastIndex) {
    final first = firstIndex + 1;  // Convert from 0-based to 1-based
    final last = lastIndex;        // lastIndex is already the count
    
    // If showing only one card, use singular format
    if (first == last) {
      return 'Card $first of ${_shuffledCards.length}';
    }
    
    // If showing multiple cards, use range format
    return 'Card $first-$last of ${_shuffledCards.length}';
  }

  /// FIXED: Builds card display with proper layout for 3 cards
  Widget _buildCardsDisplay(List<PlayingCard> cards) {
    // Single card - centered display
    if (cards.length == 1) {
      return Center(
        child: _buildSingleCard(cards[0]),
      );
    }
    
    // FIXED: Multiple cards - use Wrap for better layout flexibility
    // Wrap automatically handles overflow better than Row
    return Center(
      child: Wrap(
        spacing: 8.0,           // Horizontal space between cards
        alignment: WrapAlignment.center,
        children: cards.map((card) {
          return _buildSingleCard(card);
        }).toList(),
      ),
    );
  }

  /// Builds a single card widget
  Widget _buildSingleCard(PlayingCard card) {
    return Container(
      width: 150,
      height: 210,
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SvgPicture.asset(
          'assets/images/${card.imageName}',
          fit: BoxFit.contain, // Changed from BoxFit.cover to BoxFit.contain to show the full card
          width: 150,
          height: 210,
        ),
      ),
    );
  }
}
