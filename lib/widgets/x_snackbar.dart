import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:xwidgets_pack/look/presets/x_snackbar_look.dart';
import 'package:xwidgets_pack/look/x_look.dart';
import 'package:xwidgets_pack/models/x_snackbar_config.dart';

/// A utility class for displaying styled snackbars at the top or bottom of the
/// screen. Works with `Overlay` for top-positioned snackbars and uses the
/// native Flutter `SnackBar` for bottom-positioned snackbars.
///
/// Attach the provided [navigatorKey] to your `MaterialApp`:
///
/// ```dart
/// MaterialApp(
///   navigatorKey: XSnackbar.navigatorKey,
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
  /// for XSnackbar to access the current [NavigatorState].
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

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
    XSnackbarConfig config = const XSnackbarConfig(),
    VoidCallback? onAction,
    XLook look = XLook.standard,
  }) {
    _show(
      message: message,
      title: title,
      type: const XSnackbarType.info(),
      config: config,
      position: position,
      onAction: onAction,
      look: look,
    );
  }

  /// Shows a success snackbar (green colored).
  static void success(
    String message, {
    String? title,
    XSnackbarPosition position = XSnackbarPosition.bottom,
    XSnackbarConfig config = const XSnackbarConfig(),
    VoidCallback? onAction,
    XLook look = XLook.standard,
  }) {
    _show(
      message: message,
      title: title,
      type: const XSnackbarType.success(),
      config: config,
      position: position,
      onAction: onAction,
      look: look,
    );
  }

  /// Shows an error snackbar (red colored).
  static void error(
    String message, {
    String? title,
    XSnackbarPosition position = XSnackbarPosition.bottom,
    XSnackbarConfig config = const XSnackbarConfig(),
    VoidCallback? onAction,
    XLook look = XLook.standard,
  }) {
    _show(
      message: message,
      title: title,
      type: const XSnackbarType.error(),
      config: config,
      position: position,
      onAction: onAction,
      look: look,
    );
  }

  /// Shows a warning snackbar (orange colored).
  static void warning(
    String message, {
    String? title,
    XSnackbarPosition position = XSnackbarPosition.bottom,
    XSnackbarConfig config = const XSnackbarConfig(),
    VoidCallback? onAction,
    XLook look = XLook.standard,
  }) {
    _show(
      message: message,
      title: title,
      type: const XSnackbarType.warning(),
      config: config,
      position: position,
      onAction: onAction,
      look: look,
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
    String? title,
    Color color = Colors.lightBlue,
    XSnackbarPosition position = XSnackbarPosition.bottom,
    XSnackbarConfig config = const XSnackbarConfig(),
    VoidCallback? onAction,
    XLook look = XLook.standard,
  }) {
    _show(
      message: message,
      title: title,
      type: XSnackbarType.custom(color),
      config: config,
      position: position,
      onAction: onAction,
      look: look,
    );
  }

  /// Internal shared logic that routes either to the top snackbar (Overlay)
  /// or the bottom snackbar (native Flutter Snackbar).
  static void _show({
    required String message,
    required XSnackbarType type,
    String? title,
    XSnackbarPosition position = XSnackbarPosition.bottom,
    XSnackbarConfig config = const XSnackbarConfig(),
    VoidCallback? onAction,
    XLook look = XLook.standard,
  }) {
    bool snackbarRemoved = false;
    final overlay = navigatorKey.currentState?.overlay;
    if (overlay == null) return; // overlay belum siap

    final lookPreset = XSnackbarLook.resolve(look);
    final color = lookPreset.forceColor ?? type.color ?? Colors.blue;
    final isTop = position == XSnackbarPosition.top;
    final isFloating = config.floating == true;
    final radius = look == XLook.standard ? config.radius : lookPreset.radius;
    final elevation = look == XLook.standard ? 6.0 : lookPreset.elevation;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius.toDouble()),
      side: lookPreset.borderWidth > 0 && lookPreset.borderColor != null
          ? BorderSide(
              color: lookPreset.borderColor!,
              width: lookPreset.borderWidth,
            )
          : BorderSide.none,
    );

    late OverlayEntry entry;
    void removeEntry() {
      if (!snackbarRemoved) {
        snackbarRemoved = true;
        entry.remove();
      }
    }

    entry = OverlayEntry(
      builder: (context) {
        Widget material = Material(
          elevation: elevation,
          color: color,
          shape: isFloating || isTop ? shape : null,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...[config.leadingIcon, const SizedBox(width: 12)],
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
                if (config.actionLabel != null && onAction != null)
                  TextButton(
                    onPressed: () {
                      onAction();
                      removeEntry();
                    },
                    child: Text(
                      config.actionLabel ?? '',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        );

        if (lookPreset.blurSigma > 0) {
          material = ClipRRect(
            borderRadius: BorderRadius.circular(radius.toDouble()),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: lookPreset.blurSigma,
                sigmaY: lookPreset.blurSigma,
              ),
              child: material,
            ),
          );
        }

        return Positioned(
          top: isTop ? MediaQuery.of(context).padding.top + 12 : null,
          bottom: isTop
              ? null
              : isFloating
              ? (config.margin.bottom)
              : 0,
          left: isFloating ? (config.margin.left) : 0,
          right: isFloating ? (config.margin.right) : 0,
          child: material,
        );
      },
    );

    overlay.insert(entry);
    Future.delayed(config.duration).then((_) => removeEntry());
  }
}

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
  const XSnackbarType.success()
    : color = const Color.fromARGB(255, 47, 160, 94);

  /// Error snackbar (red).
  const XSnackbarType.error() : color = Colors.redAccent;

  /// Warning snackbar (orange).
  const XSnackbarType.warning() : color = Colors.amber;
}
