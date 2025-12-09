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

  /// Creates a new [XTextFieldStyle] instance.
  const XTextFieldStyle({
    this.outlineColor = Colors.grey,
    this.focusedOutlineColor = Colors.blue,
    this.errorOutlineColor = Colors.red,
    this.outlineWidth = 1.0,
    this.focusedOutlineWidth = 1.5,
    this.errorOutlineWidth = 1.5,
    this.borderRadius = 6.0,
  });

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
