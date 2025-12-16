import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:xwidgets_pack/utils/x_textfield_options.dart';
import 'package:xwidgets_pack/utils/x_textfield_style.dart';

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
    this.labelStyle,
    this.hintStyle,
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
    this.textAlign = TextAlign.start,
    this.contentPadding,
    this.autovalidateMode,
    this.asyncErrorText,
    this.onSaved,
  });

  final TextEditingController? controller;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextAlign textAlign;
  final EdgeInsets? contentPadding;
  final String? label;
  final String? labelOnLine;
  final String? hintText;
  final bool isRequired;
  final bool isEnable;
  final bool isReadOnly;
  final XTextFieldType fieldType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputAction textInputAction;
  final TextInputType inputType;
  final TextCapitalization textCapitalization;
  final int minLines;
  final int maxLines;
  final int maxLength;
  final bool isShowCounter;
  final bool isObscureText;
  final void Function(String)? onChanged;
  final VoidCallback? onTap;
  final XTextFieldStyle? style;
  final XTextFieldFileOptions? fileOptions;
  final XTextFieldDropdownOptions? dropdownOptions;
  final XTextFieldDatePickerOptions? datePickerOptions;
  final XTextFieldTimePickerOptions? timePickerOptions;

  /// Field validator - accepts standard Flutter validator function
  /// Use XFormValidator for common validations:
  /// ```dart
  /// validator: XFormValidator.required()
  /// validator: XFormValidator.combine([
  ///   XFormValidator.required(),
  ///   XFormValidator.email(),
  /// ])
  /// ```
  final String? Function(String?)? validator;

  final void Function(File?)? onFileSelected;
  final void Function(dynamic)? onDropdownChanged;
  final void Function(DateTime?)? onDateSelected;
  final void Function(TimeOfDay?)? onTimeSelected;

  /// Optional callback that's called when formKey.currentState!.save() is invoked.
  /// This is a standard Flutter Form API feature for collecting form data.
  /// If you prefer using controllers, you can ignore this.
  final void Function(String?)? onSaved;

  /// Controls when validation occurs. See [AutovalidateMode] for details.
  /// - [AutovalidateMode.disabled]: No auto validation (default)
  /// - [AutovalidateMode.always]: Validate immediately
  /// - [AutovalidateMode.onUserInteraction]: Validate after first user interaction
  final AutovalidateMode? autovalidateMode;

  /// For async/server-side validation errors (e.g., "email already exists")
  /// This is separate from the synchronous validator and will be displayed
  /// alongside validator errors. Clear this when user changes the field.
  final String? asyncErrorText;

  @override
  State<XTextField> createState() => _XTextFieldState();
}

class _XTextFieldState extends State<XTextField> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  File? _selectedFile;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  bool get _controllerIsExternal => widget.controller != null;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? TextEditingController();

    // Add listener to external controller
    if (_controllerIsExternal) {
      _controller.addListener(_onControllerChanged);
    }

    _selectedDate = widget.datePickerOptions?.initialDate;
    _selectedTime = widget.timePickerOptions?.initialTime;

    // Set initial date value
    if (widget.fieldType == XTextFieldType.datepicker &&
        _selectedDate != null) {
      _controller.text = DateFormat(
        widget.datePickerOptions?.dateFormat ?? 'dd/MM/yyyy',
      ).format(_selectedDate!);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Safe to use context here for time formatting
    if (widget.fieldType == XTextFieldType.timepicker &&
        _selectedTime != null &&
        _controller.text.isEmpty) {
      _controller.text = _formatTimeOfDay(
        _selectedTime!,
        widget.timePickerOptions?.timeFormat,
      );
    }
  }

  @override
  void didUpdateWidget(XTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update controller if changed
    if (oldWidget.controller != widget.controller) {
      if (oldWidget.controller != null) {
        oldWidget.controller!.removeListener(_onControllerChanged);
      }
      if (widget.controller != null) {
        widget.controller!.addListener(_onControllerChanged);
      }
    }

    // Update date if initialDate changed
    if (widget.fieldType == XTextFieldType.datepicker &&
        oldWidget.datePickerOptions?.initialDate !=
            widget.datePickerOptions?.initialDate) {
      _selectedDate = widget.datePickerOptions?.initialDate;
      if (_selectedDate != null) {
        _controller.text = DateFormat(
          widget.datePickerOptions?.dateFormat ?? 'dd/MM/yyyy',
        ).format(_selectedDate!);
      }
    }

    // Update time if initialTime changed
    if (widget.fieldType == XTextFieldType.timepicker &&
        oldWidget.timePickerOptions?.initialTime !=
            widget.timePickerOptions?.initialTime) {
      _selectedTime = widget.timePickerOptions?.initialTime;
      if (_selectedTime != null && mounted) {
        _controller.text = _formatTimeOfDay(
          _selectedTime!,
          widget.timePickerOptions?.timeFormat,
        );
      }
    }
  }

  @override
  void dispose() {
    if (_controllerIsExternal) {
      _controller.removeListener(_onControllerChanged);
    } else {
      _controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.label;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) _buildLabel(label),
        _buildFieldType(),
        if (widget.isShowCounter) _buildCounter(),
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
                widget.labelStyle ??
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

  /// Builds the validator function combining sync and async validations
  String? _buildValidator(String? value) {
    // First check async error (server-side validation)
    if (widget.asyncErrorText != null && widget.asyncErrorText!.isNotEmpty) {
      return widget.asyncErrorText;
    }

    // Then run the synchronous validator
    if (widget.validator != null) {
      return widget.validator!(value);
    }

    return null;
  }

  /// Builds validator for dropdown (accepts dynamic type)
  String? _buildDropdownValidator(dynamic value) {
    // Convert to string for validation
    final stringValue = value?.toString();
    return _buildValidator(stringValue);
  }

  Widget _buildNormalField({
    VoidCallback? onTapAction,
    bool? isReadOnly,
    bool? isEnable,
    Widget? suffixIcon,
  }) {
    final style = widget.style ?? const XTextFieldStyle();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        readOnly: isReadOnly ?? !widget.isEnable || widget.isReadOnly,
        enabled: isEnable ?? widget.isEnable,
        onTap: onTapAction ?? widget.onTap,
        textAlign: widget.textAlign,
        style: widget.textStyle,
        obscureText: widget.isObscureText,
        keyboardType: widget.inputType,
        textCapitalization: widget.textCapitalization,
        textInputAction: widget.textInputAction,
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        autovalidateMode: widget.autovalidateMode ?? AutovalidateMode.disabled,
        decoration: InputDecoration(
          contentPadding: widget.contentPadding,
          labelText: widget.labelOnLine,
          labelStyle: widget.labelStyle,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: widget.hintText,
          hintStyle: widget.hintStyle,
          prefixIcon: widget.prefixIcon,
          suffixIcon: suffixIcon ?? widget.suffixIcon,
          border: style.outline(),
          enabledBorder: style.outline(),
          focusedBorder: style.focusedOutline(),
          errorBorder: style.errorOutline(),
          focusedErrorBorder: style.errorOutline(),
          counterText: '',
        ),
        validator: _buildValidator,
        onSaved: widget.onSaved,
        onChanged: (v) {
          widget.onChanged?.call(v);
        },
      ),
    );
  }

  Widget _buildFileField() {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        _buildNormalField(isReadOnly: true),
        IconButton(
          onPressed: widget.isEnable ? _showFilePickerBottomSheet : null,
          icon: widget.suffixIcon ?? const Icon(Icons.file_present_sharp),
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
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.any);

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);

        if (mounted) {
          setState(() {
            _selectedFile = file;
            // Display only filename, not full path
            _controller.text = _getFileName(file.path);
          });
          // Callback gets full file object
          widget.onFileSelected?.call(file);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error picking file: $e')));
      }
    }
  }

  Widget _buildDropdownField() {
    final style = widget.style ?? const XTextFieldStyle();
    final opt = widget.dropdownOptions ?? const XTextFieldDropdownOptions();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: DropdownSearch<dynamic>(
        items: (filter, loadProps) => opt.items ?? [],
        selectedItem: opt.selectedItem,
        itemAsString: opt.itemAsString ?? (item) => item.toString(),
        compareFn: (a, b) => a == b,
        onChanged: (value) {
          widget.onDropdownChanged?.call(value);
        },
        validator: _buildDropdownValidator,
        autoValidateMode: widget.autovalidateMode ?? AutovalidateMode.disabled,
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
          ),
        ),
        popupProps: PopupProps.menu(
          showSearchBox: opt.showSearchBox,
          fit: FlexFit.loose,
          constraints: const BoxConstraints(),
        ),
      ),
    );
  }

  Widget _buildDatePickerField() {
    return _buildNormalField(
      isReadOnly: true,
      suffixIcon: IconButton(
        onPressed: widget.isEnable ? _showDatePicker : null,
        icon: widget.suffixIcon ?? const Icon(Icons.calendar_month),
      ),
      onTapAction: widget.isEnable ? _showDatePicker : null,
    );
  }

  Widget _buildTimePickerField() {
    return _buildNormalField(
      isReadOnly: true,
      suffixIcon: IconButton(
        onPressed: widget.isEnable ? _showTimePicker : null,
        icon: widget.suffixIcon ?? const Icon(Icons.access_time),
      ),
      onTapAction: widget.isEnable ? _showTimePicker : null,
    );
  }

  Future<void> _pickCamera() async {
    try {
      final picker = ImagePicker();
      final x = await picker.pickImage(source: ImageSource.camera);

      if (x != null && mounted) {
        final file = File(x.path);
        setState(() {
          _selectedFile = file;
          // Display only filename, not full path
          _controller.text = _getFileName(file.path);
        });
        // Callback gets full file object
        widget.onFileSelected?.call(file);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error accessing camera: $e')));
      }
    }
  }

  Future<void> _pickGallery() async {
    try {
      final picker = ImagePicker();
      final x = await picker.pickImage(source: ImageSource.gallery);

      if (x != null && mounted) {
        final file = File(x.path);
        setState(() {
          _selectedFile = file;
          // Display only filename, not full path
          _controller.text = _getFileName(file.path);
        });
        // Callback gets full file object
        widget.onFileSelected?.call(file);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error accessing gallery: $e')));
      }
    }
  }

  Future<void> _showDatePicker() async {
    final dateOpt = widget.datePickerOptions;
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? dateOpt?.initialDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null && mounted) {
      setState(() {
        _selectedDate = picked;
        final fmt = dateOpt?.dateFormat ?? 'dd/MM/yyyy';
        _controller.text = DateFormat(fmt).format(picked);
      });
      widget.onDateSelected?.call(picked);
    }
  }

  /// Format TimeOfDay to string based on custom format
  String _formatTimeOfDay(TimeOfDay time, String? format) {
    if (format == null || format.isEmpty) {
      // Use system default
      return time.format(context);
    }

    // Convert TimeOfDay to DateTime for formatting
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat(format).format(dt);
  }

  /// Extract filename from full path
  /// Example: "/storage/emulated/0/Download/document.pdf" -> "document.pdf"
  String _getFileName(String path) {
    return path.split('/').last;
  }

  Future<void> _showTimePicker() async {
    final picked = await showTimePicker(
      context: context,
      initialTime:
          _selectedTime ??
          widget.timePickerOptions?.initialTime ??
          TimeOfDay.now(),
    );

    if (picked != null && mounted) {
      setState(() {
        _selectedTime = picked;
        // Use custom format if provided, otherwise use system format
        _controller.text = _formatTimeOfDay(
          picked,
          widget.timePickerOptions?.timeFormat,
        );
      });
      widget.onTimeSelected?.call(picked);
    }
  }

  /// Public method to validate the field programmatically
  /// Returns true if valid, false if invalid
  bool validate() {
    return _buildValidator(_controller.text) == null;
  }

  /// Public method to clear the field
  void clear() {
    if (mounted) {
      setState(() {
        _controller.clear();
        _selectedFile = null;
        _selectedDate = null;
        _selectedTime = null;
      });
    }
  }

  /// Get the current value
  String get value => _controller.text;

  /// Get selected file (for file picker type)
  File? get selectedFile => _selectedFile;

  /// Get selected date (for date picker type)
  DateTime? get selectedDate => _selectedDate;

  /// Get selected time (for time picker type)
  TimeOfDay? get selectedTime => _selectedTime;
}
