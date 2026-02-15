// Card selector dropdown widget
// A reusable component that displays a blank card slot
// When tapped, opens a dialog showing all 52 cards to choose from

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/card_model.dart';
import '../models/app_settings.dart';
import '../utils/svg_font_size_util.dart';
import '../main.dart'; // Import the t() function for localization

class CardSelectorDropdown extends StatefulWidget {
  // The position index of this card in the sequence
  final int index;

  // The card currently selected for this position (null if not yet selected)
  final PlayingCard? selectedCard;

  // Callback function called when user selects a card
  // Parameters: (position index, selected card)
  final Function(int, PlayingCard?) onCardSelected;

  const CardSelectorDropdown({
    super.key,
    required this.index,
    required this.selectedCard,
    required this.onCardSelected,
  });

  @override
  State<CardSelectorDropdown> createState() => _CardSelectorDropdownState();
}

class _CardSelectorDropdownState extends State<CardSelectorDropdown> {
  // Complete deck of 52 cards that user can choose from
  late final List<PlayingCard> _allCards;

  @override
  void initState() {
    super.initState();
    // Create the full deck once when widget initializes
    _allCards = PlayingCard.createDeck();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // When tapped, show the card picker dialog
      onTap: () => _showCardPicker(context),
      child: Container(
        decoration: BoxDecoration(
          // Blue background if card selected, grey if not
          color: widget.selectedCard != null
              ? Colors.blue.withValues(alpha: 0.1)
              : Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: widget.selectedCard != null
                ? Colors.blue
                : Colors.grey.shade400,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.selectedCard != null) ...[
              // Show the selected card as SVG with adjusted size to fit container
              AspectRatio(
                aspectRatio: 0.7, // Standard card aspect ratio (width/height)
                child: Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SvgWithCustomFontSize(
                      assetPath: 'assets/images/${widget.selectedCard!.imageName}',
                      cornerFontSize: AppSettings().svgCornerFontSize,
                      centerFontSize: AppSettings().svgCenterFontSize,
                      fit: BoxFit.contain, // Changed from BoxFit.cover to BoxFit.contain to show the full card
                    ),
                  ),
                ),
              ),
            ] else ...[
              // Show placeholder when no card is selected
              // Using AspectRatio to maintain consistent height with card view
              AspectRatio(
                aspectRatio: 0.7, // Same aspect ratio as card
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.touch_app,
                        size: 32,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        t('select'),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Shows a dialog with all 52 cards in a grid
  void _showCardPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            // Constrain dialog size
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
            child: Column(
              children: [
                // Dialog header with title and close button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        t('select_card'),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1),

                const SizedBox(height: 16),

                // Grid of all 52 cards
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    // Grid with 4 columns
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 0.7,  // Cards are taller than wide
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _allCards.length,  // 52 cards
                    itemBuilder: (context, index) {
                      final card = _allCards[index];
                      final isSelected = card == widget.selectedCard;

                      return InkWell(
                        // When tapped, select this card and close dialog
                        onTap: () {
                          widget.onCardSelected(widget.index, card);
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            // Highlight if this card is currently selected
                            color: isSelected
                                ? Colors.blue.withValues(alpha: 0.2)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected ? Colors.blue : Colors.grey.shade300,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Display card as SVG without white background
                              AspectRatio(
                                aspectRatio: 0.7, // Standard card aspect ratio (width/height)
                                child: Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: SvgWithCustomFontSize(
                                      assetPath: 'assets/images/${card.imageName}',
                                      cornerFontSize: AppSettings().svgCornerFontSize,
                                      centerFontSize: AppSettings().svgCenterFontSize,
                                      fit: BoxFit.contain, // Changed from BoxFit.cover to BoxFit.contain to show the full card
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
