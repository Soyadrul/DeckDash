/// recall_screen.dart
/// UPDATED: Added back gesture confirmation to prevent accidental exits

import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../models/app_settings.dart';
import '../widgets/card_selector_dropdown.dart';
import '../widgets/recall_countdown_timer.dart';
import 'results_screen.dart';

class RecallScreen extends StatefulWidget {
  final List<PlayingCard> correctCards;
  final Duration? memorizationTime;
  final bool isMultiDeck;
  final int deckCount;

  const RecallScreen({
    super.key,
    required this.correctCards,
    this.memorizationTime,
    required this.isMultiDeck,
    required this.deckCount,
  });

  @override
  State<RecallScreen> createState() => _RecallScreenState();
}

class _RecallScreenState extends State<RecallScreen> {
  late List<PlayingCard?> _selectedCards;
  
  // Get settings instance
  final AppSettings _settings = AppSettings();
  
  // Back confirmation state
  DateTime? _lastBackPress;
  bool _showBackBanner = false;

  @override
  void initState() {
    super.initState();
    _selectedCards = List.filled(widget.correctCards.length, null);
  }

  int _calculateRecallTime() {
    const int baseTimePerDeck = 300;
    
    if (widget.isMultiDeck) {
      return baseTimePerDeck * widget.deckCount;
    } else {
      return baseTimePerDeck;
    }
  }

  int _getCardsPerRow(double screenWidth) {
    if (screenWidth >= 900) return 4;
    if (screenWidth >= 600) return 3;
    return 2;
  }

  double _getCardWidth(double availableWidth, int cardsPerRow) {
    final totalSpacing = 8.0 * (cardsPerRow - 1);
    return (availableWidth - totalSpacing) / cardsPerRow;
  }

  void _onCardSelected(int index, PlayingCard? card) {
    setState(() {
      _selectedCards[index] = card;
    });
  }

  bool _areAllCardsSelected() {
    return !_selectedCards.contains(null);
  }

  int _countSelectedCards() {
    int selected = 0;
    for (int i = 0; i < _selectedCards.length; i++) {
      if (_selectedCards[i] != null) {
        selected++;
      }
    }
    return selected;
  }

  void _handleTimeUp() {
    _goToResults(wasAutoSubmitted: true);
  }

  void _confirmFinish() {
    if (!_areAllCardsSelected()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Warning'),
          content: const Text(
              'You haven\'t selected all cards. '
                  'Do you still want to finish the recall?'
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Continue'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                _goToResults(wasAutoSubmitted: false);
              },
              child: const Text('Finish'),
            ),
          ],
        ),
      );
    } else {
      _goToResults(wasAutoSubmitted: false);
    }
  }

  void _goToResults({required bool wasAutoSubmitted}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsScreen(
          correctCards: widget.correctCards,
          selectedCards: _selectedCards,
          memorizationTime: widget.memorizationTime,
          wasAutoSubmitted: wasAutoSubmitted,
        ),
      ),
    );
  }

  /// Handles back button press with confirmation if enabled
  Future<bool> _onWillPop() async {
    // If back confirmation is disabled, allow immediate back
    if (!_settings.enableBackConfirmation) {
      return true;
    }

    final now = DateTime.now();
    
    // Check if this is the second press within 5 seconds
    if (_lastBackPress != null && 
        now.difference(_lastBackPress!) < const Duration(seconds: 5)) {
      // Second press within time limit - allow exit
      return true;
    }

    // First press - show banner and start timer
    setState(() {
      _lastBackPress = now;
      _showBackBanner = true;
    });

    // Hide banner after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showBackBanner = false;
          _lastBackPress = null;
        });
      }
    });

    // Don't exit yet
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final selectedCount = _countSelectedCards();

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Recall Phase'),
          actions: [
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
        body: SafeArea(
          child: Stack(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final availableWidth = constraints.maxWidth;
                  final cardsPerRow = _getCardsPerRow(availableWidth);
                  
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 60),
                        
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

                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: _buildAllCardRows(availableWidth, cardsPerRow),
                          ),
                        ),

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
              
              // Countdown timer
              Positioned(
                top: 8,
                left: 0,
                right: 0,
                child: Center(
                  child: RecallCountdownTimer(
                    totalSeconds: _calculateRecallTime(),
                    onTimeUp: _handleTimeUp,
                    showWarning: true,
                  ),
                ),
              ),
              
              // Back confirmation banner
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
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAllCardRows(double availableWidth, int cardsPerRow) {
    final totalRows = (widget.correctCards.length / cardsPerRow).ceil();
    
    return List.generate(totalRows, (rowIndex) {
      return _buildCardRow(rowIndex, cardsPerRow, availableWidth);
    });
  }

  Widget _buildCardRow(int rowIndex, int cardsPerRow, double availableWidth) {
    final startIndex = rowIndex * cardsPerRow;
    final endIndex = (startIndex + cardsPerRow).clamp(0, widget.correctCards.length);
    
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
