import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    this.onPressed,
    this.color,
    this.child,
    this.borderRadius,
    this.padding,
  });

  final Widget? child;
  final VoidCallback? onPressed;
  final EdgeInsets? padding;
  final Color? color;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(
          color ?? Theme.of(context).cardColor,
        ),
        elevation: const MaterialStatePropertyAll(0.0),
        splashFactory: NoSplash.splashFactory,
        padding: MaterialStatePropertyAll(padding ?? EdgeInsets.zero),
        minimumSize: const MaterialStatePropertyAll(Size(56.0, 40.0)),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(6.0),
          ),
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
