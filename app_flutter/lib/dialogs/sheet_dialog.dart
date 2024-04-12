import 'package:autocells/models/sheet_model.dart';
import 'package:autocells/providers/excel_template_provider.dart';
import 'package:autocells/widgets/input_text_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SheetDialog extends StatefulWidget {
  const SheetDialog({super.key, this.sheet, this.index});

  final int? index;
  final Sheet? sheet;

  @override
  State<SheetDialog> createState() => _SheetDialogState();
}

class _SheetDialogState extends State<SheetDialog> {
  final nameController = TextEditingController();
  bool isEdit = false;

  Future<void> _addSheet(String name) async {
    widget.sheet?.nameSheet = name;

    final sheet = Sheet(nameSheet: name, imageSlots: [], textSlots: []);

    isEdit
        ? await context
            .read<ExcelTemplateProvider>()
            .updateSheet(widget.index, widget.sheet)
        : await context.read<ExcelTemplateProvider>().addSheet(sheet);

    _closeDialog();
  }

  void _closeDialog() => Navigator.pop(context);

  @override
  void initState() {
    nameController.text = widget.sheet?.nameSheet ?? '';
    isEdit = widget.sheet != null;
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
                color: Theme.of(context).primaryColor,
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
                  onSubmitted: (value) => _addSheet(value),
                ),
              ),
              Container(
                width: double.infinity,
                color: Theme.of(context).primaryColor,
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _closeDialog,
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final name = nameController.text;
                          if (name.isEmpty) return;
                          _addSheet(name);
                        },
                        child: Text(isEdit ? 'Editar' : 'Agregar'),
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
