import 'package:flutter/material.dart';
import 'package:xwidgets_pack/look/presets/x_bottom_sheet_look.dart';
import 'package:xwidgets_pack/look/x_look.dart';

/// One selectable action displayed by [XBottomSheet.actions].
class XBottomSheetAction<T> {
  const XBottomSheetAction({
    required this.label,
    required this.value,
    this.icon,
    this.subtitle,
    this.isDestructive = false,
    this.enabled = true,
  });

  /// Main action label.
  final String label;

  /// Result returned when selected.
  final T value;

  /// Optional leading icon.
  final Widget? icon;

  /// Optional supporting label.
  final String? subtitle;

  /// Applies the theme error color to the action.
  final bool isDestructive;

  /// Whether this action can be selected.
  final bool enabled;
}

/// Consistent helpers for custom modal sheets and action sheets.
///
/// Pass [look] to opt into a visual preset. Default is [XLook.standard].
abstract final class XBottomSheet {
  /// Shows arbitrary modal bottom-sheet content.
  static Future<T?> show<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    bool isScrollControlled = false,
    bool useSafeArea = true,
    bool? showDragHandle,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    ShapeBorder? shape,
    BoxConstraints? constraints,
    bool useRootNavigator = false,
    RouteSettings? routeSettings,
    XLook look = XLook.standard,
  }) {
    final lookPreset = XBottomSheetLook.resolve(look);
    return showModalBottomSheet<T>(
      context: context,
      builder: builder,
      isScrollControlled: isScrollControlled,
      useSafeArea: useSafeArea,
      showDragHandle: showDragHandle ?? lookPreset.showDragHandle,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor ?? lookPreset.backgroundColor,
      shape: shape ?? lookPreset.shape,
      constraints: constraints,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
    );
  }

  /// Shows a typed list of actions and returns the selected value.
  static Future<T?> actions<T>(
    BuildContext context, {
    required List<XBottomSheetAction<T>> actions,
    String? title,
    String? message,
    String cancelLabel = 'Cancel',
    bool showCancel = true,
    XLook look = XLook.standard,
  }) {
    return show<T>(
      context,
      look: look,
      builder: (sheetContext) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 4),
              child: Text(
                title,
                style: Theme.of(sheetContext).textTheme.titleLarge,
              ),
            ),
          if (message != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
              child: Text(message),
            ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final action in actions)
                  ListTile(
                    enabled: action.enabled,
                    leading: action.icon,
                    title: Text(
                      action.label,
                      style: action.isDestructive
                          ? TextStyle(
                              color: Theme.of(sheetContext).colorScheme.error,
                            )
                          : null,
                    ),
                    subtitle: action.subtitle == null
                        ? null
                        : Text(action.subtitle!),
                    onTap: action.enabled
                        ? () => Navigator.of(sheetContext).pop(action.value)
                        : null,
                  ),
              ],
            ),
          ),
          if (showCancel)
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: OutlinedButton(
                  onPressed: () => Navigator.of(sheetContext).pop(),
                  child: Text(cancelLabel),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
