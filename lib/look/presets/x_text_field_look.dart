import 'package:flutter/material.dart';
import 'package:xwidgets_pack/look/x_look.dart';
import 'package:xwidgets_pack/look/x_look_tokens.dart';
import 'package:xwidgets_pack/utils/x_textfield_style.dart';

/// Resolved text-field defaults for a given [XLook].
@immutable
class XTextFieldLook {
  const XTextFieldLook({required this.style});

  final XTextFieldStyle style;

  static XTextFieldLook resolve(XLook look) {
    final tokens = XLookTokens.control(look);
    return switch (look) {
      XLook.standard => const XTextFieldLook(style: XTextFieldStyle()),
      XLook.material => XTextFieldLook(
        style: XTextFieldStyle(
          outlineColor: const Color(0xFF79747E),
          focusedOutlineColor: const Color(0xFF6750A4),
          errorOutlineColor: const Color(0xFFB3261E),
          borderRadius: tokens.radius,
          outlineWidth: 1,
          focusedOutlineWidth: 2,
          errorOutlineWidth: 2,
        ),
      ),
      XLook.ios => XTextFieldLook(
        style: XTextFieldStyle(
          outlineColor: const Color(0xFFC7C7CC),
          focusedOutlineColor: const Color(0xFF007AFF),
          errorOutlineColor: const Color(0xFFFF3B30),
          borderRadius: 10,
          outlineWidth: 0.5,
          focusedOutlineWidth: 1,
          errorOutlineWidth: 1,
        ),
      ),
      XLook.glass => XTextFieldLook(
        style: XTextFieldStyle(
          outlineColor: const Color(0x66FFFFFF),
          focusedOutlineColor: const Color(0xAAFFFFFF),
          errorOutlineColor: const Color(0xFFFF8A80),
          borderRadius: tokens.radius,
          outlineWidth: 1,
          focusedOutlineWidth: 1.5,
          errorOutlineWidth: 1.5,
        ),
      ),
      XLook.neumorphism => XTextFieldLook(
        style: XTextFieldStyle(
          outlineColor: const Color(0xFFA3B1C6),
          focusedOutlineColor: const Color(0xFF7F8FA6),
          errorOutlineColor: const Color(0xFFE57373),
          borderRadius: tokens.radius,
          outlineWidth: 2,
          focusedOutlineWidth: 2.5,
          errorOutlineWidth: 2,
          fillColor: tokens.background ?? const Color(0xFFE0E5EC),
          insetShadowColor: const Color(0xFFA3B1C6),
          insetHighlightColor: const Color(0xFFFFFFFF),
        ),
      ),
      XLook.retro => XTextFieldLook(
        style: XTextFieldStyle(
          outlineColor: const Color(0xFF5C4B37),
          focusedOutlineColor: const Color(0xFFD9845B),
          errorOutlineColor: const Color(0xFFB33A3A),
          borderRadius: 3,
          outlineWidth: 2,
          focusedOutlineWidth: 2,
          errorOutlineWidth: 2,
        ),
      ),
      XLook.neoBrutalism => XTextFieldLook(
        style: XTextFieldStyle(
          outlineColor: Colors.black,
          focusedOutlineColor: Colors.black,
          errorOutlineColor: const Color(0xFFFF1744),
          borderRadius: 0,
          outlineWidth: 3,
          focusedOutlineWidth: 3,
          errorOutlineWidth: 3,
        ),
      ),
    };
  }
}
