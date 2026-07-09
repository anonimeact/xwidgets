/// XWidgets
///
/// A small collection of reusable, customizable Flutter widgets intended to
/// speed up common UI tasks and provide a consistent look & feel across apps.
///
/// Overview
/// - Purpose: Provide lightweight, well-documented, and configurable widgets
///   that are easy to drop into any Flutter project.
/// - Scope: Visual building blocks such as app bars, buttons, cards, text
///   helpers, dashed/divider widgets, snackbars, spacers and enhanced
///   text-fields with validation helpers.
///
/// Widgets exported by this library
/// - `XAppBar` — flexible AppBar replacement with built-in title, actions,
///   and optional leading/content customization.
/// - `XAsyncView` — state-management agnostic asynchronous state renderer.
/// - `XBottomSheet` — typed modal and action-sheet helpers.
/// - `XButton` — configurable button with idle/loading/success/error states,
///   icons, and styles.
/// - `XCard` — a simple card wrapper with padding, elevation and shape props.
/// - `XCollectionView` — paginated list/grid collection.
/// - `XDebouncedSearchField` — search field with debounce and loading state.
/// - `XDiagonalStrikethroughText` — draws a diagonal strikethrough over text
///   (useful for sale/discount UI or decorative effects).
/// - `XDialog` — alert, confirmation, custom, and loading dialog helpers.
/// - `XDoubleDashedLine` — renders two parallel dashed lines, useful as a
///   decorative divider.
/// - `XResponsiveLayout` — responsive mobile/tablet/desktop layout selector.
/// - `XScreen` — scaffold with safe area and loading/error overlays.
/// - `XSingleDashedLine` — renders a single dashed line divider.
/// - `XSnackbar` — a thin wrapper for showing stylable snackbars with
///   convenience options for duration and actions.
/// - `XScrollView` — a state-management agnostic list with initial loading,
///   pull-to-refresh, pagination, empty state, and retry handling.
/// - `XSpacer` — shorthand for flexible spacing between widgets.
/// - `XTextField` — enhanced text field with built-in validator hooks and
///   styling options.
/// - `XText` — lightweight text helper that consolidates common text styles.
/// - `XLook` — optional visual look presets (`standard`, `material`, `ios`,
///   `glass`, `neumorphism`, `retro`, `neoBrutalism`). Default is `standard`
///   (existing package look). Pass `look:` only when opting into a preset.
///
/// Usage
/// Add the package import and use widgets directly:
///
/// ```dart
/// import 'package:xwidgets_pack/xwidgets.dart';
///
/// Example: simple button
/// XButton(
///   label: 'Send',
///   onPressed: () => print('sent'),
/// );
///
/// // Opt into a look preset:
/// XButton(label: 'Send', onPressed: () {}, look: XLook.ios);
/// ```
///
/// Contributing
/// - See the repository `README.md` for contribution guidelines, code style,
///   and how to run code generation or tests.
///
/// Compatibility
/// - Built for Flutter stable channel. Check `pubspec.yaml` for environment
///   SDK constraints and dependency versions.
///
library;

export 'look/x_look.dart';
export 'widgets/x_app_bar.dart';
export 'widgets/x_async_view.dart';
export 'widgets/x_bottom_sheet.dart';
export 'widgets/x_button.dart';
export 'widgets/x_card.dart';
export 'widgets/x_collection_view.dart';
export 'widgets/x_debounced_search_field.dart';
export 'widgets/x_diagonal_strikethrough_text.dart';
export 'widgets/x_dialog.dart';
export 'widgets/x_double_dashed_line.dart';
export 'widgets/x_responsive_layout.dart';
export 'widgets/x_screen.dart';
export 'widgets/x_single_dashed_line.dart';
export 'widgets/x_snackbar.dart';
export 'widgets/x_scrollview.dart';
export 'widgets/x_spacer.dart';
export 'widgets/x_text_field.dart';
export 'widgets/x_text.dart';
export 'widgets/shimmer/x_shimmer.dart';
export 'widgets/shimmer/x_shimmer_child.dart';
export 'widgets/shimmer/x_shimmer_effect.dart';
