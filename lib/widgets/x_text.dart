import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:xwidgets_pack/look/presets/x_text_look.dart';
import 'package:xwidgets_pack/look/x_look.dart';

/// A customizable text widget that supports an optional leading icon,
/// underline decoration, tap handling, width limitation, and overflow control.
///
/// Features:
/// - [text]: The main string displayed.
/// - [icon]: Optional widget shown before the text (e.g., Icon, Svg, etc.).
/// - [style]: Custom text styling. Any existing `decoration` will be removed
///   to avoid conflict with the manual underline.
/// - [isUseUnderline]: If true, draws a bottom border manually to simulate
///   an underline without affecting text metrics.
/// - [iconVerticalAlignment]: Controls vertical alignment inside the Row.
/// - [onTap]: Tap callback using GestureDetector.
/// - [maxWidth]: Constrains the text to a maximum width.
/// - [overflow]: Controls the text overflow behavior (e.g., ellipsis).
/// - [look]: Optional visual look preset (default [XLook.standard]).
///
/// Usage:
/// ```dart
/// XText(
///   "Hello World",
///   icon: Icon(Icons.info),
///   style: TextStyle(fontSize: 14),
///   isUseUnderline: true,
///   onTap: () {},
///   maxWidth: 150,
///   overflow: TextOverflow.ellipsis,
/// )
///
/// XText('Hello', look: XLook.ios);
/// ```
class XText extends StatelessWidget {
  const XText(
    this.text, {
    super.key,
    this.icon,
    this.isExpand = false,
    this.style,
    this.iconVerticalAlignment,
    this.isUseUnderline = false,
    this.onTap,
    this.maxWidth,
    this.overflow,
    this.textAlign = .start,
    this.iconSpacer = 8,
    this.strutStyle,
    this.textDirection,
    this.locale,
    this.softWrap = true,
    this.maxLines,
    this.textScaler,
    this.semanticsLabel,
    this.semanticsIdentifier,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.onDoubleTap,
    this.onLongPress,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.behavior,
    this.excludeFromSemantics = false,
    this.dragStartBehavior = DragStartBehavior.start,
    this.look = XLook.standard,
  });

  final String text;
  final Widget? icon;
  final bool isExpand;
  final TextStyle? style;
  final TextAlign textAlign;
  final bool? isUseUnderline;
  final double? iconSpacer;
  final CrossAxisAlignment? iconVerticalAlignment;
  final Function()? onTap;
  final double? maxWidth;
  final TextOverflow? overflow;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final int? maxLines;
  final TextScaler? textScaler;
  final String? semanticsLabel;
  final String? semanticsIdentifier;
  final TextWidthBasis? textWidthBasis;
  final ui.TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;
  final GestureTapCallback? onDoubleTap;
  final GestureLongPressCallback? onLongPress;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCancelCallback? onTapCancel;
  final HitTestBehavior? behavior;
  final bool excludeFromSemantics;
  final DragStartBehavior dragStartBehavior;

  /// Visual look preset. Defaults to [XLook.standard] (existing package look).
  final XLook look;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      behavior: behavior,
      excludeFromSemantics: excludeFromSemantics,
      dragStartBehavior: dragStartBehavior,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final hasBoundedWidth = constraints.hasBoundedWidth;
          final textChild = hasBoundedWidth || isExpand
              ? Flexible(
                  fit: isExpand ? FlexFit.tight : FlexFit.loose,
                  child: _buildTextContainer(),
                )
              : _buildTextContainer();

          return Row(
            mainAxisSize: isExpand ? .max : .min,
            crossAxisAlignment: iconVerticalAlignment ?? .center,
            children: [
              icon != null
                  ? Row(
                      mainAxisSize: .min,
                      children: [
                        icon!,
                        SizedBox(width: iconSpacer),
                      ],
                    )
                  : SizedBox.shrink(),
              textChild,
            ],
          );
        },
      ),
    );
  }

  Widget _buildTextContainer() {
    final lookPreset = XTextLook.resolve(look);
    final mergedStyle = style ?? lookPreset.style;
    final textStyle = isUseUnderline == true
        ? mergedStyle?.copyWith(decoration: TextDecoration.none)
        : mergedStyle;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
      child: Container(
        decoration: isUseUnderline == true
            ? BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color:
                        lookPreset.underlineColor ??
                        mergedStyle?.color ??
                        Colors.black,
                    width: lookPreset.underlineWidth,
                  ),
                ),
              )
            : null,
        padding: const EdgeInsets.only(bottom: 1),
        child: Text(
          text,
          softWrap: softWrap,
          overflow: overflow,
          style: textStyle,
          textAlign: textAlign,
          strutStyle: strutStyle,
          textDirection: textDirection,
          locale: locale,
          textScaler: textScaler,
          maxLines: maxLines,
          semanticsLabel: semanticsLabel,
          semanticsIdentifier: semanticsIdentifier,
          textWidthBasis: textWidthBasis,
          textHeightBehavior: textHeightBehavior,
          selectionColor: selectionColor,
        ),
      ),
    );
  }
}
