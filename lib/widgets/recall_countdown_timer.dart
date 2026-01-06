/// recall_countdown_timer.dart
/// This file should be placed in: lib/widgets/recall_countdown_timer.dart
/// 
/// RecallCountdownTimer - A countdown timer for the recall phase
/// Counts DOWN from a specified duration (5 min per deck)
/// Automatically calls onTimeUp callback when timer reaches zero

import 'package:flutter/material.dart';
import 'dart:async';

class RecallCountdownTimer extends StatefulWidget {
  /// Total duration to count down from (in seconds)
  /// For single deck: 300 seconds (5 minutes)
  /// For multi deck: 300 × number of decks
  final int totalSeconds;
  
  /// Callback function that gets triggered when countdown reaches 0
  /// This will auto-submit the recall and show results
  final VoidCallback onTimeUp;
  
  /// Whether to show a warning color when time is running low
  final bool showWarning;
  
  const RecallCountdownTimer({
    super.key,
    required this.totalSeconds,
    required this.onTimeUp,
    this.showWarning = true,
  });

  @override
  State<RecallCountdownTimer> createState() => RecallCountdownTimerState();
}

/// State class is public so parent can access it via GlobalKey if needed
class RecallCountdownTimerState extends State<RecallCountdownTimer> {
  // Timer object that updates every second
  Timer? _timer;
  
  // Remaining seconds - starts at totalSeconds and counts down
  late int _remainingSeconds;
  
  // Track if timer has already triggered the onTimeUp callback
  bool _hasTriggeredTimeUp = false;

  @override
  void initState() {
    super.initState();
    // Initialize remaining seconds from the total provided
    _remainingSeconds = widget.totalSeconds;
    // Start countdown immediately
    _startCountdown();
  }

  /// Starts the countdown timer
  /// Decrements remaining seconds every second
  void _startCountdown() {
    // Timer.periodic creates a repeating timer every 1 second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          // Decrease remaining time by 1 second
          _remainingSeconds--;
        } else {
          // Time's up! Stop the timer and trigger callback
          timer.cancel();
          if (!_hasTriggeredTimeUp) {
            _hasTriggeredTimeUp = true;
            // Call the onTimeUp callback to auto-submit
            widget.onTimeUp();
          }
        }
      });
    });
  }

  /// Pauses the countdown timer (can be used if user needs to pause)
  void pauseTimer() {
    _timer?.cancel();
  }

  /// Resumes the countdown timer after pause
  void resumeTimer() {
    if (_remainingSeconds > 0) {
      _startCountdown();
    }
  }

  /// Returns the remaining seconds
  /// Useful for parent widgets to check time remaining
  int get remainingSeconds => _remainingSeconds;

  /// Formats remaining seconds into readable format
  /// Returns format: HH:MM:SS for times over 1 hour
  /// Returns format: MM:SS for times under 1 hour
  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600; // Get full hours
    int minutes = (seconds % 3600) ~/ 60; // Get remaining minutes
    int secs = seconds % 60; // Get remaining seconds
    
    // If we have hours, show HH:MM:SS format
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
             '${minutes.toString().padLeft(2, '0')}:'
             '${secs.toString().padLeft(2, '0')}';
    }
    // Otherwise just show MM:SS format
    return '${minutes.toString().padLeft(2, '0')}:'
           '${secs.toString().padLeft(2, '0')}';
  }

  /// Determines the color of the timer based on remaining time
  /// Red when less than 1 minute (warning)
  /// Orange when less than 2 minutes
  /// White/normal otherwise
  Color _getTimerColor() {
    if (!widget.showWarning) {
      return Colors.white;
    }
    
    // Less than 1 minute: RED (urgent warning)
    if (_remainingSeconds < 60) {
      return Colors.red.shade400;
    }
    // Less than 2 minutes: ORANGE (warning)
    else if (_remainingSeconds < 120) {
      return Colors.orange.shade400;
    }
    // Normal time: WHITE
    return Colors.white;
  }

  /// Gets appropriate icon based on remaining time
  Icon _getTimerIcon() {
    Color iconColor = _getTimerColor();
    
    // Show warning icon when less than 1 minute remaining
    if (_remainingSeconds < 60) {
      return Icon(
        Icons.warning_amber_rounded,
        color: iconColor,
        size: 20,
      );
    }
    // Normal timer icon
    return Icon(
      Icons.hourglass_bottom,
      color: iconColor,
      size: 20,
    );
  }

  @override
  void dispose() {
    // IMPORTANT: Cancel timer when widget is destroyed to prevent memory leaks
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the current color based on remaining time
    Color timerColor = _getTimerColor();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        // Background color changes based on urgency
        color: _remainingSeconds < 60 
            ? Colors.red.withValues(alpha: 0.2)  // Red tint when urgent
            : Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(25),
        // Add subtle border when warning
        border: _remainingSeconds < 60
            ? Border.all(color: Colors.red.shade400, width: 2)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon that changes based on time remaining
          _getTimerIcon(),
          const SizedBox(width: 8),
          // Display the countdown time
          Text(
            _formatTime(_remainingSeconds),
            style: TextStyle(
              color: timerColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFeatures: const [
                FontFeature.tabularFigures(), // Monospace numbers for stable display
              ],
            ),
          ),
        ],
      ),
    );
  }
}
