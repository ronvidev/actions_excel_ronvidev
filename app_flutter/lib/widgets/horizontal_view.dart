import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class HorizontalView extends StatefulWidget {
  const HorizontalView({super.key, required this.child});

  final Widget child;

  @override
  State<HorizontalView> createState() => _HorizontalViewState();
}

class _HorizontalViewState extends State<HorizontalView> {
  double _scrollOffset = 0.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Transform.translate(
            offset: Offset(_scrollOffset, 0.0),
            child: Listener(
              onPointerSignal: (event) {
                if (event is PointerScrollEvent) {
                  _scrollOffset -= event.scrollDelta.dy;
                  if (_scrollOffset > 0) _scrollOffset = 0;
                  if (_scrollOffset < -width) _scrollOffset = -width;
                  setState(() {});
                }
              },
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}
