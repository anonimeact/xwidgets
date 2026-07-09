import 'package:flutter/material.dart';
import 'package:xwidgets_pack/look/x_look.dart';
import 'package:xwidgets_pack/look/x_look_tokens.dart';

/// Resolved dashed-divider defaults for a given [XLook].
@immutable
class XDividerLook {
  const XDividerLook({
    required this.dashWidth,
    required this.dashGap,
    required this.strokeWidth,
    this.color,
  });

  final double dashWidth;
  final double dashGap;
  final double strokeWidth;
  final Color? color;

  static XDividerLook resolve(XLook look) {
    final tokens = XLookTokens.divider(look);
    return XDividerLook(
      dashWidth: tokens.dashWidth,
      dashGap: tokens.dashGap,
      strokeWidth: tokens.strokeWidth,
      color: tokens.borderColor,
    );
  }
}
