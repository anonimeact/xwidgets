import 'package:flutter/material.dart';
import 'package:xwidgets_pack/look/x_look.dart';
import 'package:xwidgets_pack/look/x_look_tokens.dart';
import 'package:xwidgets_pack/models/x_button_style.dart';

/// Resolved button defaults for a given [XLook].
@immutable
class XButtonLook {
  const XButtonLook({required this.radius, required this.style});

  final double radius;
  final XButtonStyle style;

  static XButtonLook resolve(XLook look) {
    final tokens = XLookTokens.control(look);
    return switch (look) {
      XLook.standard => const XButtonLook(radius: 5, style: XButtonStyle()),
      XLook.material => XButtonLook(
        radius: tokens.radius,
        style: XButtonStyle(
          background: const Color(0xFF6750A4),
          foreground: Colors.white,
          loadingColor: const Color(0xFF6750A4),
          elevation: tokens.elevation,
          borderWidth: 0,
          paddingHorizontal: 16,
          paddingVertical: 10,
        ),
      ),
      XLook.ios => XButtonLook(
        radius: tokens.radius,
        style: XButtonStyle(
          background: tokens.background ?? const Color(0xFF007AFF),
          foreground: tokens.foreground ?? Colors.white,
          loadingColor: tokens.background ?? const Color(0xFF007AFF),
          elevation: 0,
          borderWidth: 0,
          paddingHorizontal: 16,
          paddingVertical: 10,
        ),
      ),
      XLook.glass => XButtonLook(
        radius: tokens.radius,
        style: XButtonStyle(
          background: tokens.background ?? const Color(0x66FFFFFF),
          foreground: tokens.foreground ?? const Color(0xFF1C1C1E),
          borderColor: tokens.borderColor ?? const Color(0x66FFFFFF),
          loadingColor: tokens.foreground ?? const Color(0xFF1C1C1E),
          elevation: 0,
          borderWidth: tokens.borderWidth,
          paddingHorizontal: 16,
          paddingVertical: 10,
        ),
      ),
      XLook.neumorphism => XButtonLook(
        radius: tokens.radius,
        style: XButtonStyle(
          background: tokens.background ?? const Color(0xFFE0E5EC),
          foreground: tokens.foreground ?? const Color(0xFF2D3436),
          borderColor: tokens.background ?? const Color(0xFFE0E5EC),
          loadingColor: tokens.foreground ?? const Color(0xFF2D3436),
          elevation: 0,
          borderWidth: 0,
          paddingHorizontal: 16,
          paddingVertical: 10,
        ),
      ),
      XLook.retro => XButtonLook(
        radius: tokens.radius,
        style: XButtonStyle(
          background: tokens.background ?? const Color(0xFFD9845B),
          foreground: tokens.foreground ?? const Color(0xFF2B2118),
          borderColor: tokens.borderColor ?? const Color(0xFF5C4B37),
          loadingColor: tokens.foreground ?? const Color(0xFF2B2118),
          elevation: 0,
          borderWidth: tokens.borderWidth,
          paddingHorizontal: 14,
          paddingVertical: 8,
        ),
      ),
      XLook.neoBrutalism => XButtonLook(
        radius: tokens.radius,
        style: XButtonStyle(
          background: tokens.background ?? const Color(0xFF7DF9FF),
          foreground: tokens.foreground ?? Colors.black,
          borderColor: tokens.borderColor ?? Colors.black,
          loadingColor: Colors.black,
          elevation: 0,
          borderWidth: tokens.borderWidth,
          paddingHorizontal: 14,
          paddingVertical: 8,
        ),
      ),
    };
  }
}
