import 'package:flutter/material.dart';

/// File picker options configuration
class XTextFieldFileOptions {
  /// Title for bottomsheet
  final String filePickerTitle;

  /// Text for Camera
  final String filePickerCameraText;

  /// Text for Gallery
  final String filePickerGalleryText;

  /// Text for Document picker
  final String filePickerDocumentText;

  /// Visibility options
  final bool showCamera;
  final bool showGallery;
  final bool showDocument;

  const XTextFieldFileOptions({
    this.filePickerTitle = 'Select File',
    this.filePickerCameraText = 'Take from Camera',
    this.filePickerGalleryText = 'Choose from Gallery',
    this.filePickerDocumentText = 'Pick a Document',
    this.showCamera = true,
    this.showGallery = true,
    this.showDocument = true,
  });
}

/// A configuration class for dropdown-based input on [XTextField].
class XTextFieldDropdownOptions {
  /// The list of selectable items.
  final List<dynamic>? items;

  /// Converts an item into a displayable string.
  final String Function(dynamic)? itemAsString;

  /// The initially selected item.
  final dynamic selectedItem;

  final bool showSearchBox;

  /// Creates a new [XTextFieldDropdownOptions] instance.
  const XTextFieldDropdownOptions({
    this.items,
    this.itemAsString,
    this.selectedItem,
    this.showSearchBox = false,
  });
}

/// Configuration class for date picker input on [XTextField].
class XTextFieldDatePickerOptions {
  /// The first date shown in the date picker.
  final DateTime? initialDate;

  /// The date format used when presenting the date.
  final String dateFormat;

  /// Creates a new [XTextFieldDatePickerOptions] instance.
  const XTextFieldDatePickerOptions({
    this.initialDate,
    this.dateFormat = 'dd/MM/yyyy',
  });
}

/// Configuration class for time picker input on [XTextField].
class XTextFieldTimePickerOptions {
  /// The initially selected time.
  final TimeOfDay? initialTime;

  /// Formatting string for displaying the selected time.
  final String timeFormat;

  /// Creates a new [XTextFieldTimePickerOptions] instance.
  const XTextFieldTimePickerOptions({
    this.initialTime,
    this.timeFormat = 'HH:mm',
  });
}

/// Holds validation logic for [XTextField].
class XTextFieldValidator {
  /// A function returning an error message or `null` if valid.
  final String? Function(String?)? validator;

  /// Creates a new [XTextFieldValidator] instance.
  const XTextFieldValidator({this.validator});
}
