import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:xwidgets_pack/look/presets/x_card_look.dart';
import 'package:xwidgets_pack/look/x_look.dart';

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
///
/// XCard(look: XLook.glass, child: Text('Frosted'));
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
  /// If not provided, it uses the active [look] preset or
  /// `Theme.of(context).canvasColor` for [XLook.standard].
  final Color? background;

  /// Color of the card shadow.
  ///
  /// Defaults to a semi-transparent grey for [XLook.standard].
  final Color? shadowColor;

  /// Border radius of the card.
  ///
  /// Defaults to the active [look] preset (`8.0` for [XLook.standard]).
  final double? radius;

  /// The blur and spread radius of the shadow.
  ///
  /// If null, defaults to `0.7` for the legacy standard shadow path.
  final double? blurRadius;

  /// Optional border width. Defaults from [look] when null.
  final double? borderWidth;

  /// Optional border color. Defaults from [look] when null.
  final Color? borderColor;

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

  /// Visual look preset. Defaults to [XLook.standard] (existing package look).
  final XLook look;

  /// Creates an [XCard] with customizable styling options.
  const XCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(10.0),
    this.radius,
    this.background,
    this.margin = const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
    this.blurRadius,
    this.shadowColor,
    this.borderWidth,
    this.borderColor,
    this.width,
    this.height,
    this.alignment,
    this.onTap,
    this.enableRipple = false,
    this.look = XLook.standard,
  });

  @override
  Widget build(BuildContext context) {
    final lookPreset = XCardLook.resolve(look);
    final effectiveRadius = radius ?? lookPreset.radius;
    final effectiveBackground =
        background ?? lookPreset.background ?? Theme.of(context).canvasColor;
    final effectiveBorderWidth = borderWidth ?? lookPreset.borderWidth;
    final effectiveBorderColor = borderColor ?? lookPreset.borderColor;
    final border = effectiveBorderWidth > 0 && effectiveBorderColor != null
        ? Border.all(color: effectiveBorderColor, width: effectiveBorderWidth)
        : null;

    final List<BoxShadow> boxShadows;
    if (lookPreset.useLegacyShadow) {
      final blur = blurRadius ?? lookPreset.blurRadius ?? .7;
      boxShadows = [
        BoxShadow(
          color: shadowColor ?? Colors.grey.withAlpha(100),
          spreadRadius: blur,
          blurRadius: blur,
          offset: Offset(0, blur),
        ),
      ];
    } else {
      boxShadows = lookPreset.shadows;
    }

    Widget content = Container(
      width: width ?? double.infinity,
      height: height,
      margin: margin,
      padding: padding,
      alignment: alignment,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(effectiveRadius),
        color: effectiveBackground,
        border: border,
        boxShadow: boxShadows,
      ),
      child: child,
    );

    if (lookPreset.blurSigma > 0) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(effectiveRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: lookPreset.blurSigma,
            sigmaY: lookPreset.blurSigma,
          ),
          child: content,
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      splashColor: enableRipple == true
          ? Theme.of(context).primaryColor.withAlpha(50)
          : Colors.transparent,
      highlightColor: enableRipple == true
          ? Theme.of(context).highlightColor
          : Colors.transparent,
      child: Material(color: Colors.transparent, child: content),
    );
  }
}
