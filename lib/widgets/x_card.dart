import 'package:flutter/material.dart';

/// A customizable card container widget with padding, margin,
/// background color, rounded corners, and shadow.
///
/// The [XCard] is a lightweight alternative to Flutter's `Card` widget,
/// offering more control over padding, margin, shadow intensity, and radius,
/// while avoiding unnecessary Material elevation layers.
///
/// Common use-cases:
/// - Wrapping content inside a styled card
/// - Creating reusable container blocks
/// - Building list item containers with subtle shadows
///
/// Example:
/// ```dart
/// XCard(
///   padding: EdgeInsets.all(16),
///   radius: 12,
///   background: Colors.white,
///   child: Text("Hello Card"),
/// );
/// ```
class XCard extends StatelessWidget {
  /// The widget inside the card.
  final Widget child;

  /// Padding applied inside the card around its [child].
  ///
  /// Defaults to `EdgeInsets.all(10)`.
  final EdgeInsetsGeometry padding;

  /// External margin around the card.
  ///
  /// Defaults to `EdgeInsets.symmetric(horizontal: 3, vertical: 2)`.
  final EdgeInsetsGeometry margin;

  /// Background color of the card container.
  ///
  /// If not provided, it uses `Theme.of(context).canvasColor`.
  final Color? background;

  /// Color of the card shadow.
  ///
  /// Defaults to a semi-transparent grey.
  final Color? shadowColor;

  /// Border radius of the card.
  ///
  /// Defaults to `8.0`.
  final double radius;

  /// The blur and spread radius of the shadow.
  ///
  /// If null, defaults to `0.7`.
  final double? blurRadius;

  /// Width of the card.
  final double? width;

  /// Height of the card.
  final double? height;

  /// Alignment of the child within the card.
  final AlignmentGeometry? alignment;

  /// Callback when the card is tapped.
  final VoidCallback? onTap;

  /// Whether to enable ripple effect on tap.
  /// Defaults to `false`.
  final bool enableRipple;

  /// Creates an [XCard] with customizable styling options.
  const XCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(10.0),
    this.radius = 8.0,
    this.background,
    this.margin = const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
    this.blurRadius,
    this.shadowColor,
    this.width,
    this.height,
    this.alignment,
    this.onTap,
    this.enableRipple = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: enableRipple == true
          ? Theme.of(context).primaryColor.withAlpha(50)
          : Colors.transparent,
      highlightColor: enableRipple == true
          ? Theme.of(context).highlightColor
          : Colors.transparent,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: width ?? double.infinity,
          height: height,
          margin: margin,
          padding: padding,
          alignment: alignment,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color: background ?? Theme.of(context).canvasColor,
            boxShadow: [
              BoxShadow(
                color: shadowColor ?? Colors.grey.withAlpha(100),
                spreadRadius: blurRadius ?? .7,
                blurRadius: blurRadius ?? .7,
                offset: Offset(0, blurRadius ?? .7),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
