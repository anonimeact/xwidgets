import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:xwidgets/utils/x_textfield_options.dart';
import 'package:xwidgets/utils/x_textfield_style.dart';

/// Defines supported field types for [XTextField].
enum XTextFieldType { normal, file, dropdown, datepicker, timepicker }

/// A flexible text field widget supporting:
/// - Standard text input
/// - File picker
/// - Dropdown list
/// - Date picker
/// - Time picker
///
/// Includes:
/// - Customizable style
/// - Validation
/// - Character counter
/// - Common callbacks
class XTextField extends StatefulWidget {
  /// Creates a new customizable [XTextField].
  const XTextField({
    super.key,
    this.controller,
    this.textStyle,
    this.label,
    this.labelOnLine,
    this.hintText,
    this.isRequired = false,
    this.isEnable = true,
    this.prefixIcon,
    this.suffixIcon,
    this.inputType = TextInputType.text,
    this.fieldType = XTextFieldType.normal,
    this.textCapitalization = TextCapitalization.sentences,
    this.minLines = 1,
    this.maxLines = 1,
    this.maxLength = 500,
    this.isShowCounter = false,
    this.onChanged,
    this.onTap,
    this.textInputAction = TextInputAction.next,
    this.style,
    this.fileOptions,
    this.dropdownOptions,
    this.datePickerOptions,
    this.timePickerOptions,
    this.validator,
    this.onFileSelected,
    this.onDropdownChanged,
    this.onDateSelected,
    this.onTimeSelected,
    this.isReadOnly = false,
    this.isObscureText = false,
  });

  /// Controller for reading and modifying the text displayed.
  final TextEditingController? controller;

  /// The text style applied to the field’s content.
  final TextStyle? textStyle;

  /// The label placed above the field.
  final String? label;

  /// The inline label placed beside the field.
  final String? labelOnLine;

  /// Placeholder text shown when the field is empty.
  final String? hintText;

  /// Whether the field is required.
  final bool isRequired;

  /// Whether the field is enabled.
  final bool isEnable;

  final bool isReadOnly;

  /// The type of field that will be displayed.
  final XTextFieldType fieldType;

  /// Icon displayed at the beginning of the field.
  final Widget? prefixIcon;

  /// Icon displayed at the end of the field.
  final Widget? suffixIcon;

  /// Determines the action button on the keyboard.
  final TextInputAction textInputAction;

  /// The keyboard type to show.
  final TextInputType inputType;

  /// How text should be capitalized.
  final TextCapitalization textCapitalization;

  /// Minimum visible lines.
  final int minLines;

  /// Maximum visible lines.
  final int maxLines;

  /// Maximum allowed character count.
  final int maxLength;

  /// Whether a custom counter should be displayed.
  final bool isShowCounter;

  final bool isObscureText;

  /// Fires when the text content changes.
  final void Function(String)? onChanged;

  /// Fires when the field is tapped.
  final VoidCallback? onTap;

  /// A customizable style applied to borders and shape.
  final XTextFieldStyle? style;

  /// File picker configuration.
  final XTextFieldFileOptions? fileOptions;

  /// Dropdown configuration.
  final XTextFieldDropdownOptions? dropdownOptions;

  /// Date picker configuration.
  final XTextFieldDatePickerOptions? datePickerOptions;

  /// Time picker configuration.
  final XTextFieldTimePickerOptions? timePickerOptions;

  /// Field validator.
  final XTextFieldValidator? validator;

  /// File selected callback.
  final void Function(File?)? onFileSelected;

  /// Dropdown selection callback.
  final void Function(dynamic)? onDropdownChanged;

  /// Date selected callback.
  final void Function(DateTime?)? onDateSelected;

  /// Time selected callback.
  final void Function(TimeOfDay?)? onTimeSelected;

  @override
  State<XTextField> createState() => _XTextFieldState();
}

class _XTextFieldState extends State<XTextField> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  // ignore: unused_field
  File? _selectedFile;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  String? _errorText;

  bool get _controllerIsExternal => widget.controller != null;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? TextEditingController();

    _selectedDate = widget.datePickerOptions?.initialDate;
    _selectedTime = widget.timePickerOptions?.initialTime;

    if (widget.fieldType == XTextFieldType.datepicker &&
        _selectedDate != null) {
      _controller.text = DateFormat(
        widget.datePickerOptions?.dateFormat,
      ).format(_selectedDate!);
    }

    if (widget.fieldType == XTextFieldType.timepicker &&
        _selectedTime != null) {
      _controller.text = _selectedTime!.format(context);
    }
  }

  @override
  void dispose() {
    if (!_controllerIsExternal) {
      _controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.label;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[_buildLabel(label)],
        _buildFieldType(),
        if (widget.isShowCounter) _buildCounter(),
        if (_errorText != null) _buildErrorText(),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        children: [
          Text(
            text,
            style:
                widget.textStyle ??
                const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          if (widget.isRequired)
            const Text(' *', style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }

  Widget _buildCounter() {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          '${_controller.text.length}/${widget.maxLength}',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildErrorText() {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        _errorText!,
        style: const TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
  }

  Widget _buildFieldType() {
    switch (widget.fieldType) {
      case XTextFieldType.normal:
        return _buildNormalField();
      case XTextFieldType.file:
        return _buildFileField();
      case XTextFieldType.dropdown:
        return _buildDropdownField();
      case XTextFieldType.datepicker:
        return _buildDatePickerField();
      case XTextFieldType.timepicker:
        return _buildTimePickerField();
    }
  }

  Widget _buildNormalField({
    VoidCallback? onTapAction,
    bool? isReadOnly,
    bool? isEnable,
    Widget? suffixIcon,
  }) {
    final style = widget.style ?? XTextFieldStyle();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        readOnly: isReadOnly ?? !widget.isEnable || widget.isReadOnly,
        enabled: isEnable ?? widget.isEnable,
        onTap: onTapAction ?? widget.onTap,
        decoration: InputDecoration(
          labelText: widget.labelOnLine,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: widget.hintText,
          prefixIcon: widget.prefixIcon,
          suffixIcon: suffixIcon ?? widget.suffixIcon,
          border: style.outline(),
          enabledBorder: style.outline(),
          focusedBorder: style.focusedOutline(),
          errorBorder: style.errorOutline(),
          focusedErrorBorder: style.errorOutline(),
          errorText: _errorText,
          counterText: '',
        ),
        onChanged: (v) {
          widget.onChanged?.call(v);
          _validate(v);
        },
      ),
    );
  }

  Widget _buildFileField() {
    return Stack(
      alignment: .centerRight,
      children: [
        _buildNormalField(isReadOnly: true),
        IconButton(
          onPressed: widget.isEnable ? _showFilePickerBottomSheet : null,
          icon: widget.suffixIcon ?? Icon(Icons.file_present_sharp),
        ),
      ],
    );
  }

  void _showFilePickerBottomSheet() {
    final fileOpt = widget.fileOptions ?? const XTextFieldFileOptions();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),

              Text(
                fileOpt.filePickerTitle,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Divider(height: 20),

              if (fileOpt.showCamera)
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: Text(fileOpt.filePickerCameraText),
                  onTap: () {
                    Navigator.pop(context);
                    _pickCamera();
                  },
                ),

              if (fileOpt.showGallery)
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: Text(fileOpt.filePickerGalleryText),
                  onTap: () {
                    Navigator.pop(context);
                    _pickGallery();
                  },
                ),

              if (fileOpt.showDocument)
                ListTile(
                  leading: const Icon(Icons.insert_drive_file),
                  title: Text(fileOpt.filePickerDocumentText),
                  onTap: () {
                    Navigator.pop(context);
                    _pickDocument();
                  },
                ),

              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickDocument() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);

      setState(() => _controller.text = file.path);

      widget.onFileSelected?.call(file);

      _validate(file.path);
    }
  }

  Widget _buildDropdownField() {
    final style = widget.style ?? const XTextFieldStyle();
    final opt = widget.dropdownOptions ?? const XTextFieldDropdownOptions();

    return DropdownSearch<dynamic>(
      items: (filter, loadProps) => opt.items ?? [],
      selectedItem: opt.selectedItem,
      itemAsString: opt.itemAsString ?? (item) => item.toString(),
      compareFn: (a, b) => a == b,
      onChanged: (value) {
        widget.onDropdownChanged?.call(value);
        _validate(value?.toString());
      },
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          border: style.outline(),
          enabledBorder: style.outline(),
          focusedBorder: style.focusedOutline(),
          errorBorder: style.errorOutline(),
          focusedErrorBorder: style.errorOutline(),
          errorText: _errorText,
        ),
      ),
      popupProps: PopupProps.menu(
        showSearchBox: opt.showSearchBox,
        fit: FlexFit.loose,
        constraints: const BoxConstraints(),
      ),
    );
  }

  Widget _buildDatePickerField() {
    return _buildNormalField(
      isReadOnly: true,
      suffixIcon: IconButton(
        onPressed: widget.isEnable ? _showDatePicker : null,
        icon: widget.suffixIcon ?? Icon(Icons.calendar_month),
      ),
      onTapAction: widget.isEnable ? _showDatePicker : null,
    );
  }

  Widget _buildTimePickerField() {
    return _buildNormalField(
      isReadOnly: true,
      suffixIcon: IconButton(
        onPressed: widget.isEnable ? _showTimePicker : null,
        icon: widget.suffixIcon ?? Icon(Icons.timer),
      ),
      onTapAction: widget.isEnable ? _showTimePicker : null,
    );
  }

  Future<void> _pickCamera() async {
    final picker = ImagePicker();
    final x = await picker.pickImage(source: ImageSource.camera);

    if (x != null) {
      final file = File(x.path);
      _selectedFile = file;
      _controller.text = file.path;
      widget.onFileSelected?.call(file);
      _validate(file.path);
      setState(() {});
    }
  }

  Future<void> _pickGallery() async {
    final picker = ImagePicker();
    final x = await picker.pickImage(source: ImageSource.gallery);

    if (x != null) {
      final file = File(x.path);
      _selectedFile = file;
      _controller.text = file.path;
      widget.onFileSelected?.call(file);
      _validate(file.path);
      setState(() {});
    }
  }

  Future<void> _showDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      _selectedDate = picked;
      final fmt = widget.datePickerOptions?.dateFormat ?? 'dd/MM/yyyy';
      _controller.text = DateFormat(fmt).format(picked);
      widget.onDateSelected?.call(picked);
      _validate(_controller.text);
      setState(() {});
    }
  }

  Future<void> _showTimePicker() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      _selectedTime = picked;
      _controller.text = picked.format(context);
      widget.onTimeSelected?.call(picked);
      _validate(_controller.text);
      setState(() {});
    }
  }

  void _validate(String? value) {
    final validator = widget.validator?.validator;
    if (validator != null) {
      setState(() => _errorText = validator(value));
    } else {
      setState(() => _errorText = null);
    }
  }
}
