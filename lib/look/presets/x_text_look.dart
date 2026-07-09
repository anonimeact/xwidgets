import 'package:flutter/material.dart';
import 'package:xwidgets_pack/look/x_look.dart';

/// Resolved text defaults for a given [XLook].
@immutable
class XTextLook {
  const XTextLook({this.style, this.underlineWidth = 1.2, this.underlineColor});

  final TextStyle? style;
  final double underlineWidth;
  final Color? underlineColor;

  static XTextLook resolve(XLook look) => switch (look) {
    XLook.standard => const XTextLook(),
    XLook.material => const XTextLook(
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: Color(0xFF1C1B1F),
      ),
      underlineWidth: 1,
    ),
    XLook.ios => const XTextLook(
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.4,
        color: Color(0xFF000000),
      ),
      underlineWidth: 1,
      underlineColor: Color(0xFF007AFF),
    ),
    XLook.glass => const XTextLook(
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFF1C1C1E),
      ),
      underlineWidth: 1,
      underlineColor: Color(0xAAFFFFFF),
    ),
    XLook.neumorphism => const XTextLook(
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFF2D3436),
      ),
      underlineWidth: 1.5,
      underlineColor: Color(0xFFA3B1C6),
    ),
    XLook.retro => const XTextLook(
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: Color(0xFF2B2118),
      ),
      underlineWidth: 2,
      underlineColor: Color(0xFF5C4B37),
    ),
    XLook.neoBrutalism => const XTextLook(
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.2,
        color: Colors.black,
      ),
      underlineWidth: 3,
      underlineColor: Colors.black,
    ),
  };
}
