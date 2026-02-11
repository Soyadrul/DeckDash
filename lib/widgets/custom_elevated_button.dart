import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final OutlinedBorder? shape;

  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.width,
    this.height = 60,
    this.padding,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: width != null ? Size(width!, height!) : null, // Allow content-based sizing
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: shape ?? RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
        ),
        child: child,
      ),
    );
  }
}

class CustomElevatedButtonIcon extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget icon;
  final Widget label;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final OutlinedBorder? shape;

  const CustomElevatedButtonIcon({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    this.width,
    this.height = 60,
    this.padding,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon,
        label: label,
        style: ElevatedButton.styleFrom(
          minimumSize: width != null ? Size(width!, height!) : null, // Allow content-based sizing
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: shape ?? RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
        ),
      ),
    );
  }
}

class CustomOutlinedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final OutlinedBorder? shape;

  const CustomOutlinedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.width,
    this.height = 60,
    this.padding,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: width != null ? Size(width!, height!) : null, // Allow content-based sizing
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: shape ?? RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
        ),
        child: child,
      ),
    );
  }
}