// This file defines the data model for a playing card
// A playing card has a rank (A, 2-10, J, Q, K) and a suit (hearts, diamonds, clubs, spades)

class PlayingCard {
  // The rank of the card: 'A' (Ace), '2' through '10', 'J' (Jack), 'Q' (Queen), 'K' (King)
  final String rank;

  // The suit of the card using Unicode symbols:
  // '♥' for hearts, '♦' for diamonds, '♣' for clubs, '♠' for spades
  final String suit;

  // Constructor: creates a new PlayingCard with the given rank and suit
  PlayingCard({required this.rank, required this.suit});

  // Returns the SVG image filename for this card
  // Example: "ace-of-hearts.svg" or "4-of-spades.svg"
  String get imageName {
    String rankName = _getRankName();
    String suitName = _getSuitName();
    return '$rankName-of-$suitName.svg';
  }

  // Converts the rank to a lowercase string suitable for filenames
  // 'A' becomes 'ace', 'J' becomes 'jack', etc.
  String _getRankName() {
    switch (rank) {
      case 'A': return 'ace';
      case 'J': return 'jack';
      case 'Q': return 'queen';
      case 'K': return 'king';
      default: return rank.toLowerCase();  // Numbers stay as-is (2, 3, 4, etc.)
    }
  }

  // Converts the suit symbol to a lowercase English name for filenames
  // '♥' becomes 'hearts', '♦' becomes 'diamonds', etc.
  String _getSuitName() {
    switch (suit) {
      case '♥': return 'hearts';
      case '♦': return 'diamonds';
      case '♣': return 'clubs';
      case '♠': return 'spades';
      default: return '';
    }
  }

  // Returns a human-readable display name for the card
  // Example: "A♥" or "10♠"
  String get displayName => '$rank$suit';

  // Equality operator: determines if two cards are the same
  // Two cards are equal if they have the same rank AND suit
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PlayingCard &&
              runtimeType == other.runtimeType &&
              rank == other.rank &&
              suit == other.suit;

  // Hash code: needed for equality comparisons and using cards in Sets/Maps
  @override
  int get hashCode => rank.hashCode ^ suit.hashCode;

  // Creates an exact copy of this card
  PlayingCard copy() => PlayingCard(rank: rank, suit: suit);

  // Static method: creates a complete deck of 52 cards
  // Returns a List containing all possible combinations of ranks and suits
  static List<PlayingCard> createDeck() {
    List<PlayingCard> deck = [];

    // All possible ranks in a standard deck
    List<String> ranks = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'];

    // All four suits
    List<String> suits = ['♥', '♦', '♣', '♠'];

    // Create all 52 combinations (13 ranks × 4 suits = 52 cards)
    for (String suit in suits) {
      for (String rank in ranks) {
        deck.add(PlayingCard(rank: rank, suit: suit));
      }
    }

    return deck;
  }
}