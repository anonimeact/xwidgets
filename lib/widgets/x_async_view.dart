import 'package:flutter/material.dart';

/// Describes the lifecycle state rendered by [XAsyncView].
enum XAsyncStatus { initial, loading, data, empty, error }

/// An immutable, state-management agnostic representation of asynchronous data.
///
/// Store this value in `setState`, BLoC, Provider, Riverpod, GetX, MobX, or any
/// other state container, then pass it to [XAsyncView].
class XAsyncState<T> {
  const XAsyncState._({
    required this.status,
    this.data,
    this.error,
    this.stackTrace,
  });

  /// Creates a state before any work has started.
  const XAsyncState.initial() : this._(status: XAsyncStatus.initial);

  /// Creates an in-progress state, optionally preserving previous data.
  const XAsyncState.loading({T? previousData})
    : this._(status: XAsyncStatus.loading, data: previousData);

  /// Creates a successfully loaded state.
  const XAsyncState.data(T data)
    : this._(status: XAsyncStatus.data, data: data);

  /// Creates a successful state that contains no data.
  const XAsyncState.empty() : this._(status: XAsyncStatus.empty);

  /// Creates a failed state with its original error information.
  const XAsyncState.error(Object error, [StackTrace? stackTrace])
    : this._(status: XAsyncStatus.error, error: error, stackTrace: stackTrace);

  /// Current asynchronous lifecycle status.
  final XAsyncStatus status;

  /// Loaded or previously loaded data.
  final T? data;

  /// Error associated with [XAsyncStatus.error].
  final Object? error;

  /// Optional stack trace associated with [error].
  final StackTrace? stackTrace;

  /// Whether this state is currently loading.
  bool get isLoading => status == XAsyncStatus.loading;

  /// Whether this state contains successfully loaded data.
  bool get hasData => status == XAsyncStatus.data && data != null;
}

typedef XAsyncDataBuilder<T> = Widget Function(BuildContext context, T data);
typedef XAsyncErrorBuilder =
    Widget Function(BuildContext context, Object error, VoidCallback? retry);

/// Renders initial, loading, data, empty, and error states consistently.
///
/// The widget does not fetch or own application state. This makes it usable
/// with every state-management solution while still removing repetitive
/// conditional UI code.
class XAsyncView<T> extends StatelessWidget {
  const XAsyncView({
    required this.state,
    required this.dataBuilder,
    super.key,
    this.onRetry,
    this.initialBuilder,
    this.loadingBuilder,
    this.emptyBuilder,
    this.errorBuilder,
    this.showPreviousDataWhileLoading = false,
    this.transitionDuration = Duration.zero,
    this.transitionBuilder,
  });

  /// State to render.
  final XAsyncState<T> state;

  /// Builds successful data.
  final XAsyncDataBuilder<T> dataBuilder;

  /// Called by the default or custom error UI when retry is requested.
  final VoidCallback? onRetry;

  /// Builds the state before work starts.
  final WidgetBuilder? initialBuilder;

  /// Builds the loading state.
  final WidgetBuilder? loadingBuilder;

  /// Builds the successful empty state.
  final WidgetBuilder? emptyBuilder;

  /// Builds the error state.
  final XAsyncErrorBuilder? errorBuilder;

  /// Keeps rendering previous data when a loading state contains it.
  final bool showPreviousDataWhileLoading;

  /// Duration used to animate between states.
  final Duration transitionDuration;

  /// Optional custom transition used by the internal [AnimatedSwitcher].
  final AnimatedSwitcherTransitionBuilder? transitionBuilder;

  @override
  Widget build(BuildContext context) {
    final child = KeyedSubtree(
      key: ValueKey(state.status),
      child: _buildState(context),
    );
    if (transitionDuration == Duration.zero) return child;

    return AnimatedSwitcher(
      duration: transitionDuration,
      transitionBuilder:
          transitionBuilder ?? AnimatedSwitcher.defaultTransitionBuilder,
      child: child,
    );
  }

  Widget _buildState(BuildContext context) {
    switch (state.status) {
      case XAsyncStatus.initial:
        return initialBuilder?.call(context) ?? const SizedBox.shrink();
      case XAsyncStatus.loading:
        final previousData = state.data;
        if (showPreviousDataWhileLoading && previousData != null) {
          return dataBuilder(context, previousData);
        }
        return loadingBuilder?.call(context) ??
            const Center(child: CircularProgressIndicator());
      case XAsyncStatus.data:
        final data = state.data;
        if (data == null) {
          return emptyBuilder?.call(context) ?? const _XDefaultEmptyView();
        }
        return dataBuilder(context, data);
      case XAsyncStatus.empty:
        return emptyBuilder?.call(context) ?? const _XDefaultEmptyView();
      case XAsyncStatus.error:
        final error = state.error ?? StateError('Unknown asynchronous error');
        return errorBuilder?.call(context, error, onRetry) ??
            _XDefaultErrorView(error: error, onRetry: onRetry);
    }
  }
}

class _XDefaultEmptyView extends StatelessWidget {
  const _XDefaultEmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('No data available'));
  }
}

class _XDefaultErrorView extends StatelessWidget {
  const _XDefaultErrorView({required this.error, this.onRetry});

  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 8),
              TextButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ],
        ),
      ),
    );
  }
}
