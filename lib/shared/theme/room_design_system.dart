import 'package:flutter/material.dart';

/// Standardized design system for room-related UI components
class RoomDesignSystem {
  /// Primary spacing scale (based on 8px grid)
  static const double spacingXs = 4.0; // For tight spacing within elements
  static const double spacingSm = 8.0; // For small gaps between related items
  static const double spacingMd = 16.0; // For standard spacing between sections
  static const double spacingLg = 24.0; // For major section separation
  static const double spacingXl =
      32.0; // For large gaps between major components

  /// Specialized spacing
  static const double cardPadding = 20.0; // Internal card padding
  static const double screenPadding = 20.0; // Screen edge padding
  static const double buttonSpacing = 12.0; // Between action buttons

  /// Visual hierarchy through spacing
  static const double primarySection =
      spacingXl; // 32px - Between major sections
  static const double secondarySection =
      spacingLg; // 24px - Between sub-sections
  static const double relatedItems = spacingMd; // 16px - Between related items
  static const double itemDetails = spacingSm; // 8px - Within items
  static const double tightSpacing = spacingXs; // 4px - Tight grouping

  /// Border radius standards
  static const double radiusSmall = 8.0; // For small interactive elements
  static const double radiusMedium = 12.0; // For cards and buttons (primary)
  static const double radiusLarge = 16.0; // For major containers
  static const double radiusXl = 20.0; // For special emphasis

  /// Shadow elevation system
  static const List<BoxShadow> shadowLevel1 = [
    BoxShadow(
      color: Color(0x1F000000), // 12% black
      offset: Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> shadowLevel2 = [
    BoxShadow(
      color: Color(0x24000000), // 14% black
      offset: Offset(0, 2),
      blurRadius: 6,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> shadowLevel3 = [
    BoxShadow(
      color: Color(0x29000000), // 16% black
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  /// Themed shadows for magical feel
  static List<BoxShadow> primaryGlow(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: 0.3),
      offset: const Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];

  /// Component-specific decoration builders
  static BoxDecoration roomInfoCardDecoration(Color surfaceColor) =>
      BoxDecoration(
        color: surfaceColor.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(radiusMedium),
        boxShadow: shadowLevel2,
      );

  static BoxDecoration settingsPanelDecoration(Color surfaceColor) =>
      BoxDecoration(
        color: surfaceColor.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(radiusMedium),
        boxShadow: shadowLevel1,
      );

  static BoxDecoration playerCardDecoration(
    Color surfaceColor,
    bool isCurrentUser,
    Color primaryColor,
  ) => BoxDecoration(
    color: surfaceColor.withValues(alpha: 0.8),
    borderRadius: BorderRadius.circular(radiusLarge),
    boxShadow: isCurrentUser ? primaryGlow(primaryColor) : shadowLevel1,
  );

  static BoxDecoration actionButtonDecoration(Color buttonColor) =>
      BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(radiusMedium),
        boxShadow: shadowLevel2,
      );
}
