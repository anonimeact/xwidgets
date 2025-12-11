import 'package:flutter/material.dart';
import 'package:xwidgets_pack/widgets/shimmer/x_shimmer.dart';
/// A rectangular placeholder widget that shows a shimmer animation.
///
/// [XSkeleton] is typically used as a loading placeholder for text lines,
/// avatars, cards, or any widget while content is loading. It wraps its
/// child with [XShimmer] to create the animated shimmer effect.
///
/// Example usage:
/// ```dart
/// XSkeleton(width: 200, height: 16) // text line
/// XSkeleton(width: 80, height: 80, borderRadius: BorderRadius.circular(40)) // avatar
/// ```

class XSkeleton extends StatelessWidget {
  /// The height of the skeleton placeholder. Default is 16.
  final double height;
  /// The width of the skeleton placeholder. Default is double.infinity.
  final double width;
  /// The border radius of the placeholder rectangle.
  final BorderRadius borderRadius;

  const XSkeleton({
    super.key,
    this.height = 16,
    this.width = double.infinity,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  @override
  Widget build(BuildContext context) {
    return XShimmer(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}
