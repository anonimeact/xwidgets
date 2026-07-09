/// Visual look presets for XWidgets.
///
/// Default is [XLook.standard], which preserves the existing package look.
/// Pass another value via the optional `look:` parameter to opt into a preset.
enum XLook {
  /// Existing package defaults (backward-compatible).
  standard,

  /// Material 3-inspired surfaces and shapes.
  material,

  /// iOS-inspired large radius, light borders, low elevation.
  ios,

  /// Glassmorphism: translucent fill and blur.
  glass,

  /// Soft extruded dual-shadow surfaces.
  neumorphism,

  /// Vintage muted palette with firm borders.
  retro,

  /// High-contrast thick borders and hard offset shadows.
  neoBrutalism,
}
