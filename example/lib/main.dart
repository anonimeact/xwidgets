/*
==========================================================
🧩 Example App — XWidgets
==========================================================
*/

import 'package:example/look_picker_page.dart';
import 'package:flutter/material.dart';
import 'package:xwidgets_pack/xwidgets.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'XWidgets Example',
      navigatorKey: XSnackbar.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF00BAFF),
      ),
      home: const LookPickerPage(),
    ),
  );
}
