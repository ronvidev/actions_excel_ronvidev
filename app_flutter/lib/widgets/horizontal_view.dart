import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class HorizontalView extends StatefulWidget {
  const HorizontalView({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsets? padding;

  @override
  State<HorizontalView> createState() => _HorizontalViewState();
}

class _HorizontalViewState extends State<HorizontalView> {
  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: SingleChildScrollView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        child: Listener(
          onPointerSignal: (event) {
            if (event is PointerScrollEvent) {
              double offset = _controller.offset + event.scrollDelta.dy;
              if (offset < 0) offset = 0.0;
              _controller.jumpTo(offset);
            }
          },
          child: widget.child,
        ),
      ),
    );
  }
}
