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
  final List<Widget> actions;
  final bool isTitleCenter;
  final double? toolbarHeight;
  final Color? backgroundColor;
  final Widget? backButton;

  const XAppBar({
    super.key,
    this.title,
    this.child,
    this.titleTextStyle,
    this.onTapBack,
    this.actions = const [],
    this.isTitleCenter = true,
    this.toolbarHeight,
    this.backgroundColor,
    this.backButton,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor = backgroundColor ?? Colors.lightBlue;

    final bool isDarkBackground = bgColor.computeLuminance() < 0.5;

    return AppBar(
      titleSpacing: 0,
      toolbarHeight: toolbarHeight,
      backgroundColor: bgColor,
      centerTitle: isTitleCenter,
      actions: actions,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: bgColor,
        statusBarIconBrightness: isDarkBackground
            ? Brightness.light
            : Brightness.dark,
        statusBarBrightness: isDarkBackground
            ? Brightness.dark
            : Brightness.light,
      ),

      /// Leading logic:
      /// - If `backButton` provided → wrap it with GestureDetector for consistent callback.
      /// - Else → default IconButton back arrow.
      leading: backButton != null
          ? GestureDetector(
              onTap: onTapBack ?? () => Navigator.pop(context),
              behavior: HitTestBehavior.opaque,
              child: Center(child: backButton),
            )
          : IconButton(
              icon: const Icon(Icons.arrow_back_outlined),
              onPressed: onTapBack ?? () => Navigator.pop(context),
            ),

      title:
          child ??
          Text(
            title ?? '',
            style:
                titleTextStyle ??
                const TextStyle(fontSize: 18, color: Colors.white),
          ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight ?? kToolbarHeight);
}
