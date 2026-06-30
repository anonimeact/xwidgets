import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xwidgets_pack/xwidgets.dart';

void main() {
  testWidgets('XScrollView initializes, paginates, and handles item taps', (
    tester,
  ) async {
    final requests = <XScrollRequest>[];
    var accumulatedItems = <String>[];
    String? tappedItem;

    Future<XScrollPage<String>> fetch(XScrollRequest request) async {
      requests.add(request);
      return XScrollPage(
        items: List.generate(
          request.limit,
          (index) => 'Item ${request.offset + index + 1}',
        ),
        hasMore: request.page < 2,
      );
    }

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 240,
            child: XScrollView<String>(
              pageSize: 5,
              paginationThreshold: 0,
              onInit: fetch,
              onLoadMore: fetch,
              onItemsChanged: (items) => accumulatedItems = items,
              onItemTap: (item, _) => tappedItem = item,
              itemBuilder: (_, item, _) =>
                  SizedBox(height: 80, child: Text(item)),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(requests, hasLength(1));
    expect(requests.first.offset, 0);
    expect(requests.first.limit, 5);
    expect(find.text('Item 1'), findsOneWidget);

    await tester.tap(find.text('Item 1'));
    expect(tappedItem, 'Item 1');

    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();

    expect(requests, hasLength(2));
    expect(requests.last.page, 2);
    expect(requests.last.offset, 5);
    expect(accumulatedItems, hasLength(10));
    expect(accumulatedItems.last, 'Item 10');
  });

  testWidgets('XScrollView exposes first-load errors and retry', (
    tester,
  ) async {
    var attempts = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: XScrollView<String>(
          onInit: (_) {
            attempts++;
            if (attempts == 1) throw StateError('network failed');
            return const XScrollPage(items: ['Recovered'], hasMore: false);
          },
          itemBuilder: (_, item, _) => Text(item),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('network failed'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(attempts, 2);
    expect(find.text('Recovered'), findsOneWidget);
  });

  testWidgets('XScrollView supports horizontal pagination and refresh', (
    tester,
  ) async {
    final requests = <XScrollRequest>[];
    final controller = ScrollController();
    var paginationBuilderCalls = 0;
    var refreshBuilderCalls = 0;
    final paginationCompleter = Completer<void>();
    addTearDown(controller.dispose);

    Future<XScrollPage<int>> fetch(XScrollRequest request) async {
      requests.add(request);
      if (request.page == 2 && !request.isRefresh) {
        await paginationCompleter.future;
      }
      return XScrollPage(
        items: List.generate(request.limit, (index) => request.offset + index),
        hasMore: !request.isRefresh && request.page < 2,
      );
    }

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 300,
              height: 120,
              child: XScrollView<int>(
                controller: controller,
                scrollDirection: Axis.horizontal,
                pageSize: 4,
                paginationThreshold: 0,
                refreshTriggerExtent: 50,
                onInit: fetch,
                onLoadMore: fetch,
                paginationLoadingBuilder: (_) {
                  paginationBuilderCalls++;
                  return const Text('Custom pagination loading');
                },
                refreshIndicatorBuilder: (_, progress, isRefreshing) {
                  refreshBuilderCalls++;
                  return Text(isRefreshing ? 'Custom refreshing' : '$progress');
                },
                itemBuilder: (_, item, _) =>
                    SizedBox(width: 100, child: Center(child: Text('$item'))),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView), const Offset(-400, 0));
    await tester.pump();

    expect(requests, hasLength(2));
    expect(requests.last.page, 2);
    expect(requests.last.offset, 4);
    expect(paginationBuilderCalls, greaterThan(0));
    paginationCompleter.complete();
    await tester.pumpAndSettle();

    controller.jumpTo(0);
    await tester.pump();
    final horizontalGesture = await tester.startGesture(
      tester.getCenter(find.byType(ListView)),
    );
    await horizontalGesture.moveBy(const Offset(120, 0));
    await tester.pump();
    expect(refreshBuilderCalls, greaterThan(0));
    await horizontalGesture.up();
    await tester.pumpAndSettle();

    expect(requests, hasLength(3));
    expect(requests.last.page, 1);
    expect(requests.last.offset, 0);
    expect(requests.last.isRefresh, isTrue);
  });

  testWidgets('XScrollView supports a custom vertical refresh indicator', (
    tester,
  ) async {
    final requests = <XScrollRequest>[];
    var builderCalls = 0;

    Future<XScrollPage<String>> fetch(XScrollRequest request) async {
      requests.add(request);
      return const XScrollPage(items: ['Item'], hasMore: false);
    }

    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          height: 300,
          child: XScrollView<String>(
            refreshTriggerExtent: 40,
            onInit: fetch,
            refreshIndicatorBuilder: (_, progress, isRefreshing) {
              builderCalls++;
              return Text(isRefreshing ? 'Refreshing' : '$progress');
            },
            itemBuilder: (_, item, _) =>
                SizedBox(height: 80, child: Text(item)),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final verticalGesture = await tester.startGesture(
      tester.getCenter(find.byType(ListView)),
    );
    await verticalGesture.moveBy(const Offset(0, 100));
    await tester.pump();
    expect(builderCalls, greaterThan(0));
    await verticalGesture.up();
    await tester.pumpAndSettle();

    expect(requests, hasLength(2));
    expect(requests.last.isRefresh, isTrue);
  });
}
