import 'package:flutter/material.dart';
import 'package:xwidgets_pack/xwidgets.dart';

/// Executable showcase for additional state, layout, and overlay widgets.
class OtherWidgetsExample extends StatefulWidget {
  const OtherWidgetsExample({super.key});

  @override
  State<OtherWidgetsExample> createState() => _OtherWidgetsExampleState();
}

class _OtherWidgetsExampleState extends State<OtherWidgetsExample> {
  XAsyncState<String> profileState = const XAsyncState.data('Fulan');
  XButtonState buttonState = XButtonState.idle;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return XScreen(
      appBar: AppBar(title: const Text('Other Widgets')),
      maxContentWidth: 1100,
      padding: const EdgeInsets.all(16),
      body: ListView(
        children: [
          XResponsiveLayout(
            mobile: (_, _) => const Text('Mobile layout'),
            tablet: (_, _) => const Text('Tablet layout'),
            desktop: (_, _) => const Text('Desktop layout'),
          ),
          const SizedBox(height: 16),
          XAsyncView<String>(
            state: profileState,
            dataBuilder: (_, name) =>
                ListTile(leading: const Icon(Icons.person), title: Text(name)),
            emptyBuilder: (_) => const Text('No profile found'),
            onRetry: _reloadProfile,
          ),
          const SizedBox(height: 16),
          XDebouncedSearchField(
            onSearch: (query) => setState(() => searchQuery = query),
          ),
          Text('Search query: $searchQuery'),
          const SizedBox(height: 16),
          XButton(
            state: buttonState,
            label: 'Save',
            loadingLabel: 'Saving...',
            onPressed: _save,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              OutlinedButton(
                onPressed: _showConfirmation,
                child: const Text('Open dialog'),
              ),
              OutlinedButton(
                onPressed: _showActions,
                child: const Text('Open bottom sheet'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 360,
            child: XCollectionView<String>.grid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              pageSize: 12,
              onInit: _fetchProducts,
              onLoadMore: _fetchProducts,
              emptyBuilder: (_) => const Center(child: Text('No products')),
              itemBuilder: (_, item, _) =>
                  Card(child: Center(child: Text(item))),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _reloadProfile() async {
    setState(() => profileState = const XAsyncState.loading());
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() => profileState = const XAsyncState.data('Fulan'));
    }
  }

  Future<void> _save() async {
    setState(() => buttonState = XButtonState.loading);
    await Future<void>.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => buttonState = XButtonState.success);
  }

  Future<void> _showConfirmation() async {
    await XDialog.confirm(
      context,
      title: 'Save changes?',
      message: 'Your profile will be updated.',
    );
  }

  Future<void> _showActions() async {
    await XBottomSheet.actions<String>(
      context,
      title: 'Select source',
      actions: const [
        XBottomSheetAction(
          label: 'Camera',
          value: 'camera',
          icon: Icon(Icons.camera_alt),
        ),
        XBottomSheetAction(
          label: 'Gallery',
          value: 'gallery',
          icon: Icon(Icons.photo),
        ),
      ],
    );
  }

  Future<XScrollPage<String>> _fetchProducts(XScrollRequest request) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    const total = 30;
    final end = (request.offset + request.limit).clamp(0, total);
    return XScrollPage(
      items: List.generate(
        end - request.offset,
        (index) => 'Product ${request.offset + index + 1}',
      ),
      hasMore: end < total,
    );
  }
}
