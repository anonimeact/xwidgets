import 'package:example/look_scrollview_demo.dart';
import 'package:flutter/material.dart';
import 'package:xwidgets_pack/xwidgets.dart';

/// Focused showcase for a single [XLook] preset applied across visual widgets.
class LookThemedExample extends StatefulWidget {
  const LookThemedExample({super.key, required this.look});

  final XLook look;

  @override
  State<LookThemedExample> createState() => _LookThemedExampleState();
}

class _LookThemedExampleState extends State<LookThemedExample> {
  var _isSaving = false;

  String get _title => switch (widget.look) {
    XLook.ios => 'iOS Look',
    XLook.glass => 'Glassmorphism Look',
    XLook.neumorphism => 'Neumorphism Look',
    XLook.retro => 'Retro Look',
    XLook.neoBrutalism => 'Neo-Brutalism Look',
    _ => widget.look.name,
  };

  Color? get _scaffoldBackground => switch (widget.look) {
    XLook.glass => const Color(0xFF1A1A2E),
    XLook.neumorphism => const Color(0xFFE0E5EC),
    XLook.retro => const Color(0xFFF3E5C4),
    XLook.neoBrutalism => const Color(0xFFFFF200),
    _ => null,
  };

  @override
  Widget build(BuildContext context) {
    final look = widget.look;
    final content = XCard(
      look: look,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            XText(
              'All widgets on this page use look: $look',
              look: look,
            ),
            const SizedBox(height: 16),
            XTextField(
              look: look,
              labelOnLine: 'Email',
              hintText: 'you@example.com',
            ),
            const SizedBox(height: 12),
            XTextField(
              look: look,
              labelOnLine: 'Password',
              hintText: '••••••••',
              isObscureText: true,
            ),
            const SizedBox(height: 16),
            XButton(
              look: look,
              widthInfinity: true,
              isLoading: _isSaving,
              label: 'Save profile',
              onPressed: () async {
                setState(() => _isSaving = true);
                await Future.delayed(const Duration(seconds: 1));
                if (!mounted) return;
                setState(() => _isSaving = false);
                XSnackbar.success('Profile saved', look: look);
              },
            ),
            const SizedBox(height: 12),
            XButton(
              look: look,
              widthInfinity: true,
              label: 'Show dialog',
              onPressed: () => XDialog.alert(
                context,
                title: _title,
                message: 'Dialog styled with $look look.',
                look: look,
              ),
            ),
            const SizedBox(height: 12),
            XButton(
              look: look,
              widthInfinity: true,
              label: 'Show bottom sheet',
              onPressed: () => XBottomSheet.actions<String>(
                context,
                look: look,
                title: 'Actions',
                actions: const [
                  XBottomSheetAction(label: 'Share', value: 'share'),
                  XBottomSheetAction(label: 'Copy', value: 'copy'),
                  XBottomSheetAction(
                    label: 'Delete',
                    value: 'delete',
                    isDestructive: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            XText('Section divider', look: look),
            XSingleDashedLine(look: look),
            const SizedBox(height: 8),
            XDoubleDashedLine(look: look),
            const SizedBox(height: 16),
            XText('Loading placeholder', look: look),
            const SizedBox(height: 8),
            XShimmerChild(look: look, height: 48),
            const SizedBox(height: 8),
            XShimmerChild(look: look, height: 16, width: 180),
            const SizedBox(height: 16),
            LookScrollViewDemo(look: look),
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: _scaffoldBackground,
      appBar: XAppBar(
        look: look,
        title: _title,
        onTapBack: () => Navigator.of(context).pop(),
      ),
      body: look == XLook.glass
          ? DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: content,
            )
          : content,
    );
  }
}
