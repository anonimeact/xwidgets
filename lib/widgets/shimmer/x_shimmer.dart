import 'package:flutter/widgets.dart';

class XShimmer extends StatelessWidget {
  const XShimmer({
    super.key,
    required this.isLoading,
    required this.child,
    required this.shimmerChild,
  });

  final bool isLoading;
  final Widget child;
  final Widget shimmerChild;

  @override
  Widget build(BuildContext context) {
    return isLoading ? shimmerChild : child;
  }
}
