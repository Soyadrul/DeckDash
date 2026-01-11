# DeckDash

A Flutter-based Android application designed to help users train and improve their card memorization skills for Speed Card competitions.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Technical Details](#technical-details)
- [Customization](#customization)
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
- **Customize training experience with extensive settings**

## ✨ Features

### ⚙️ Settings & Customization

Comprehensive settings system organized into intuitive categories:

#### **Appearance**
- **Theme Mode**: Choose between System (follows device), Light or Dark themes
- Instant theme switching without app restart

#### **Training**
- **Timer Visibility**: Show or hide timer during memorization (timer still tracks time even when hidden)
- **Cards Display Mode**: View cards in three different ways:
  - **1 card at a time**: Classic mode, view one card per screen
  - **2 cards at a time**: View cards in pairs for faster training
  - **3 cards at a time**: View cards in groups of three
  - Automatically handles incomplete final groups (e.g., 52 cards ÷ 3)

#### **Behavior**
- **Back Gesture Confirmation**: Prevent accidental exits during training
  - First back press shows a 5-second warning banner
  - Must press back again within 5 seconds to actually exit
  - Only applies to Memorization and Recall screens
  - Enabled by default, can be disabled in settings

#### **Language**
- **Multi-language Support**: Choose from 8 languages
  - English, Spanish, French, German, Italian, Portuguese, Japanese, Chinese
  - App restart required for language changes to take effect

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

View and memorize cards with precision timing and flexible display modes:

- **Flexible Card Display**: View 1, 2, or 3 cards at once based on your settings
  - Progress tracked by groups, not individual cards
  - Handles incomplete final groups automatically
  - Example: 52 cards with 3-card mode = 18 groups (last group has 1 card)
- **Precision Timer**: Tracks memorization time with 1/100 second accuracy (centiseconds)
- **Automatic Timer**:
    - Starts automatically when memorization begins
    - Stops automatically when viewing the last card
    - Displays final time on completion screen
    - **Continues tracking even when hidden** (if disabled in settings)
- **Timer Display**: Non-intrusive timer in top-right corner showing MM:SS.CS format
- **Progress Tracking**: Visual progress bar showing group progress
- **Card Counter**: Displays current card range (e.g., "Card 1-3 of 52" or "Card 1 of 52")
- **Navigation Controls**:
    - **Next**: Advance to the next group of cards
    - **Previous**: Go back to review previous groups (disabled on first group)
- **Exit Protection**: Optional double-back confirmation prevents accidental exits
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
- **Exit Protection**: Optional double-back confirmation prevents accidental exits
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
- **Dark Mode Support**: Automatic adaptation to system theme or manual selection
- **Precision Timing**: Sub-second accuracy for competitive training
- **Automatic Timer Management**: No manual timer control needed
- **Visual Feedback**: Color-coded warnings and status indicators
- **Persistent Settings**: All preferences saved and restored across app restarts
- **SafeArea Implementation**: Content never overlaps with device notches, status bars, or navigation bars
- **Keyboard-Safe Scrolling**: All screens scroll smoothly when keyboard appears
- **Responsive Layout**: Adapts to different screen sizes and orientations
- **Input Validation**: Real-time validation with helpful error messages
- **Confirmation Dialogs**: Prevents accidental data loss
- **Exit Protection**: Optional double-back gesture to prevent accidental exits during training

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

### Accessing Settings

1. **Launch the app** - You'll see the home screen
2. **Tap the settings icon** in the top-right corner of the home screen
3. **Configure preferences** organized by category:
   - **Appearance**: Theme mode
   - **Training**: Timer visibility and cards display mode
   - **Behavior**: Back gesture confirmation
   - **Language**: App language selection

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
    - View cards (1, 2, or 3 at a time based on your settings)
    - Use Next/Previous to navigate between groups
    - Timer appears in top-right corner (if enabled in settings)
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

### Cards Display Modes

The app supports three different viewing modes during memorization:

#### 1 Card at a Time (Classic Mode)
- Traditional single-card display
- Best for beginners
- Shows "Card 1 of 52" format
- Example: Card 1 → Card 2 → Card 3...

#### 2 Cards at a Time (Pair Mode)
- View two cards simultaneously
- Faster training for intermediate users
- Shows "Card 1-2 of 52" format
- 52 cards = 26 groups
- Example: Cards 1-2 → Cards 3-4 → Cards 5-6...

#### 3 Cards at a Time (Triple Mode)
- View three cards simultaneously
- Advanced training for experienced users
- Shows "Card 1-3 of 52" format
- 52 cards = 18 groups (last group may have fewer cards)
- Example: Cards 1-3 → Cards 4-6 → Cards 7-9...
- Handles incomplete groups: ...Cards 49-51 → Card 52

### Back Gesture Confirmation

When enabled (default), prevents accidental exits during training:

1. **First Back Press**:
   - Orange banner appears at the top
   - Message: "Press back again within 5 seconds to exit"
   - Training continues normally

2. **Second Back Press** (within 5 seconds):
   - Exits the current screen
   - Returns to previous screen

3. **Wait 5 Seconds**:
   - Banner disappears automatically
   - Must press back twice again to exit

**Note**: This feature only applies to Memorization and Recall screens. Other screens exit immediately on back press.

### Timer Behavior Reference

| Mode | Card Count | Display Mode | Memorization Timer | Recall Countdown | Auto-Submit |
|------|------------|--------------|-------------------|------------------|-------------|
| Single | 10 cards | 1 at a time | Tracks actual time | 5:00 | Yes |
| Single | 26 cards | 2 at a time (13 groups) | Tracks actual time | 5:00 | Yes |
| Single | 52 cards | 3 at a time (18 groups) | Tracks actual time | 5:00 | Yes |
| Multi | 2 decks (104) | User choice | Tracks actual time | 10:00 | Yes |
| Multi | 4 decks (208) | User choice | Tracks actual time | 20:00 | Yes |
| Multi | 8 decks (416) | User choice | Tracks actual time | 40:00 | Yes |

**Timer Visibility**: Timer can be hidden via settings but continues tracking time in the background. Final time is always displayed on completion screen.

### Tips for Better Training

- **Start with fewer cards** (10-20) and gradually increase
- **Experiment with display modes** - try 2 or 3 cards at a time once comfortable
- **Pay attention to your memorization time** - try to improve it each session
- **Use the countdown pressure** to simulate competition conditions
- **Review when timer warnings appear** - orange (<2 min) and red (<1 min)
- **Submit early if confident** - don't wait for auto-submit if you're done
- **Enable back confirmation** during serious training to prevent accidents
- **Hide the timer** if you find it distracting (it still tracks time)
- Use the "Previous" button to review cards you're uncertain about
- Pay attention to the patterns in multi-deck separate shuffling
- Review your mistakes in the results screen to identify weak spots
- **Track your times** - aim to decrease memorization time while maintaining accuracy
- **Customize your experience** - adjust settings to match your training style

## 📁 Project Structure

```
DeckDash/
├── assets/
│   └── icon.png                           # App icon
│   └── images/                            # Card SVG images (TO-DO)
├── LICENSE                                # GPL-3.0 license
├── lib/
│   ├── main.dart                          # App entry point with theme management
│   ├── models/
│   │   ├── app_settings.dart              # Settings manager (singleton)
│   │   └── card_model.dart                # Playing card data model
│   ├── screens/
│   │   ├── home_screen.dart               # Main menu with settings button
│   │   ├── memorization_screen.dart       # Card viewing phase with multi-card support
│   │   ├── multi_deck_config_screen.dart  # Multi deck configuration
│   │   ├── recall_screen.dart             # Card recall phase with countdown
│   │   ├── results_screen.dart            # Performance results with timing
│   │   ├── settings_screen.dart           # Settings page with categories
│   │   └── single_deck_config_screen.dart # Single deck configuration
│   └── widgets/
│       ├── card_selector_dropdown.dart    # Reusable card selection component
│       ├── memorization_timer.dart        # Stopwatch timer (counts up)
│       └── recall_countdown_timer.dart    # Countdown timer (counts down)
├── pubspec.yaml                           # Project configuration with dependencies
└── README.md                              # This file
```

## 🔧 Technical Details

### Architecture

- **Pattern**: Simple StatefulWidget architecture with clear separation of concerns
- **State Management**: Local state management using `setState()`
- **Settings Management**: Singleton pattern with SharedPreferences for persistence
- **Navigation**: Standard Flutter navigation with `Navigator.push()` and `Navigator.pushReplacement()`
- **Timer Management**: Dart's `Timer.periodic` for precise timing
- **Widget Composition**: Reusable timer widgets with callback functions
- **Back Button Handling**: WillPopScope for custom back behavior

### Key Technologies

- **Flutter SDK**: Cross-platform UI framework
- **Material 3**: Latest Material Design implementation
- **SharedPreferences**: Persistent local storage for user settings
- **Dart Timer**: Built-in timer for precision timing (10ms for stopwatch, 1s for countdown)
- **GlobalKey**: For parent-child widget communication
- **WillPopScope**: Custom back button behavior
- **Opacity & IgnorePointer**: For invisible but functional widgets
- **Wrap Widget**: Flexible multi-card layout
- **flutter_svg**: SVG image rendering (ready for card assets)
- **Dart**: Programming language

### Settings Implementation

#### Storage
- Uses `SharedPreferences` for persistent local storage
- Settings survive app restarts and device reboots
- Singleton pattern ensures single source of truth
- All settings loaded asynchronously on app startup

#### Supported Settings
```dart
// Appearance
ThemeMode: system | light | dark

// Training
showMemorizationTimer: bool
cardsDisplayMode: single | pair | triple

// Behavior
enableBackConfirmation: bool (default: true)

// Language
languageCode: string (default: 'en')
```

### Timer Implementation

#### Memorization Timer
- **Update Frequency**: Every 10 milliseconds (1/100 second precision)
- **Display Format**: MM:SS.CS (minutes:seconds.centiseconds)
- **Control**: Automatically starts/stops, controlled via GlobalKey
- **Visibility**: Uses Opacity widget to hide while continuing to run
- **Memory**: Properly disposed to prevent memory leaks

#### Recall Countdown Timer
- **Update Frequency**: Every 1 second
- **Display Format**: MM:SS or HH:MM:SS (for multi-deck)
- **Auto-Submit**: Triggers callback at 0:00 to submit automatically
- **Visual Warnings**: Dynamic color changes based on remaining time
- **Memory**: Properly disposed to prevent memory leaks

### Multi-Card Display Implementation

#### Layout Strategy
- **Single Card**: Centered display using `Center` widget
- **Multiple Cards**: `Wrap` widget for flexible layout
- **Responsive**: Automatically adapts to available screen space
- **Incomplete Groups**: Gracefully handles final groups with fewer cards

#### Progress Tracking
- Tracks by groups, not individual cards
- Example: 52 cards in triple mode = 18 groups
- Progress bar reflects group completion
- App bar shows card range (e.g., "Card 1-3 of 52")

### Back Gesture Confirmation

#### Implementation
- Uses `WillPopScope` to intercept back button/gesture
- Tracks timestamp of last back press
- Shows banner for 5 seconds after first press
- Compares timestamps to allow/deny exit
- Automatically resets after timeout

#### Scope
- **Active on**: Memorization Screen, Recall Screen
- **Inactive on**: All other screens (normal back behavior)
- **Toggle**: Can be disabled in settings

### Design Patterns

- **Singleton**: Settings manager (AppSettings)
- **Model-View Pattern**: Separate data models from UI
- **Composition**: Reusable widgets for common functionality
- **Callback Pattern**: Timer widgets notify parents via callbacks
- **Validation**: Input validation at the UI layer
- **Responsive Design**: Adaptive layouts based on screen size
- **State Lifting**: Timer state managed at appropriate widget levels
- **Conditional Rendering**: Widgets conditionally displayed based on settings

### Performance Considerations

- **Efficient Shuffling**: Uses Dart's built-in `shuffle()` with Random
- **Memory Management**: Proper disposal of controllers, timers, and resources
- **Timer Precision**: 10ms updates for memorization, 1s for countdown (no excessive CPU usage)
- **Lazy Loading**: `ListView.builder` for efficient scrolling with many cards
- **Const Constructors**: Used where possible for better performance
- **Minimal Rebuilds**: Only timer widgets rebuild during timing, not entire screens
- **Settings Caching**: Settings loaded once on startup, cached in memory
- **Widget Optimization**: Opacity instead of conditional rendering for better performance

## 🎨 Customization

### Adjusting Timer Settings

#### Memorization Timer Appearance
In `lib/widgets/memorization_timer.dart`:

```dart
// Make timer more prominent
Container(
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Larger
  decoration: BoxDecoration(
    color: Colors.black.withValues(alpha: 0.6), // More opaque
  ),
  // ...
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

### Adjusting Cards Display

#### Card Size
In `lib/screens/memorization_screen.dart`:

```dart
Widget _buildSingleCard(PlayingCard card) {
  return Container(
    width: 180,  // Increase from 150
    height: 252, // Increase from 210 (maintain 1.4 aspect ratio)
    // ...
  );
}
```

#### Spacing Between Cards
In `lib/screens/memorization_screen.dart`:

```dart
Widget _buildCardsDisplay(List<PlayingCard> cards) {
  return Center(
    child: Wrap(
      spacing: 16.0,  // Increase from 8.0 for more space
      // ...
    ),
  );
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

### Modifying Settings Defaults

In `lib/models/app_settings.dart`:

```dart
// Change default display mode
CardsDisplayMode _cardsDisplayMode = CardsDisplayMode.pair; // Default to 2 cards

// Change default back confirmation
bool _enableBackConfirmation = false; // Disabled by default

// Change default timer visibility
bool _showMemorizationTimer = false; // Hidden by default
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

### Adjusting Back Confirmation Timer

In `lib/screens/memorization_screen.dart` and `recall_screen.dart`:

```dart
// Change from 5 seconds to 10 seconds
if (_lastBackPress != null && 
    now.difference(_lastBackPress!) < const Duration(seconds: 10)) {
  return true;
}

// Update banner timeout
Future.delayed(const Duration(seconds: 10), () {
  // ...
});

// Update banner text
'Press back again within 10 seconds to exit'
```

## 🚧 Future Enhancements

Potential features for future versions:

- [x] **Timer System**: ✅ **IMPLEMENTED** - Precision timing for memorization and recall
- [x] **Settings System**: ✅ **IMPLEMENTED** - Comprehensive settings with categories
- [x] **Multi-Card Display**: ✅ **IMPLEMENTED** - View 1, 2, or 3 cards at once
- [x] **Exit Protection**: ✅ **IMPLEMENTED** - Double-back confirmation
- [ ] **Statistics Dashboard**: Historical performance tracking with time graphs
- [ ] **Personal Records**: Track best times and scores per card count
- [ ] **Time-Based Challenges**: Target specific time goals
- [ ] **Practice Mode**: No time pressure for learning
- [ ] **Card Images**: Replace text with actual card SVG images
- [ ] **Different Card Backs**: Customize card appearance
- [ ] **Difficulty Levels**: Preset configurations for different skill levels
- [ ] **Training Modes**:
    - [ ] PAO (Person-Action-Object) practice
    - [ ] Specific suit practice
    - [ ] Speed drills
    - [ ] Timed challenges
- [ ] **Full Localization**: Complete translation system for all supported languages
- [ ] **Cloud Sync**: Save settings and progress across devices
- [ ] **Leaderboards**: Compare times with other users
- [ ] **Import/Export Results**: Save and share performance data with timestamps
- [ ] **Sound Effects**: Audio feedback and timer beeps
- [ ] **Haptic Feedback**: Vibration on correct/incorrect selections and time warnings
- [ ] **Achievements System**: Unlock badges for milestones
- [ ] **Custom Themes**: User-created color schemes
- [ ] **Widget Customization**: Drag-and-drop timer positioning

## 🤝 Contributing

Contributions are welcome!

### Coding Guidelines

- Follow Flutter/Dart style guidelines
- Add comprehensive comments for new features
- Ensure all screens are keyboard-safe and use SafeArea
- Test timer functionality across different scenarios
- Test settings persistence across app restarts
- Properly dispose of timers and controllers
- Test on multiple screen sizes
- Test back gesture confirmation in different scenarios
- Test multi-card display with various card counts
- Update README.md for new features

### Testing Checklist

When modifying features, test:
- **Timer Features**:
  - Timer starts/stops correctly
  - Display updates smoothly
  - No memory leaks (timers disposed properly)
  - Timer continues tracking when hidden
  - Auto-submit triggers at correct time
  - Visual warnings appear at correct thresholds
- **Settings Features**:
  - Settings save and load correctly
  - Theme changes apply immediately
  - Settings persist after app restart
  - All settings categories function properly
- **Multi-Card Display**:
  - 1, 2, and 3 card modes display correctly
  - Incomplete groups handled properly
  - Card counter shows correct format
  - Layout adapts to screen size
- **Back Confirmation**:
  - Banner appears on first press
  - Second press within time limit exits
  - Timeout resets confirmation state
  - Only active on correct screens
  - Can be disabled in settings

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
    - Settings configuration (if relevant)
    - Timer-related issues: include when the issue occurred (memorization/recall)
    - Multi-card display issues: include display mode and card count

---

**Happy Training! 🧠🃏**

*Memorize faster, recall better.*
