import 'package:flutter/widgets.dart';

extension HeadingText on Text {
  Text heading() {
    return Text(
      data ?? "",
      style: (style ?? const TextStyle()).copyWith(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
