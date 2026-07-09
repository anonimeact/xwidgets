import 'package:flutter/material.dart';
import 'package:xwidgets_pack/look/x_look.dart';
import 'package:xwidgets_pack/look/x_look_tokens.dart';

/// Resolved bottom-sheet chrome defaults for a given [XLook].
@immutable
class XBottomSheetLook {
  const XBottomSheetLook({
    this.backgroundColor,
    this.shape,
    this.showDragHandle = true,
  });

  final Color? backgroundColor;
  final ShapeBorder? shape;
  final bool showDragHandle;

  static XBottomSheetLook resolve(XLook look) {
    final tokens = XLookTokens.surface(look);
    ShapeBorder shapeFor(double topRadius, {double borderWidth = 0, Color? borderColor}) {
      return RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(topRadius)),
        side: borderWidth > 0 && borderColor != null
            ? BorderSide(color: borderColor, width: borderWidth)
            : BorderSide.none,
      );
    }

    return switch (look) {
      XLook.standard => const XBottomSheetLook(),
      XLook.material => XBottomSheetLook(
        backgroundColor: tokens.background,
        shape: shapeFor(tokens.radius),
      ),
      XLook.ios => XBottomSheetLook(
        backgroundColor: tokens.background,
        shape: shapeFor(16, borderWidth: 0.5, borderColor: tokens.borderColor),
      ),
      XLook.glass => XBottomSheetLook(
        backgroundColor: tokens.background,
        shape: shapeFor(tokens.radius, borderWidth: 1, borderColor: tokens.borderColor),
      ),
      XLook.neumorphism => XBottomSheetLook(
        backgroundColor: tokens.background,
        shape: shapeFor(tokens.radius),
      ),
      XLook.retro => XBottomSheetLook(
        backgroundColor: tokens.background,
        shape: shapeFor(
          tokens.radius,
          borderWidth: tokens.borderWidth,
          borderColor: tokens.borderColor,
        ),
      ),
      XLook.neoBrutalism => XBottomSheetLook(
        backgroundColor: tokens.background,
        shape: shapeFor(
          0,
          borderWidth: tokens.borderWidth,
          borderColor: tokens.borderColor,
        ),
        showDragHandle: false,
      ),
    };
  }
}
