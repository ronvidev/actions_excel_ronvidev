import 'package:autocells/widgets/widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class TextPickerBox extends StatefulWidget {
  const TextPickerBox({super.key, this.controller, this.title, this.onChanged});

  final String? title;
  final TextEditingController? controller;
  final void Function(String value)? onChanged;

  @override
  State<TextPickerBox> createState() => _TextPickerBoxState();
}

class _TextPickerBoxState extends State<TextPickerBox> {
  @override
  Widget build(BuildContext context) {
    return InputTextBox(
      controller: widget.controller,
      title: widget.title,
      onChanged: widget.onChanged,
      suffix: ActionButton(
        borderRadius: BorderRadius.zero,
        onPressed: () async {
          String? result = await FilePicker.platform.getDirectoryPath(
            lockParentWindow: true,
          );

          if (result != null) {
            if (widget.onChanged != null) widget.onChanged!(result);
            setState(() => widget.controller?.text = result);
          }
        },
        child: const Icon(Icons.folder_rounded),
      ),
    );
  }
}
