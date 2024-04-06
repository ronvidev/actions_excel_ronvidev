import 'package:flutter/material.dart';

class TextEditable extends StatefulWidget {
  const TextEditable({
    super.key,
    this.maxLines = 1,
    this.initialValue,
    this.decoration,
    this.textAlign = TextAlign.start,
    this.onChanged,
  });

  final int? maxLines;
  final TextAlign textAlign;
  final String? initialValue;
  final BoxDecoration? decoration;
  final void Function(String value)? onChanged;

  @override
  State<TextEditable> createState() => _TextEditableState();
}

class _TextEditableState extends State<TextEditable> {
  final focusNode = FocusNode();
  final controller = TextEditingController();
  bool isEditing = false;

  final textStyle = const TextStyle(fontSize: 16.0);

  @override
  void initState() {
    if (widget.initialValue != null) controller.text = widget.initialValue!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: isEditing
          ? BoxDecoration(color: Theme.of(context).canvasColor.withOpacity(0.5))
          : null,
      child: isEditing
          ? TextField(
              maxLines: widget.maxLines,
              focusNode: focusNode,
              controller: controller,
              style: textStyle,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
              ),
              onTapOutside: (event) => setState(() {
                isEditing = false;
                FocusScope.of(context).unfocus();
                controller.selection = const TextSelection.collapsed(offset: 0);
              }),
              onChanged: widget.onChanged,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                color: Colors.transparent,
                // width: double.infinity,
                child: Text(controller.text, style: textStyle),
              ),
            ),
    );
  }
}
