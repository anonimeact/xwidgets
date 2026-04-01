import 'package:flutter/material.dart';
import 'package:xwidgets_pack/models/x_button_style.dart';

/// A customizable button widget that supports icons, loading state,
/// custom text widget, rounded style, and various appearance configurations.
///
/// The [XButton] is designed to simplify button creation with flexible styling
/// using [XButtonStyle]. It supports prefix, center, and suffix icons,
/// loading indicator, disabled state, and forced tap functionality.
///
/// This widget is suitable for most general button use-cases in Flutter apps.
///
/// Example:
/// ```dart
/// XButton(
///   label: "Submit",
///   onPressed: () {},
///   style: XButtonStyle(background: Colors.blue),
/// );
/// ```
class XButton extends StatelessWidget {
  const XButton({
    super.key,
    required this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.label,
    this.radius = 5,
    this.style,
    this.elevatedButtonStyle,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior,
    this.statesController,
    this.textStyle,
    this.isLoading = false,
    this.isLoadingInside = false,
    this.isEnable = true,
    this.isForceTap = false,
    this.child,
    this.width,
    this.height,
    this.widthInfinity = false,
  });

  /// Called when the button is tapped.
  final Function onPressed;

  /// Called when the button is long-pressed.
  final VoidCallback? onLongPress;

  /// Called when a pointer enters or exits the button.
  final ValueChanged<bool>? onHover;

  /// Called when the button gains or loses focus.
  final ValueChanged<bool>? onFocusChange;

  /// Text label displayed on the button.
  final String? label;

  /// Border radius for the button shape.
  final double radius;

  /// Whether to show a loading indicator instead of the button.
  final bool isLoading;

  /// Whether to show loading indicator inside [ElevatedButton].
  final bool isLoadingInside;

  /// Controls whether the button is enabled.
  ///
  /// If false, the button uses a disabled background color and onPressed won't execute
  /// unless [isForceTap] is set to true.
  final bool isEnable;

  /// Force the onPressed function to run even when [isEnable] is false.
  final bool? isForceTap;

  /// Custom height of the button. Defaults to 48.
  final double? height;

  final double? width;

  final bool widthInfinity;

  /// Custom widget to replace the label text, useful for advanced text layouts.
  final Widget? child;

  /// Custom style configuration for the button.
  final XButtonStyle? style;

  /// Native [ButtonStyle] for [ElevatedButton].
  ///
  /// If provided, it will be merged on top of [XButton] default style.
  final ButtonStyle? elevatedButtonStyle;

  /// Optional focus node for [ElevatedButton].
  final FocusNode? focusNode;

  /// Whether this button should be focused initially.
  final bool autofocus;

  /// The clipping behavior of the button's content.
  final Clip? clipBehavior;

  /// Optional states controller for [ElevatedButton].
  final WidgetStatesController? statesController;

  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final buttonStyle = style ?? XButtonStyle();
    final buttonTextStyle =
        textStyle ??
        buttonStyle.textStyle ??
        TextStyle(
          fontSize: buttonStyle.textSize,
          color: buttonStyle.foreground,
        );
    final buttonContent = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Prefix Icon
        buttonStyle.prefixIcon != null
            ? Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: buttonStyle.prefixIcon!,
                ),
              )
            : const SizedBox.shrink(),

        // Center Content
        Row(
          mainAxisAlignment: .center,
          mainAxisSize: .min,
          children: [
            if (buttonStyle.centerIcon != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: buttonStyle.centerIcon!,
              ),

            if (label != null) Text(label!, style: buttonTextStyle),

            if (child != null) child!,
          ],
        ),

        // Suffix Icon
        buttonStyle.suffixIcon != null
            ? Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: buttonStyle.suffixIcon!,
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
    final mergedElevatedStyle = styleButtonRounded(
      radius: radius,
      background: isEnable
          ? buttonStyle.background
          : buttonStyle.disableBackground,
      foreground: buttonStyle.foreground,
      borderColor: buttonStyle.borderColor,
      isEnable: buttonStyle.isEnable,
      borderWidth: buttonStyle.borderWidth,
      elevation: buttonStyle.elevation,
      paddingHorizontal: buttonStyle.paddingHorizontal,
      paddingVertical: buttonStyle.paddingVertical,
    ).merge(elevatedButtonStyle);

    return SizedBox(
      height: height ?? 48,
      width: widthInfinity ? double.infinity : width,
      child:
          isLoading &&
              !isLoadingInside // Show loading indicator instead of button.
          ? Center(
              child: SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(
                  color: buttonStyle.loadingColor,
                  strokeWidth: buttonStyle.loadingStrokeWidth,
                ),
              ),
            )
          : ElevatedButton(
              onPressed: () {
                isForceTap == true
                    ? onPressed()
                    : isEnable
                    ? onPressed()
                    : null;
              },
              onLongPress: onLongPress,
              onHover: onHover,
              onFocusChange: onFocusChange,
              focusNode: focusNode,
              autofocus: autofocus,
              clipBehavior: clipBehavior ?? Clip.none,
              statesController: statesController,
              style: mergedElevatedStyle,
              child: isLoading && isLoadingInside
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        Opacity(opacity: 0, child: buttonContent),
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: buttonStyle.loadingColor,
                            strokeWidth: buttonStyle.loadingStrokeWidth,
                          ),
                        ),
                      ],
                    )
                  : buttonContent,
            ),
    );
  }
}

/// Creates a rounded [ButtonStyle] used by [XButton].
///
/// This method allows defining background color, foreground color,
/// border, padding, elevation, and radius.
///
/// Typically used internally by [XButton], but can also be used
/// independently.
///
/// Example:
/// ```dart
/// styleButtonRounded(
///   radius: 12,
///   background: Colors.blue,
/// );
/// ```
ButtonStyle styleButtonRounded({
  double radius = 10,
  Color? background,
  Color? foreground,
  Color? borderColor,
  bool? isEnable = true,
  double elevation = 1,
  double paddingHorizontal = 12,
  double paddingVertical = 5,
  double borderWidth = 0,
}) {
  final bgColor = isEnable == false
      ? Colors.grey[300]
      : background ?? Colors.lightBlue;
  final fgColor = foreground ?? Colors.white;

  ButtonStyle buttonStyle =
      ElevatedButton.styleFrom(
        minimumSize: const Size(80, 48),
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        elevation: elevation,
        textStyle: TextStyle(color: fgColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: borderColor != null
              ? BorderSide(color: borderColor, width: borderWidth)
              : BorderSide.none,
        ),
      ).copyWith(
        padding: WidgetStateProperty.all<EdgeInsets>(
          EdgeInsets.symmetric(
            horizontal: paddingHorizontal,
            vertical: paddingVertical,
          ),
        ),
      );

  return buttonStyle;
}
