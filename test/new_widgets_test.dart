import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xwidgets_pack/xwidgets.dart';

void main() {
  testWidgets('XAsyncView renders data, empty, and retryable errors', (
    tester,
  ) async {
    var state = const XAsyncState<String>.data('Loaded');
    var retries = 0;
    late StateSetter setState;

    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setter) {
            setState = setter;
            return XAsyncView<String>(
              state: state,
              onRetry: () => retries++,
              dataBuilder: (_, data) => Text(data),
              emptyBuilder: (_) => const Text('Custom empty'),
            );
          },
        ),
      ),
    );
    expect(find.text('Loaded'), findsOneWidget);

    setState(() => state = const XAsyncState.empty());
    await tester.pump();
    expect(find.text('Custom empty'), findsOneWidget);

    setState(() => state = XAsyncState.error(StateError('failed')));
    await tester.pump();
    await tester.tap(find.text('Retry'));
    expect(retries, 1);
  });

  testWidgets('XDebouncedSearchField debounces and clears queries', (
    tester,
  ) async {
    final queries = <String>[];
    var clears = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: XDebouncedSearchField(
            debounceDuration: const Duration(milliseconds: 300),
            onSearch: queries.add,
            onClear: () => clears++,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'flutter');
    await tester.pump(const Duration(milliseconds: 299));
    expect(queries, isEmpty);
    await tester.pump(const Duration(milliseconds: 1));
    expect(queries, ['flutter']);

    await tester.tap(find.byTooltip('Clear search'));
    await tester.pump();
    expect(clears, 1);
    expect(queries.last, '');
  });

  testWidgets('XResponsiveLayout selects layouts from available width', (
    tester,
  ) async {
    Widget buildAt(double width) {
      return MaterialApp(
        home: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: width,
            child: XResponsiveLayout(
              breakpoints: const XBreakpoints(tablet: 300, desktop: 700),
              mobile: (_, _) => const Text('mobile'),
              tablet: (_, _) => const Text('tablet'),
              desktop: (_, _) => const Text('desktop'),
            ),
          ),
        ),
      );
    }

    await tester.pumpWidget(buildAt(200));
    expect(find.text('mobile'), findsOneWidget);
    await tester.pumpWidget(buildAt(400));
    expect(find.text('tablet'), findsOneWidget);
    await tester.pumpWidget(buildAt(750));
    expect(find.text('desktop'), findsOneWidget);
  });

  testWidgets('XCollectionView renders fetched data as a grid', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: XCollectionView<int>.grid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          onInit: (_) => const XScrollPage(items: [1, 2, 3, 4], hasMore: false),
          itemBuilder: (_, item, _) => Text('Grid $item'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(GridView), findsOneWidget);
    expect(find.text('Grid 4'), findsOneWidget);
  });

  testWidgets('XButton follows external visual state', (tester) async {
    var presses = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: XButton(
          state: XButtonState.loading,
          loadingLabel: 'Saving',
          onPressed: () => presses++,
        ),
      ),
    );
    expect(find.text('Saving'), findsOneWidget);
    await tester.tap(find.byType(ElevatedButton));
    expect(presses, 0);

    await tester.pumpWidget(
      MaterialApp(
        home: XButton(
          state: XButtonState.idle,
          label: 'Save',
          onPressed: () => presses++,
        ),
      ),
    );
    await tester.tap(find.text('Save'));
    expect(presses, 1);
  });

  testWidgets('XDialog and XBottomSheet return typed selections', (
    tester,
  ) async {
    bool? confirmed;
    String? selected;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Column(
            children: [
              TextButton(
                onPressed: () async {
                  confirmed = await XDialog.confirm(
                    context,
                    title: 'Delete?',
                    message: 'This cannot be undone.',
                  );
                },
                child: const Text('Open dialog'),
              ),
              TextButton(
                onPressed: () async {
                  selected = await XBottomSheet.actions<String>(
                    context,
                    actions: const [
                      XBottomSheetAction(label: 'Camera', value: 'camera'),
                    ],
                  );
                },
                child: const Text('Open sheet'),
              ),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open dialog'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();
    expect(confirmed, isTrue);

    await tester.tap(find.text('Open sheet'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Camera'));
    await tester.pumpAndSettle();
    expect(selected, 'camera');
  });

  testWidgets('XScreen renders loading and error overlays', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: XScreen(isLoading: true, body: Text('Content'))),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpWidget(
      MaterialApp(
        home: XScreen(
          error: StateError('screen failed'),
          body: const Text('Content'),
        ),
      ),
    );
    expect(find.textContaining('screen failed'), findsOneWidget);
  });
}
