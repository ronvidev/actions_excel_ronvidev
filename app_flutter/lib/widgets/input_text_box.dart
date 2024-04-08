import 'package:flutter/material.dart';

class InputTextBox extends StatefulWidget {
  const InputTextBox({
    super.key,
    this.controller,
    this.onChanged,
    this.onTapOutside,
    this.title,
    this.hintText,
    this.suffix,
    this.focusNode,
  });

  final String? title;
  final String? hintText;
  final TextEditingController? controller;
  final void Function(String value)? onChanged;
  final void Function(PointerDownEvent)? onTapOutside;
  final Widget? suffix;
  final FocusNode? focusNode;

  @override
  State<InputTextBox> createState() => _InputTextBoxState();
}

class _InputTextBoxState extends State<InputTextBox> {
  late TextEditingController _controller;

  @override
  void initState() {
    if (widget.controller == null) {
      _controller = TextEditingController();
    } else {
      _controller = widget.controller!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) _placeholder(),
        Container(
          clipBehavior: Clip.antiAlias,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          // padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: widget.focusNode,
                  onChanged: widget.onChanged,
                  onTapOutside: widget.onTapOutside,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isCollapsed: true,
                    hintText: widget.hintText ?? '',
                    hintStyle: const TextStyle(fontWeight: FontWeight.w400),
                    contentPadding: const EdgeInsets.all(8.0),
                  ),
                ),
              ),
              if (widget.suffix != null)
                Row(
                  children: [
                    const SizedBox(width: 8.0),
                    Material(
                      color: Colors.transparent,
                      child: widget.suffix,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _placeholder() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(widget.title!),
    );
  }
}
