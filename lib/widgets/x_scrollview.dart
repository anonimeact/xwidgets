import 'dart:async';

import 'package:flutter/material.dart';

/// Describes one data request made by [XScrollView].
class XScrollRequest {
  const XScrollRequest({
    required this.page,
    required this.offset,
    required this.limit,
    required this.isRefresh,
  });

  /// One-based page number.
  final int page;

  /// Number of items already loaded.
  final int offset;

  /// Maximum number of items requested for this load.
  final int limit;

  /// Whether this request was triggered by pull-to-refresh.
  final bool isRefresh;
}

/// A page returned by an [XScrollFetcher].
class XScrollPage<T> {
  const XScrollPage({required this.items, this.hasMore});

  /// Items returned for the current request.
  final List<T> items;

  /// Whether another page is available.
  ///
  /// When omitted, [XScrollView] infers it from whether [items] contains at
  /// least the requested number of items.
  final bool? hasMore;
}

typedef XScrollFetcher<T> =
    FutureOr<XScrollPage<T>> Function(XScrollRequest request);
typedef XScrollItemBuilder<T> =
    Widget Function(BuildContext context, T item, int index);
typedef XScrollItemTap<T> = void Function(T item, int index);
typedef XScrollErrorBuilder =
    Widget Function(BuildContext context, Object error, VoidCallback retry);
typedef XScrollRefreshIndicatorBuilder =
    Widget Function(BuildContext context, double progress, bool isRefreshing);

/// A reusable, paginated scroll view with first-load, refresh, and retry
/// handling.
///
/// The widget owns only its presentation state. Fetch callbacks can call any
/// repository or state-management solution and [onItemsChanged] can be used to
/// mirror the accumulated items into external state.
class XScrollView<T> extends StatefulWidget {
  const XScrollView({
    required this.itemBuilder,
    super.key,
    this.onInit,
    this.onLoadMore,
    this.onItemsChanged,
    this.onItemTap,
    this.initialItems = const [],
    this.initialHasMore = true,
    this.pageSize = 20,
    this.autoLoad = true,
    this.enableRefresh = true,
    this.scrollDirection = Axis.vertical,
    this.refreshTriggerExtent = 80,
    this.paginationThreshold = 200,
    this.controller,
    this.padding,
    this.physics,
    this.gridDelegate,
    this.separatorBuilder,
    this.header,
    this.footer,
    this.loadingBuilder,
    this.emptyBuilder,
    this.errorBuilder,
    this.paginationLoadingBuilder,
    this.paginationErrorBuilder,
    this.refreshIndicatorBuilder,
    this.horizontalRefreshIndicatorBuilder,
    this.shrinkWrap = false,
    this.reverse = false,
    this.primary,
    this.cacheExtent,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
  }) : assert(pageSize > 0),
       assert(refreshTriggerExtent > 0),
       assert(paginationThreshold >= 0);

  /// Fetches the first page when the widget is mounted or refreshed.
  final XScrollFetcher<T>? onInit;

  /// Fetches the next page when the remaining scroll extent reaches
  /// [paginationThreshold].
  final XScrollFetcher<T>? onLoadMore;

  /// Reports the complete accumulated item list after a successful fetch.
  final ValueChanged<List<T>>? onItemsChanged;

  final XScrollItemTap<T>? onItemTap;
  final XScrollItemBuilder<T> itemBuilder;

  /// Items shown before the first fetch completes.
  final List<T> initialItems;

  /// Initial pagination state, useful when only [initialItems] are supplied.
  final bool initialHasMore;

  /// Number of items requested on every first or next-page fetch.
  final int pageSize;

  /// Whether [onInit] runs automatically after the first frame.
  final bool autoLoad;

  /// Enables pull-to-refresh when [onInit] is provided.
  final bool enableRefresh;

  /// Direction in which the items scroll.
  ///
  /// Both directions support pagination and pull-to-refresh.
  final Axis scrollDirection;

  /// Overscroll distance required to trigger a custom refresh.
  ///
  /// This applies to horizontal lists and vertical lists using
  /// [refreshIndicatorBuilder]. Vertical lists without a custom builder use
  /// Flutter's native [RefreshIndicator] threshold.
  final double refreshTriggerExtent;

  /// Starts loading the next page when this many logical pixels remain.
  final double paginationThreshold;

  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;

  /// When supplied, renders items with [GridView] instead of [ListView].
  ///
  /// Grid mode cannot be combined with [separatorBuilder].
  final SliverGridDelegate? gridDelegate;

  final IndexedWidgetBuilder? separatorBuilder;
  final Widget? header;
  final Widget? footer;
  final WidgetBuilder? loadingBuilder;
  final WidgetBuilder? emptyBuilder;
  final XScrollErrorBuilder? errorBuilder;
  final WidgetBuilder? paginationLoadingBuilder;
  final XScrollErrorBuilder? paginationErrorBuilder;

  /// Custom indicator used while pulling or refreshing in either direction.
  ///
  /// Supplying this replaces the native vertical [RefreshIndicator] as well as
  /// the default horizontal indicator.
  final XScrollRefreshIndicatorBuilder? refreshIndicatorBuilder;

  /// Custom indicator used while pulling or refreshing a horizontal list.
  @Deprecated('Use refreshIndicatorBuilder, which supports both directions.')
  final XScrollRefreshIndicatorBuilder? horizontalRefreshIndicatorBuilder;
  final bool shrinkWrap;
  final bool reverse;
  final bool? primary;
  final double? cacheExtent;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;
  final Clip clipBehavior;

  @override
  State<XScrollView<T>> createState() => _XScrollViewState<T>();
}

class _XScrollViewState<T> extends State<XScrollView<T>> {
  late List<T> _items;
  late ScrollController _controller;
  late bool _hasMore;

  bool _isInitialLoading = false;
  bool _isLoadingMore = false;
  Object? _initialError;
  Object? _paginationError;
  int _nextPage = 2;
  double _refreshExtent = 0;
  bool _isCustomRefreshing = false;

  bool get _ownsController => widget.controller == null;

  @override
  void initState() {
    super.initState();
    _items = List<T>.of(widget.initialItems);
    _hasMore = widget.initialHasMore;
    _controller = widget.controller ?? ScrollController();
    _controller.addListener(_handleScroll);

    if (widget.autoLoad && widget.onInit != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadInitial());
    }
  }

  @override
  void didUpdateWidget(covariant XScrollView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _controller.removeListener(_handleScroll);
      if (oldWidget.controller == null) {
        _controller.dispose();
      }
      _controller = widget.controller ?? ScrollController();
      _controller.addListener(_handleScroll);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleScroll);
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleScroll() {
    if (!_controller.hasClients ||
        _controller.position.extentAfter > widget.paginationThreshold) {
      return;
    }
    _loadMore();
  }

  Future<void> _loadInitial({bool isRefresh = false}) async {
    final fetcher = widget.onInit;
    if (fetcher == null || _isInitialLoading || _isLoadingMore) return;

    setState(() {
      _isInitialLoading = true;
      _initialError = null;
      _paginationError = null;
    });

    try {
      final page = await fetcher(
        XScrollRequest(
          page: 1,
          offset: 0,
          limit: widget.pageSize,
          isRefresh: isRefresh,
        ),
      );
      if (!mounted) return;

      setState(() {
        _items = List<T>.of(page.items);
        _hasMore = page.hasMore ?? page.items.length >= widget.pageSize;
        _nextPage = 2;
      });
      widget.onItemsChanged?.call(List<T>.unmodifiable(_items));
    } catch (error) {
      if (!mounted) return;
      setState(() => _initialError = error);
    } finally {
      if (mounted) {
        setState(() => _isInitialLoading = false);
      }
    }
  }

  Future<void> _loadMore() async {
    final fetcher = widget.onLoadMore;
    if (fetcher == null || !_hasMore || _isInitialLoading || _isLoadingMore) {
      return;
    }

    setState(() {
      _isLoadingMore = true;
      _paginationError = null;
    });

    try {
      final page = await fetcher(
        XScrollRequest(
          page: _nextPage,
          offset: _items.length,
          limit: widget.pageSize,
          isRefresh: false,
        ),
      );
      if (!mounted) return;

      setState(() {
        _items.addAll(page.items);
        _hasMore = page.hasMore ?? page.items.length >= widget.pageSize;
        _nextPage++;
      });
      widget.onItemsChanged?.call(List<T>.unmodifiable(_items));
    } catch (error) {
      if (!mounted) return;
      setState(() => _paginationError = error);
    } finally {
      if (mounted) {
        setState(() => _isLoadingMore = false);
      }
    }
  }

  Future<void> _refresh() => _loadInitial(isRefresh: true);

  @override
  Widget build(BuildContext context) {
    if (_isInitialLoading && _items.isEmpty) {
      return widget.loadingBuilder?.call(context) ??
          const Center(child: CircularProgressIndicator());
    }

    if (_initialError != null && _items.isEmpty) {
      return widget.errorBuilder?.call(context, _initialError!, _loadInitial) ??
          _DefaultErrorView(error: _initialError!, onRetry: _loadInitial);
    }

    final effectivePhysics = widget.enableRefresh && widget.onInit != null
        ? widget.physics ?? const AlwaysScrollableScrollPhysics()
        : widget.physics;
    final gridDelegate = widget.gridDelegate;
    final Widget scrollView;
    if (gridDelegate == null || _items.isEmpty) {
      scrollView = ListView.builder(
        controller: _controller,
        scrollDirection: widget.scrollDirection,
        padding: widget.padding,
        physics: effectivePhysics,
        shrinkWrap: widget.shrinkWrap,
        reverse: widget.reverse,
        primary: widget.primary ?? false,
        cacheExtent: widget.cacheExtent,
        keyboardDismissBehavior: widget.keyboardDismissBehavior,
        restorationId: widget.restorationId,
        clipBehavior: widget.clipBehavior,
        itemCount: _itemCount,
        itemBuilder: _buildItem,
      );
    } else {
      assert(
        widget.separatorBuilder == null,
        'separatorBuilder is not supported in grid mode.',
      );
      scrollView = GridView.builder(
        controller: _controller,
        scrollDirection: widget.scrollDirection,
        padding: widget.padding,
        physics: effectivePhysics,
        shrinkWrap: widget.shrinkWrap,
        reverse: widget.reverse,
        primary: widget.primary ?? false,
        cacheExtent: widget.cacheExtent,
        keyboardDismissBehavior: widget.keyboardDismissBehavior,
        restorationId: widget.restorationId,
        clipBehavior: widget.clipBehavior,
        gridDelegate: gridDelegate,
        itemCount: _itemCount,
        itemBuilder: _buildItem,
      );
    }

    if (!widget.enableRefresh || widget.onInit == null) return scrollView;
    if (widget.scrollDirection == Axis.vertical &&
        widget.refreshIndicatorBuilder == null) {
      return RefreshIndicator(onRefresh: _refresh, child: scrollView);
    }
    return _buildCustomRefreshView(scrollView);
  }

  Widget _buildCustomRefreshView(Widget scrollView) {
    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: _handleCustomRefreshNotification,
          child: scrollView,
        ),
        if (_refreshExtent > 0 || _isCustomRefreshing)
          IgnorePointer(
            child: Align(
              alignment: _refreshIndicatorAlignment,
              child:
                  widget.refreshIndicatorBuilder?.call(
                    context,
                    (_refreshExtent / widget.refreshTriggerExtent).clamp(0, 1),
                    _isCustomRefreshing,
                  ) ??
                  widget.horizontalRefreshIndicatorBuilder?.call(
                    context,
                    (_refreshExtent / widget.refreshTriggerExtent).clamp(0, 1),
                    _isCustomRefreshing,
                  ) ??
                  _DefaultRefreshIndicator(
                    progress: (_refreshExtent / widget.refreshTriggerExtent)
                        .clamp(0, 1),
                    isRefreshing: _isCustomRefreshing,
                  ),
            ),
          ),
      ],
    );
  }

  Alignment get _refreshIndicatorAlignment {
    if (widget.scrollDirection == Axis.vertical) {
      return widget.reverse ? Alignment.bottomCenter : Alignment.topCenter;
    }

    final isLeftToRight = Directionality.of(context) == TextDirection.ltr;
    final startsOnLeft = isLeftToRight != widget.reverse;
    return startsOnLeft ? Alignment.centerLeft : Alignment.centerRight;
  }

  bool _handleCustomRefreshNotification(ScrollNotification notification) {
    if (notification.depth != 0 || _isCustomRefreshing) return false;

    if (notification is OverscrollNotification &&
        notification.metrics.extentBefore == 0) {
      setState(() {
        _refreshExtent = (_refreshExtent + notification.overscroll.abs()).clamp(
          0,
          widget.refreshTriggerExtent * 1.5,
        );
      });
    } else if (notification is ScrollUpdateNotification &&
        notification.metrics.extentBefore > 0 &&
        _refreshExtent > 0) {
      setState(() => _refreshExtent = 0);
    } else if (notification is ScrollEndNotification && _refreshExtent > 0) {
      if (_refreshExtent >= widget.refreshTriggerExtent) {
        _runCustomRefresh();
      } else {
        setState(() => _refreshExtent = 0);
      }
    }
    return false;
  }

  Future<void> _runCustomRefresh() async {
    if (_isCustomRefreshing) return;
    setState(() {
      _isCustomRefreshing = true;
      _refreshExtent = widget.refreshTriggerExtent;
    });
    try {
      await _refresh();
    } finally {
      if (mounted) {
        setState(() {
          _isCustomRefreshing = false;
          _refreshExtent = 0;
        });
      }
    }
  }

  int get _itemCount {
    if (_items.isEmpty) return 1;
    return _items.length +
        (widget.header == null ? 0 : 1) +
        (_showPaginationFooter ? 1 : 0) +
        (widget.footer == null ? 0 : 1);
  }

  bool get _showPaginationFooter => _isLoadingMore || _paginationError != null;

  Widget _buildItem(BuildContext context, int position) {
    if (_items.isEmpty) {
      return widget.emptyBuilder?.call(context) ??
          const Center(child: Text('No data available'));
    }

    var cursor = position;
    if (widget.header != null) {
      if (cursor == 0) return widget.header!;
      cursor--;
    }

    if (cursor < _items.length) {
      final index = cursor;
      Widget child = widget.itemBuilder(context, _items[index], index);
      if (widget.onItemTap != null) {
        child = InkWell(
          onTap: () => widget.onItemTap!(_items[index], index),
          child: child,
        );
      }
      if (widget.separatorBuilder != null && index > 0) {
        child = Flex(
          direction: widget.scrollDirection,
          mainAxisSize: MainAxisSize.min,
          children: [widget.separatorBuilder!(context, index - 1), child],
        );
      }
      return child;
    }
    cursor -= _items.length;

    if (_showPaginationFooter) {
      if (cursor == 0) return _buildPaginationFooter(context);
      cursor--;
    }

    return widget.footer ?? const SizedBox.shrink();
  }

  Widget _buildPaginationFooter(BuildContext context) {
    if (_paginationError != null) {
      return widget.paginationErrorBuilder?.call(
            context,
            _paginationError!,
            _loadMore,
          ) ??
          _DefaultErrorView(
            error: _paginationError!,
            onRetry: _loadMore,
            compact: true,
          );
    }
    return widget.paginationLoadingBuilder?.call(context) ??
        const Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        );
  }
}

class _DefaultRefreshIndicator extends StatelessWidget {
  const _DefaultRefreshIndicator({
    required this.progress,
    required this.isRefreshing,
  });

  final double progress;
  final bool isRefreshing;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, spreadRadius: 1),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox.square(
          dimension: 24,
          child: CircularProgressIndicator(
            value: isRefreshing ? null : progress,
            strokeWidth: 2.5,
          ),
        ),
      ),
    );
  }
}

class _DefaultErrorView extends StatelessWidget {
  const _DefaultErrorView({
    required this.error,
    required this.onRetry,
    this.compact = false,
  });

  final Object error;
  final VoidCallback onRetry;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(compact ? 12 : 24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            const SizedBox(height: 8),
            TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
