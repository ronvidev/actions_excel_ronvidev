import 'package:autocells/models/slot_model.dart';
import 'package:autocells/providers/insert_image_provider.dart';
import 'package:autocells/widgets/action_button.dart';
import 'package:autocells/widgets/input_text_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewSlotDialog extends StatefulWidget {
  const NewSlotDialog({super.key});

  @override
  State<NewSlotDialog> createState() => _NewSlotDialogState();
}

class _NewSlotDialogState extends State<NewSlotDialog> {
  void _closeDialog() => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final cellsController = TextEditingController();

    return Center(
      child: Material(
        color: Theme.of(context).dialogBackgroundColor,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(8.0),
        child: SizedBox(
          width: 250.0,
          // height: 300.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                color: Theme.of(context).hoverColor,
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Nuevo espacio',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    InputTextBox(
                      title: 'Nombre',
                      controller: nameController,
                    ),
                    const SizedBox(height: 10.0),
                    InputTextBox(
                      title: 'Celdas',
                      controller: cellsController,
                    ),
                  ],
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
                        child: const Text('Agregar'),
                        onPressed: () async {
                          final name = nameController.text;
                          final cells = cellsController.text;
                          if (name.isEmpty || cells.isEmpty) return;
                          final insertImageProvider =
                              context.read<InsertImageProvider>();

                          await insertImageProvider.addSlot(Slot(
                            name: name,
                            cells: cells,
                            photos: [],
                          ));

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
