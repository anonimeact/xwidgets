import 'package:flutter/material.dart';
import 'package:xwidgets_pack/look/presets/x_dialog_look.dart';
import 'package:xwidgets_pack/look/x_look.dart';

/// Consistent helpers for custom, alert, confirmation, and loading dialogs.
///
/// All methods return the native dialog result and accept common route
/// controls, keeping navigation behavior explicit.
///
/// Pass [look] to opt into a visual preset. Default is [XLook.standard].
abstract final class XDialog {
  /// Shows arbitrary dialog content.
  static Future<T?> show<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
  }) {
    return showDialog<T>(
      context: context,
      builder: builder,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
    );
  }

  /// Shows an informational alert and completes when it is closed.
  static Future<void> alert(
    BuildContext context, {
    required String title,
    required String message,
    String actionLabel = 'OK',
    Widget? icon,
    bool barrierDismissible = true,
    XLook look = XLook.standard,
  }) {
    final lookPreset = XDialogLook.resolve(look);
    return show<void>(
      context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) => AlertDialog(
        icon: icon,
        title: Text(title),
        content: Text(message),
        backgroundColor: lookPreset.backgroundColor,
        elevation: lookPreset.elevation,
        shape: look == XLook.standard ? null : lookPreset.shape,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(actionLabel),
          ),
        ],
      ),
    );
  }

  /// Shows a confirmation dialog and returns `true` only when confirmed.
  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    Widget? icon,
    bool isDestructive = false,
    bool barrierDismissible = true,
    XLook look = XLook.standard,
  }) async {
    final lookPreset = XDialogLook.resolve(look);
    final result = await show<bool>(
      context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) => AlertDialog(
        icon: icon,
        title: Text(title),
        content: Text(message),
        backgroundColor: lookPreset.backgroundColor,
        elevation: lookPreset.elevation,
        shape: look == XLook.standard ? null : lookPreset.shape,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(cancelLabel),
          ),
          FilledButton(
            style: isDestructive
                ? FilledButton.styleFrom(
                    backgroundColor: Theme.of(dialogContext).colorScheme.error,
                    foregroundColor: Theme.of(
                      dialogContext,
                    ).colorScheme.onError,
                  )
                : null,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Shows a non-dismissible loading dialog.
  ///
  /// Close it with `Navigator.of(context, rootNavigator: useRootNavigator)
  /// .pop()` after the operation completes.
  static Future<T?> loading<T>(
    BuildContext context, {
    String? message,
    Widget? indicator,
    bool useRootNavigator = true,
    XLook look = XLook.standard,
  }) {
    final lookPreset = XDialogLook.resolve(look);
    return show<T>(
      context,
      barrierDismissible: false,
      useRootNavigator: useRootNavigator,
      builder: (_) => PopScope(
        canPop: false,
        child: AlertDialog(
          backgroundColor: lookPreset.backgroundColor,
          elevation: lookPreset.elevation,
          shape: look == XLook.standard ? null : lookPreset.shape,
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              indicator ?? const CircularProgressIndicator(),
              if (message != null) ...[
                const SizedBox(width: 16),
                Flexible(child: Text(message)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
