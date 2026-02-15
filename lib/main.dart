/// This is the entry point of the application
/// When the app starts, Flutter calls the main() function

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/home_screen.dart';
import 'models/app_settings.dart';
import 'l10n/app_localizations.dart';
import 'utils/update_checker.dart';

/// The main function: the first thing that runs when the app starts
/// Now includes settings initialization
void main() async {
  // Required for async operations before runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Load saved settings before starting the app
  // This ensures theme and preferences are applied immediately
  await AppSettings().loadSettings();

  // Check for updates automatically
  bool updateAvailable = await UpdateChecker.checkForUpdateAuto();
  
  // runApp() takes a Widget and makes it the root of the widget tree
  runApp(MyApp(
    showUpdateDialog: updateAvailable,
  ));
}

/// The root widget of the entire application
/// Changed to StatefulWidget to support theme and language changes
class MyApp extends StatefulWidget {
  final bool showUpdateDialog;

  const MyApp({super.key, this.showUpdateDialog = false});

  @override
  State<MyApp> createState() => _MyAppState();

  /// Static method to access MyApp state from anywhere in the widget tree
  /// This allows children widgets to trigger theme updates
  static _MyAppState? of(BuildContext context) {
    return context.findAncestorStateOfType<_MyAppState>();
  }
}

class _MyAppState extends State<MyApp> {
  // Get reference to settings singleton
  final AppSettings _settings = AppSettings();
  Locale? _locale;
  // Key to force complete rebuild when locale changes
  GlobalKey _navigatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Set the initial locale based on saved language setting
    String languageCode = AppSettings().languageCode;
    _locale = Locale(languageCode);
    
    // Show update dialog if update is available
    if (widget.showUpdateDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showUpdateDialog();
      });
    }
  }

  /// Shows the update dialog when update is available
  void _showUpdateDialog() async {
    try {
      final updateInfo = await UpdateChecker.checkForUpdate();
      if (updateInfo != null) {
        showDialog(
          context: context,
          barrierDismissible: false,
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
    } catch (e) {
      print('Error showing update dialog: $e');
    }
  }

  /// Downloads and installs the update
  void _downloadAndInstallUpdate(UpdateInfo updateInfo) {
    UpdateChecker.downloadAndInstallUpdate(updateInfo);
  }

  void updateLocale(String languageCode) {
    setState(() {
      _locale = Locale(languageCode);
    });
  }

  /// Called by settings screen to refresh theme and language
  /// This rebuilds the entire app with new theme and language settings
  void updateTheme() {
    setState(() {
      // setState triggers rebuild with new theme and language from settings
    });
  }

  /// Force a complete app restart by changing the navigator key
  void forceRestart() {
    setState(() {
      _navigatorKey = GlobalKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    // MaterialApp provides Material Design styling and navigation
    return MaterialApp(
      key: _navigatorKey, // Key to force complete rebuild when changed
      // The title shown in the app switcher on mobile devices
      title: t('app_name'),

      locale: _locale,
      supportedLocales: [
        Locale('en'), // English
        Locale('it'), // Italian
      ],
      localizationsDelegates: [
        // Custom localization delegate
        _AppLocalizationDelegate(),
        // Built-in localization for Material widgets
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // Light theme configuration using Material 3 design system
      theme: ThemeData(
        // Material 3 (Material Design 3) is the latest design system from Google
        useMaterial3: true,

        // ColorScheme.fromSeed generates a complete color palette from a single color
        // This ensures all UI elements have harmonious colors
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue, // Primary color for the app
          brightness: Brightness.light, // Light mode
        ),
      ),

      // Dark theme configuration (used when device is in dark mode or user selects dark)
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark, // Dark mode
        ),
      ),

      // UPDATED: Now uses saved theme preference
      // ThemeMode controls which theme is active:
      // - ThemeMode.system: follows device setting
      // - ThemeMode.light: always light
      // - ThemeMode.dark: always dark
      themeMode: _settings.themeMode,

      // The first screen the user sees when opening the app
      home: const HomeScreen(),

      // Removes the "Debug" banner shown in the top-right corner during development
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Localization Delegate to provide localized strings
class _AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'it'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations();
  }

  @override
  bool shouldReload(_AppLocalizationDelegate old) => false;
}

/// Helper function to get localized strings
String t(String key) {
  return AppLocalizations.of(key, AppSettings().languageCode);
}
