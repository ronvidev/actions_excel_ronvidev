import 'package:autocells/models/sheet_model.dart';
import 'package:autocells/providers/insert_image_provider.dart';
import 'package:autocells/widgets/action_button.dart';
import 'package:autocells/widgets/input_text_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SheetDialog extends StatefulWidget {
  const SheetDialog({super.key, this.name, this.index});

  final int? index;
  final String? name;

  @override
  State<SheetDialog> createState() => _SheetDialogState();
}

class _SheetDialogState extends State<SheetDialog> {
  final nameController = TextEditingController();
  bool isEdit = false;
  void _closeDialog() => Navigator.pop(context);

  @override
  void initState() {
    nameController.text = widget.name ?? '';
    isEdit = widget.name != null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Theme.of(context).dialogBackgroundColor,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(8.0),
        child: SizedBox(
          width: 250.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                color: Theme.of(context).hoverColor,
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  isEdit ? 'Editando hoja' : 'Nueva hoja',
                  style: const TextStyle(fontSize: 18.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InputTextBox(
                  title: 'Nombre',
                  controller: nameController,
                ),
              ),
              Container(
                width: double.infinity,
                color: Theme.of(context).hoverColor,
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ActionButton(
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () => _closeDialog(),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: ActionButton(
                        child: Text(isEdit ? 'Editar' : 'Agregar'),
                        onPressed: () async {
                          final name = nameController.text;

                          if (name.isEmpty) return;

                          final sheet = Sheet(nameSheet: name, slots: []);

                          isEdit
                              ? await context
                                  .read<InsertImageProvider>()
                                  .updateSheet(widget.index, sheet)
                              : await context
                                  .read<InsertImageProvider>()
                                  .addSheet(sheet);

                          _closeDialog();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
