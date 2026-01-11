/// settings_screen.dart
/// This file contains the Settings page where users can customize app preferences
/// UPDATED: Organized settings into categories and added new options

import 'package:flutter/material.dart';
import '../models/app_settings.dart';
import '../main.dart';

/// SettingsScreen widget - displays all user-configurable settings
/// Settings are now organized into logical categories for better UX
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Get reference to the settings singleton
  final AppSettings _settings = AppSettings();

  // Local state variables to track current selections
  late ThemeMode _selectedThemeMode;
  late bool _showTimer;
  late CardsDisplayMode _cardsDisplayMode;
  late bool _enableBackConfirmation;
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    // Initialize local state with current saved settings
    _selectedThemeMode = _settings.themeMode;
    _showTimer = _settings.showMemorizationTimer;
    _cardsDisplayMode = _settings.cardsDisplayMode;
    _enableBackConfirmation = _settings.enableBackConfirmation;
    _selectedLanguage = _settings.languageCode;
  }

  /// Updates the theme mode setting
  Future<void> _updateThemeMode(ThemeMode mode) async {
    setState(() {
      _selectedThemeMode = mode;
    });
    await _settings.setThemeMode(mode);
    
    // Notify the app to rebuild with new theme
    if (mounted) {
      MyApp.of(context)?.updateTheme();
    }
  }

  /// Updates the timer visibility setting
  Future<void> _updateShowTimer(bool show) async {
    setState(() {
      _showTimer = show;
    });
    await _settings.setShowMemorizationTimer(show);
  }

  /// Updates the cards display mode setting
  Future<void> _updateCardsDisplayMode(CardsDisplayMode mode) async {
    setState(() {
      _cardsDisplayMode = mode;
    });
    await _settings.setCardsDisplayMode(mode);
  }

  /// Updates the back confirmation setting
  Future<void> _updateBackConfirmation(bool enable) async {
    setState(() {
      _enableBackConfirmation = enable;
    });
    await _settings.setEnableBackConfirmation(enable);
  }

  /// Updates the language setting
  Future<void> _updateLanguage(String languageCode) async {
    setState(() {
      _selectedLanguage = languageCode;
    });
    await _settings.setLanguageCode(languageCode);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Language will update on next app restart'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CATEGORY 1: APPEARANCE
                _buildCategoryHeader(
                  icon: Icons.palette,
                  title: 'Appearance',
                  subtitle: 'Customize how the app looks',
                ),
                const SizedBox(height: 12),
                _buildThemeCard(),
                
                const SizedBox(height: 32),
                
                // CATEGORY 2: TRAINING
                _buildCategoryHeader(
                  icon: Icons.fitness_center,
                  title: 'Training',
                  subtitle: 'Configure your training experience',
                ),
                const SizedBox(height: 12),
                _buildTimerCard(),
                const SizedBox(height: 12),
                _buildCardsDisplayCard(),
                
                const SizedBox(height: 32),
                
                // CATEGORY 3: BEHAVIOR
                _buildCategoryHeader(
                  icon: Icons.touch_app,
                  title: 'Behavior',
                  subtitle: 'Control app interactions',
                ),
                const SizedBox(height: 12),
                _buildBackConfirmationCard(),
                
                const SizedBox(height: 32),
                
                // CATEGORY 4: LANGUAGE
                _buildCategoryHeader(
                  icon: Icons.language,
                  title: 'Language',
                  subtitle: 'Choose your preferred language',
                ),
                const SizedBox(height: 12),
                _buildLanguageCard(),
                
                const SizedBox(height: 32),
                
                // CATEGORY 5: ABOUT
                _buildCategoryHeader(
                  icon: Icons.info,
                  title: 'About',
                  subtitle: 'App information',
                ),
                const SizedBox(height: 12),
                _buildAboutCard(),
                
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a category header with icon, title, and subtitle
  Widget _buildCategoryHeader({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 36),
          child: Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Divider(
          thickness: 1,
          color: Colors.grey.shade300,
        ),
      ],
    );
  }

  /// Builds the theme selection card
  Widget _buildThemeCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.brightness_6,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Theme Mode',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            RadioListTile<ThemeMode>(
              title: const Text('System'),
              subtitle: const Text('Follow device theme'),
              value: ThemeMode.system,
              groupValue: _selectedThemeMode,
              onChanged: (value) => value != null ? _updateThemeMode(value) : null,
            ),
            
            RadioListTile<ThemeMode>(
              title: const Text('Light'),
              subtitle: const Text('Always light theme'),
              value: ThemeMode.light,
              groupValue: _selectedThemeMode,
              onChanged: (value) => value != null ? _updateThemeMode(value) : null,
            ),
            
            RadioListTile<ThemeMode>(
              title: const Text('Dark'),
              subtitle: const Text('Always dark theme'),
              value: ThemeMode.dark,
              groupValue: _selectedThemeMode,
              onChanged: (value) => value != null ? _updateThemeMode(value) : null,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the timer visibility card
  Widget _buildTimerCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.timer,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Memorization Timer',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            SwitchListTile(
              title: const Text('Show timer during memorization'),
              subtitle: const Text(
                'Timer tracks time but won\'t be visible if disabled',
              ),
              value: _showTimer,
              onChanged: _updateShowTimer,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the cards display mode card
  Widget _buildCardsDisplayCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.view_carousel,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Cards Display Mode',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 32, top: 4, bottom: 8),
              child: Text(
                'Choose how many cards to view at once during memorization',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            
            RadioListTile<CardsDisplayMode>(
              title: const Text('1 card at a time'),
              subtitle: const Text('View cards one by one (classic mode)'),
              value: CardsDisplayMode.single,
              groupValue: _cardsDisplayMode,
              onChanged: (value) => value != null ? _updateCardsDisplayMode(value) : null,
            ),
            
            RadioListTile<CardsDisplayMode>(
              title: const Text('2 cards at a time'),
              subtitle: const Text('View cards in pairs'),
              value: CardsDisplayMode.pair,
              groupValue: _cardsDisplayMode,
              onChanged: (value) => value != null ? _updateCardsDisplayMode(value) : null,
            ),
            
            RadioListTile<CardsDisplayMode>(
              title: const Text('3 cards at a time'),
              subtitle: const Text('View cards in groups of three'),
              value: CardsDisplayMode.triple,
              groupValue: _cardsDisplayMode,
              onChanged: (value) => value != null ? _updateCardsDisplayMode(value) : null,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the back confirmation card
  Widget _buildBackConfirmationCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Back Gesture Confirmation',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            SwitchListTile(
              title: const Text('Require double-back to exit'),
              subtitle: const Text(
                'Prevents accidental exits during training. '
                'Press back twice within 5 seconds to exit Memorization/Recall screens.',
              ),
              value: _enableBackConfirmation,
              onChanged: _updateBackConfirmation,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the language selection card
  Widget _buildLanguageCard() {
    final Map<String, String> languages = {
      'en': 'English',
      'es': 'Español (Spanish)',
      'fr': 'Français (French)',
      'de': 'Deutsch (German)',
      'it': 'Italiano (Italian)',
      'pt': 'Português (Portuguese)',
      'ja': '日本語 (Japanese)',
      'zh': '中文 (Chinese)',
    };

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedLanguage,
              decoration: const InputDecoration(
                labelText: 'Select Language',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: languages.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
              onChanged: (value) => value != null ? _updateLanguage(value) : null,
            ),
            const SizedBox(height: 8),
            
            Text(
              'Note: App restart required for language changes',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the about card
  Widget _buildAboutCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.style,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                const Text(
                  'DeckDash',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('Version 1.0.0'),
            const SizedBox(height: 8),
            const Text(
              'A Flutter-based training app for Speed Card memorization',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
