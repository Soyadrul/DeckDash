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
- Test recall accuracy
- Track performance with detailed results

## ✨ Features

### 🃏 Single Deck Mode

Train with a single deck of cards with flexible options:

- **Full Deck (52 cards)**: Practice with a complete deck
- **Custom Card Count**: Choose any number from 1 to 52 cards
- **Input Validation**: Ensures only valid numbers are accepted

### 🎴 Multi Deck Mode

Increase difficulty by training with multiple decks:

- **Configurable Deck Count**: Use 2 to 10 decks (104 to 520 cards)
- **Shuffling Options**:
    - **Shuffle Together**: All cards from all decks are combined and shuffled as one large deck
    - **Shuffle Separately**: Each deck is shuffled individually, then combined in order
- **Real-time Card Count Display**: Shows total number of cards before starting

### 📸 Memorization Phase

View and memorize cards one at a time:

- **Progress Tracking**: Visual progress bar showing how many cards you've seen
- **Card Counter**: Displays "Card X of Y" in the app bar
- **Navigation Controls**:
    - **Next**: Advance to the next card
    - **Previous**: Go back to review previous cards (disabled on first card)
- **Card Display**: Large, clear card visualization with rank and suit
- **Completion Notification**: Alerts when all cards have been viewed

### 🧠 Recall Phase

Test your memory by recalling the cards in order:

- **Adaptive Grid Layout**: Displays 2, 3, or 4 cards per row based on screen size
- **Interactive Card Selection**: Tap any blank card to open a selection dialog
- **Card Picker Dialog**:
    - Grid view of all 52 cards
    - Visual highlight for currently selected card
    - Easy tap-to-select interface
- **Completion Warning**: Alerts if you try to finish without selecting all cards
- **Keyboard-Safe Design**: Content remains accessible when dialogs appear

### 📊 Results Screen

Comprehensive performance analysis:

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
4. View each card, using Next/Previous to navigate
5. After viewing all cards, tap "Start Recall"
6. Select the cards in the order you remember
7. Tap "Finish Recall" to see your results

### Multi Deck Workflow

1. Enter the number of decks (2-10)
2. Choose shuffling method:
    - "Shuffle all cards together"
    - "Shuffle each deck separately"
3. Note the total card count displayed
4. Tap "Start Training"
5. Follow the same memorization and recall process as single deck

### Tips for Better Training

- Start with fewer cards (10-20) and gradually increase
- Use the "Previous" button to review cards you're uncertain about
- Pay attention to the patterns in multi-deck separate shuffling
- Review your mistakes in the results screen to identify weak spots

## 📁 Project Structure

```
speedcard/
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
│   │   ├── memorization_screen.dart       # Card viewing phase
│   │   ├── multi_deck_config_screen.dart  # Multi deck configuration
│   │   ├── recall_screen.dart             # Card recall phase
│   │   ├── results_screen.dart            # Performance results
│   │   └── single_deck_config_screen.dart # Single deck configuration
│   └── widgets/
│       └── card_selector_dropdown.dart    # Reusable card selection component
├── pubspec.yaml                           # Project configuration
└── README.md                              # This file
```

## 🔧 Technical Details

### Architecture

- **Pattern**: Simple StatefulWidget architecture with clear separation of concerns
- **State Management**: Local state management using `setState()`
- **Navigation**: Standard Flutter navigation with `Navigator.push()` and `Navigator.pushReplacement()`

### Key Technologies

- **Flutter SDK**: Cross-platform UI framework
- **Material 3**: Latest Material Design implementation
- **flutter_svg**: SVG image rendering (ready for card assets)
- **Dart**: Programming language

### Design Patterns

- **Model-View Pattern**: Separate data models from UI
- **Composition**: Reusable widgets for common functionality
- **Validation**: Input validation at the UI layer
- **Responsive Design**: Adaptive layouts based on screen size

### Performance Considerations

- **Efficient Shuffling**: Uses Dart's built-in `shuffle()` with Random
- **Memory Management**: Proper disposal of controllers and resources
- **Lazy Loading**: ListView.builder for efficient scrolling with many cards
- **Const Constructors**: Used where possible for better performance

## 🎨 Customization

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

- [ ] **Timer System**: Track memorization and recall times
- [ ] **Statistics Dashboard**: Historical performance tracking
- [ ] **Different Card Backs**: Customize card appearance
- [ ] **Difficulty Levels**: Preset configurations for different skill levels
- [ ] **Training Modes**:
    - [ ] PAO (Person-Action-Object) practice
    - [ ] Specific suit practice
    - [ ] Speed drills
- [ ] **Leaderboards**: Compare with other users
- [ ] **Import/Export Results**: Save and share performance data
- [ ] **Sound Effects**: Audio feedback for selections
- [ ] **Haptic Feedback**: Vibration on correct/incorrect selections
- [ ] **Multiple Languages**: Internationalization support

## 🤝 Contributing

Contributions are welcome!

### Coding Guidelines

- Follow Flutter/Dart style guidelines
- Add comprehensive comments for new features
- Ensure all screens are keyboard-safe and use SafeArea
- Test on multiple screen sizes
- Update README.md for new features

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

---

**Happy Training! 🧠🃏**

*Memorize faster, recall better.*
