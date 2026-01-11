/// app_settings.dart
/// This file manages all user preferences and settings for the app
/// It handles saving/loading settings and provides default values
/// UPDATED: Added cards display mode and back gesture confirmation settings

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Enum for how many cards to display at once during memorization
/// single = 1 card at a time (original behavior)
/// pair = 2 cards at a time
/// triple = 3 cards at a time
enum CardsDisplayMode {
  single,
  pair,
  triple,
}

/// AppSettings class - stores all user preferences
/// This is a singleton class (only one instance exists in the entire app)
/// It persists settings across app restarts using SharedPreferences
class AppSettings {
  // Singleton pattern - ensures only one instance exists
  static final AppSettings _instance = AppSettings._internal();
  factory AppSettings() => _instance;
  AppSettings._internal();

  // APPEARANCE SETTINGS
  // Theme mode options: system (follows device), light, or dark
  ThemeMode _themeMode = ThemeMode.system;

  // TRAINING SETTINGS
  // Whether to show the timer during memorization phase
  // If false, timer still tracks time but doesn't display
  bool _showMemorizationTimer = true;
  
  // How many cards to display at once during memorization
  CardsDisplayMode _cardsDisplayMode = CardsDisplayMode.single;

  // BEHAVIOR SETTINGS
  // Whether to require double-back gesture to exit memorization/recall screens
  // This prevents accidental exits during training
  bool _enableBackConfirmation = true;

  // LANGUAGE SETTINGS
  // App language code (e.g., 'en' for English, 'es' for Spanish)
  String _languageCode = 'en';

  // Getters - allow other parts of the app to read settings
  ThemeMode get themeMode => _themeMode;
  bool get showMemorizationTimer => _showMemorizationTimer;
  CardsDisplayMode get cardsDisplayMode => _cardsDisplayMode;
  bool get enableBackConfirmation => _enableBackConfirmation;
  String get languageCode => _languageCode;

  /// Loads saved settings from device storage
  /// Called when the app starts to restore user preferences
  Future<void> loadSettings() async {
    // SharedPreferences is Flutter's way to save simple data locally
    final prefs = await SharedPreferences.getInstance();
    
    // Load theme mode (default to system if not set)
    final themeModeString = prefs.getString('themeMode') ?? 'system';
    _themeMode = _stringToThemeMode(themeModeString);
    
    // Load timer visibility setting (default to true = show timer)
    _showMemorizationTimer = prefs.getBool('showMemorizationTimer') ?? true;
    
    // Load cards display mode (default to single)
    final displayModeString = prefs.getString('cardsDisplayMode') ?? 'single';
    _cardsDisplayMode = _stringToCardsDisplayMode(displayModeString);
    
    // Load back confirmation setting (default to true = enabled)
    _enableBackConfirmation = prefs.getBool('enableBackConfirmation') ?? true;
    
    // Load language code (default to English)
    _languageCode = prefs.getString('languageCode') ?? 'en';
  }

  /// Saves the current theme mode preference
  /// @param mode The new theme mode to save
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', _themeModeToString(mode));
  }

  /// Saves the timer visibility preference
  /// @param show Whether to show the timer during memorization
  Future<void> setShowMemorizationTimer(bool show) async {
    _showMemorizationTimer = show;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showMemorizationTimer', show);
  }

  /// Saves the cards display mode preference
  /// @param mode How many cards to show at once (single/pair/triple)
  Future<void> setCardsDisplayMode(CardsDisplayMode mode) async {
    _cardsDisplayMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cardsDisplayMode', _cardsDisplayModeToString(mode));
  }

  /// Saves the back confirmation preference
  /// @param enable Whether to require double-back to exit
  Future<void> setEnableBackConfirmation(bool enable) async {
    _enableBackConfirmation = enable;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('enableBackConfirmation', enable);
  }

  /// Saves the language preference
  /// @param code Language code (e.g., 'en', 'es', 'fr')
  Future<void> setLanguageCode(String code) async {
    _languageCode = code;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', code);
  }

  /// Converts ThemeMode enum to a string for storage
  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'system';
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
    }
  }

  /// Converts a string back to ThemeMode enum
  ThemeMode _stringToThemeMode(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  /// Converts CardsDisplayMode enum to a string for storage
  String _cardsDisplayModeToString(CardsDisplayMode mode) {
    switch (mode) {
      case CardsDisplayMode.single:
        return 'single';
      case CardsDisplayMode.pair:
        return 'pair';
      case CardsDisplayMode.triple:
        return 'triple';
    }
  }

  /// Converts a string back to CardsDisplayMode enum
  CardsDisplayMode _stringToCardsDisplayMode(String mode) {
    switch (mode) {
      case 'pair':
        return CardsDisplayMode.pair;
      case 'triple':
        return CardsDisplayMode.triple;
      default:
        return CardsDisplayMode.single;
    }
  }

  /// Helper method to get the number of cards from display mode
  /// Returns 1 for single, 2 for pair, 3 for triple
  int getCardsPerView() {
    switch (_cardsDisplayMode) {
      case CardsDisplayMode.single:
        return 1;
      case CardsDisplayMode.pair:
        return 2;
      case CardsDisplayMode.triple:
        return 3;
    }
  }
}
