import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A highly configurable wrapper around Flutter's built-in [AppBar], providing
/// extended flexibility for common UI requirements.
///
/// Features:
/// - Text-based title via [title] or full custom widget using [child].
/// - Custom back button via [backButton] or default Material back button.
/// - Custom actions via [actions].
/// - Custom back-navigation handler via [onTapBack].
/// - Adjustable toolbar height via [toolbarHeight].
/// - Configurable background color via [backgroundColor].
/// - Auto system overlay style based on background luminance.
///
/// Title precedence:
/// - If [child] is provided, it is used as the title widget.
/// - Otherwise, [title] is displayed using [titleTextStyle].
///
/// Back button behavior:
/// - If [backButton] is provided, it becomes the leading widget.
/// - If [onTapBack] is provided, it is executed when back button is pressed.
/// - If neither is provided, default back button calls `Navigator.pop()`.
///
/// Implements [PreferredSizeWidget] for use in `Scaffold.appBar`.
class XAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? child;
  final TextStyle? titleTextStyle;
  final VoidCallback? onTapBack;
  final List<Widget>? actions;
  final bool isTitleCenter;
  final double? toolbarHeight;
  final Color? backgroundColor;
  final Widget? backButton;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final bool automaticallyImplyActions;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;
  final double? elevation;
  final double? scrolledUnderElevation;
  final ScrollNotificationPredicate notificationPredicate;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final ShapeBorder? shape;
  final Color? foregroundColor;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;
  final bool primary;
  final bool excludeHeaderSemantics;
  final double? titleSpacing;
  final double toolbarOpacity;
  final double bottomOpacity;
  final double? leadingWidth;
  final TextStyle? toolbarTextStyle;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final bool forceMaterialTransparency;
  final bool useDefaultSemanticsOrder;
  final Clip? clipBehavior;
  final EdgeInsetsGeometry? actionsPadding;
  final bool animateColor;

  const XAppBar({
    super.key,
    this.title,
    this.child,
    this.titleTextStyle,
    this.onTapBack,
    this.actions,
    this.isTitleCenter = true,
    this.toolbarHeight,
    this.backgroundColor,
    this.backButton,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.automaticallyImplyActions = true,
    this.flexibleSpace,
    this.bottom,
    this.elevation,
    this.scrolledUnderElevation,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.shadowColor,
    this.surfaceTintColor,
    this.shape,
    this.foregroundColor,
    this.iconTheme,
    this.actionsIconTheme,
    this.primary = true,
    this.excludeHeaderSemantics = false,
    this.titleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.leadingWidth,
    this.toolbarTextStyle,
    this.systemOverlayStyle,
    this.forceMaterialTransparency = false,
    this.useDefaultSemanticsOrder = true,
    this.clipBehavior,
    this.actionsPadding,
    this.animateColor = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor = backgroundColor ?? Colors.lightBlue;

    final bool isDarkBackground = bgColor.computeLuminance() < 0.5;

    Widget? effectiveLeading = leading;
    if (effectiveLeading == null && (backButton != null || onTapBack != null)) {
      effectiveLeading = backButton != null
          ? GestureDetector(
              onTap: onTapBack ?? () => Navigator.pop(context),
              behavior: HitTestBehavior.opaque,
              child: Center(child: backButton),
            )
          : IconButton(
              icon: const Icon(Icons.arrow_back_outlined),
              onPressed: onTapBack ?? () => Navigator.pop(context),
            );
    }

    return AppBar(
      leading: effectiveLeading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      automaticallyImplyActions: automaticallyImplyActions,
      titleSpacing: titleSpacing ?? 0,
      toolbarHeight: toolbarHeight,
      leadingWidth: leadingWidth,
      backgroundColor: bgColor,
      foregroundColor: foregroundColor,
      flexibleSpace: flexibleSpace,
      bottom: bottom,
      elevation: elevation,
      scrolledUnderElevation: scrolledUnderElevation,
      notificationPredicate: notificationPredicate,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      shape: shape,
      iconTheme: iconTheme,
      actionsIconTheme: actionsIconTheme,
      primary: primary,
      centerTitle: isTitleCenter,
      actions: actions,
      excludeHeaderSemantics: excludeHeaderSemantics,
      toolbarOpacity: toolbarOpacity,
      bottomOpacity: bottomOpacity,
      toolbarTextStyle: toolbarTextStyle,
      titleTextStyle: titleTextStyle,
      systemOverlayStyle:
          systemOverlayStyle ??
          SystemUiOverlayStyle(
            statusBarColor: bgColor,
            statusBarIconBrightness: isDarkBackground
                ? Brightness.light
                : Brightness.dark,
            statusBarBrightness: isDarkBackground
                ? Brightness.dark
                : Brightness.light,
          ),
      forceMaterialTransparency: forceMaterialTransparency,
      useDefaultSemanticsOrder: useDefaultSemanticsOrder,
      clipBehavior: clipBehavior,
      actionsPadding: actionsPadding,
      animateColor: animateColor,

      title:
          child ??
          Text(
            title ?? '',
            style: titleTextStyle ?? const TextStyle(fontSize: 18),
          ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    (toolbarHeight ?? kToolbarHeight) + (bottom?.preferredSize.height ?? 0),
  );
}
