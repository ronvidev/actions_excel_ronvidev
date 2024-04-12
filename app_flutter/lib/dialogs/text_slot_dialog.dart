import 'package:autocells/models/models.dart';
import 'package:autocells/providers/excel_template_provider.dart';
import 'package:autocells/widgets/input_text_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TextSlotDialog extends StatefulWidget {
  const TextSlotDialog({super.key, this.textSlot, this.index});

  final int? index;
  final TextSlot? textSlot;

  @override
  State<TextSlotDialog> createState() => _TextSlotDialogState();
}

class _TextSlotDialogState extends State<TextSlotDialog> {
  final titleController = TextEditingController();
  final cellController = TextEditingController();
  late bool isEdit;

  void _closeDialog() => Navigator.pop(context);

  @override
  void initState() {
    isEdit = widget.textSlot != null;

    if (isEdit) {
      titleController.text = widget.textSlot!.title;
      cellController.text = widget.textSlot!.cell;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final insertImageProvider = context.read<ExcelTemplateProvider>();

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
                  isEdit ? 'Editar espacio' : 'Nuevo espacio',
                  style: const TextStyle(fontSize: 18.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    InputTextBox(
                      title: 'Título',
                      controller: titleController,
                    ),
                    InputTextBox(
                      title: 'Celda',
                      controller: cellController,
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                color: Theme.of(context).cardColor,
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
                          final title = titleController.text;
                          final cell = cellController.text;

                          if (cell.isEmpty || title.isEmpty) return;

                          if (isEdit) {
                            await insertImageProvider.updateTextCell(
                              widget.index!,
                              TextSlot(
                                title: title,
                                cell: cell,
                                value: widget.textSlot!.value,
                              ),
                            );
                          } else {
                            await insertImageProvider.addTextCell(TextSlot(
                              title: title,
                              cell: cell,
                              value: '',
                            ));
                          }

                          _closeDialog();
                        },
                        child: Text(isEdit ? 'Guardar' : 'Agregar'),
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
