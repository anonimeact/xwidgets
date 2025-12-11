import 'package:flutter/material.dart';

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
  });

  final String text;
  final Widget? icon;
  final bool isExpand;
  final TextStyle? style;
  final bool? isUseUnderline;
  final CrossAxisAlignment? iconVerticalAlignment;
  final Function()? onTap;
  final double? maxWidth;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: isExpand ? .max : .min,
        crossAxisAlignment: iconVerticalAlignment ?? .center,
        children: [
          icon != null
              ? Row(mainAxisSize: .min, children: [icon!, SizedBox(width: 5)])
              : SizedBox.shrink(),
          isExpand
              ? Flexible(child: _buildTextContainer())
              : _buildTextContainer(),
        ],
      ),
    );
  }

  Widget _buildTextContainer() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
      child: Container(
        decoration: isUseUnderline == true
            ? BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: style?.color ?? Colors.black,
                    width: 1.2,
                  ),
                ),
              )
            : null,
        padding: const EdgeInsets.only(bottom: 1),
        child: Text(
          text,
          softWrap: true,
          overflow: overflow,
          style: style?.copyWith(decoration: TextDecoration.none),
        ),
      ),
    );
  }
}
