import 'package:flutter/material.dart';

class ProcessButton extends StatefulWidget {
  const ProcessButton({
    super.key,
    required this.inProcess,
    this.onPressed,
    required this.icon,
  });

  final bool inProcess;
  final VoidCallback? onPressed;
  final Icon icon;

  @override
  State<ProcessButton> createState() => _ProcessButtonState();
}

class _ProcessButtonState extends State<ProcessButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(
            Theme.of(context).colorScheme.primary,
          ),
        ),
        onPressed: widget.onPressed,
        icon: widget.inProcess
            ? SizedBox.square(
                dimension: 15.0,
                child: CircularProgressIndicator(
                  strokeWidth: 3.0,
                  color: Theme.of(context).primaryColor,
                ),
              )
            : Icon(
                Icons.play_arrow,
                color: Theme.of(context).primaryColor,
              ));
  }
}
