import 'package:flutter/material.dart';

/// A style configuration class used to customize the appearance
class XTextFieldStyle {
  /// Outline color when the field is in its default state.
  final Color outlineColor;

  /// Outline color when the field is focused.
  final Color focusedOutlineColor;

  /// Outline color when the field has an error.
  final Color errorOutlineColor;

  /// Border width in default state.
  final double outlineWidth;

  /// Border width in focused state.
  final double focusedOutlineWidth;

  /// Border width in error state.
  final double errorOutlineWidth;

  /// Border radius for all outline shapes.
  final double borderRadius;

  /// Optional fill color for [InputDecoration.filled].
  final Color? fillColor;

  /// Dark edge for inset neumorphic fields (top/left).
  final Color? insetShadowColor;

  /// Light edge for inset neumorphic fields (bottom/right).
  final Color? insetHighlightColor;

  /// Whether this style uses an inset neumorphic border instead of outline.
  bool get usesInsetDecoration =>
      insetShadowColor != null && insetHighlightColor != null;

  /// Creates a new [XTextFieldStyle] instance.
  const XTextFieldStyle({
    this.outlineColor = Colors.grey,
    this.focusedOutlineColor = Colors.blue,
    this.errorOutlineColor = Colors.red,
    this.outlineWidth = 1.0,
    this.focusedOutlineWidth = 1.5,
    this.errorOutlineWidth = 1.5,
    this.borderRadius = 6.0,
    this.fillColor,
    this.insetShadowColor,
    this.insetHighlightColor,
  });

  /// Inset border used by neumorphic text fields.
  Border insetBorder({required bool focused, bool hasError = false}) {
    if (hasError) {
      return Border.all(color: errorOutlineColor, width: errorOutlineWidth);
    }

    final darkColor = focused ? focusedOutlineColor : insetShadowColor!;
    final lightColor = insetHighlightColor!;
    final width = focused ? focusedOutlineWidth : outlineWidth;

    return Border(
      top: BorderSide(color: darkColor, width: width),
      left: BorderSide(color: darkColor, width: width),
      bottom: BorderSide(color: lightColor, width: width),
      right: BorderSide(color: lightColor, width: width),
    );
  }

  /// Borderless input decoration for inset-wrapped fields.
  InputDecoration insetDecoration(InputDecoration base) => base.copyWith(
    filled: true,
    fillColor: Colors.transparent,
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    focusedErrorBorder: InputBorder.none,
  );

  /// Wraps a field with an inset neumorphic shell.
  Widget wrapInsetField({
    required Widget child,
    required bool focused,
    bool hasError = false,
  }) {
    final radius = BorderRadius.circular(borderRadius);

    if (hasError) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: radius,
          border: Border.all(
            color: errorOutlineColor,
            width: errorOutlineWidth,
          ),
        ),
        child: child,
      );
    }

    final frameWidth = focused ? focusedOutlineWidth : outlineWidth;
    final darkColor = focused ? focusedOutlineColor : insetShadowColor!;
    final lightColor = insetHighlightColor!;
    final innerRadius = BorderRadius.circular(
      (borderRadius - frameWidth).clamp(0, borderRadius),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [darkColor, lightColor],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(frameWidth),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: innerRadius,
          ),
          child: ClipRRect(borderRadius: innerRadius, child: child),
        ),
      ),
    );
  }

  /// Returns a default [OutlineInputBorder] using the provided width.
  OutlineInputBorder outline([double? width]) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(borderRadius),
    borderSide: BorderSide(color: outlineColor, width: width ?? outlineWidth),
  );

  /// Returns the focused [OutlineInputBorder].
  OutlineInputBorder focusedOutline() => OutlineInputBorder(
    borderRadius: BorderRadius.circular(borderRadius),
    borderSide: BorderSide(
      color: focusedOutlineColor,
      width: focusedOutlineWidth,
    ),
  );

  /// Returns the error [OutlineInputBorder].
  OutlineInputBorder errorOutline() => OutlineInputBorder(
    borderRadius: BorderRadius.circular(borderRadius),
    borderSide: BorderSide(color: errorOutlineColor, width: errorOutlineWidth),
  );
}
