import 'package:flutter/material.dart';
import 'package:xwidgets_pack/look/x_look.dart';
import 'package:xwidgets_pack/look/x_look_tokens.dart';

/// Resolved snackbar chrome defaults for a given [XLook].
@immutable
class XSnackbarLook {
  const XSnackbarLook({
    required this.radius,
    this.elevation = 6,
    this.borderWidth = 0,
    this.borderColor,
    this.blurSigma = 0,
    this.forceColor,
  });

  final double radius;
  final double elevation;
  final double borderWidth;
  final Color? borderColor;
  final double blurSigma;

  /// Optional color override applied on top of snackbar type color.
  final Color? forceColor;

  static XSnackbarLook resolve(XLook look) {
    final tokens = XLookTokens.surface(look);
    return switch (look) {
      XLook.standard => const XSnackbarLook(radius: 8, elevation: 6),
      XLook.material => XSnackbarLook(radius: tokens.radius, elevation: 2),
      XLook.ios => const XSnackbarLook(
        radius: 14,
        elevation: 0,
        borderWidth: 0.5,
        borderColor: Color(0x33000000),
      ),
      XLook.glass => XSnackbarLook(
        radius: tokens.radius,
        elevation: 0,
        borderWidth: 1,
        borderColor: tokens.borderColor,
        blurSigma: tokens.blurSigma,
        forceColor: tokens.background,
      ),
      XLook.neumorphism => XSnackbarLook(
        radius: tokens.radius,
        elevation: 0,
        forceColor: tokens.background,
      ),
      XLook.retro => XSnackbarLook(
        radius: tokens.radius,
        elevation: 0,
        borderWidth: tokens.borderWidth,
        borderColor: tokens.borderColor,
      ),
      XLook.neoBrutalism => XSnackbarLook(
        radius: 0,
        elevation: 0,
        borderWidth: tokens.borderWidth,
        borderColor: tokens.borderColor,
      ),
    };
  }
}
