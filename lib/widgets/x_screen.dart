import 'package:flutter/material.dart';

typedef XScreenErrorBuilder =
    Widget Function(BuildContext context, Object error, VoidCallback? retry);

/// A page scaffold with safe-area, keyboard dismissal, responsive padding,
/// loading overlay, and error overlay support.
///
/// Every state remains externally controlled, so [XScreen] can be used with
/// any navigation and state-management architecture.
class XScreen extends StatelessWidget {
  const XScreen({
    required this.body,
    super.key,
    this.appBar,
    this.backgroundColor,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.safeArea = true,
    this.safeAreaTop = true,
    this.safeAreaBottom = true,
    this.dismissKeyboardOnTap = true,
    this.padding,
    this.maxContentWidth,
    this.isLoading = false,
    this.loadingBuilder,
    this.loadingBarrierColor = const Color(0x66000000),
    this.error,
    this.errorBuilder,
    this.onRetry,
    this.resizeToAvoidBottomInset,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
  });

  /// Main page content.
  final Widget body;

  final PreferredSizeWidget? appBar;
  final Color? backgroundColor;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? endDrawer;

  /// Wraps content in [SafeArea].
  final bool safeArea;
  final bool safeAreaTop;
  final bool safeAreaBottom;

  /// Unfocuses the active input when the page background is tapped.
  final bool dismissKeyboardOnTap;

  /// Padding around page content.
  final EdgeInsetsGeometry? padding;

  /// Centers and constrains content on wide screens.
  final double? maxContentWidth;

  /// Shows a modal loading overlay above the body.
  final bool isLoading;

  /// Builds custom loading overlay content.
  final WidgetBuilder? loadingBuilder;
  final Color loadingBarrierColor;

  /// Shows an error overlay when non-null.
  final Object? error;

  /// Builds custom error overlay content.
  final XScreenErrorBuilder? errorBuilder;

  /// Retry callback supplied to the error overlay.
  final VoidCallback? onRetry;

  final bool? resizeToAvoidBottomInset;
  final bool extendBody;
  final bool extendBodyBehindAppBar;

  @override
  Widget build(BuildContext context) {
    Widget content = body;
    if (maxContentWidth != null) {
      content = Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxContentWidth!),
          child: content,
        ),
      );
    }
    if (padding != null) content = Padding(padding: padding!, child: content);
    if (safeArea) {
      content = SafeArea(
        top: safeAreaTop,
        bottom: safeAreaBottom,
        child: content,
      );
    }
    if (dismissKeyboardOnTap) {
      content = GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: content,
      );
    }

    content = Stack(
      fit: StackFit.expand,
      children: [
        content,
        if (error != null) _buildErrorOverlay(context),
        if (isLoading) _buildLoadingOverlay(context),
      ],
    );

    return Scaffold(
      appBar: appBar,
      backgroundColor: backgroundColor,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      endDrawer: endDrawer,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      body: content,
    );
  }

  Widget _buildLoadingOverlay(BuildContext context) {
    return ColoredBox(
      color: loadingBarrierColor,
      child:
          loadingBuilder?.call(context) ??
          const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorOverlay(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child:
          errorBuilder?.call(context, error!, onRetry) ??
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 12),
                  Text(error.toString(), textAlign: TextAlign.center),
                  if (onRetry != null) ...[
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: onRetry,
                      child: const Text('Retry'),
                    ),
                  ],
                ],
              ),
            ),
          ),
    );
  }
}
