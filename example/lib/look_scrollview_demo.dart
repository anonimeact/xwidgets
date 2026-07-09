import 'package:flutter/material.dart';
import 'package:xwidgets_pack/xwidgets.dart';

/// Paginated [XScrollView] showcase styled for the active [XLook].
class LookScrollViewDemo extends StatelessWidget {
  const LookScrollViewDemo({super.key, required this.look});

  final XLook look;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        XText(
          'XScrollView',
          look: look,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 4),
        XText(
          'Paginated list with pull-to-refresh — styled for $look.',
          look: look,
          isExpand: true,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 280,
          child: XScrollView<String>(
            pageSize: 8,
            onInit: fetchLookScrollItems,
            onLoadMore: fetchLookScrollItems,
            separatorBuilder: (_, _) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: XSingleDashedLine(look: look),
            ),
            paginationLoadingBuilder: (_) => _PaginationLoading(look: look),
            refreshIndicatorBuilder: (_, progress, isRefreshing) {
              return _RefreshIndicator(
                look: look,
                progress: progress,
                isRefreshing: isRefreshing,
              );
            },
            onItemTap: (item, index) {
              XSnackbar.success(
                'Selected $item',
                position: .bottom,
                look: look,
              );
            },
            itemBuilder: (context, item, index) {
              return _LookScrollItem(
                look: look,
                item: item,
                index: index,
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        XText(
          'XScrollView Horizontal',
          look: look,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 132,
          child: XScrollView<String>(
            scrollDirection: Axis.horizontal,
            pageSize: 8,
            onInit: fetchLookScrollItems,
            onLoadMore: fetchLookScrollItems,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            paginationLoadingBuilder: (_) => SizedBox(
              width: 96,
              child: Center(
                child: XText('Loading →', look: look),
              ),
            ),
            refreshIndicatorBuilder: (_, progress, isRefreshing) {
              return _HorizontalRefreshIndicator(
                look: look,
                progress: progress,
                isRefreshing: isRefreshing,
              );
            },
            onItemTap: (item, _) {
              XSnackbar.success(
                'Selected $item',
                position: .bottom,
                look: look,
              );
            },
            itemBuilder: (context, item, index) {
              return _LookScrollHorizontalItem(
                look: look,
                item: item,
                index: index,
              );
            },
          ),
        ),
      ],
    );
  }
}

Future<XScrollPage<String>> fetchLookScrollItems(XScrollRequest request) async {
  await Future.delayed(const Duration(milliseconds: 650));

  const totalItems = 36;
  final end = (request.offset + request.limit).clamp(0, totalItems);
  final items = List.generate(
    end - request.offset,
    (index) => 'Item ${request.offset + index + 1}',
  );

  return XScrollPage(items: items, hasMore: end < totalItems);
}

class _LookScrollItem extends StatelessWidget {
  const _LookScrollItem({
    required this.look,
    required this.item,
    required this.index,
  });

  final XLook look;
  final String item;
  final int index;

  @override
  Widget build(BuildContext context) {
    return XCard(
      look: look,
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: _accentColor(look).withValues(alpha: 0.18),
            foregroundColor: _accentColor(look),
            child: Text('${index + 1}'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                XText(
                  item,
                  look: look,
                  isExpand: true,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                XText(
                  'Tap to preview $look styling',
                  look: look,
                  isExpand: true,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: _accentColor(look)),
        ],
      ),
    );
  }
}

class _LookScrollHorizontalItem extends StatelessWidget {
  const _LookScrollHorizontalItem({
    required this.look,
    required this.item,
    required this.index,
  });

  final XLook look;
  final String item;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 132,
      child: XCard(
        look: look,
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: _accentColor(look).withValues(alpha: 0.18),
              foregroundColor: _accentColor(look),
              child: Text('${index + 1}'),
            ),
            const SizedBox(height: 8),
            XText(
              item,
              look: look,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _PaginationLoading extends StatelessWidget {
  const _PaginationLoading({required this.look});

  final XLook look;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox.square(
            dimension: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: _accentColor(look),
            ),
          ),
          const SizedBox(width: 8),
          XText('Loading more...', look: look),
        ],
      ),
    );
  }
}

class _RefreshIndicator extends StatelessWidget {
  const _RefreshIndicator({
    required this.look,
    required this.progress,
    required this.isRefreshing,
  });

  final XLook look;
  final double progress;
  final bool isRefreshing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: XCard(
        look: look,
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(
              dimension: 18,
              child: CircularProgressIndicator(
                value: isRefreshing ? null : progress,
                strokeWidth: 2,
                color: _accentColor(look),
              ),
            ),
            const SizedBox(width: 8),
            XText(
              isRefreshing ? 'Refreshing...' : 'Pull to refresh',
              look: look,
            ),
          ],
        ),
      ),
    );
  }
}

class _HorizontalRefreshIndicator extends StatelessWidget {
  const _HorizontalRefreshIndicator({
    required this.look,
    required this.progress,
    required this.isRefreshing,
  });

  final XLook look;
  final double progress;
  final bool isRefreshing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: XCard(
        look: look,
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.all(10),
        child: isRefreshing
            ? SizedBox.square(
                dimension: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: _accentColor(look),
                ),
              )
            : XText(
                '${(progress * 100).round()}%',
                look: look,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}

Color _accentColor(XLook look) => switch (look) {
  XLook.material => const Color(0xFF6750A4),
  XLook.ios => const Color(0xFF007AFF),
  XLook.glass => Colors.white,
  XLook.neumorphism => const Color(0xFF2D3436),
  XLook.retro => const Color(0xFF5C4B37),
  XLook.neoBrutalism => Colors.black,
  _ => Colors.blue,
};
