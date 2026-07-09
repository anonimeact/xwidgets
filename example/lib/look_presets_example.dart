import 'package:flutter/material.dart';
import 'package:xwidgets_pack/xwidgets.dart';

/// Interactive showcase for every [XLook] preset.
class LookPresetsExample extends StatefulWidget {
  const LookPresetsExample({super.key});

  @override
  State<LookPresetsExample> createState() => _LookPresetsExampleState();
}

class _LookPresetsExampleState extends State<LookPresetsExample> {
  static const _looks = <XLook>[
    XLook.standard,
    XLook.material,
    XLook.ios,
    XLook.glass,
    XLook.neumorphism,
    XLook.retro,
    XLook.neoBrutalism,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: XAppBar(
        title: 'Look Presets',
        onTapBack: () => Navigator.of(context).pop(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Each section uses the same widget APIs with a different '
            '`look:` preset. Default is XLook.standard (existing package look).',
            style: TextStyle(height: 1.4),
          ),
          const SizedBox(height: 16),
          for (final look in _looks) ...[
            _LookSection(look: look),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }
}

class _LookSection extends StatelessWidget {
  const _LookSection({required this.look});

  final XLook look;

  String get _title => switch (look) {
    XLook.standard => 'Standard (default)',
    XLook.material => 'Material',
    XLook.ios => 'iOS',
    XLook.glass => 'Glassmorphism',
    XLook.neumorphism => 'Neumorphism',
    XLook.retro => 'Retro',
    XLook.neoBrutalism => 'Neo-Brutalism',
  };

  String get _description => switch (look) {
    XLook.standard =>
      'Existing package defaults. Omit `look:` to keep this look after upgrade.',
    XLook.material => 'Material 3-inspired shapes, tonal surfaces, and colors.',
    XLook.ios =>
      'Large radius, light borders, and low elevation inspired by iOS chrome.',
    XLook.glass =>
      'Translucent surfaces with blur. Best viewed on colorful backgrounds.',
    XLook.neumorphism => 'Soft extruded surfaces with dual light/dark shadows.',
    XLook.retro => 'Muted vintage palette with firm borders.',
    XLook.neoBrutalism =>
      'Thick borders, hard offset shadows, and high-contrast fills.',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          _title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(_description, style: TextStyle(color: Colors.grey.shade700)),
        const SizedBox(height: 12),
        _buildSurface(context),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            XButton(
              look: look,
              label: 'Button',
              onPressed: () => XSnackbar.info(
                'Pressed with look: ${look.name}',
                look: look,
              ),
            ),
            OutlinedButton(
              onPressed: () => XDialog.alert(
                context,
                title: _title,
                message: 'Alert dialog with look: ${look.name}',
                look: look,
              ),
              child: const Text('Dialog'),
            ),
            OutlinedButton(
              onPressed: () => XBottomSheet.actions<String>(
                context,
                look: look,
                title: _title,
                actions: const [
                  XBottomSheetAction(label: 'Share', value: 'share'),
                  XBottomSheetAction(label: 'Copy link', value: 'copy'),
                ],
              ),
              child: const Text('Sheet'),
            ),
            OutlinedButton(
              onPressed: () => XSnackbar.success(
                'Saved with ${look.name} look',
                look: look,
              ),
              child: const Text('Snackbar'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSurface(BuildContext context) {
    final card = XCard(
      look: look,
      padding: const EdgeInsets.all(16),
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          XText('XText with $look look', look: look),
          const SizedBox(height: 12),
          XTextField(
            look: look,
            hintText: 'XTextField hint',
            labelOnLine: 'Label',
          ),
          const SizedBox(height: 12),
          const XSingleDashedLine(),
          const SizedBox(height: 8),
          const XDoubleDashedLine(),
          const SizedBox(height: 12),
          XShimmerChild(look: look, height: 40),
        ],
      ),
    );

    if (look == XLook.glass) {
      return DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Padding(padding: EdgeInsets.all(16), child: card),
      );
    }

    if (look == XLook.neumorphism) {
      return ColoredBox(
        color: const Color(0xFFE0E5EC),
        child: Padding(padding: const EdgeInsets.all(16), child: card),
      );
    }

    return card;
  }
}
