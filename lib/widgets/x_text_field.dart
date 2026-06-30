import 'dart:ui' as ui show BoxHeightStyle, BoxWidthStyle;

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:file_selector/file_selector.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;
import 'package:image_picker/image_picker.dart';

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
    this.groupId = EditableText,
    this.restorationId,
    this.controller,
    this.focusNode,
    this.decoration,
    this.textStyle,
    this.strutStyle,
    this.textDirection,
    this.textAlignVertical,
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
    this.onTapAlwaysCalled = false,
    this.onTapOutside,
    this.onTapUpOutside,
    this.onEditingComplete,
    this.onFieldSubmitted,
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
    this.floatingLabelBehavior = .auto,
    this.autofocus = false,
    this.showCursor,
    this.obscuringCharacter = '•',
    this.autocorrect = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    this.maxLengthEnforcement,
    this.expands = false,
    this.inputFormatters,
    this.enabled,
    this.ignorePointers,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor = Colors.black87,
    this.cursorErrorColor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection,
    this.selectAllOnFocus,
    this.selectionControls,
    this.buildCounter,
    this.scrollPhysics,
    this.autofillHints,
    this.scrollController,
    this.enableIMEPersonalizedLearning = true,
    this.mouseCursor,
    this.contextMenuBuilder,
    this.spellCheckConfiguration,
    this.magnifierConfiguration,
    this.undoController,
    this.onAppPrivateCommand,
    this.cursorOpacityAnimates,
    this.selectionHeightStyle,
    this.selectionWidthStyle,
    this.dragStartBehavior = DragStartBehavior.start,
    this.contentInsertionConfiguration,
    this.statesController,
    this.clipBehavior = Clip.hardEdge,
    this.stylusHandwritingEnabled =
        EditableText.defaultStylusHandwritingEnabled,
    this.canRequestFocus = true,
    this.hintLocales,
  });

  /// Identifier used by [EditableText] to group text fields for shared behavior.
  final Object groupId;

  /// Restoration ID for state restoration.
  final String? restorationId;

  /// Controller for managing the text field's value.
  /// If not provided, an internal controller is created.
  final TextEditingController? controller;

  /// Focus node for controlling focus state.
  final FocusNode? focusNode;

  /// Full [InputDecoration] override for [TextFormField].
  final InputDecoration? decoration;

  /// Text style within the field.
  final TextStyle? textStyle;

  /// Strut style for vertical text metrics.
  final StrutStyle? strutStyle;

  /// Text direction.
  final TextDirection? textDirection;

  /// Vertical alignment for text.
  final TextAlignVertical? textAlignVertical;

  /// Label text style displayed above the field.
  final TextStyle? labelStyle;

  /// Hint text style displayed when the field is empty.
  final TextStyle? hintStyle;

  /// Text alignment within the field.
  /// Defaults to [TextAlign.start].
  final TextAlign textAlign;

  /// Padding inside the text field.
  /// If null, default padding is applied.
  final EdgeInsets? contentPadding;

  /// Label text style displayed above the field.
  final String? label;

  /// Label text displayed on the same line as the field.
  final String? labelOnLine;

  /// Hint text displayed when the field is empty.
  final String? hintText;

  /// Whether the field is required.
  /// Defaults to `false`.
  final bool isRequired;

  /// Whether the field is enabled.
  /// Defaults to `true`.
  final bool isEnable;

  /// Whether the field is read-only.
  /// Defaults to `false`.
  final bool isReadOnly;

  /// Type of field to display.
  /// Defaults to [XTextFieldType.normal].
  final XTextFieldType fieldType;

  /// Prefix icon widget.
  /// For file picker, dropdown, date picker, and time picker types,
  /// it's recommended to use an [IconButton] to trigger the respective action.
  final Widget? prefixIcon;

  /// Suffix icon widget.
  /// For file picker, dropdown, date picker, and time picker types,
  /// it's recommended to use an [IconButton] to trigger the respective action.
  final Widget? suffixIcon;

  /// Action button on the keyboard.
  /// Defaults to `TextInputAction.next`.
  final TextInputAction textInputAction;

  /// Type of keyboard to use for text input.
  /// Defaults to `TextInputType.text`.
  final TextInputType inputType;

  /// Text capitalization behavior.
  /// Defaults to `TextCapitalization.sentences`.
  final TextCapitalization textCapitalization;

  /// Behavior of the floating label.
  /// Defaults to `FloatingLabelBehavior.auto`.
  final FloatingLabelBehavior floatingLabelBehavior;

  /// Minimum lines of input.
  final int minLines;

  /// Minimum lines of input.
  final int maxLines;

  /// Maximum length of input text.
  final int maxLength;

  /// Whether to show character counter below the field.
  /// Defaults to `false`.
  final bool isShowCounter;

  /// Whether to obscure the text (for password fields).
  final bool isObscureText;

  /// Callback when the field value changes.
  final void Function(String)? onChanged;

  /// Callback when the field is tapped.
  final VoidCallback? onTap;

  /// Whether to call [onTap] for each tap even when focused.
  final bool onTapAlwaysCalled;

  /// Callback when tapped outside of this text field.
  final TapRegionCallback? onTapOutside;

  /// Callback when tap-up happens outside of this text field.
  final TapRegionUpCallback? onTapUpOutside;

  /// Callback for editing completion.
  final VoidCallback? onEditingComplete;

  /// Callback when user submits text from keyboard action.
  final ValueChanged<String>? onFieldSubmitted;

  /// Style customization for the text field.
  /// If null, default styles are applied.
  final XTextFieldStyle? style;

  /// Options for file picker field.
  final XTextFieldFileOptions? fileOptions;

  /// Options for dropdown field.
  final XTextFieldDropdownOptions? dropdownOptions;

  /// Options for date picker field.
  final XTextFieldDatePickerOptions? datePickerOptions;

  /// Options for time picker field.
  final XTextFieldTimePickerOptions? timePickerOptions;

  /// Color of the text cursor.
  /// Defaults to `Colors.black87`.
  final Color? cursorColor;

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

  final void Function(XFile?)? onFileSelected;
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

  /// Whether this field should be focused initially.
  final bool autofocus;

  /// Whether to show cursor.
  final bool? showCursor;

  /// Character used for obscured text.
  final String obscuringCharacter;

  /// Whether to enable autocorrect.
  final bool autocorrect;

  /// Smart dashes behavior.
  final SmartDashesType? smartDashesType;

  /// Smart quotes behavior.
  final SmartQuotesType? smartQuotesType;

  /// Whether to enable suggestions.
  final bool enableSuggestions;

  /// Max length enforcement behavior.
  final MaxLengthEnforcement? maxLengthEnforcement;

  /// Whether this field expands to fill available space.
  final bool expands;

  /// Text input formatters.
  final List<TextInputFormatter>? inputFormatters;

  /// Optional direct enabled override.
  final bool? enabled;

  /// Whether to ignore pointers.
  final bool? ignorePointers;

  /// Width of cursor.
  final double cursorWidth;

  /// Height of cursor.
  final double? cursorHeight;

  /// Radius for cursor corners.
  final Radius? cursorRadius;

  /// Cursor error color.
  final Color? cursorErrorColor;

  /// Keyboard appearance brightness.
  final Brightness? keyboardAppearance;

  /// Scroll padding around editable region.
  final EdgeInsets scrollPadding;

  /// Whether interactive selection is enabled.
  final bool? enableInteractiveSelection;

  /// Whether to select all text on focus.
  final bool? selectAllOnFocus;

  /// Text selection controls.
  final TextSelectionControls? selectionControls;

  /// Custom max length counter builder.
  final InputCounterWidgetBuilder? buildCounter;

  /// Scroll physics for editable text.
  final ScrollPhysics? scrollPhysics;

  /// Autofill hints.
  final Iterable<String>? autofillHints;

  /// Scroll controller for editable text.
  final ScrollController? scrollController;

  /// Whether IME personalized learning is enabled.
  final bool enableIMEPersonalizedLearning;

  /// Mouse cursor when hovering this field.
  final MouseCursor? mouseCursor;

  /// Context menu builder.
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  /// Spell check configuration.
  final SpellCheckConfiguration? spellCheckConfiguration;

  /// Magnifier configuration.
  final TextMagnifierConfiguration? magnifierConfiguration;

  /// Undo history controller.
  final UndoHistoryController? undoController;

  /// Callback for app private command.
  final AppPrivateCommandCallback? onAppPrivateCommand;

  /// Whether cursor opacity animates.
  final bool? cursorOpacityAnimates;

  /// Selection height style.
  final ui.BoxHeightStyle? selectionHeightStyle;

  /// Selection width style.
  final ui.BoxWidthStyle? selectionWidthStyle;

  /// Drag start behavior.
  final DragStartBehavior dragStartBehavior;

  /// Content insertion configuration.
  final ContentInsertionConfiguration? contentInsertionConfiguration;

  /// State controller for text field material states.
  // ignore: deprecated_member_use
  final MaterialStatesController? statesController;

  /// Clip behavior of text field.
  final Clip clipBehavior;

  /// Whether stylus handwriting is enabled.
  final bool stylusHandwritingEnabled;

  /// Whether this field can request focus.
  final bool canRequestFocus;

  /// Hint locales used by input method.
  final List<Locale>? hintLocales;

  /// For async/server-side validation errors (e.g., "email already exists")
  /// This is separate from the synchronous validator and will be displayed
  /// alongside validator errors. Clear this when user changes the field.
  final String? asyncErrorText;

  @override
  State<XTextField> createState() => _XTextFieldState();
}

class _XTextFieldState extends State<XTextField> {
  late final TextEditingController _controller;
  late final FocusNode _internalFocusNode;

  XFile? _selectedFile;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  bool get _controllerIsExternal => widget.controller != null;
  FocusNode get _effectiveFocusNode => widget.focusNode ?? _internalFocusNode;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? TextEditingController();
    _internalFocusNode = FocusNode();

    // Add listener to external controller
    if (_controllerIsExternal) {
      _controller.addListener(_onControllerChanged);
    }

    _selectedDate = widget.datePickerOptions?.initialDate;
    _selectedTime = widget.timePickerOptions?.initialTime;

    // Set initial date value
    if (widget.fieldType == XTextFieldType.datepicker &&
        _selectedDate != null) {
      _controller.text = intl.DateFormat(
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
        _controller.text = intl.DateFormat(
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
    _internalFocusNode.dispose();
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
    final enabled = (isEnable ?? widget.isEnable) && (widget.enabled ?? true);
    final decoration = (widget.decoration ?? const InputDecoration()).copyWith(
      contentPadding: widget.contentPadding,
      labelText: widget.labelOnLine,
      labelStyle: widget.labelStyle,
      floatingLabelBehavior: widget.floatingLabelBehavior,
      hintText: widget.hintText,
      hintStyle: widget.hintStyle,
      prefixIcon: widget.prefixIcon,
      suffixIcon: suffixIcon ?? widget.suffixIcon,
      border: style.outline(),
      enabledBorder: style.outline(),
      focusedBorder: style.focusedOutline(),
      errorBorder: style.errorOutline(),
      focusedErrorBorder: style.errorOutline(),
      counterText: widget.isShowCounter ? null : '',
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        groupId: widget.groupId,
        restorationId: widget.restorationId,
        controller: _controller,
        focusNode: _effectiveFocusNode,
        readOnly: isReadOnly ?? !enabled || widget.isReadOnly,
        enabled: enabled,
        onTap: onTapAction ?? widget.onTap,
        onTapAlwaysCalled: widget.onTapAlwaysCalled,
        onTapOutside: widget.onTapOutside,
        onTapUpOutside: widget.onTapUpOutside,
        onEditingComplete: widget.onEditingComplete,
        onFieldSubmitted: widget.onFieldSubmitted,
        textAlign: widget.textAlign,
        textAlignVertical: widget.textAlignVertical,
        textDirection: widget.textDirection,
        style: widget.textStyle,
        strutStyle: widget.strutStyle,
        autofocus: widget.autofocus,
        showCursor: widget.showCursor,
        obscuringCharacter: widget.obscuringCharacter,
        obscureText: widget.isObscureText,
        autocorrect: widget.autocorrect,
        smartDashesType: widget.smartDashesType,
        smartQuotesType: widget.smartQuotesType,
        enableSuggestions: widget.enableSuggestions,
        keyboardType: widget.inputType,
        keyboardAppearance: widget.keyboardAppearance,
        textCapitalization: widget.textCapitalization,
        textInputAction: widget.textInputAction,
        maxLengthEnforcement: widget.maxLengthEnforcement,
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        expands: widget.expands,
        maxLength: widget.maxLength,
        inputFormatters: widget.inputFormatters,
        ignorePointers: widget.ignorePointers,
        cursorWidth: widget.cursorWidth,
        cursorHeight: widget.cursorHeight,
        cursorRadius: widget.cursorRadius,
        autovalidateMode: widget.autovalidateMode ?? AutovalidateMode.disabled,
        cursorColor: widget.cursorColor,
        cursorErrorColor: widget.cursorErrorColor,
        scrollPadding: widget.scrollPadding,
        enableInteractiveSelection: widget.enableInteractiveSelection,
        selectAllOnFocus: widget.selectAllOnFocus,
        selectionControls: widget.selectionControls,
        buildCounter: widget.buildCounter,
        scrollPhysics: widget.scrollPhysics,
        autofillHints: widget.autofillHints,
        scrollController: widget.scrollController,
        enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
        mouseCursor: widget.mouseCursor,
        contextMenuBuilder: widget.contextMenuBuilder,
        spellCheckConfiguration: widget.spellCheckConfiguration,
        magnifierConfiguration: widget.magnifierConfiguration,
        undoController: widget.undoController,
        onAppPrivateCommand: widget.onAppPrivateCommand,
        cursorOpacityAnimates: widget.cursorOpacityAnimates,
        selectionHeightStyle: widget.selectionHeightStyle,
        selectionWidthStyle: widget.selectionWidthStyle,
        dragStartBehavior: widget.dragStartBehavior,
        contentInsertionConfiguration: widget.contentInsertionConfiguration,
        statesController: widget.statesController,
        clipBehavior: widget.clipBehavior,
        stylusHandwritingEnabled: widget.stylusHandwritingEnabled,
        canRequestFocus: widget.canRequestFocus,
        hintLocales: widget.hintLocales,
        decoration: decoration,
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
      final file = await openFile();

      if (file != null && mounted) {
        setState(() {
          _selectedFile = file;
          _controller.text = file.name;
        });
        widget.onFileSelected?.call(file);
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
        onSelected: (value) {
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
      final file = await picker.pickImage(source: ImageSource.camera);

      if (file != null && mounted) {
        setState(() {
          _selectedFile = file;
          _controller.text = file.name;
        });
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
      final file = await picker.pickImage(source: ImageSource.gallery);

      if (file != null && mounted) {
        setState(() {
          _selectedFile = file;
          _controller.text = file.name;
        });
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
        _controller.text = intl.DateFormat(fmt).format(picked);
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
    return intl.DateFormat(format).format(dt);
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
  XFile? get selectedFile => _selectedFile;

  /// Get selected date (for date picker type)
  DateTime? get selectedDate => _selectedDate;

  /// Get selected time (for time picker type)
  TimeOfDay? get selectedTime => _selectedTime;
}
