import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTypography {
  // 1. Newsreader (Editorial Serif Headings & Numbers)
  static final TextStyle _headingLargeBase = GoogleFonts.newsreader(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );
  static TextStyle headingLarge({Color color = AppColors.pine}) =>
      _headingLargeBase.copyWith(color: color);

  static final TextStyle _headingMediumBase = GoogleFonts.newsreader(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );
  static TextStyle headingMedium({Color color = AppColors.pine}) =>
      _headingMediumBase.copyWith(color: color);

  static final TextStyle _headingSmallBase = GoogleFonts.newsreader(
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );
  static TextStyle headingSmall({Color color = AppColors.pine}) =>
      _headingSmallBase.copyWith(color: color);

  static final TextStyle _statNumberBase = GoogleFonts.newsreader(
    fontSize: 26,
    fontWeight: FontWeight.w700,
  );
  static TextStyle statNumber({Color color = AppColors.pine}) =>
      _statNumberBase.copyWith(color: color);

  // 2. Inter (Sans-serif Body, UI, Labels, Buttons)
  static final TextStyle _cardTitleBase = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );
  static TextStyle cardTitle({Color color = AppColors.slate}) =>
      _cardTitleBase.copyWith(color: color);

  static final TextStyle _bodyLargeBase = GoogleFonts.inter(
    fontSize: 13,
    height: 1.4,
  );
  static TextStyle bodyLarge({
    Color color = AppColors.slate,
    FontWeight fontWeight = FontWeight.w400,
  }) => _bodyLargeBase.copyWith(color: color, fontWeight: fontWeight);

  static final TextStyle _bodyMediumBase = GoogleFonts.inter(
    fontSize: 12.5,
    height: 1.4,
  );
  static TextStyle bodyMedium({
    Color color = AppColors.slateMid,
    FontWeight fontWeight = FontWeight.w400,
  }) => _bodyMediumBase.copyWith(color: color, fontWeight: fontWeight);

  static final TextStyle _bodySmallBase = GoogleFonts.inter(
    fontSize: 12,
    height: 1.35,
  );
  static TextStyle bodySmall({
    Color color = AppColors.slateMute,
    FontWeight fontWeight = FontWeight.w400,
  }) => _bodySmallBase.copyWith(color: color, fontWeight: fontWeight);

  static final TextStyle _buttonTextBase = GoogleFonts.inter(fontSize: 13);
  static TextStyle buttonText({
    Color color = AppColors.white,
    FontWeight fontWeight = FontWeight.w600,
  }) => _buttonTextBase.copyWith(color: color, fontWeight: fontWeight);

  static final TextStyle _captionBase = GoogleFonts.inter(fontSize: 11);
  static TextStyle caption({
    Color color = AppColors.slateMute,
    FontWeight fontWeight = FontWeight.w400,
  }) => _captionBase.copyWith(color: color, fontWeight: fontWeight);

  // 3. IBM Plex Mono (Eyebrows, Timestamps, Codes)
  static final TextStyle _eyebrowBase = GoogleFonts.ibmPlexMono(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.2,
  );
  static TextStyle eyebrow({Color color = AppColors.sage}) =>
      _eyebrowBase.copyWith(color: color);

  static final TextStyle _eyebrowMonoBase = GoogleFonts.ibmPlexMono(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.2,
  );
  static TextStyle eyebrowMono({
    Color color = AppColors.sage,
    double fontSize = 10,
  }) => _eyebrowMonoBase.copyWith(color: color, fontSize: fontSize);

  static final TextStyle _metricLabelBase = GoogleFonts.ibmPlexMono(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.8,
  );
  static TextStyle metricLabel({Color color = AppColors.slateMute}) =>
      _metricLabelBase.copyWith(color: color);

  static final TextStyle _monoBadgeBase = GoogleFonts.ibmPlexMono(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.8,
  );
  static TextStyle monoBadge({Color color = AppColors.pine}) =>
      _monoBadgeBase.copyWith(color: color);
}
