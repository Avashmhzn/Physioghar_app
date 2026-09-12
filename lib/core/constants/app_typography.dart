import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  // Fraunces - Headings and Large Numbers
  static TextStyle headingLarge({Color color = AppColors.ink}) =>
      GoogleFonts.fraunces(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.2,
      );

  static TextStyle headingMedium({Color color = AppColors.ink}) =>
      GoogleFonts.fraunces(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.25,
      );

  static TextStyle headingSmall({Color color = AppColors.ink}) =>
      GoogleFonts.fraunces(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.3,
      );

  static TextStyle statNumber({Color color = AppColors.pine}) =>
      GoogleFonts.fraunces(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: color,
      );

  // Inter - Body text, buttons and labels
  static TextStyle bodyLarge({Color color = AppColors.ink, FontWeight fontWeight = FontWeight.w400}) =>
      GoogleFonts.inter(
        fontSize: 16,
        fontWeight: fontWeight,
        color: color,
        height: 1.4,
      );

  static TextStyle bodyMedium({Color color = AppColors.inkMid, FontWeight fontWeight = FontWeight.w400}) =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: fontWeight,
        color: color,
        height: 1.4,
      );

  static TextStyle bodySmall({Color color = AppColors.inkMute, FontWeight fontWeight = FontWeight.w400}) =>
      GoogleFonts.inter(
        fontSize: 12,
        fontWeight: fontWeight,
        color: color,
        height: 1.35,
      );

  static TextStyle buttonText({Color color = AppColors.white, FontWeight fontWeight = FontWeight.w600}) =>
      GoogleFonts.inter(
        fontSize: 15,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: 0.2,
      );

  // IBM Plex Mono - Small uppercase labels/eyebrows
  static TextStyle eyebrow({Color color = AppColors.inkMute}) =>
      GoogleFonts.ibmPlexMono(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 1.1,
      );

  static TextStyle monoBadge({Color color = AppColors.pine}) =>
      GoogleFonts.ibmPlexMono(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color,
      );
}
