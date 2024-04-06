import 'package:flutter/material.dart';

class ConfigSpace extends StatefulWidget {
  const ConfigSpace({super.key, this.child, required this.isOpened, this.height});

  final Widget? child;
  final bool isOpened;
  final double? height;

  @override
  State<ConfigSpace> createState() => _ConfigSpaceState();
}

class _ConfigSpaceState extends State<ConfigSpace> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      color: Theme.of(context).focusColor,
      duration: Durations.medium2,
      curve: Curves.easeOutQuart,
      height: widget.isOpened ? widget.height : 0.0,
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: widget.child,
      ),
    );
  }
}