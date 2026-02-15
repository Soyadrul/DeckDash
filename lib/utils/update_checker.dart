import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateChecker {
  static const String githubRepoUrl = 'https://api.github.com/repos/Soyadrul/DeckDash/releases/latest';

  /// Checks if there's a newer version available on GitHub
  static Future<UpdateInfo?> checkForUpdate() async {
    try {
      final response = await http.get(
        Uri.parse(githubRepoUrl),
        headers: {'Accept': 'application/vnd.github.v3+json'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        // Get current app version
        final PackageInfo packageInfo = await PackageInfo.fromPlatform();
        final currentVersion = packageInfo.version;
        
        // Get latest version from GitHub
        final latestVersion = jsonData['tag_name']?.toString().replaceAll('v', '') ?? '';
        
        // Get download URL based on platform
        String downloadUrl = '';
        final List assets = jsonData['assets'] ?? [];
        
        if (Platform.isAndroid) {
          // Look for APK file
          for (var asset in assets) {
            if (asset['name'].toString().toLowerCase().endsWith('.apk')) {
              downloadUrl = asset['browser_download_url'].toString();
              break;
            }
          }
        } else if (Platform.isLinux) {
          // Look for AppImage or deb file
          for (var asset in assets) {
            final assetName = asset['name'].toString().toLowerCase();
            if (assetName.endsWith('.appimage') || assetName.endsWith('.deb')) {
              downloadUrl = asset['browser_download_url'].toString();
              break;
            }
          }
        }
        
        // Compare versions
        if (_isNewerVersion(currentVersion, latestVersion)) {
          return UpdateInfo(
            currentVersion: currentVersion,
            latestVersion: latestVersion,
            downloadUrl: downloadUrl,
            releaseNotes: jsonData['body'] ?? '',
            releaseDate: jsonData['published_at'] ?? '',
          );
        }
      }
      
      return null;
    } catch (e) {
      print('Error checking for updates: $e');
      return null;
    }
  }

  /// Performs an automatic update check and returns true if update is available
  static Future<bool> checkForUpdateAuto() async {
    final updateInfo = await checkForUpdate();
    return updateInfo != null;
  }

  /// Compares two version strings (e.g., "1.2.0" vs "1.3.0")
  static bool _isNewerVersion(String current, String latest) {
    try {
      final currentParts = current.split('.').map((e) => int.tryParse(e) ?? 0).toList();
      final latestParts = latest.split('.').map((e) => int.tryParse(e) ?? 0).toList();
      
      // Pad with zeros if needed
      while (currentParts.length < 3) currentParts.add(0);
      while (latestParts.length < 3) latestParts.add(0);
      
      // Compare major, minor, patch versions
      for (int i = 0; i < 3; i++) {
        if (latestParts[i] > currentParts[i]) {
          return true;
        } else if (latestParts[i] < currentParts[i]) {
          return false;
        }
      }
      
      return false; // Versions are equal
    } catch (e) {
      print('Error comparing versions: $e');
      return false;
    }
  }

  /// Downloads and installs the update based on the platform
  static Future<void> downloadAndInstallUpdate(UpdateInfo updateInfo) async {
    if (Platform.isAndroid) {
      await _downloadAndInstallAndroid(updateInfo);
    } else if (Platform.isLinux) {
      await _downloadAndInstallLinux(updateInfo);
    } else {
      // For other platforms, open the release page in browser
      await launchUrl(Uri.parse('https://github.com/Soyadrul/DeckDash/releases'));
    }
  }

  /// Downloads and installs update for Android
  static Future<void> _downloadAndInstallAndroid(UpdateInfo updateInfo) async {
    if (updateInfo.downloadUrl.isEmpty) {
      throw Exception('No APK file found for download');
    }

    try {
      // Get temporary directory to save the APK
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/updated_app.apk';
      final file = File(filePath);

      // Download the APK file
      final response = await http.get(Uri.parse(updateInfo.downloadUrl));
      await file.writeAsBytes(response.bodyBytes);

      // Launch the downloaded APK for installation
      await launchUrl(Uri.file(filePath), mode: LaunchMode.externalApplication);
    } catch (e) {
      print('Error downloading or installing Android update: $e');
      rethrow;
    }
  }

  /// Downloads and installs update for Linux
  static Future<void> _downloadAndInstallLinux(UpdateInfo updateInfo) async {
    if (updateInfo.downloadUrl.isEmpty) {
      throw Exception('No Linux package found for download');
    }

    try {
      // Get documents directory to save the file
      final directory = await getDownloadsDirectory();
      if (directory == null) {
        throw Exception('Could not access downloads directory');
      }

      // Determine file extension based on the download URL
      String fileName = updateInfo.downloadUrl.split('/').last;
      if (!fileName.toLowerCase().endsWith('.appimage') && !fileName.toLowerCase().endsWith('.deb')) {
        fileName = 'DeckDash_Update.${Platform.isLinux ? 'AppImage' : 'deb'}';
      }

      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);

      // Download the file
      final response = await http.get(Uri.parse(updateInfo.downloadUrl));
      await file.writeAsBytes(response.bodyBytes);

      // Open the file with the default application
      await launchUrl(Uri.file(filePath), mode: LaunchMode.externalApplication);
    } catch (e) {
      print('Error downloading or installing Linux update: $e');
      rethrow;
    }
  }
}

class UpdateInfo {
  final String currentVersion;
  final String latestVersion;
  final String downloadUrl;
  final String releaseNotes;
  final String releaseDate;

  UpdateInfo({
    required this.currentVersion,
    required this.latestVersion,
    required this.downloadUrl,
    required this.releaseNotes,
    required this.releaseDate,
  });
}