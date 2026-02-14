import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class SvgWithCustomFontSize extends StatelessWidget {
  final String assetPath;
  final double cornerFontSize;
  final double centerFontSize;
  final BoxFit fit;
  final double? width;
  final double? height;

  const SvgWithCustomFontSize({
    super.key,
    required this.assetPath,
    required this.cornerFontSize,
    required this.centerFontSize,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _loadAndModifySvg(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SvgPicture.string(
            snapshot.data!,
            fit: fit,
            width: width,
            height: height,
          );
        } else {
          return SvgPicture.asset(
            assetPath,
            fit: fit,
            width: width,
            height: height,
          );
        }
      },
    );
  }

  Future<String> _loadAndModifySvg() async {
    try {
      String svgContent = await rootBundle.loadString(assetPath);
      
      // Replace corner text font size (typically 0.5em)
      svgContent = svgContent.replaceAll(
        RegExp(r'font-size="0\.5em"'),
        'font-size="${cornerFontSize.toStringAsFixed(2)}em"',
      );
      
      // Replace center symbol font size (typically 1.0em)
      svgContent = svgContent.replaceAll(
        RegExp(r'font-size="1\.0em"'),
        'font-size="${centerFontSize.toStringAsFixed(2)}em"',
      );
      
      return svgContent;
    } catch (e) {
      // If there's an error, return the original SVG
      return await rootBundle.loadString(assetPath);
    }
  }
}