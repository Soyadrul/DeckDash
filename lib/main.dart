/// This is the entry point of the application
/// When the app starts, Flutter calls the main() function

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/home_screen.dart';
import 'models/app_settings.dart';
import 'l10n/app_localizations.dart';

/// The main function: the first thing that runs when the app starts
/// Now includes settings initialization
void main() async {
  // Required for async operations before runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Load saved settings before starting the app
  // This ensures theme and preferences are applied immediately
  await AppSettings().loadSettings();

  // runApp() takes a Widget and makes it the root of the widget tree
  runApp(MyApp());
}

/// The root widget of the entire application
/// Changed to StatefulWidget to support theme and language changes
class MyApp extends StatefulWidget {
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

  @override
  void initState() {
    super.initState();
    // Set the initial locale based on saved language setting
    String languageCode = AppSettings().languageCode;
    _locale = Locale(languageCode);
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

  @override
  Widget build(BuildContext context) {
    // MaterialApp provides Material Design styling and navigation
    return MaterialApp(
      // The title shown in the app switcher on mobile devices
      title: 'DeckDash',
      
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
