import 'package:flutter/material.dart';
import 'package:xwidgets_pack/look/presets/x_shimmer_look.dart';
import 'package:xwidgets_pack/look/x_look.dart';
import 'package:xwidgets_pack/widgets/shimmer/x_shimmer_effect.dart';

/// A rectangular placeholder widget that shows a shimmer animation.
///
/// [XShimmerChild] is typically used as a loading placeholder for text lines,
/// avatars, cards, or any widget while content is loading. It wraps its
/// child with [XShimmerEffect] to create the animated shimmer effect.
///
/// Example usage:
/// ```dart
/// XShimmerChild(width: 200, height: 16) // text line
/// XShimmerChild(
///   width: 80,
///   height: 80,
///   borderRadius: BorderRadius.circular(40),
/// ) // avatar
/// XShimmerChild(look: XLook.ios);
/// ```
class XShimmerChild extends StatelessWidget {
  /// The height of the skeleton placeholder. Default is 16.
  final double height;

  /// The width of the skeleton placeholder. Default is double.infinity.
  final double width;

  /// The border radius of the placeholder rectangle.
  ///
  /// Defaults to the active [look] preset.
  final BorderRadius? borderRadius;

  /// Visual look preset. Defaults to [XLook.standard] (existing package look).
  final XLook look;

  const XShimmerChild({
    super.key,
    this.height = 16,
    this.width = double.infinity,
    this.borderRadius,
    this.look = XLook.standard,
  });

  @override
  Widget build(BuildContext context) {
    final lookPreset = XShimmerLook.resolve(look);
    return XShimmerEffect(
      baseColor: lookPreset.baseColor,
      highlightColor: lookPreset.highlightColor,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: lookPreset.fillColor ?? Colors.grey.shade300,
          borderRadius: borderRadius ?? lookPreset.borderRadius,
        ),
      ),
    );
  }
}
