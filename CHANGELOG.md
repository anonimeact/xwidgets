## 1.3.0 - 2026-07-09

* Add optional visual **look presets** via the public `XLook` enum (`standard`, `material`, `ios`, `glass`, `neumorphism`, `retro`, `neoBrutalism`).
* Add an optional `look:` parameter to visual widgets. Default is `XLook.standard`, preserving the existing package look for backward-compatible upgrades.
* Support `look:` on `XButton`, `XCard`, `XTextField`, `XAppBar`, `XText`, `XSingleDashedLine`, `XDoubleDashedLine`, and `XShimmerChild`.
* Support `look:` on overlay helpers: `XDialog.alert`, `XDialog.confirm`, `XDialog.loading`, `XBottomSheet.show`, `XBottomSheet.actions`, and all `XSnackbar` entry points.
* Add lightweight look resolution under `lib/look/` with shared tokens and per-widget presets.
* Export `XLook` and shimmer widgets from the public `xwidgets.dart` barrel.
* Add `example/lib/look_presets_example.dart` as a runnable side-by-side showcase for every look preset.
* Expand README documentation for look presets, supported widgets, override rules, and example usage.
* Add automated look preset tests in `test/x_look_test.dart`.

## 1.2.1 - 2026-06-30

* Replace `file_picker` usage in `XTextField` with `file_selector` to avoid pulling platform-specific desktop-only transitive code into the public package surface.
* Remove `dart:io` from the public `XTextField` API by switching file callbacks and state from `File` to `XFile`, improving Web and WASM compatibility for pub.dev scoring.
* Keep file, camera, and gallery selection behavior intact while making the package platform-agnostic at the library boundary.
* Silence deprecated `cacheExtent` analyzer info in `XScrollView` with targeted ignores that remain compatible with the current Flutter SDK used by this package.

## 1.2.0

* Add `XScrollView<T>` with initial fetching, vertical/horizontal pagination, pull-to-refresh, empty/error states, retry, item interactions, and custom loading indicators.
* Add `XCollectionView<T>` with list and grid layouts using the same paginated data contract as `XScrollView`.
* Add state-management agnostic `XAsyncView<T>` and `XAsyncState<T>` for initial, loading, data, empty, and error UI.
* Add `XDebouncedSearchField` with configurable debounce, minimum query length, clear action, async loading, submission, and error handling.
* Add `XResponsiveLayout`, `XBreakpoints`, and `XResponsiveSize` for mobile, tablet, and desktop layouts.
* Add typed `XDialog` and `XBottomSheet` helpers for alerts, confirmation, loading, custom content, and action sheets.
* Add `XScreen` with safe-area handling, keyboard dismissal, constrained content, and loading/error overlays.
* Extend `XButton` with externally controlled idle, loading, success, and error states while preserving `isLoading` and `isLoadingInside`.
* Update `XTextField` for `dropdown_search` 7 and `file_picker` 11 APIs.
* Upgrade `dropdown_search` to `^7.0.0` and `file_picker` to `^11.0.2`.
* Expand the example application, automated widget tests, API documentation, and README navigation/examples.

## 1.1.0

* Enhance `XButton` with `isLoadingInside` and preserved button width while loading.
* Add `loadingStrokeWidth` in `XButtonStyle` and apply `loadingColor` + `loadingStrokeWidth` to all button loaders.
* Add more native `ElevatedButton` passthrough options in `XButton` (`onLongPress`, `onHover`, `onFocusChange`, `focusNode`, `autofocus`, `clipBehavior`, `statesController`, `elevatedButtonStyle`).
* Enhance `XTextField` with broader `TextFormField` passthrough parameters for full customization.
* Enhance `XAppBar` with broader native `AppBar` passthrough parameters and `preferredSize` support for `bottom`.
* Enhance `XText` with broader native `Text` and gesture passthrough parameters.

## 1.0.9

* Add option cursorColor in XTextField
* Add on tap action on XCard

## 1.0.8

* Add iconSpacer in XText
* Add floatingLabelBehavior inXTextField
* Aad option textStyle ourside XButtonStyle 

## 1.0.7

* Enhance XTextField Widget

## 1.0.6

* Adjust textstyle in XTextField

## 1.0.5

* Add content padding option on XTextField widget

## 1.0.4

* Add textAlign option in XTextField
* Add XHeight and XWidth Widget
* Add option widthInfinity to make button width match parent

## 1.0.3

* Enhance XSnackbar & XShimmer widget

## 1.0.2

* New XShimmer custom widget

## 1.0.1

* Add wrap mode in XText
* Adjust readme.md

## 1.0.0

* Release XWidgets Package
