# DeckDash

A Flutter-based Android application designed to help users train and improve their card memorization skills for Speed Card competitions.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Technical Details](#technical-details)
- [Future Enhancements](#future-enhancements)
- [Contributing](#contributing)
- [License](#license)

## 🎯 Overview

Speed Card is the art of memorizing a shuffled deck of 52 playing cards in the shortest time possible. This app provides a comprehensive training platform that allows to:

- Practice with customizable card quantities
- Train with single or multiple decks
- **Track memorization time with precision timing**
- **Race against countdown timers during recall**
- Test recall accuracy with detailed results
- Monitor performance improvements over time

## ✨ Features

### 🃏 Single Deck Mode

Train with a single deck of cards with flexible options:

- **Full Deck (52 cards)**: Practice with a complete deck
- **Custom Card Count**: Choose any number from 1 to 52 cards
- **5-Minute Recall Time**: Standardized recall phase regardless of card count
- **Input Validation**: Ensures only valid numbers are accepted

### 🎴 Multi Deck Mode

Increase difficulty by training with multiple decks:

- **Configurable Deck Count**: Use 2 to 10 decks (104 to 520 cards)
- **Shuffling Options**:
    - **Shuffle Together**: All cards from all decks are combined and shuffled as one large deck
    - **Shuffle Separately**: Each deck is shuffled individually, then combined in order
- **Scaled Recall Time**: 5 minutes per deck (e.g., 4 decks = 20 minutes)
- **Real-time Card Count Display**: Shows total number of cards before starting

### 📸 Memorization Phase

View and memorize cards one at a time with precision timing:

- **Precision Timer**: Tracks memorization time with 1/100 second accuracy (centiseconds)
- **Automatic Timer**:
    - Starts automatically when memorization begins
    - Stops automatically when viewing the last card
    - Displays final time on completion screen
- **Timer Display**: Non-intrusive timer in top-right corner showing MM:SS.CS format (minutes:seconds.centiseconds)
- **Progress Tracking**: Visual progress bar showing how many cards you've seen
- **Card Counter**: Displays "Card X of Y" in the app bar
- **Navigation Controls**:
    - **Next**: Advance to the next card
    - **Previous**: Go back to review previous cards (disabled on first card)
- **Card Display**: Large, clear card visualization with rank and suit
- **Completion Screen**:
    - Final memorization time prominently displayed
    - Clear "Start Recall" button

### 🧠 Recall Phase

Test your memory by recalling the cards in order with countdown pressure:

- **Intelligent Countdown Timer**:
    - **Single Deck**: 5 minutes (300 seconds) for all card counts
    - **Multi Deck**: 5 minutes × number of decks (e.g., 4 decks = 20 minutes)
    - **Position**: Clearly visible at top-center of screen
    - **Format**: MM:SS or HH:MM:SS for longer times
- **Visual Warnings**:
    - **Normal** (≥2 minutes): White text, standard display
    - **Warning** (<2 minutes): Orange text to alert time is running low
    - **Urgent** (<1 minute): Red text with warning icon and red border
- **Auto-Submit**: Automatically submits recall when countdown reaches 0:00
- **Manual Submit**: Option to finish early if completed before time expires
- **Adaptive Grid Layout**: Displays 2, 3, or 4 cards per row based on screen size
- **Interactive Card Selection**: Tap any blank card to open a selection dialog
- **Card Picker Dialog**:
    - Grid view of all 52 cards
    - Visual highlight for currently selected card
    - Easy tap-to-select interface
- **Progress Counter**: Shows "X/52" selected cards in app bar
- **Completion Warning**: Alerts if you try to finish without selecting all cards
- **Keyboard-Safe Design**: Content remains accessible when dialogs appear

### 📊 Results Screen

Comprehensive performance analysis with timing information:

- **Timer Notifications**:
    - **Auto-Submit Warning**: Orange banner if time ran out during recall
    - **Memorization Time**: Blue info banner showing exact time taken
- **Score Display**:
    - Large, prominent score (e.g., "45 / 52")
    - Percentage accuracy (e.g., "86.5% correct")
    - Color-coded by performance:
        - 🟢 Green: 90%+ (Excellent)
        - 🟠 Orange: 70-89% (Good)
        - 🔴 Red: Below 70% (Needs Practice)
- **Detailed Card-by-Card Comparison**:
    - Row 1: Your selected cards (green background if correct, red if wrong)
    - Row 2: The actual correct cards (blue background)
    - Visual alignment makes it easy to spot mistakes
- **Return to Home**: Start a new training session

### 🛡️ User Experience Features

- **Material 3 Design**: Modern, clean interface following Google's latest design system
- **Dark Mode Support**: Automatic adaptation to system theme
- **Precision Timing**: Sub-second accuracy for competitive training
- **Automatic Timer Management**: No manual timer control needed
- **Visual Feedback**: Color-coded warnings and status indicators
- **SafeArea Implementation**: Content never overlaps with device notches, status bars, or navigation bars
- **Keyboard-Safe Scrolling**: All screens scroll smoothly when keyboard appears
- **Responsive Layout**: Adapts to different screen sizes and orientations
- **Input Validation**: Real-time validation with helpful error messages
- **Confirmation Dialogs**: Prevents accidental data loss

## 🚀 Installation

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio or VS Code with Flutter extensions
- Android device or emulator

### Steps

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Soyadrul/DeckDash
   cd DeckDash
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

## 📱 Usage

### Starting a Training Session

1. **Launch the app** - You'll see the home screen with two options
2. **Choose your mode**:
    - Tap "Single Deck" for basic training
    - Tap "Multi Deck" for advanced training

### Single Deck Workflow

1. Select "Full deck (52 cards)" or "Custom number"
2. If custom, enter a number between 1-52
3. Tap "Start Training"
4. **Memorization Phase**:
    - Timer starts automatically at 00:00.00
    - View each card, using Next/Previous to navigate
    - Timer appears subtly in top-right corner
    - After viewing the last card, timer stops automatically
    - See your final memorization time
5. Tap "Start Recall"
6. **Recall Phase**:
    - Countdown timer starts at 5:00 (top-center)
    - Select the cards in the order you remember
    - Watch for color warnings as time runs low
    - Submit manually or wait for auto-submit at 0:00
7. **Results**:
    - See if recall was auto-submitted (orange banner)
    - View your memorization time (blue banner)
    - Check your score and card-by-card comparison

### Multi Deck Workflow

1. Enter the number of decks (2-10)
2. Choose shuffling method:
    - "Shuffle all cards together"
    - "Shuffle each deck separately"
3. Note the total card count displayed
4. Tap "Start Training"
5. **Memorization Phase**: Same as single deck, timer tracks your progress
6. **Recall Phase**: Countdown time is scaled (5 minutes × number of decks)
    - 2 decks = 10:00
    - 4 decks = 20:00
    - 6 decks = 30:00
    - 8 decks = 40:00
7. **Results**: View your performance with timing data

### Timer Behavior Reference

| Mode | Card Count | Memorization Timer | Recall Countdown | Auto-Submit |
|------|------------|-------------------|------------------|-------------|
| Single | 10 cards | Tracks actual time | 5:00 | Yes |
| Single | 26 cards | Tracks actual time | 5:00 | Yes |
| Single | 52 cards | Tracks actual time | 5:00 | Yes |
| Multi | 2 decks (104) | Tracks actual time | 10:00 | Yes |
| Multi | 4 decks (208) | Tracks actual time | 20:00 | Yes |
| Multi | 8 decks (416) | Tracks actual time | 40:00 | Yes |

### Tips for Better Training

- **Start with fewer cards** (10-20) and gradually increase
- **Pay attention to your memorization time** - try to improve it each session
- **Use the countdown pressure** to simulate competition conditions
- **Review when timer warnings appear** - orange (<2 min) and red (<1 min)
- **Submit early if confident** - don't wait for auto-submit if you're done
- Use the "Previous" button to review cards you're uncertain about
- Pay attention to the patterns in multi-deck separate shuffling
- Review your mistakes in the results screen to identify weak spots
- **Track your times** - aim to decrease memorization time while maintaining accuracy

## 📁 Project Structure

```
DeckDash/
├── assets/
│   └── icon.png                           # App icon
│   └── images/                            # Card SVG images (TO-DO)
├── LICENSE                                # GPL-3.0 license
├── lib/
│   ├── main.dart                          # App entry point
│   ├── models/
│   │   └── card_model.dart                # Playing card data model
│   ├── screens/
│   │   ├── home_screen.dart               # Main menu
│   │   ├── memorization_screen.dart       # Card viewing phase with timer
│   │   ├── multi_deck_config_screen.dart  # Multi deck configuration
│   │   ├── recall_screen.dart             # Card recall phase with countdown
│   │   ├── results_screen.dart            # Performance results with timing
│   │   └── single_deck_config_screen.dart # Single deck configuration
│   └── widgets/
│       ├── card_selector_dropdown.dart    # Reusable card selection component
│       ├── memorization_timer.dart        # Stopwatch timer (counts up)
│       └── recall_countdown_timer.dart    # Countdown timer (counts down)
├── pubspec.yaml                           # Project configuration
└── README.md                              # This file
```

## 🔧 Technical Details

### Architecture

- **Pattern**: Simple StatefulWidget architecture with clear separation of concerns
- **State Management**: Local state management using `setState()`
- **Navigation**: Standard Flutter navigation with `Navigator.push()` and `Navigator.pushReplacement()`
- **Timer Management**: Dart's `Timer.periodic` for precise timing
- **Widget Composition**: Reusable timer widgets with callback functions

### Key Technologies

- **Flutter SDK**: Cross-platform UI framework
- **Material 3**: Latest Material Design implementation
- **Dart Timer**: Built-in timer for precision timing (10ms for stopwatch, 1s for countdown)
- **GlobalKey**: For parent-child widget communication
- **flutter_svg**: SVG image rendering (ready for card assets)
- **Dart**: Programming language

### Timer Implementation

#### Memorization Timer
- **Update Frequency**: Every 10 milliseconds (1/100 second precision)
- **Display Format**: MM:SS.CS (minutes:seconds.centiseconds)
- **Control**: Automatically starts/stops, controlled via GlobalKey
- **Memory**: Properly disposed to prevent memory leaks

#### Recall Countdown Timer
- **Update Frequency**: Every 1 second
- **Display Format**: MM:SS or HH:MM:SS (for multi-deck)
- **Auto-Submit**: Triggers callback at 0:00 to submit automatically
- **Visual Warnings**: Dynamic color changes based on remaining time
- **Memory**: Properly disposed to prevent memory leaks

### Design Patterns

- **Model-View Pattern**: Separate data models from UI
- **Composition**: Reusable widgets for common functionality
- **Callback Pattern**: Timer widgets notify parents via callbacks
- **Validation**: Input validation at the UI layer
- **Responsive Design**: Adaptive layouts based on screen size
- **State Lifting**: Timer state managed at appropriate widget levels

### Performance Considerations

- **Efficient Shuffling**: Uses Dart's built-in `shuffle()` with Random
- **Memory Management**: Proper disposal of controllers, timers, and resources
- **Timer Precision**: 10ms updates for memorization, 1s for countdown (no excessive CPU usage)
- **Lazy Loading**: `ListView.builder` for efficient scrolling with many cards
- **Const Constructors**: Used where possible for better performance
- **Minimal Rebuilds**: Only timer widgets rebuild during timing, not entire screens

## 🎨 Customization

### Adjusting Timer Settings

#### Memorization Timer Appearance
In `lib/widgets/memorization_timer.dart`:

```dart
// Make timer less prominent
Container(
  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Smaller
  decoration: BoxDecoration(
    color: Colors.black.withValues(alpha: 0.3), // More transparent
  ),
  // ...
)

// Change position in memorization_screen.dart
Positioned(
  top: 16,
  left: 16,  // Move to left instead of right
  child: MemorizationTimer(...),
)
```

#### Countdown Timer Warnings
In `lib/widgets/recall_countdown_timer.dart`:

```dart
// Change warning thresholds
Color _getTimerColor() {
  if (_remainingSeconds < 30) {       // Urgent at 30 seconds instead of 60
    return Colors.red.shade400;
  } else if (_remainingSeconds < 180) { // Warning at 3 min instead of 2
    return Colors.orange.shade400;
  }
  return Colors.white;
}

// Change warning colors
if (_remainingSeconds < 60) {
  return Colors.yellow;  // Yellow instead of red
}
```

#### Recall Time Limits
In `lib/screens/recall_screen.dart`:

```dart
// Modify base time per deck
int _calculateRecallTime() {
  const int baseTimePerDeck = 420; // Change to 7 minutes (420 seconds)
  // ...
}
```

### Adding Card Images

1. Create SVG files for all 52 cards with naming format:
    - `ace-of-hearts.svg`
    - `2-of-clubs.svg`
    - `king-of-spades.svg`
    - etc.

2. Place SVG files in `assets/images/`

3. Uncomment the assets section in `pubspec.yaml`:
   ```yaml
   flutter:
     assets:
       - assets/images/
   ```

4. Run `flutter pub get`

5. Import flutter_svg in the screen files:
   ```dart
   import 'package:flutter_svg/flutter_svg.dart';
   ```

6. Replace the `Text` widget displaying cards with:
   ```dart
   SvgPicture.asset(
     'assets/images/${card.imageName}',
     width: 100,
     height: 140,
   )
   ```

### Modifying Deck Limits

In `multi_deck_config_screen.dart`, change the validation:

```dart
// Current: maximum 10 decks
if (number > 10) { ... }

// Change to: maximum 20 decks
if (number > 20) { ... }
```

### Changing Color Scheme

In `main.dart`, modify the `seedColor`:

```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: Colors.purple,  // Change to any color
  brightness: Brightness.light,
),
```

## 🚧 Future Enhancements

Potential features for future versions:

- [x] **Timer System**: ✅ **IMPLEMENTED** - Precision timing for memorization and recall
- [ ] **Statistics Dashboard**: Historical performance tracking with time graphs
- [ ] **Personal Records**: Track best times and scores
- [ ] **Time-Based Challenges**: Target specific time goals
- [ ] **Practice Mode**: No time pressure for learning
- [ ] **Different Card Backs**: Customize card appearance
- [ ] **Difficulty Levels**: Preset configurations for different skill levels
- [ ] **Training Modes**:
    - [ ] PAO (Person-Action-Object) practice
    - [ ] Specific suit practice
    - [ ] Speed drills
- [ ] **Leaderboards**: Compare times with other users
- [ ] **Import/Export Results**: Save and share performance data with timestamps
- [ ] **Sound Effects**: Audio feedback and timer beeps
- [ ] **Haptic Feedback**: Vibration on correct/incorrect selections and time warnings
- [ ] **Multiple Languages**: Internationalization support

## 🤝 Contributing

Contributions are welcome!

### Coding Guidelines

- Follow Flutter/Dart style guidelines
- Add comprehensive comments for new features
- Ensure all screens are keyboard-safe and use SafeArea
- Test timer functionality across different scenarios
- Properly dispose of timers and controllers
- Test on multiple screen sizes
- Update README.md for new features

### Testing Timer Features

When modifying timer functionality, test:
- Timer starts/stops correctly
- Display updates smoothly
- No memory leaks (timers disposed properly)
- Auto-submit triggers at correct time
- Visual warnings appear at correct thresholds
- Different deck configurations calculate time correctly

## 📄 License

This project is open source and available under the [GPL-3.0 License](LICENSE).

## 📞 Support

If you encounter any issues or have questions:

1. Check the [Issues](https://github.com/Soyadrul/DeckDash/issues) page
2. Create a new issue with:
    - Description of the problem
    - Steps to reproduce
    - Screenshots if applicable
    - Device and Android version
    - Timer-related issues: include when the issue occurred (memorization/recall)

---

**Happy Training! 🧠🃏**

*Memorize faster, recall better.*
