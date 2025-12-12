import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'x_snackbar_config.freezed.dart';

@freezed
abstract class XSnackbarConfig with _$XSnackbarConfig {
  const factory XSnackbarConfig({
    @Default(Duration(seconds: 2)) Duration duration,
    @Default(SizedBox.shrink()) Widget leadingIcon,
    @Default(true) bool floating,
    @Default(EdgeInsets.fromLTRB(16, 12, 16, 16)) EdgeInsets margin,
    @Default(8) double radius,
    String? actionLabel,
  }) = _XSnackbarConfig;

  const XSnackbarConfig._();
}
