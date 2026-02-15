/// settings_screen.dart
/// This file contains the Settings page where users can customize app preferences
/// UPDATED: Version now reads dynamically from pubspec.yaml

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../models/app_settings.dart';
import '../main.dart';
import '../utils/update_checker.dart';

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
  
  // Variable to store app version info
  String _appVersion = 'Loading...';
  String _buildNumber = '';

  // Variables to track SVG font sizes
  late double _svgCornerFontSize;
  late double _svgCenterFontSize;

  @override
  void initState() {
    super.initState();
    // Initialize local state with current saved settings
    _selectedThemeMode = _settings.themeMode;
    _showTimer = _settings.showMemorizationTimer;
    _cardsDisplayMode = _settings.cardsDisplayMode;
    _enableBackConfirmation = _settings.enableBackConfirmation;
    _selectedLanguage = _settings.languageCode;
    _svgCornerFontSize = _settings.svgCornerFontSize;
    _svgCenterFontSize = _settings.svgCenterFontSize;

    // Load app version information
    _loadAppVersion();
  }

  /// Loads the app version and build number from package info
  /// This reads directly from pubspec.yaml at runtime
  Future<void> _loadAppVersion() async {
    try {
      // Get package information
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      
      // Update the UI with version info
      setState(() {
        _appVersion = packageInfo.version;       // e.g., "1.1.0"
        _buildNumber = packageInfo.buildNumber;  // e.g., "1"
      });
    } catch (e) {
      // If there's an error loading version, show error message
      setState(() {
        _appVersion = 'Unknown';
        _buildNumber = '';
      });
      print('Error loading app version: $e');
    }
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
    // Show confirmation dialog before changing language
    bool confirmChange = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(t('language')),
          content: Text(t('note_language_restart')),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel
              },
              child: Text(t('cancel')),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm
              },
              child: Text(t('ok')),
            ),
          ],
        );
      },
    ) ?? false; // Default to false if dialog is dismissed

    if (confirmChange) {
      setState(() {
        _selectedLanguage = languageCode;
      });
      await _settings.setLanguageCode(languageCode);

      if (mounted) {
        // Update the app's locale and trigger a rebuild
        MyApp.of(context)?.updateLocale(languageCode);
        MyApp.of(context)?.updateTheme(); // This forces a rebuild of the entire app

        // Show snackbar with success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t('language_changed_successfully')),
            duration: Duration(seconds: 2),
          ),
        );

        // Force a complete app restart to ensure all screens update to the new language
        // Using a delayed future to allow the snackbar to show before restarting
        Future.delayed(Duration(milliseconds: 500), () {
          if (mounted) {
            MyApp.of(context)?.forceRestart();
          }
        });
      }
    }
  }

  /// Updates the SVG corner font size setting
  Future<void> _updateSvgCornerFontSize(double fontSize) async {
    setState(() {
      _svgCornerFontSize = fontSize;
    });
    await _settings.setSvgCornerFontSize(fontSize);
  }

  /// Updates the SVG center font size setting
  Future<void> _updateSvgCenterFontSize(double fontSize) async {
    setState(() {
      _svgCenterFontSize = fontSize;
    });
    await _settings.setSvgCenterFontSize(fontSize);
  }

  /// Checks for app updates and prompts user to update if available
  Future<void> _checkForUpdates() async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 20),
                Text(t('checking_for_updates')),
              ],
            ),
          );
        },
      );

      // Check for updates
      final updateInfo = await UpdateChecker.checkForUpdate();

      // Close loading dialog
      Navigator.of(context).pop();

      if (updateInfo != null) {
        // New version is available
        _showUpdateDialog(updateInfo);
      } else {
        // No updates available
        _showNoUpdateDialog();
      }
    } catch (e) {
      // Close loading dialog if still open
      Navigator.of(context).pop();

      // Show error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(t('error')),
            content: Text(t('error_checking_for_updates')),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(t('ok')),
              ),
            ],
          );
        },
      );
    }
  }

  /// Shows dialog when a new update is available
  void _showUpdateDialog(UpdateInfo updateInfo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(t('update_available')),
          content: SizedBox(
            width: double.maxFinite, // Allow full width for changelog
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${t('current_version')}: ${updateInfo.currentVersion}\n${t('latest_version')}: ${updateInfo.latestVersion}',
                ),
                const SizedBox(height: 10),
                Text(
                  t('changelog'),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Flexible(
                  child: Container(
                    height: 200,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        child: Text(
                          updateInfo.releaseNotes.isNotEmpty 
                            ? updateInfo.releaseNotes 
                            : t('no_changelog_available'),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  t('update_description'),
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(t('later')),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _downloadAndInstallUpdate(updateInfo);
              },
              child: Text(t('update_now')),
            ),
          ],
        );
      },
    );
  }

  /// Shows dialog when no updates are available
  void _showNoUpdateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(t('no_update_available')),
          content: Text(t('running_latest_version')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(t('ok')),
            ),
          ],
        );
      },
    );
  }

  /// Downloads and installs the update
  void _downloadAndInstallUpdate(UpdateInfo updateInfo) {
    // For now, we'll just open the GitHub releases page in a browser
    // In a real implementation, you would handle downloading and installing the APK
    _showDownloadInstructions(updateInfo);
  }

  /// Shows instructions for downloading the update
  void _showDownloadInstructions(UpdateInfo updateInfo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(t('download_update')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t('download_instructions')),
              const SizedBox(height: 10),
              SelectableText(
                updateInfo.downloadUrl,
                style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(t('ok')),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t('settings')),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600), // Limit max width on large screens
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CATEGORY 1: APPEARANCE
                    _buildCategoryHeader(
                      icon: Icons.palette,
                      title: t('appearance'),
                      subtitle: t('customize_appearance'),
                    ),
                    const SizedBox(height: 12),
                    _buildThemeCard(),

                    const SizedBox(height: 32),

                    // CATEGORY 2: CARD APPEARANCE
                    _buildCategoryHeader(
                      icon: Icons.card_membership,
                      title: t('card_appearance'),
                      subtitle: t('customize_cards'),
                    ),
                    const SizedBox(height: 12),
                    _buildSvgFontSizeCard(),

                    const SizedBox(height: 32),

                    // CATEGORY 3: TRAINING
                    _buildCategoryHeader(
                      icon: Icons.fitness_center,
                      title: t('training'),
                      subtitle: t('configure_training'),
                    ),
                    const SizedBox(height: 12),
                    _buildTimerCard(),
                    const SizedBox(height: 12),
                    _buildCardsDisplayCard(),

                    const SizedBox(height: 32),

                    // CATEGORY 4: BEHAVIOR
                    _buildCategoryHeader(
                      icon: Icons.touch_app,
                      title: t('behavior'),
                      subtitle: t('control_interactions'),
                    ),
                    const SizedBox(height: 12),
                    _buildBackConfirmationCard(),

                    const SizedBox(height: 32),

                    // CATEGORY 5: LANGUAGE
                    _buildCategoryHeader(
                      icon: Icons.language,
                      title: t('language'),
                      subtitle: t('choose_language'),
                    ),
                    const SizedBox(height: 12),
                    _buildLanguageCard(),

                    const SizedBox(height: 32),

                    // CATEGORY 6: ABOUT
                    _buildCategoryHeader(
                      icon: Icons.info,
                      title: t('about'),
                      subtitle: t('app_information'),
                    ),
                    const SizedBox(height: 12),
                    _buildAboutCard(),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
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
                Text(
                  t('theme_mode'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            RadioListTile<ThemeMode>(
              title: Text(t('system_theme')),
              value: ThemeMode.system,
              groupValue: _selectedThemeMode,
              onChanged: (value) => value != null ? _updateThemeMode(value) : null,
            ),

            RadioListTile<ThemeMode>(
              title: Text(t('light_theme')),
              value: ThemeMode.light,
              groupValue: _selectedThemeMode,
              onChanged: (value) => value != null ? _updateThemeMode(value) : null,
            ),

            RadioListTile<ThemeMode>(
              title: Text(t('dark_theme')),
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
                Text(
                  t('memorization_timer'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            SwitchListTile(
              title: Text(t('show_timer')),
              subtitle: Text(t('timer_subtitle')),
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
                Text(
                  t('cards_display_mode'),
                  style: const TextStyle(
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
                t('choose_cards_display'),
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            ),

            RadioListTile<CardsDisplayMode>(
              title: Text(t('one_card')),
              subtitle: Text(t('one_card_subtitle')),
              value: CardsDisplayMode.single,
              groupValue: _cardsDisplayMode,
              onChanged: (value) => value != null ? _updateCardsDisplayMode(value) : null,
            ),

            RadioListTile<CardsDisplayMode>(
              title: Text(t('two_cards')),
              subtitle: Text(t('two_cards_subtitle')),
              value: CardsDisplayMode.pair,
              groupValue: _cardsDisplayMode,
              onChanged: (value) => value != null ? _updateCardsDisplayMode(value) : null,
            ),

            RadioListTile<CardsDisplayMode>(
              title: Text(t('three_cards')),
              subtitle: Text(t('three_cards_subtitle')),
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
                Text(
                  t('back_gesture_confirmation'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            SwitchListTile(
              title: Text(t('double_back_exit')),
              subtitle: Text(t('back_subtitle')),
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
      'it': 'Italiano (Italian)',
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
              decoration: InputDecoration(
                labelText: t('select_language'),
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
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
              t('note_language_restart'),
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

  /// Builds the about card with dynamic version info
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
                Text(
                  t('app_name'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // UPDATED: Version now shows dynamically from pubspec.yaml
            Text(
              'Version $_appVersion${_buildNumber.isNotEmpty ? ' ($_buildNumber)' : ''}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              t('app_description'),
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _checkForUpdates,
              icon: Icon(Icons.update, size: 18),
              label: Text(t('check_for_updates')),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the SVG font size card
  Widget _buildSvgFontSizeCard() {
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
                  Icons.text_fields,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  t('svg_card_font_sizes'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              t('adjust_font_sizes'),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),

            // Corner text font size slider
            Text(
              t('corner_text_size'),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Slider(
              value: _svgCornerFontSize,
              min: 0.2,
              max: 1.5,
              divisions: 26, // 0.05 increments between 0.2 and 1.5
              label: '${_svgCornerFontSize.toStringAsFixed(2)} em',
              onChanged: (double value) {
                _updateSvgCornerFontSize(value);
              },
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t('smaller'),
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  '${_svgCornerFontSize.toStringAsFixed(2)} em',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  t('larger'),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Center symbol font size slider
            Text(
              t('center_symbol_size'),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Slider(
              value: _svgCenterFontSize,
              min: 0.5,
              max: 2.0,
              divisions: 30, // 0.05 increments between 0.5 and 2.0
              label: '${_svgCenterFontSize.toStringAsFixed(2)} em',
              onChanged: (double value) {
                _updateSvgCenterFontSize(value);
              },
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t('smaller'),
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  '${_svgCenterFontSize.toStringAsFixed(2)} em',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  t('larger'),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
