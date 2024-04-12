import 'package:flutter/material.dart';

class TextEditable extends StatefulWidget {
  const TextEditable({
    super.key,
    this.maxLines = 1,
    this.initialValue,
    this.decoration,
    this.alignment = Alignment.centerLeft,
    this.textAlign = TextAlign.start,
    this.onChanged,
    this.controller,
    this.value,
  });

  final int? maxLines;
  final Alignment alignment;
  final TextAlign textAlign;
  final String? value;
  final String? initialValue;
  final BoxDecoration? decoration;
  final TextEditingController? controller;
  final void Function(String value)? onChanged;

  @override
  State<TextEditable> createState() => _TextEditableState();
}

class _TextEditableState extends State<TextEditable> {
  late TextEditingController controller;
  final focusNode = FocusNode();
  bool isEditing = false;

  final textStyle = const TextStyle(fontSize: 16.0);

  void _onSubmitted() async {
    setState(() {
      isEditing = false;
      controller.selection = const TextSelection.collapsed(offset: 0);
    });
    FocusScope.of(context).unfocus();
  }

  @override
  void initState() {
    controller = widget.controller ?? TextEditingController();
    if (widget.initialValue != null) controller.text = widget.initialValue!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.value != null) controller.text = widget.value!;
    return Container(
      alignment: widget.alignment,
      decoration: isEditing
          ? BoxDecoration(color: Theme.of(context).canvasColor)
          : null,
      child: isEditing
          ? TextField(
              maxLines: widget.maxLines,
              focusNode: focusNode,
              controller: controller,
              style: textStyle,
              onChanged: widget.onChanged,
              textAlign: widget.textAlign,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 6.0,
                ),
              ),
              onTapOutside: (event) => _onSubmitted(),
              onSubmitted: (value) => _onSubmitted(),
            )
          : GestureDetector(
              onDoubleTap: () {
                setState(() => isEditing = true);
                FocusScope.of(context).requestFocus(focusNode);
                controller.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: controller.text.length,
                );
              },
              child: Container(
                alignment: widget.alignment,
                color: Colors.transparent,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 6.0,
                  vertical: 3.0,
                ),
                child: Text(controller.text, style: textStyle),
              ),
            ),
    );
  }
}
