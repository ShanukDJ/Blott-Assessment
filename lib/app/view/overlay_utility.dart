import 'package:flutter/material.dart';

/// A utility class for creating an overlay widget that dismisses the keyboard when tapped outside.
///
/// This class is typically used as a wrapper around other widgets to provide a gesture detector
/// that unFocuses the primary focus when tapped outside the wrapped widget.
class OverlayUtility extends StatelessWidget {
  const OverlayUtility({
    this.child, super.key,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Builder(
        builder: (context) {
          return child ?? const SizedBox.shrink();
        },
      ),
    );
  }
}
