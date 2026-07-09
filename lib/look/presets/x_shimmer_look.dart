import 'package:flutter/material.dart';
import 'package:xwidgets_pack/look/x_look.dart';

/// Resolved shimmer defaults for a given [XLook].
@immutable
class XShimmerLook {
  const XShimmerLook({
    required this.baseColor,
    required this.highlightColor,
    required this.borderRadius,
    this.fillColor,
  });

  final Color baseColor;
  final Color highlightColor;
  final BorderRadius borderRadius;
  final Color? fillColor;

  static XShimmerLook resolve(XLook look) => switch (look) {
    XLook.standard => const XShimmerLook(
      baseColor: Color(0xFFE0E0E0),
      highlightColor: Color(0xFFF5F5F5),
      borderRadius: BorderRadius.all(Radius.circular(8)),
      fillColor: Color(0xFFE0E0E0),
    ),
    XLook.material => const XShimmerLook(
      baseColor: Color(0xFFE7E0EC),
      highlightColor: Color(0xFFF7F2FA),
      borderRadius: BorderRadius.all(Radius.circular(12)),
      fillColor: Color(0xFFE7E0EC),
    ),
    XLook.ios => const XShimmerLook(
      baseColor: Color(0xFFE5E5EA),
      highlightColor: Color(0xFFF2F2F7),
      borderRadius: BorderRadius.all(Radius.circular(10)),
      fillColor: Color(0xFFE5E5EA),
    ),
    XLook.glass => const XShimmerLook(
      baseColor: Color(0x66FFFFFF),
      highlightColor: Color(0xAAFFFFFF),
      borderRadius: BorderRadius.all(Radius.circular(16)),
      fillColor: Color(0x33FFFFFF),
    ),
    XLook.neumorphism => const XShimmerLook(
      baseColor: Color(0xFFD1D9E6),
      highlightColor: Color(0xFFFFFFFF),
      borderRadius: BorderRadius.all(Radius.circular(16)),
      fillColor: Color(0xFFE0E5EC),
    ),
    XLook.retro => const XShimmerLook(
      baseColor: Color(0xFFD8C3A5),
      highlightColor: Color(0xFFF3E5C4),
      borderRadius: BorderRadius.all(Radius.circular(4)),
      fillColor: Color(0xFFE8D5B7),
    ),
    XLook.neoBrutalism => const XShimmerLook(
      baseColor: Color(0xFFCCCCCC),
      highlightColor: Color(0xFFFFFFFF),
      borderRadius: BorderRadius.zero,
      fillColor: Color(0xFFE0E0E0),
    ),
  };
}
