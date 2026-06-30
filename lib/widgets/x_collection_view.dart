import 'package:flutter/material.dart';

import 'x_scrollview.dart';

/// Collection layouts supported by [XCollectionView].
enum XCollectionLayout { list, grid }

/// A list or grid with the same fetch, refresh, pagination, and state API.
///
/// This is a convenience layer over [XScrollView] for screens that may switch
/// between list and grid presentation without rewriting data-loading logic.
class XCollectionView<T> extends StatelessWidget {
  /// Creates a paginated list collection.
  const XCollectionView.list({
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
    this.separatorBuilder,
    this.header,
    this.footer,
    this.loadingBuilder,
    this.emptyBuilder,
    this.errorBuilder,
    this.paginationLoadingBuilder,
    this.paginationErrorBuilder,
    this.refreshIndicatorBuilder,
    this.shrinkWrap = false,
    this.reverse = false,
    this.cacheExtent,
  }) : layout = XCollectionLayout.list,
       gridDelegate = null;

  /// Creates a paginated grid collection.
  const XCollectionView.grid({
    required this.itemBuilder,
    required this.gridDelegate,
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
    this.header,
    this.footer,
    this.loadingBuilder,
    this.emptyBuilder,
    this.errorBuilder,
    this.paginationLoadingBuilder,
    this.paginationErrorBuilder,
    this.refreshIndicatorBuilder,
    this.shrinkWrap = false,
    this.reverse = false,
    this.cacheExtent,
  }) : layout = XCollectionLayout.grid,
       separatorBuilder = null;

  /// Selected collection layout.
  final XCollectionLayout layout;

  /// Delegate controlling grid sizing in [XCollectionLayout.grid].
  final SliverGridDelegate? gridDelegate;

  final XScrollItemBuilder<T> itemBuilder;
  final XScrollFetcher<T>? onInit;
  final XScrollFetcher<T>? onLoadMore;
  final ValueChanged<List<T>>? onItemsChanged;
  final XScrollItemTap<T>? onItemTap;
  final List<T> initialItems;
  final bool initialHasMore;
  final int pageSize;
  final bool autoLoad;
  final bool enableRefresh;
  final Axis scrollDirection;
  final double refreshTriggerExtent;
  final double paginationThreshold;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final IndexedWidgetBuilder? separatorBuilder;
  final Widget? header;
  final Widget? footer;
  final WidgetBuilder? loadingBuilder;
  final WidgetBuilder? emptyBuilder;
  final XScrollErrorBuilder? errorBuilder;
  final WidgetBuilder? paginationLoadingBuilder;
  final XScrollErrorBuilder? paginationErrorBuilder;
  final XScrollRefreshIndicatorBuilder? refreshIndicatorBuilder;
  final bool shrinkWrap;
  final bool reverse;
  final double? cacheExtent;

  @override
  Widget build(BuildContext context) {
    return XScrollView<T>(
      onInit: onInit,
      onLoadMore: onLoadMore,
      onItemsChanged: onItemsChanged,
      onItemTap: onItemTap,
      itemBuilder: itemBuilder,
      initialItems: initialItems,
      initialHasMore: initialHasMore,
      pageSize: pageSize,
      autoLoad: autoLoad,
      enableRefresh: enableRefresh,
      scrollDirection: scrollDirection,
      refreshTriggerExtent: refreshTriggerExtent,
      paginationThreshold: paginationThreshold,
      controller: controller,
      padding: padding,
      physics: physics,
      gridDelegate: gridDelegate,
      separatorBuilder: separatorBuilder,
      header: header,
      footer: footer,
      loadingBuilder: loadingBuilder,
      emptyBuilder: emptyBuilder,
      errorBuilder: errorBuilder,
      paginationLoadingBuilder: paginationLoadingBuilder,
      paginationErrorBuilder: paginationErrorBuilder,
      refreshIndicatorBuilder: refreshIndicatorBuilder,
      shrinkWrap: shrinkWrap,
      reverse: reverse,
      cacheExtent: cacheExtent,
    );
  }
}
