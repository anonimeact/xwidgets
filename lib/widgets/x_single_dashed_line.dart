import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:xwidgets_pack/look/presets/x_divider_look.dart';
import 'package:xwidgets_pack/look/x_look.dart';

/// A horizontal single dashed line divider drawn using a custom painter.
///
/// This widget renders a lightweight dashed line, useful for separating
/// sections in a layout while maintaining a clean, minimalistic look.
///
/// Features:
/// - Custom dash width
/// - Custom dash gap
/// - Adjustable stroke thickness
/// - Custom color
///
/// Example:
/// ```dart
/// XSingleDashedLine(
///   dashWidth: 6,
///   dashGap: 3,
///   strokeWidth: 1,
///   color: Colors.grey,
/// );
/// ```
///
/// This widget is often used in:
/// - Receipt-style layouts
/// - Informational sections
/// - Decorative separators
class XSingleDashedLine extends StatelessWidget {
  /// Length of each dash segment.
  ///
  /// Defaults to the active [look] preset (`6` for [XLook.standard]).
  final double? dashWidth;

  /// Gap between dash segments.
  ///
  /// Defaults to the active [look] preset (`4` for [XLook.standard]).
  final double? dashGap;

  /// Thickness of the dashed line.
  ///
  /// Defaults to the active [look] preset (`1` for [XLook.standard]).
  final double? strokeWidth;

  /// Color of the dashed line.
  ///
  /// Defaults to `Colors.black54` for [XLook.standard].
  final Color? color;

  /// Visual look preset. Defaults to [XLook.standard] (existing package look).
  final XLook look;

  /// Creates a horizontal single dashed divider.
  const XSingleDashedLine({
    super.key,
    this.dashWidth,
    this.dashGap,
    this.strokeWidth,
    this.color,
    this.look = XLook.standard,
  });

  @override
  Widget build(BuildContext context) {
    final lookPreset = XDividerLook.resolve(look);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: CustomPaint(
        size: const Size(double.infinity, 1),
        painter: _XDashedDividerPainter(
          dashWidth: dashWidth ?? lookPreset.dashWidth,
          dashGap: dashGap ?? lookPreset.dashGap,
          strokeWidth: strokeWidth ?? lookPreset.strokeWidth,
          color: color ?? lookPreset.color ?? Colors.black54,
        ),
      ),
    );
  }
}

/// Internal painter responsible for rendering the dashed line.
///
/// This class is used internally by [XSingleDashedLine]
/// and is not intended for direct use.
class _XDashedDividerPainter extends CustomPainter {
  /// Length of each dash segment.
  final double dashWidth;

  /// Gap between dash segments.
  final double dashGap;

  /// Thickness of the dashed stroke.
  final double strokeWidth;

  /// Color of the dashed line.
  final Color color;

  _XDashedDividerPainter({
    required this.dashWidth,
    required this.dashGap,
    required this.strokeWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Draw line horizontally centered by stroke thickness
    _drawDashedLine(
      canvas,
      Offset(0, strokeWidth / 2),
      Offset(size.width, strokeWidth / 2),
      paint,
    );
  }

  /// Draws a dashed line between [p1] and [p2].
  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    final dx = p2.dx - p1.dx;
    final dy = p2.dy - p1.dy;
    final total = math.sqrt(dx * dx + dy * dy);

    // Unit direction vector
    final ux = dx / total;
    final uy = dy / total;

    double drawn = 0;
    bool draw = true;
    var current = p1;

    while (drawn < total) {
      final len = draw ? dashWidth : dashGap;
      final step = math.min(len, total - drawn);
      final next = Offset(current.dx + ux * step, current.dy + uy * step);

      if (draw) canvas.drawLine(current, next, paint);

      current = next;
      drawn += step;
      draw = !draw; // alternate dash and gap
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
