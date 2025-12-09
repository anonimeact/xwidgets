import 'package:flutter/material.dart';

/// A utility class for displaying styled snackbars at the top or bottom of the
/// screen. Works with `Overlay` for top-positioned snackbars and uses the
/// native Flutter `SnackBar` for bottom-positioned snackbars.
///
/// Attach the provided [scaffoldMessengerKey] to your `MaterialApp`:
///
/// ```dart
/// MaterialApp(
///   scaffoldMessengerKey: XSnackbar.scaffoldMessengerKey,
///   home: MyApp(),
/// )
/// ```
///
/// Usage examples:
///
/// ```dart
/// XSnackbar.info('Saved!');
/// XSnackbar.error('Something went wrong', title: 'Error');
/// XSnackbar.custom('Hello', color: Colors.purple);
/// XSnackbar.success('Done', position: XSnackbarPosition.top);
/// ```
class XSnackbar {
  /// A global key that must be assigned to the app's `MaterialApp` in order
  /// for XSnackbar to access the current [ScaffoldMessengerState].
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // ---------------------------------------------------------------------------
  // PUBLIC API – PRESET SNACKBAR TYPES
  // ---------------------------------------------------------------------------

  /// Shows an informational snackbar.
  ///
  /// Example:
  /// ```dart
  /// XSnackbar.info('This is an info message');
  /// ```
  static void info(
    String message, {
    String? title,
    XSnackbarPosition position = XSnackbarPosition.bottom,
    Duration duration = const Duration(seconds: 2),
    IconData? leadingIcon,
    bool floating = true,
    EdgeInsets? margin,
    ShapeBorder? shape,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _show(
      message: message,
      title: title,
      type: const XSnackbarType.info(),
      position: position,
      duration: duration,
      leadingIcon: leadingIcon,
      isFloating: floating,
      margin: margin,
      shape: shape,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Shows a success snackbar (green colored).
  static void success(
    String message, {
    String? title,
    XSnackbarPosition position = XSnackbarPosition.bottom,
    Duration duration = const Duration(seconds: 2),
    IconData? leadingIcon,
    bool floating = true,
    EdgeInsets? margin,
    ShapeBorder? shape,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _show(
      message: message,
      title: title,
      type: const XSnackbarType.success(),
      position: position,
      duration: duration,
      leadingIcon: leadingIcon,
      isFloating: floating,
      margin: margin,
      shape: shape,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Shows an error snackbar (red colored).
  static void error(
    String message, {
    String? title,
    XSnackbarPosition position = XSnackbarPosition.bottom,
    Duration duration = const Duration(seconds: 2),
    IconData? leadingIcon,
    bool floating = true,
    EdgeInsets? margin,
    ShapeBorder? shape,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _show(
      message: message,
      title: title,
      type: const XSnackbarType.error(),
      position: position,
      duration: duration,
      leadingIcon: leadingIcon,
      isFloating: floating,
      margin: margin,
      shape: shape,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Shows a warning snackbar (orange colored).
  static void warning(
    String message, {
    String? title,
    XSnackbarPosition position = XSnackbarPosition.bottom,
    Duration duration = const Duration(seconds: 2),
    IconData? leadingIcon,
    bool floating = true,
    EdgeInsets? margin,
    ShapeBorder? shape,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _show(
      message: message,
      title: title,
      type: const XSnackbarType.warning(),
      position: position,
      duration: duration,
      leadingIcon: leadingIcon,
      isFloating: floating,
      margin: margin,
      shape: shape,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Shows a snackbar with a custom color.
  ///
  /// Example:
  /// ```dart
  /// XSnackbar.custom(
  ///   'Custom snackbar',
  ///   color: Colors.purple,
  ///   title: 'Hello',
  /// );
  /// ```
  static void custom(
    String message, {
    required Color color,
    String? title,
    XSnackbarPosition position = XSnackbarPosition.bottom,
    Duration duration = const Duration(seconds: 2),
    IconData? leadingIcon,
    bool floating = true,
    EdgeInsets? margin,
    ShapeBorder? shape,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _show(
      message: message,
      title: title,
      type: XSnackbarType.custom(color),
      position: position,
      duration: duration,
      leadingIcon: leadingIcon,
      isFloating: floating,
      margin: margin,
      shape: shape,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  // ---------------------------------------------------------------------------
  // INTERNAL HANDLER
  // ---------------------------------------------------------------------------

  /// Internal shared logic that routes either to the top snackbar (Overlay)
  /// or the bottom snackbar (native Flutter Snackbar).
  static void _show({
    required String message,
    required XSnackbarType type,
    required XSnackbarPosition position,
    required Duration duration,
    required bool isFloating,
    String? title,
    IconData? leadingIcon,
    EdgeInsets? margin,
    ShapeBorder? shape,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final overlay = navigatorKey.currentState?.overlay;
    if (overlay == null) return; // overlay belum siap

    _showSnackbar(
      message: message,
      type: type,
      duration: duration,
      title: "Title",
      leadingIcon: leadingIcon,
      isTop: position == XSnackbarPosition.top,
      floating: isFloating,
      margin: margin,
      shape: shape,
      actionLabel: actionLabel,
      onAction: onAction,
    );
    // if (position == XSnackbarPosition.top) {
    //   _showTopSnackbar(message: message, title: title, type: type, duration: duration, leadingIcon: leadingIcon);
    // } else {
    //   _showBottomSnackbar(
    //     message: message,
    //     title: title,
    //     type: type,
    //     duration: duration,
    //     leadingIcon: leadingIcon,
    //     floating: floating,
    //     margin: margin,
    //     shape: shape,
    //     actionLabel: actionLabel,
    //     onAction: onAction,
    //   );
    // }
  }

  // ---------------------------------------------------------------------------
  // TOP SNACKBAR (Overlay-based)
  // ---------------------------------------------------------------------------

  /// Displays a snackbar at the top of the screen using an OverlayEntry.
  ///
  static void _showSnackbar({
    required String message,
    required XSnackbarType type,
    required Duration duration,
    String? title,
    IconData? leadingIcon,
    String? actionLabel,
    VoidCallback? onAction,
    bool isTop = true,
    bool floating = false,
    EdgeInsets? margin,
    ShapeBorder? shape,
  }) {
    final overlay = navigatorKey.currentState?.overlay;
    if (overlay == null) return; // overlay belum siap

    final color = type.color ?? Colors.blue;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => Positioned(
        top: isTop ? MediaQuery.of(context).padding.top + 12 : null,
        bottom: isTop ? null : (floating ? (margin?.bottom ?? 16) : 0),
        left: floating ? (margin?.left ?? 16) : 0,
        right: floating ? (margin?.right ?? 16) : 0,
        child: Material(
          elevation: 6,
          color: color,
          shape: floating && !isTop
              ? (shape ??
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ))
              : null,
          borderRadius: isTop ? BorderRadius.circular(12) : null,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (leadingIcon != null) ...[
                  Icon(leadingIcon, color: Colors.white),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null) ...[
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                      Text(
                        message,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                if (actionLabel != null && onAction != null)
                  TextButton(
                    onPressed: () {
                      onAction();
                      entry.remove();
                    },
                    child: Text(
                      actionLabel,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    Future.delayed(duration).then((_) => entry.remove());
  }
}

// -----------------------------------------------------------------------------
// SNACKBAR POSITION ENUM
// -----------------------------------------------------------------------------

/// Determines where the snackbar will be displayed.
///
/// - [XSnackbarPosition.top] → Uses an OverlayEntry.
/// - [XSnackbarPosition.bottom] → Uses native `SnackBar`.
enum XSnackbarPosition { top, bottom }

// -----------------------------------------------------------------------------
// SNACKBAR TYPE DEFINITIONS
// -----------------------------------------------------------------------------

/// Defines the color of the snackbar.
/// Used internally by [XSnackbar].
///
/// Includes built-in presets and a `custom` constructor for complete control.
class XSnackbarType {
  /// The background color for the snackbar.
  final Color? color;

  /// Creates a custom-colored snackbar type.
  const XSnackbarType.custom(this.color);

  /// Info snackbar; uses theme primary color if no custom color is defined.
  const XSnackbarType.info() : color = null;

  /// Success snackbar (green).
  const XSnackbarType.success() : color = const Color(0xFF2E7D32);

  /// Error snackbar (red).
  const XSnackbarType.error() : color = const Color(0xFFC62828);

  /// Warning snackbar (orange).
  const XSnackbarType.warning() : color = const Color(0xFFEF6C00);
}
