import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  // 1. Newsreader (Editorial Serif Headings & Numbers)
  static TextStyle headingLarge({Color color = AppColors.pine}) =>
      GoogleFonts.newsreader(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.2,
      );

  static TextStyle headingMedium({Color color = AppColors.pine}) =>
      GoogleFonts.newsreader(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.25,
      );

  static TextStyle headingSmall({Color color = AppColors.pine}) =>
      GoogleFonts.newsreader(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: color,
      );

  static TextStyle statNumber({Color color = AppColors.pine}) =>
      GoogleFonts.newsreader(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: color,
      );

  // 2. Inter (Sans-serif Body, UI, Labels, Buttons)
  static TextStyle cardTitle({Color color = AppColors.ink}) =>
      GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle bodyLarge({
    Color color = AppColors.ink,
    FontWeight fontWeight = FontWeight.w400,
  }) =>
      GoogleFonts.inter(
        fontSize: 13,
        fontWeight: fontWeight,
        color: color,
        height: 1.4,
      );

  static TextStyle bodyMedium({
    Color color = AppColors.inkMid,
    FontWeight fontWeight = FontWeight.w400,
  }) =>
      GoogleFonts.inter(
        fontSize: 12.5,
        fontWeight: fontWeight,
        color: color,
        height: 1.4,
      );

  static TextStyle bodySmall({
    Color color = AppColors.inkMute,
    FontWeight fontWeight = FontWeight.w400,
  }) =>
      GoogleFonts.inter(
        fontSize: 12,
        fontWeight: fontWeight,
        color: color,
        height: 1.35,
      );

  static TextStyle buttonText({
    Color color = AppColors.white,
    FontWeight fontWeight = FontWeight.w600,
  }) =>
      GoogleFonts.inter(
        fontSize: 13,
        fontWeight: fontWeight,
        color: color,
      );

  static TextStyle caption({
    Color color = AppColors.inkMute,
    FontWeight fontWeight = FontWeight.w400,
  }) =>
      GoogleFonts.inter(
        fontSize: 11,
        fontWeight: fontWeight,
        color: color,
      );

  // 3. IBM Plex Mono (Eyebrows, Timestamps, Codes)
  static TextStyle eyebrow({Color color = AppColors.pineLight}) =>
      GoogleFonts.ibmPlexMono(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: color,
        letterSpacing: 1.2,
      );

  static TextStyle eyebrowMono({Color color = AppColors.pineLight}) =>
      GoogleFonts.ibmPlexMono(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: color,
        letterSpacing: 1.2,
      );

  static TextStyle metricLabel({Color color = AppColors.inkMute}) =>
      GoogleFonts.ibmPlexMono(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: color,
        letterSpacing: 0.8,
      );

  static TextStyle monoBadge({Color color = AppColors.pine}) =>
      GoogleFonts.ibmPlexMono(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: color,
        letterSpacing: 0.8,
      );
}