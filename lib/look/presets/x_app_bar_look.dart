import 'package:flutter/material.dart';
import 'package:xwidgets_pack/look/x_look.dart';

/// Resolved app-bar defaults for a given [XLook].
@immutable
class XAppBarLook {
  const XAppBarLook({
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.scrolledUnderElevation,
    this.surfaceTintColor,
    this.shape,
  });

  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final double? scrolledUnderElevation;
  final Color? surfaceTintColor;
  final ShapeBorder? shape;

  static XAppBarLook resolve(XLook look) => switch (look) {
    XLook.standard => const XAppBarLook(backgroundColor: Colors.lightBlue),
    XLook.material => const XAppBarLook(
      backgroundColor: Color(0xFF6750A4),
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 2,
      surfaceTintColor: Color(0xFF6750A4),
    ),
    XLook.ios => const XAppBarLook(
      backgroundColor: Color(0xFFF9F9F9),
      foregroundColor: Color(0xFF000000),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    XLook.glass => const XAppBarLook(
      backgroundColor: Color(0x99FFFFFF),
      foregroundColor: Color(0xFF1C1C1E),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    XLook.neumorphism => const XAppBarLook(
      backgroundColor: Color(0xFFE0E5EC),
      foregroundColor: Color(0xFF2D3436),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    XLook.retro => const XAppBarLook(
      backgroundColor: Color(0xFFD9845B),
      foregroundColor: Color(0xFF2B2118),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      shape: Border(bottom: BorderSide(color: Color(0xFF5C4B37), width: 2)),
    ),
    XLook.neoBrutalism => const XAppBarLook(
      backgroundColor: Color(0xFFFFF200),
      foregroundColor: Colors.black,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      shape: Border(bottom: BorderSide(color: Colors.black, width: 3)),
    ),
  };
}
