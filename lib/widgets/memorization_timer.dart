/// memorization_timer.dart
/// This file should be placed in: lib/widgets/memorization_timer.dart
/// 
/// MemorizationTimer - A stopwatch that counts UP during the memorization phase
/// Shows time in format: MM:SS.ms (minutes:seconds.centiseconds)
/// This timer helps users track how long they take to memorize the deck

import 'package:flutter/material.dart';
import 'dart:async';

class MemorizationTimer extends StatefulWidget {
  /// Callback function that gets called with the elapsed time when timer stops
  /// This allows parent widgets to save/use the memorization time
  final Function(Duration)? onTimerStop;
  
  const MemorizationTimer({
    super.key,
    this.onTimerStop,
  });

  @override
  State<MemorizationTimer> createState() => MemorizationTimerState();
}

/// State class is public so parent can access it via GlobalKey
class MemorizationTimerState extends State<MemorizationTimer> {
  // Timer object that triggers updates every 10 milliseconds (1/100 second precision)
  Timer? _timer;
  
  // Duration object that stores the total elapsed time
  Duration _elapsed = Duration.zero;
  
  // Boolean to track if timer is currently running
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    // Automatically start the timer when this widget is created
    _startTimer();
  }

  /// Starts the stopwatch timer
  /// Creates a periodic timer that updates every 10 milliseconds
  void _startTimer() {
    _isRunning = true;
    // Timer.periodic creates a repeating timer
    // Duration(milliseconds: 10) = 1/100 of a second precision
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        // Add 10 milliseconds to elapsed time on each tick
        _elapsed += const Duration(milliseconds: 10);
      });
    });
  }

  /// Stops the timer and notifies parent widget of final time
  /// This is called from parent widget using GlobalKey
  void stopTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel(); // Stop the periodic timer
      _isRunning = false;
      
      // Call the callback function if provided, passing the total elapsed time
      widget.onTimerStop?.call(_elapsed);
      
      setState(() {}); // Update UI to show timer has stopped
    }
  }

  /// Returns the current elapsed time
  /// Useful for parent widgets to get the time without stopping the timer
  Duration get elapsedTime => _elapsed;

  /// Formats the Duration into a readable string: MM:SS.CS
  /// MM = minutes (00-99)
  /// SS = seconds (00-59)
  /// CS = centiseconds (00-99, which is 1/100 of a second)
  String _formatTime(Duration duration) {
    int totalSeconds = duration.inSeconds;
    int minutes = totalSeconds ~/ 60; // Integer division to get full minutes
    int seconds = totalSeconds % 60;  // Remainder gives us the seconds
    int centiseconds = (duration.inMilliseconds % 1000) ~/ 10; // Get 1/100 second precision
    
    // Return formatted string with leading zeros
    return '${minutes.toString().padLeft(2, '0')}:'
           '${seconds.toString().padLeft(2, '0')}.'
           '${centiseconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    // IMPORTANT: Cancel timer when widget is destroyed to prevent memory leaks
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Semi-transparent background so it doesn't distract too much
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Small clock icon to indicate this is a timer
          Icon(
            Icons.timer_outlined,
            color: Colors.white.withValues(alpha: 0.9),
            size: 16,
          ),
          const SizedBox(width: 6),
          // Display the formatted time
          Text(
            _formatTime(_elapsed),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
              fontWeight: FontWeight.w500,
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
