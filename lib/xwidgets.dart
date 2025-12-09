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
/// - `XButton` — configurable button supporting variants, icons, and styles.
/// - `XCard` — a simple card wrapper with padding, elevation and shape props.
/// - `XDiagonalStrikethroughText` — draws a diagonal strikethrough over text
///   (useful for sale/discount UI or decorative effects).
/// - `XDoubleDashedLine` — renders two parallel dashed lines, useful as a
///   decorative divider.
/// - `XSingleDashedLine` — renders a single dashed line divider.
/// - `XSnackbar` — a thin wrapper for showing stylable snackbars with
///   convenience options for duration and actions.
/// - `XSpacer` — shorthand for flexible spacing between widgets.
/// - `XTextField` — enhanced text field with built-in validator hooks and
///   styling options.
/// - `XText` — lightweight text helper that consolidates common text styles.
///
/// Usage
/// Add the package import and use widgets directly:
///
/// ```dart
/// import 'package:xwidgets/xwidgets.dart';
///
/// Example: simple button
/// XButton(
///   label: 'Send',
///   onPressed: () => print('sent'),
/// );
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

export 'widgets/x_app_bar.dart';
export 'widgets/x_button.dart';
export 'widgets/x_card.dart';
export 'widgets/x_diagonal_strikethrough_text.dart';
export 'widgets/x_double_dashed_line.dart';
export 'widgets/x_single_dashed_line.dart';
export 'widgets/x_snackbar.dart';
export 'widgets/x_spacer.dart';
export 'widgets/x_text_field.dart';
export 'widgets/x_text.dart';
