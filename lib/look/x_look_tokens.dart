import 'package:flutter/material.dart';

import 'package:xwidgets_pack/look/x_look.dart';

/// Shared visual tokens resolved from [XLook].
///
/// Kept small on purpose — widget presets map these into existing style props.
@immutable
class XLookTokens {
  const XLookTokens({
    required this.radius,
    this.elevation = 0,
    this.borderWidth = 0,
    this.borderColor,
    this.background,
    this.foreground,
    this.blurSigma = 0,
    this.shadows = const <BoxShadow>[],
    this.dashWidth = 6,
    this.dashGap = 4,
    this.strokeWidth = 1,
  });

  final double radius;
  final double elevation;
  final double borderWidth;
  final Color? borderColor;
  final Color? background;
  final Color? foreground;
  final double blurSigma;
  final List<BoxShadow> shadows;
  final double dashWidth;
  final double dashGap;
  final double strokeWidth;

  /// Generic surface tokens used by cards, sheets, dialogs, and snackbars.
  static XLookTokens surface(XLook look) => switch (look) {
    XLook.standard => const XLookTokens(radius: 8, elevation: 0.7),
    XLook.material => const XLookTokens(
      radius: 12,
      elevation: 1,
      background: Color(0xFFFFFBFE),
    ),
    XLook.ios => const XLookTokens(
      radius: 14,
      elevation: 0,
      borderWidth: 0.5,
      borderColor: Color(0x33000000),
      background: Color(0xFFF2F2F7),
    ),
    XLook.glass => const XLookTokens(
      radius: 16,
      elevation: 0,
      borderWidth: 1,
      borderColor: Color(0x66FFFFFF),
      background: Color(0x66FFFFFF),
      blurSigma: 12,
    ),
    XLook.neumorphism => XLookTokens(
      radius: 16,
      elevation: 0,
      background: const Color(0xFFE0E5EC),
      shadows: const [
        BoxShadow(
          color: Color(0xFFFFFFFF),
          offset: Offset(-4, -4),
          blurRadius: 8,
        ),
        BoxShadow(
          color: Color(0xFFA3B1C6),
          offset: Offset(4, 4),
          blurRadius: 8,
        ),
      ],
    ),
    XLook.retro => const XLookTokens(
      radius: 4,
      elevation: 0,
      borderWidth: 2,
      borderColor: Color(0xFF5C4B37),
      background: Color(0xFFF3E5C4),
      shadows: [
        BoxShadow(
          color: Color(0x665C4B37),
          offset: Offset(2, 2),
          blurRadius: 0,
        ),
      ],
    ),
    XLook.neoBrutalism => const XLookTokens(
      radius: 0,
      elevation: 0,
      borderWidth: 3,
      borderColor: Colors.black,
      background: Color(0xFFFFF200),
      shadows: [
        BoxShadow(color: Colors.black, offset: Offset(4, 4), blurRadius: 0),
      ],
    ),
  };

  /// Tokens tuned for compact controls (buttons, text fields).
  static XLookTokens control(XLook look) => switch (look) {
    XLook.standard => const XLookTokens(radius: 5, elevation: 1),
    XLook.material => const XLookTokens(radius: 20, elevation: 0),
    XLook.ios => const XLookTokens(
      radius: 12,
      elevation: 0,
      borderWidth: 0,
      background: Color(0xFF007AFF),
      foreground: Colors.white,
    ),
    XLook.glass => const XLookTokens(
      radius: 14,
      elevation: 0,
      borderWidth: 1,
      borderColor: Color(0x66FFFFFF),
      background: Color(0x66FFFFFF),
      foreground: Color(0xFF1C1C1E),
      blurSigma: 10,
    ),
    XLook.neumorphism => XLookTokens(
      radius: 14,
      elevation: 0,
      background: const Color(0xFFE0E5EC),
      foreground: const Color(0xFF2D3436),
      borderColor: const Color(0xFFE0E5EC),
      shadows: const [
        BoxShadow(
          color: Color(0xFFFFFFFF),
          offset: Offset(-3, -3),
          blurRadius: 6,
        ),
        BoxShadow(
          color: Color(0xFFA3B1C6),
          offset: Offset(3, 3),
          blurRadius: 6,
        ),
      ],
    ),
    XLook.retro => const XLookTokens(
      radius: 3,
      elevation: 0,
      borderWidth: 2,
      borderColor: Color(0xFF5C4B37),
      background: Color(0xFFD9845B),
      foreground: Color(0xFF2B2118),
    ),
    XLook.neoBrutalism => const XLookTokens(
      radius: 0,
      elevation: 0,
      borderWidth: 3,
      borderColor: Colors.black,
      background: Color(0xFF7DF9FF),
      foreground: Colors.black,
      shadows: [
        BoxShadow(color: Colors.black, offset: Offset(3, 3), blurRadius: 0),
      ],
    ),
  };

  /// Tokens for dashed dividers.
  static XLookTokens divider(XLook look) => switch (look) {
    XLook.standard => const XLookTokens(
      radius: 0,
      dashWidth: 6,
      dashGap: 4,
      strokeWidth: 1,
    ),
    XLook.material => const XLookTokens(
      radius: 0,
      dashWidth: 4,
      dashGap: 4,
      strokeWidth: 1,
      borderColor: Color(0xFFCAC4D0),
    ),
    XLook.ios => const XLookTokens(
      radius: 0,
      dashWidth: 2,
      dashGap: 4,
      strokeWidth: 0.5,
      borderColor: Color(0xFFC7C7CC),
    ),
    XLook.glass => const XLookTokens(
      radius: 0,
      dashWidth: 8,
      dashGap: 6,
      strokeWidth: 1,
      borderColor: Color(0x66FFFFFF),
    ),
    XLook.neumorphism => const XLookTokens(
      radius: 0,
      dashWidth: 6,
      dashGap: 6,
      strokeWidth: 1.5,
      borderColor: Color(0xFFA3B1C6),
    ),
    XLook.retro => const XLookTokens(
      radius: 0,
      dashWidth: 10,
      dashGap: 4,
      strokeWidth: 1.5,
      borderColor: Color(0xFF5C4B37),
    ),
    XLook.neoBrutalism => const XLookTokens(
      radius: 0,
      dashWidth: 12,
      dashGap: 6,
      strokeWidth: 3,
      borderColor: Colors.black,
    ),
  };
}
