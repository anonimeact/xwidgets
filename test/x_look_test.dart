import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xwidgets_pack/look/presets/x_button_look.dart';
import 'package:xwidgets_pack/look/presets/x_card_look.dart';
import 'package:xwidgets_pack/xwidgets.dart';

void main() {
  test('XLook.standard button preset matches existing defaults', () {
    final preset = XButtonLook.resolve(XLook.standard);
    expect(preset.radius, 5);
    expect(preset.style.background, Colors.lightBlue);
    expect(preset.style.elevation, 1);
  });

  test('non-standard looks resolve distinct control tokens', () {
    final ios = XButtonLook.resolve(XLook.ios);
    final brutal = XButtonLook.resolve(XLook.neoBrutalism);
    expect(ios.radius, greaterThan(5));
    expect(brutal.radius, 0);
    expect(brutal.style.borderWidth, greaterThan(0));
  });

  test('XLook.standard card preset keeps legacy shadow path', () {
    final preset = XCardLook.resolve(XLook.standard);
    expect(preset.radius, 8);
    expect(preset.useLegacyShadow, isTrue);
  });

  testWidgets('XButton without look builds with existing defaults', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: XButton(label: 'Save', onPressed: () {}),
        ),
      ),
    );
    expect(find.text('Save'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('XButton look presets build without error', (tester) async {
    for (final look in XLook.values) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: XButton(label: look.name, onPressed: () {}, look: look),
          ),
        ),
      );
      expect(find.text(look.name), findsOneWidget);
    }
  });

  testWidgets('XCard look presets build without error', (tester) async {
    for (final look in XLook.values) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: XCard(look: look, child: Text(look.name)),
          ),
        ),
      );
      expect(find.text(look.name), findsOneWidget);
    }
  });

  testWidgets('XText look presets build without error', (tester) async {
    for (final look in XLook.values) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: XText(look.name, look: look)),
        ),
      );
      expect(find.text(look.name), findsOneWidget);
    }
  });

  testWidgets('XAppBar and XTextField accept look', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: XAppBar(title: 'Bar', look: XLook.ios),
          body: const XTextField(look: XLook.material, hintText: 'Search'),
        ),
      ),
    );
    expect(find.text('Bar'), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);
  });

  testWidgets('dashed lines accept look', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              XSingleDashedLine(look: XLook.retro),
              XDoubleDashedLine(look: XLook.neoBrutalism),
            ],
          ),
        ),
      ),
    );
    expect(find.byType(XSingleDashedLine), findsOneWidget);
    expect(find.byType(XDoubleDashedLine), findsOneWidget);
  });
}
