import 'package:flutter/widgets.dart';

/// Widget to apply a shimmer effect (loading placeholder) on a child widget.
///
/// [XShimmer] wraps a child widget and applies a moving linear gradient animation,
/// creating a skeleton-loading shimmer effect commonly used in modern apps.
///
/// Example usage:
/// ```dart
/// XShimmer(
///   child: Container(
///     width: 200,
///     height: 20,
///     color: Colors.grey,
///   ),
/// )
/// ```
class XShimmer extends StatefulWidget {
  /// The child widget to display with shimmer effect.
  final Widget child;
  /// The duration of the shimmer animation.
  final Duration duration;
  /// Base color of the shimmer (background color).
  final Color baseColor;
  /// Highlight color of the shimmer (the brighter moving part).
  final Color highlightColor;

  const XShimmer({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
  });

  @override
  State<XShimmer> createState() => _XShimmerState();
}

class _XShimmerState extends State<XShimmer>
    with SingleTickerProviderStateMixin {
  /// Animation controller that drives the shimmer effect.
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller and start looping.
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    // Dispose the controller when the widget is removed from the tree.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        // Use a linear curved animation for smooth shimmer.
        final animation = CurvedAnimation(
          parent: _controller,
          curve: Curves.linear,
        );
        // Position of the shimmer highlight: from -1 to 1.
        final gradientPosition = animation.value * 2 - 1;

        return ShaderMask(
          // ShaderMask overlays the child with the animated gradient.
          shaderCallback: (rect) {
            return LinearGradient(
              begin: Alignment(-1, -0.3),
              end: Alignment(1, 0.3),
              colors: [
                widget.baseColor.withValues(alpha: 0.6), // base color with transparency
                widget.highlightColor.withValues(alpha: 0.3), // shimmer highlight
                widget.baseColor.withValues(alpha: 0.6),
              ],
              // stops define the position of the gradient highlight
              stops: [
                (gradientPosition - 0.4).clamp(0.0, 1.0),
                gradientPosition.clamp(0.0, 1.0),
                (gradientPosition + 0.4).clamp(0.0, 1.0),
              ],
            ).createShader(rect);
          },
          blendMode: BlendMode.srcATop, // blend the gradient on top of the child
          child: widget.child,
        );
      },
    );
  }
}
