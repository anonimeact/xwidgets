/*
==========================================================
🧩 Example App — XWidgets
==========================================================
*/

import 'package:example/example_xwidgets.dart';
import 'package:flutter/material.dart';
import 'package:xwidgets_pack/xwidgets.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'XWidgets Example',
      navigatorKey: XSnackbar.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const ExampleXwidgets(),
    ),
  );
}
