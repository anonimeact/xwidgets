import 'package:flutter/material.dart';
import 'package:xwidgets_pack/look/x_look.dart';
import 'package:xwidgets_pack/look/x_look_tokens.dart';

/// Resolved dialog chrome defaults for a given [XLook].
@immutable
class XDialogLook {
  const XDialogLook({
    required this.radius,
    this.backgroundColor,
    this.elevation,
    this.borderWidth = 0,
    this.borderColor,
    this.shadows = const <BoxShadow>[],
  });

  final double radius;
  final Color? backgroundColor;
  final double? elevation;
  final double borderWidth;
  final Color? borderColor;
  final List<BoxShadow> shadows;

  ShapeBorder get shape {
    final side = borderWidth > 0 && borderColor != null
        ? BorderSide(color: borderColor!, width: borderWidth)
        : BorderSide.none;
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: side,
    );
  }

  static XDialogLook resolve(XLook look) {
    final tokens = XLookTokens.surface(look);
    return switch (look) {
      XLook.standard => const XDialogLook(radius: 4, elevation: 6),
      XLook.material => XDialogLook(
        radius: tokens.radius,
        backgroundColor: tokens.background,
        elevation: 3,
      ),
      XLook.ios => XDialogLook(
        radius: 14,
        backgroundColor: tokens.background,
        elevation: 0,
        borderWidth: tokens.borderWidth,
        borderColor: tokens.borderColor,
      ),
      XLook.glass => XDialogLook(
        radius: tokens.radius,
        backgroundColor: tokens.background,
        elevation: 0,
        borderWidth: tokens.borderWidth,
        borderColor: tokens.borderColor,
      ),
      XLook.neumorphism => XDialogLook(
        radius: tokens.radius,
        backgroundColor: tokens.background,
        elevation: 0,
        shadows: tokens.shadows,
      ),
      XLook.retro => XDialogLook(
        radius: tokens.radius,
        backgroundColor: tokens.background,
        elevation: 0,
        borderWidth: tokens.borderWidth,
        borderColor: tokens.borderColor,
        shadows: tokens.shadows,
      ),
      XLook.neoBrutalism => XDialogLook(
        radius: tokens.radius,
        backgroundColor: tokens.background,
        elevation: 0,
        borderWidth: tokens.borderWidth,
        borderColor: tokens.borderColor,
        shadows: tokens.shadows,
      ),
    };
  }
}
