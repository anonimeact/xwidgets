# XWidgets

XWidgets is a Flutter package that provides a curated set of reusable,
customizable UI widgets to accelerate app development and improve
consistency across projects. The library focuses on lightweight, well-documented
components that are easy to style and compose.

![Example](xwidgets.jpeg)

## Features

- **XAppBar** — A configurable app bar with title, subtitle, leading and action
  slots. Supports quick theming and layout variants.
- **XButton** — Flexible button supporting primary/secondary variants, icons,
  loading states and custom styles.
- **XCard** — Styled card wrapper with padding, elevation and corner options.
- **XDiagonalStrikethroughText** — Text widget that renders a diagonal
  strikethrough for decorative or sale UI.
- **XDoubleDashedLine** — Two parallel dashed lines for decorative dividers.
- **XSingleDashedLine** — Single dashed divider with spacing and stroke options.
- **XSnackbar** — Convenience wrapper to show stylable snackbars with actions.
- **XSpacer** — Utility widget to insert flexible space between widgets.
- **XTextField** — Enhanced text field with validation hooks and prefined styles.
- **XText** — Convenience text widget consolidating common text styles.

## Installation

Add `xwidgets` to your `pubspec.yaml` dependencies:

Or if published on pub.dev, use the latest version:

```yaml
dependencies:
  xwidgets: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage

Import the package and use widgets directly:

```dart
import 'package:xwidgets/xwidgets.dart';

// Use a simple XButton
XButton(
  label: 'Send',
  onPressed: () => print('sent'),
);

// AppBar example
XAppBar(
  title: 'Home',
  actions: [IconButton(icon: Icon(Icons.search), onPressed: () {})],
);

// Text field with validation
XTextField(
  controller: myController,
  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
);
```

See the `example/` folder for more complete demos.
