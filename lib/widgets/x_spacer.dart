import 'package:flutter/material.dart';

/// A simple spacer widget that provides vertical or horizontal spacing.
///
/// [XSpacer] works similarly to Flutter's `SizedBox`, but is more semantic
/// for scenarios where you explicitly want to add spacing in layout structures.
///
/// Behavior:
/// - If [height] is provided, it creates vertical space.
/// - If [height] is null and [width] is provided, it creates horizontal space.
///
/// Example:
/// ```dart
/// Column(
///   children: [
///     Text("Above"),
///     const XSpacer(height: 16), // vertical space
///     Text("Below"),
///   ],
/// );
///
/// Row(
///   children: [
///     Icon(Icons.star),
///     const XSpacer(width: 8), // horizontal space
///     Text("Star"),
///   ],
/// );
/// ```
class XSpacer extends StatelessWidget {
  /// The vertical spacing amount.
  ///
  /// If provided, [XSpacer] renders a `SizedBox` with this height.
  final double? height;

  /// The horizontal spacing amount.
  ///
  /// Used only when [height] is null.
  final double? width;

  /// Creates a simple spacing widget.
  ///
  /// Provide either [height] for vertical space or [width] for horizontal space.
  const XSpacer({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return height != null ? SizedBox(height: height) : SizedBox(width: width);
  }
}

class XHeight extends StatelessWidget {
  const XHeight(this.height, {super.key});

  final double height;

  @override
  Widget build(BuildContext context) {
    return XSpacer(height: height);
  }
}

class XWidth extends StatelessWidget {
  const XWidth(this.width, {super.key});

  final double width;

  @override
  Widget build(BuildContext context) {
    return XSpacer(width: width);
  }
}
