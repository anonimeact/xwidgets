import 'dart:async';

import 'package:flutter/material.dart';

typedef XSearchCallback = FutureOr<void> Function(String query);
typedef XSearchErrorCallback =
    void Function(Object error, StackTrace stackTrace);

/// A search text field with built-in debounce, clear, submit, and loading UI.
///
/// Search results remain external, so the callback can dispatch events or
/// update any state-management solution.
class XDebouncedSearchField extends StatefulWidget {
  const XDebouncedSearchField({
    required this.onSearch,
    super.key,
    this.controller,
    this.focusNode,
    this.debounceDuration = const Duration(milliseconds: 500),
    this.minimumQueryLength = 0,
    this.onChanged,
    this.onClear,
    this.onError,
    this.decoration = const InputDecoration(
      hintText: 'Search',
      prefixIcon: Icon(Icons.search),
    ),
    this.searchOnSubmitted = true,
    this.searchOnEmpty = true,
    this.showClearButton = true,
    this.showLoadingIndicator = true,
    this.enabled = true,
    this.autofocus = false,
    this.textInputAction = TextInputAction.search,
    this.keyboardType = TextInputType.text,
    this.loadingBuilder,
  }) : assert(minimumQueryLength >= 0);

  /// Called after the query remains unchanged for [debounceDuration].
  final XSearchCallback onSearch;

  /// Optional externally owned text controller.
  final TextEditingController? controller;

  /// Optional externally owned focus node.
  final FocusNode? focusNode;

  /// Delay between typing and [onSearch].
  final Duration debounceDuration;

  /// Minimum query length required before searching.
  final int minimumQueryLength;

  /// Receives every raw text change without debounce.
  final ValueChanged<String>? onChanged;

  /// Called after the clear action.
  final VoidCallback? onClear;

  /// Receives asynchronous errors thrown by [onSearch].
  final XSearchErrorCallback? onError;

  /// Native text-field decoration.
  final InputDecoration decoration;

  /// Executes immediately when the keyboard search action is submitted.
  final bool searchOnSubmitted;

  /// Allows an empty query to trigger [onSearch], including after clear.
  final bool searchOnEmpty;

  /// Shows a clear action when text is present.
  final bool showClearButton;

  /// Shows an indicator while an asynchronous search is running.
  final bool showLoadingIndicator;

  final bool enabled;
  final bool autofocus;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;

  /// Builds a custom asynchronous search indicator.
  final WidgetBuilder? loadingBuilder;

  @override
  State<XDebouncedSearchField> createState() => _XDebouncedSearchFieldState();
}

class _XDebouncedSearchFieldState extends State<XDebouncedSearchField> {
  late TextEditingController _controller;
  Timer? _timer;
  bool _isSearching = false;
  int _searchGeneration = 0;

  bool get _ownsController => widget.controller == null;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_handleControllerChange);
  }

  @override
  void didUpdateWidget(covariant XDebouncedSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _controller.removeListener(_handleControllerChange);
      if (oldWidget.controller == null) _controller.dispose();
      _controller = widget.controller ?? TextEditingController();
      _controller.addListener(_handleControllerChange);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.removeListener(_handleControllerChange);
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  void _handleControllerChange() {
    if (mounted) setState(() {});
  }

  void _handleChanged(String query) {
    widget.onChanged?.call(query);
    _timer?.cancel();
    if (!_canSearch(query)) return;

    _timer = Timer(widget.debounceDuration, () => _executeSearch(query));
  }

  bool _canSearch(String query) {
    if (query.isEmpty) return widget.searchOnEmpty;
    return query.length >= widget.minimumQueryLength;
  }

  Future<void> _executeSearch(String query) async {
    if (!_canSearch(query)) return;
    final generation = ++_searchGeneration;
    setState(() => _isSearching = true);
    try {
      await widget.onSearch(query);
    } catch (error, stackTrace) {
      if (widget.onError != null) {
        widget.onError!(error, stackTrace);
      } else {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: error,
            stack: stackTrace,
            library: 'xwidgets_pack',
            context: ErrorDescription('while executing a debounced search'),
          ),
        );
      }
    } finally {
      if (mounted && generation == _searchGeneration) {
        setState(() => _isSearching = false);
      }
    }
  }

  void _handleSubmitted(String query) {
    if (!widget.searchOnSubmitted) return;
    _timer?.cancel();
    _executeSearch(query);
  }

  void _clear() {
    _timer?.cancel();
    _controller.clear();
    widget.onChanged?.call('');
    widget.onClear?.call();
    if (widget.searchOnEmpty) _executeSearch('');
  }

  @override
  Widget build(BuildContext context) {
    final originalSuffix = widget.decoration.suffixIcon;
    Widget? suffix = originalSuffix;
    if (_isSearching && widget.showLoadingIndicator) {
      suffix =
          widget.loadingBuilder?.call(context) ??
          const Padding(
            padding: EdgeInsets.all(12),
            child: SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
    } else if (widget.showClearButton && _controller.text.isNotEmpty) {
      suffix = IconButton(
        tooltip: 'Clear search',
        onPressed: widget.enabled ? _clear : null,
        icon: const Icon(Icons.clear),
      );
    }

    return TextField(
      controller: _controller,
      focusNode: widget.focusNode,
      decoration: widget.decoration.copyWith(suffixIcon: suffix),
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      onChanged: _handleChanged,
      onSubmitted: _handleSubmitted,
    );
  }
}
