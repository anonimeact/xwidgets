import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'x_button_style.freezed.dart';

@freezed
abstract class XButtonStyle with _$XButtonStyle {
  const factory XButtonStyle({
    @Default(Colors.lightBlue) Color background,
    @Default(Colors.white) Color foreground,
    @Default(Colors.white) Color borderColor,
    @Default(Colors.lightBlue) Color loadingColor,
    @Default(2.0) double loadingStrokeWidth,
    @Default(Color.fromRGBO(238, 238, 238, 1)) Color disableBackground,
    @Default(0.0) double borderWidth,
    @Default(true) bool isEnable,
    @Default(1.0) double elevation,
    @Default(12.0) double paddingHorizontal,
    @Default(8.0) double paddingVertical,
    @Default(14) double textSize,
    Widget? prefixIcon,
    Widget? suffixIcon,
    Widget? centerIcon,
    TextStyle? textStyle,
  }) = _XButtonStyle;
}
