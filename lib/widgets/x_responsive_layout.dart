import 'package:flutter/widgets.dart';

/// Device-size categories used by [XResponsiveLayout].
enum XResponsiveSize { mobile, tablet, desktop }

/// Width thresholds used to select a responsive layout.
class XBreakpoints {
  const XBreakpoints({this.tablet = 600, this.desktop = 1024})
    : assert(tablet > 0),
      assert(desktop > tablet);

  /// Minimum logical width classified as tablet.
  final double tablet;

  /// Minimum logical width classified as desktop.
  final double desktop;

  /// Resolves a width to its responsive category.
  XResponsiveSize resolve(double width) {
    if (width >= desktop) return XResponsiveSize.desktop;
    if (width >= tablet) return XResponsiveSize.tablet;
    return XResponsiveSize.mobile;
  }
}

typedef XResponsiveBuilder =
    Widget Function(BuildContext context, BoxConstraints constraints);

/// Chooses mobile, tablet, or desktop content from the available width.
///
/// Builders are evaluated lazily and receive the actual layout constraints.
/// Missing tablet or desktop builders fall back to the nearest smaller layout.
class XResponsiveLayout extends StatelessWidget {
  const XResponsiveLayout({
    required this.mobile,
    super.key,
    this.tablet,
    this.desktop,
    this.breakpoints = const XBreakpoints(),
  });

  /// Builder used below the tablet breakpoint.
  final XResponsiveBuilder mobile;

  /// Builder used from the tablet breakpoint.
  final XResponsiveBuilder? tablet;

  /// Builder used from the desktop breakpoint.
  final XResponsiveBuilder? desktop;

  /// Breakpoints controlling layout selection.
  final XBreakpoints breakpoints;

  /// Resolves the current screen width using [MediaQuery].
  static XResponsiveSize sizeOf(
    BuildContext context, {
    XBreakpoints breakpoints = const XBreakpoints(),
  }) {
    return breakpoints.resolve(MediaQuery.sizeOf(context).width);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        return switch (breakpoints.resolve(width)) {
          XResponsiveSize.mobile => mobile(context, constraints),
          XResponsiveSize.tablet => (tablet ?? mobile)(context, constraints),
          XResponsiveSize.desktop => (desktop ?? tablet ?? mobile)(
            context,
            constraints,
          ),
        };
      },
    );
  }
}
