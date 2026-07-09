import 'package:flutter/material.dart';
import 'package:xwidgets_pack/look/x_look.dart';
import 'package:xwidgets_pack/look/x_look_tokens.dart';

/// Resolved card surface defaults for a given [XLook].
@immutable
class XCardLook {
  const XCardLook({
    required this.radius,
    this.background,
    this.shadowColor,
    this.blurRadius,
    this.borderWidth = 0,
    this.borderColor,
    this.shadows = const <BoxShadow>[],
    this.blurSigma = 0,
    this.useLegacyShadow = true,
  });

  final double radius;
  final Color? background;
  final Color? shadowColor;
  final double? blurRadius;
  final double borderWidth;
  final Color? borderColor;
  final List<BoxShadow> shadows;
  final double blurSigma;

  /// When true, [XCard] keeps the original single-shadow path.
  final bool useLegacyShadow;

  static XCardLook resolve(XLook look) {
    final tokens = XLookTokens.surface(look);
    return switch (look) {
      XLook.standard => const XCardLook(radius: 8, useLegacyShadow: true),
      XLook.material => XCardLook(
        radius: tokens.radius,
        background: tokens.background,
        blurRadius: 2,
        useLegacyShadow: true,
      ),
      XLook.ios => XCardLook(
        radius: tokens.radius,
        background: tokens.background,
        borderWidth: tokens.borderWidth,
        borderColor: tokens.borderColor,
        useLegacyShadow: false,
        shadows: const [],
      ),
      XLook.glass => XCardLook(
        radius: tokens.radius,
        background: tokens.background,
        borderWidth: tokens.borderWidth,
        borderColor: tokens.borderColor,
        blurSigma: tokens.blurSigma,
        useLegacyShadow: false,
        shadows: const [],
      ),
      XLook.neumorphism => XCardLook(
        radius: tokens.radius,
        background: tokens.background,
        useLegacyShadow: false,
        shadows: tokens.shadows,
      ),
      XLook.retro => XCardLook(
        radius: tokens.radius,
        background: tokens.background,
        borderWidth: tokens.borderWidth,
        borderColor: tokens.borderColor,
        useLegacyShadow: false,
        shadows: tokens.shadows,
      ),
      XLook.neoBrutalism => XCardLook(
        radius: tokens.radius,
        background: tokens.background,
        borderWidth: tokens.borderWidth,
        borderColor: tokens.borderColor,
        useLegacyShadow: false,
        shadows: tokens.shadows,
      ),
    };
  }
}
