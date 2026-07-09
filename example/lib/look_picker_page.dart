import 'package:example/example_xwidgets.dart';
import 'package:example/look_themed_example.dart';
import 'package:flutter/material.dart';
import 'package:xwidgets_pack/xwidgets.dart';

/// Entry screen — pick a look preset to open its example page.
class LookPickerPage extends StatelessWidget {
  const LookPickerPage({super.key});

  static const _options = <_LookOption>[
    _LookOption(
      look: XLook.standard,
      title: 'Standard (Default)',
      subtitle: 'Existing package look — full widget showcase',
      icon: Icons.widgets_outlined,
      route: _LookRoute.existing,
    ),
    _LookOption(
      look: XLook.material,
      title: 'Material',
      subtitle: 'Material 3-inspired preset on the full showcase',
      icon: Icons.layers_outlined,
      route: _LookRoute.existing,
    ),
    _LookOption(
      look: XLook.ios,
      title: 'iOS',
      subtitle: 'iOS-inspired chrome, radius, and typography',
      icon: Icons.phone_iphone,
      route: _LookRoute.themed,
    ),
    _LookOption(
      look: XLook.glass,
      title: 'Glassmorphism',
      subtitle: 'Translucent surfaces with blur',
      icon: Icons.blur_on,
      route: _LookRoute.themed,
    ),
    _LookOption(
      look: XLook.neumorphism,
      title: 'Neumorphism',
      subtitle: 'Soft extruded dual-shadow surfaces',
      icon: Icons.circle_outlined,
      route: _LookRoute.themed,
    ),
    _LookOption(
      look: XLook.retro,
      title: 'Retro',
      subtitle: 'Vintage palette with firm borders',
      icon: Icons.history,
      route: _LookRoute.themed,
    ),
    _LookOption(
      look: XLook.neoBrutalism,
      title: 'Neo-Brutalism',
      subtitle: 'Thick borders and hard offset shadows',
      icon: Icons.crop_square,
      route: _LookRoute.themed,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('XWidgets — Choose Look'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _options.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final option = _options[index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    leading: CircleAvatar(child: Icon(option.icon)),
                    title: Text(
                      option.title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(option.subtitle),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _open(context, option),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Center(
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.3,
                child: Image.asset(
                  'assets/branding/logo_anonimeact_small.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _open(BuildContext context, _LookOption option) {
    final Widget page = switch (option.route) {
      _LookRoute.existing => ExampleXwidgets(look: option.look),
      _LookRoute.themed => LookThemedExample(look: option.look),
    };

    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }
}

enum _LookRoute { existing, themed }

class _LookOption {
  const _LookOption({
    required this.look,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
  });

  final XLook look;
  final String title;
  final String subtitle;
  final IconData icon;
  final _LookRoute route;
}
